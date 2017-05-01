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
  ["debugPrint"] = function() print("Debug tooltip created"); end
}

--Paradoxbar behavior bundles
local paradoxBarBundles = {
  ["standard"] = function(instance, group) paradoxBarFuncs["deleteOnRMB"](instance, group); paradoxBarSound["addSound"](); end
}

--These are the default notification templates
--Feel free to add to this as necessary

--Paradoxbar stock data
local paradoxBarStock = {
  ["debug"] = {
    ["group"] = "Debug", ["icon"] = "Controls_Circle", ["tooltip"] = "This is a debug tooltip", ["text"] = "Dbg", ["funcs"] = {paradoxBarFuncs["debugPrint"], paradoxBarBundles["standard"]}
  },
  ["debug2"] = {
    ["group"] = "Debug2", ["icon"] = "Controls_Circle", ["tooltip"] = "This is a debug tooltip", ["text"] = "Dbg2", ["funcs"] = {paradoxBarFuncs["debugPrint"], paradoxBarBundles["standard"]}
  }
};

-- This function handles adding new notifications to the paradox bar
-- If an ID is supplied, paradoxBarStock is checked for a matching ID and loads presets if available. If additional values are supplied, they are used to overwrite the default values
-- group is used for the purposes of chunking notifications together and is mandatory
-- props is a table containing properties for overriding the defaults supplied by the template selected using the ID
  -- icon is the texture name of the image to be used. Not defining this will leave only a background portrait texture
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

  --Applies properties
  if(props["icon"]) then
    instance.Icon:SetTexture(props["icon"]);
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
  --Reveals completed notification
  instance.Top:SetHide(false);
end

function RemoveNotification(instance, group)
  instance.SlideAnimation:Reverse();
  instance.SlideAnimation:RegisterEndCallback(function()
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
end

function Initialize()
  groupStackIM:ResetInstances();
  LuaEvents.CQUI_AddNotification.Add(AddNotification);
  ContextPtr:SetHide(false);
end

Initialize();
