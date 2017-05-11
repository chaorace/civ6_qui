--This is a layer that lives at the very top of the UI. It's an excellent place for catching inputs globally or displaying a custom overlay
-- This layer is the home of the paradox bar
include("InstanceManager");

--Members
local groupStackIM = InstanceManager:new("ParadoxBarGroupInstance", "Top", Controls.ParadoxBarStack); -- IM for the groups for the notifications
local groupStackInstances: table = {}; --Instances of the groupings for the notifications
local groupStacks: table = {}; --Instance managers for the individual notifications

--These following tables define the various behaviors a notification can contain, modifying a given effect will affect ALL notifications which use them.
--Feel free to add new behaviors here as necessary

--Paradoxbar sound
local paradoxBarSound = {
  ["addSound"] = function() UI.PlaySound("NOTIFICATION_MISC_NEUTRAL"); end,
  ["removeSound"] = function() UI.PlaySound("Map_Pin_Remove"); end
}

--Paradoxbar functions
local paradoxBarFuncs = {
  ["deleteOnRMB"] = function(instance, group)
    instance.Button:RegisterCallback(Mouse.eRClick, function() RemoveNotification(instance, group); end);
  end,
  ["debugPrint"] = function() print("Debug notification created"); end
}

--Paradoxbar behavior bundles
local paradoxBarBundles = {
  ["standard"] = function(instance, group) paradoxBarFuncs["deleteOnRMB"](instance, group); paradoxBarSound["addSound"](); end
}

--These are the default notification templates
--Feel free to add to this as necessary

--Paradoxbar stock data
local paradoxBarStock = {};
function NewTemplate(name, data, base)
  local merged = {};
  if(not data) then return end --There must be something here to differentiate from the base
  if(paradoxBarStock[base]) then --If there's a base to work with, apply it first
    merged = DeepCopy(paradoxBarStock[base]); --Copy the table instead of mangling the original
  end
  for k,v in pairs(data) do merged[k] = v; end --Overriding base values with given data table
  paradoxBarStock[name] = merged; --Adding to stock table
end
NewTemplate("debug", {
  ["group"] = "Debug", ["icon"] = "Controls_Circle", ["tooltip"] = "This is a debug tooltip", ["text"] = "Dbg", ["funcs"] = {paradoxBarFuncs["debugPrint"], paradoxBarBundles["standard"]}
});
NewTemplate("debug2", {
  ["group"] = "Debug2", ["text"] = "Dbg2"
}, "debug");

-- This function handles adding new notifications to the paradox bar
-- If an ID is supplied, paradoxBarStock is checked for a matching ID and loads presets if available. If additional values are supplied, they are used to overwrite the default values
-- group is used for the purposes of chunking notifications together and is mandatory
-- props is a table containing properties for overriding the defaults supplied by the template selected using the ID, you can also use this table for defining arbitrary parameters for use with attatched functions
  -- icon is the name of the texture/icon to be used. Not defining this will leave only a background portrait texture. This can also be a table with the desired X/Y offset values
  -- tooltip is the string to be used describing the notification in detail. Please add an LOC string to cqui_text_notify if you need to employ a new string
  -- ttprops is a table of additional values to be injected into the LOC string. Limit of 5 parameters. See cqui_text_notify for examples concerning working with inserting into LOCs
  -- text is drawn directly on top of the icon and is meant to be used lightly. It will look ugly if you use any more than a few characters
-- funcs is an array of functions used for adding behavior to the notification. This is where closing behavior and other intricacies, like sound, are defined
function AddNotification(ID, group, props, funcs)
  local defaults = paradoxBarStock[ID];
  -- Group must be defined somehow or else we give up here
  if(not group) then
    group = defaults["group"];
    if(not group) then return; end
  end

  --Creates a group for a specific notification group if it does not exist
  if(groupStackInstances[group] == nil) then
    groupStackInstances[group] = groupStackIM:GetInstance();
    groupStacks[group] = InstanceManager:new("ParadoxBarInstance", "Top", groupStackInstances[group].Stack);
  end
  instance = groupStacks[group]:GetInstance();

  --If no property table was provided at all, create an empty one
  if(not props) then
    props = {};
  end

  --Applies defaults where appropriate
  if(defaults) then
    if(defaults["icon"] and not props["icon"]) then
      props["icon"] = defaults["icon"];
    end
    if(defaults["ttprops"] and not props["ttprops"]) then
      props["ttprops"] = defaults["ttprops"];
    end
    if(defaults["tooltip"] and not props["tooltip"]) then
      props["tooltip"] = defaults["tooltip"];
    end
    if(defaults["text"] and not props["text"]) then
      props["text"] = defaults["text"];
    end
    if(defaults["funcs"] and not props["funcs"]) then
      funcs = defaults["funcs"];
    end
  end

  --Applies properties.

  --If a table is supplied instead of a string, treat the 2nd and 3rd values as texture offsets
  if(props["icon"]) then
    if(props["icon"][2] and props["icon"][3]) then
      instance.Icon:SetTexture(props["icon"][2], props["icon"][3], props["icon"][1]);
    else
      --If we didn't provide an offset, there's no easy way to tell if the supplied string will refer to an icon or a texture. In this scenario, we just try both methods since it's a relatively cheap thing to fail at.
      instance.Icon:SetIcon(props["icon"]);
      instance.Icon:SetTexture(props["icon"]);
    end
  end

  if(props["tooltip"]) then
    if(not props["ttprops"]) then
      props["ttprops"] = {};
    end
    instance.Button:LocalizeAndSetToolTip(props["tooltip"], props["ttprops"][1] or "X", props["ttprops"][2] or "X", props["ttprops"][3] or "X", props["ttprops"][4] or "X", props["ttprops"][5] or "X");
  end
  if(props["text"]) then
    instance.Text:LocalizeAndSetText(props["text"]);
  end
  --Invokes functions
  if(funcs) then
    for _,v in ipairs(funcs) do
      v(instance, group, props);
    end
  end
  --Check if this asset has been used before and, if so, fix any mutable states that may have persisted
  if(instance.Top:GetID() == "Exhausted") then
    instance.Top:SetID("NotExhausted");
    instance.AlphaAnimation:RegisterEndCallback(function() end);
    instance.AlphaAnimation:SetToBeginning();
  end
  --Reveals completed notification
  instance.Top:SetHide(false);
  instance.AlphaAnimation:Play();
end

function RemoveNotification(instance, group)
  instance.AlphaAnimation:RegisterEndCallback(function()
    groupStacks[group]:ReleaseInstance(instance);
    --This is a hacky workaround since releasing an instance doesn't necessarily actually remove it from a given stack
    instance.Top:SetID("Exhausted");
    for _,v in ipairs(groupStackInstances[group].Stack:GetChildren()) do
      if(v:GetID() ~= "Exhausted") then return; end
    end
    --Removes the group stack from the main notification stack
    Controls.ParadoxBarStack:ReleaseChild(groupStackInstances[group].Top);
    groupStackInstances[group] = nil;
  end)
  instance.AlphaAnimation:Reverse();
end

function Initialize()
  groupStackIM:ResetInstances();
  LuaEvents.CQUI_AddNotification.Add(AddNotification);
  ContextPtr:SetHide(false);
end

Initialize();
