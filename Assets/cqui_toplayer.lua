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
  ["debug"] = {"Debug", "Controls_Circle", "This is a debug tooltip", "Dbg", {paradoxBarFuncs["debugPrint"], paradoxBarBundles["standard"]}},
  ["debug2"] = {"Debug2", "Controls_Circle", "This is a debug tooltip", "Dbg2", {paradoxBarFuncs["debugPrint"], paradoxBarBundles["standard"]}}
};

-- This function handles adding new notifications to the paradox bar
-- Group is used for the purposes of chunking notifications together and is mandatory
-- If an ID is supplied, paradoxBarStock is checked for a matching ID and loads presets if available. If additional values are supplied, they are used to overwrite the default values
-- text is drawn directly on top of the icon and is meant to be used lightly. It will look ugly if you use any more than a few characters
-- funcs is an array of functions used for adding behavior to the notification. This is where closing behavior and other intricacies are defined
function AddNotification(ID, group, icon, tooltip, text, funcs)
  local defaults = paradoxBarStock[ID];
  -- Group must be defined somehow or else we give up here
  if(not group) then
    group = defaults[1];
    if(not group) then return; end
  end

  --Creates a group for a specific notification group if it does not exist
  if(groupStackInstances[group] == nil) then
    groupStackInstances[group] = groupStackIM:GetInstance();
    groupStacks[group] = InstanceManager:new("ParadoxBarInstance", "Top", groupStackInstances[group].Stack);
  end
  instance = groupStacks[group]:GetInstance();

  --Applies defaults where appropriate
  if(defaults) then
    if(defaults[2]) then
      instance.Icon:SetTexture(defaults[2]);
    end
    if(defaults[3]) then
      instance.Button:LocalizeAndSetToolTip(defaults[3]);
    end
    if(defaults[4]) then
      instance.Text:SetText(defaults[4]);
    end
    if(defaults[5] and not funcs) then
      funcs = defaults[5]
    end
  end
  if(icon) then
    instance.Icon:SetTexture(icon);
  end
  if(tooltip) then
    instance.Button:LocalizeAndSetToolTip(tooltip);
  end
  if(text) then
    instance.Text:SetText(text);
  end
  --Invokes functions
  if(funcs) then
    for _,v in ipairs(funcs) do
      v(instance, group, icon, tooltip, text);
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
