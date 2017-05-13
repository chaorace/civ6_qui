--This is a layer that lives at the very top of the UI. It's an excellent place for catching inputs globally or displaying a custom overlay
-- This layer is the home of the paradox bar
include("InstanceManager");
include("supportfunctions");

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
  ["goToCity"] = function(instance, _, props)
    instance.Button:RegisterCallback(Mouse.eLClick, function()
      local city = props["city"];
      UI:SelectCityID(city:GetID());
      UI.LookAtPlotScreenPosition( city:GetX(), city:GetY(), 0.5, 0.5 );
    end);
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
NewTemplate("cityGrowth", {
  ["group"] = "CityGrowth", ["icon"] = "ICON_CITIZEN", ["iconColor"] = "Green", ["tooltip"] = "LOC_CQUI_CITYGROWTH", ["funcs"] = {paradoxBarBundles["standard"], paradoxBarFuncs["goToCity"]}
});
NewTemplate("cityShrink", {
  ["iconColor"] = "Red", ["tooltip"] = "LOC_CQUI_CITYSHRINK"
}, "cityGrowth");

-- This function handles adding new notifications to the paradox bar
-- If an ID is supplied, paradoxBarStock is checked for a matching ID and loads presets if available. If additional values are supplied, they are used to overwrite the default values
-- props is a table containing properties for overriding the defaults supplied by the template selected using the ID, you can also use this table for defining arbitrary parameters for use with attatched functions
  -- group is used for the purposes of chunking notifications together and is mandatory, though, usually supplied by a preset, if employed
  -- icon is the name of the texture/icon to be used. Not defining this will leave only a background portrait texture. This can also be a table with the desired X/Y offset values
  -- noIconStretch is an optional true/false value which can be used to disable icon/texture scaling, forcing the given image to display in original size. Default behavior is as if this were set to false
  -- iconColor is an optional value used to set the color hue of the icon element. See the in game use of ":SetColor" for examples of valid values
  -- tooltip is the string to be used describing the notification in detail. Please add an LOC string to cqui_text_notify if you need to employ a new string
  -- ttprops is a table of additional values to be injected into the LOC string. Limit of 5 parameters. See cqui_text_notify for examples concerning working with inserting into LOCs
  -- text is drawn directly on top of the icon and is meant to be used lightly. It will look ugly if you use any more than a few characters
-- funcs is an array of functions used for adding behavior to the notification. This is where closing behavior and other intricacies, like sound, are defined
function AddNotification(ID, props, funcs)
  local defaults = DeepCopy(paradoxBarStock[ID]); --Copy by value instead of by reference, so as not to mangle the real defaults table

  --If no property table was provided at all, create an empty one
  if(not props) then
    props = {};
  end

  --Merges defaults with overrides supplied via props
  if(defaults) then
    if(defaults["group"] and not props["group"]) then
      group = defaults["group"];
      defaults["group"] = nil;
    end
    if(defaults["funcs"] and not props["funcs"]) then
      funcs = defaults["funcs"];
      defaults["funcs"] = nil;
    end
    for k,v in pairs(defaults) do props[k] = v; end
  end

  -- Group must be defined somehow or else we give up here
  if(not group) then return; end

  --Creates a group for a specific notification group if it does not exist
  if(groupStackInstances[group] == nil) then
    groupStackInstances[group] = groupStackIM:GetInstance();
    groupStacks[group] = InstanceManager:new("ParadoxBarInstance", "Top", groupStackInstances[group].Stack);
  end
  instance = groupStacks[group]:GetInstance();


  --Applies properties.

  --If a table is supplied instead of a string, treat the 2nd and 3rd values as texture offsets
  if(props["icon"]) then
    local iconElement;
    if(props["noIconStretch"]) then
      iconElement = instance.IconNoStretch;
    else
      iconElement = instance.Icon;
    end
    if(props["icon"][2] and props["icon"][3]) then
      iconElement:SetTexture(props["icon"][2], props["icon"][3], props["icon"][1]);
    else
      --If we didn't provide an offset, there's no easy way to tell if the supplied string will refer to an icon or a texture. In this scenario, we just try both methods since it's a relatively cheap thing to fail at.
      iconElement:SetIcon(props["icon"]);
      iconElement:SetTexture(props["icon"]);
    end
    if(props["iconColor"]) then
      if(type(props["iconColor"]) == "string") then
        iconElement:SetColorByName(props["iconColor"]);
      else
        iconElement:SetColor(props["iconColor"]);
      end
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

  --Implementing city population change
  Events.CityPopulationChanged.Add(
    function(playerID : number, cityID : number, newPopulation : number)
      if(not Game:GetLocalPlayer()) then return end
      if(playerID == Game:GetLocalPlayer()) then
        local city = Players[playerID]:GetCities():FindID(cityID);
        if(city:GetGrowth():GetFoodSurplus() < 0) then --This isn't a perfect heuristic, but the game doesn't make it easy to tell between a city that just grew and a city that just shrunk
          AddNotification("cityShrink", {["ttprops"] = {city:GetName()}, ["city"] = city});
        else
          AddNotification("cityGrowth", {["ttprops"] = {city:GetName()}, ["city"] = city});
        end
      end
    end
  )
end

Initialize();
