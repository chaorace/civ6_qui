-- ===========================================================================
--	Contains scaffolding for WorldRankings and other Right Anchored screens
-- ===========================================================================
include("TabSupport");
include("InstanceManager");
include("SupportFunctions");
include("AnimSidePanelSupport");
include("TeamSupport");

-- ===========================================================================
--	DEBUG
-- ===========================================================================
local m_isDebugForceShowAllScoreCategories :boolean = false;		-- (false) Show all scoring categories under details

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local RELOAD_CACHE_ID:string = "WorldRankings"; -- Must be unique (usually the same as the file name)
local REQUIREMENT_CONTEXT:string = "VictoryProgress";
local DATA_FIELD_SELECTION:string = "Selection";
local DATA_FIELD_LEADER_TOOLTIP:string = "LeaderTooltip";
local DATA_FIELD_HEADER_HEIGHT:string = "HeaderHeight";
local DATA_FIELD_HEADER_RESIZED:string = "HeaderResized";
local DATA_FIELD_HEADER_EXPANDED:string = "HeaderExpanded";
local DATA_FIELD_OVERALL_PLAYERS_IM:string = "OverallPlayersIM";
local DATA_FIELD_DOMINATED_CITIES_IM:string = "DominatedCitiesIM";
local DATA_FIELD_RELIGION_CONVERTED_CIVS_IM:string = "ConvertedCivsIM";

local PADDING_HEADER:number = 10;
local PADDING_CULTURE_HEADER:number = 90;
local PADDING_GENERIC_ITEM_BG:number = 25;
local PADDING_TAB_BUTTON_TEXT:number = 17;
local PADDING_EXTRA_TAB_BG:number = 10;
local PADDING_EXTRA_TAB_SHADOW:number = 23;
local PADDING_ADVISOR_TEXT_BG:number = 20;
local PADDING_RELIGION_NAME_BG:number = 42;
local PADDING_RELIGION_BG_HEIGHT:number = 26;
local PADDING_VICTORY_GRADIENT:number = 45;
local PADDING_NEXT_STEP_HIGHLIGHT:number = 4;
local PADDING_VICTORY_LABEL_UNDERLINE:number = 90;
local PADDING_SCORE_DETAILS_BUTTON_WIDTH:number = 40;
local OFFSET_VIEW_CONTENTS:number = 130;
local OFFSET_ADVISOR_ICON_Y:number = 5;
local OFFSET_ADVISOR_TEXT_Y:number = 70;
local OFFSET_HIDDEN_SCROLLBAR:number = 7;
local OFFSET_CONTRACT_BUTTON_Y:number = 63;
local OFFSET_SCIENCE_REQUIREMENTS_Y:number = 80;
local SIZE_OVERALL_TOP_PLAYER_ICON:number = 48;
local SIZE_OVERALL_PLAYER_ICON:number = 36;
local SIZE_OVERALL_BG_HEIGHT:number = 100;
local SIZE_OVERALL_INSTANCE:number = 40;
local SIZE_VICTORY_ICON_SMALL:number = 64;
local SIZE_RELIGION_BG_HEIGHT:number = 55;
local SIZE_RELIGION_ICON_SMALL:number = 22;
local SIZE_RELIGION_CIV_ICON:number = 30;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local SIZE_SCORE_ITEM_DEFAULT:number = 54;
local SIZE_SCORE_ITEM_DETAILS:number = 180;
local SIZE_STACK_DEFAULT:number = 225;
local SIZE_HEADER_DEFAULT:number = 60;
local SIZE_HEADER_MIN_Y:number = 46;
local SIZE_HEADER_MAX_Y:number = 270;
local SIZE_HEADER_ICON:number = 80;
local SIZE_LEADER_ICON:number = 55;
local SIZE_CIV_ICON:number = 36;

local TEAM_RIBBON_PREFIX:string = "ICON_TEAM_RIBBON_";
local TEAM_RIBBON_SIZE_TOP_TEAM:number = 53;
local TEAM_RIBBON_SIZE:number = 44;

local TEAM_ICON_PREFIX:string = "Team";
local TEAM_ICON_SIZE_TOP_TEAM:number = 38;
local TEAM_ICON_SIZE:number = 28;

local TAB_SCORE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_TAB");
local TAB_OVERALL:string = Locale.Lookup("LOC_WORLD_RANKINGS_OVERALL_TAB");
local TAB_SCIENCE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_TAB");
local TAB_CULTURE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TAB");
local TAB_RELIGION:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_TAB");
local TAB_DOMINATION:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_TAB");

local SCORE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_VICTORY");
local SCORE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_DETAILS");

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3")
};

local CULTURE_ICON:string = "ICON_VICTORY_CULTURE";
local CULTURE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY");
local CULTURE_VICTORY_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY_DETAILS");
local CULTURE_DOMESTIC_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_DOMESTIC_TOURISTS");
local CULTURE_VISITING_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_VISITING_TOURISTS");

local DOMINATION_ICON:string = "ICON_VICTORY_DOMINATION";
local DOMINATION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_VICTORY");
local DOMINATION_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_DETAILS");
local DOMINATION_HAS_ORIGINAL_CAPITAL:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_HAS_ORIGINAL_CAPITAL");

local RELIGION_ICON:string = "ICON_VICTORY_RELIGIOUS";
local RELIGION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_VICTORY");
local RELIGION_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_DETAILS");

local ICON_GENERIC:string = "ICON_VICTORY_GENERIC";
local ICON_UNKNOWN_CIV:string = "ICON_CIVILIZATION_UNKNOWN";
local LOC_UNKNOWN_CIV:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER");
local LOC_UNKNOWN_CIV_COLORED:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER_COLORED");

local UNKNOWN_COLOR:number = RGBAValuesToABGRHex(1, 1, 1, 1);

--antonjs: Removed the other state and related text, in favor of showing all information together. Leaving state functionality intact in case we want to use it in the future.
--[[
local CULTURE_HOW_TO_VICTORY:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_VICTORY");
local CULTURE_HOW_TO_TOURISM:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_TOURISM");
local CULTURE_TOURISM_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TOURISM_DETAILS");
--]]
local CULTURE_HEADER_STATES:table = {
	WHAT_IS_CULTURE_VICTORY	= 0;
};

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_PROJECT_INFOS:table = { 
	GameInfo.Projects["PROJECT_LAUNCH_MARS_REACTOR"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HABITATION"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HYDROPONICS"]
};
local SCIENCE_PROJECTS:table = {
	EARTH_SATELLITE_PROJECT_INFOS,
	MOON_LANDING_PROJECT_INFOS,
	MARS_COLONY_PROJECT_INFOS
};

local STANDARD_VICTORY_TYPES:table = {
	"VICTORY_DEFAULT",
	"VICTORY_SCORE",
	"VICTORY_TECHNOLOGY",
	"VICTORY_CULTURE",
	"VICTORY_CONQUEST",
	"VICTORY_RELIGIOUS"
};

function IsCustomVictoryType(victoryType:string)
	for _, checkVictoryType in ipairs(STANDARD_VICTORY_TYPES) do
		if victoryType == checkVictoryType then
			return false;
		end
	end
	return true;
end

-- ===========================================================================
--	PLAYER VARIABLES
-- ===========================================================================
local m_LocalPlayer:table;
local m_LocalPlayerID:number;
-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================
local m_TabSupport:table; -- TabSupport
local m_AnimSupport:table; --AnimSidePanelSupport
local m_ActiveHeader:table;
local m_TotalTabSize:number = 0;
local m_MaxExtraTabSize:number = 0;
local m_ExtraTabs:table = {};
local m_HeaderInstances:table = {};
local m_ActiveViewUpdate:ifunction;
local m_ShowScoreDetails:boolean = false;
local m_CultureHeaderState:number = CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY;
local m_TabSupportIM:table = InstanceManager:new("TabInstance", "Button", Controls.TabContainer);
local m_GenericHeaderIM:table = InstanceManager:new("GenericHeaderInstance", "HeaderTop"); -- Used by Score, Religion and Domination Views
local m_ScienceHeaderIM:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);
local m_CultureHeaderIM:table = InstanceManager:new("CultureHeaderInstance", "HeaderTop", Controls.CultureViewHeader);
local m_OverallIM:table = InstanceManager:new("OverallInstance", "ButtonBG", Controls.OverallViewStack);

local m_ScoreIM:table = InstanceManager:new("ScoreInstance", "ButtonBG", Controls.ScoreViewStack);
local m_ScoreTeamIM:table = InstanceManager:new("ScoreTeamInstance", "ButtonFrame", Controls.ScoreViewStack);

local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_ScienceTeamIM:table = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.ScienceViewStack);

local m_CultureIM:table = InstanceManager:new("CultureInstance", "ButtonBG", Controls.CultureViewStack);
local m_CultureTeamIM:table = InstanceManager:new("CultureTeamInstance", "ButtonFrame", Controls.CultureViewStack);

local m_DominationIM:table = InstanceManager:new("DominationInstance", "ButtonBG", Controls.DominationViewStack);
local m_DominationTeamIM:table = InstanceManager:new("DominationTeamInstance", "ButtonFrame", Controls.DominationViewStack);

local m_ReligionIM:table = InstanceManager:new("ReligionInstance", "ButtonBG", Controls.ReligionViewStack);
local m_ReligionTeamIM:table = InstanceManager:new("ReligionTeamInstance", "ButtonFrame", Controls.ReligionViewStack);

local m_GenericIM:table = InstanceManager:new("GenericInstance", "ButtonBG", Controls.GenericViewStack);
local m_GenericTeamIM:table = InstanceManager:new("GenericTeamInstance", "ButtonFrame", Controls.GenericViewStack);

local m_ExtraTabsIM:table = InstanceManager:new("ExtraTab", "Button", Controls.ExtraTabStack);

local m_CivTooltip = {};
TTManager:GetTypeControlTable("CivTooltip", m_CivTooltip);

local m_TeamTooltip = {};
TTManager:GetTypeControlTable("TeamTooltip", m_TeamTooltip);

-- ===========================================================================
--	Called once during Init
-- ===========================================================================
function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	m_ExtraTabsIM:ResetInstances();
	m_TabSupportIM:ResetInstances();
	
	-- Deselect previously selected tab
	if(m_TabSupport ~= nil) then
		m_TabSupport.SelectTab(nil);
		if(m_TabSupport.prevSelectedControl ~= nil) then
			m_TabSupport.prevSelectedControl[DATA_FIELD_SELECTION]:SetHide(true);
		end
	end

	-- Create TabSupport object
	m_TabSupport = CreateTabs(Controls.TabContainer, 42, 34, 0xFF331D05);

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE")) then
		AddTab(TAB_SCORE, ViewScore);
	end
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		AddTab(TAB_SCIENCE, ViewScience);
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		AddTab(TAB_CULTURE, ViewCulture);
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		AddTab(TAB_DOMINATION, ViewDomination);
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		AddTab(TAB_RELIGION, ViewReligion);
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
		local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
			AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
		end
	end

	if m_TotalTabSize > Controls.TabContainer:GetSizeX() then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	Controls.ExtraTabs:SetOffsetX(-1 * Controls.ExtraTabStack:GetSizeX() + PADDING_EXTRA_TAB_BG);
	Controls.ExtraTabsBG:SetSizeVal(Controls.ExtraTabStack:GetSizeX() + PADDING_EXTRA_TAB_BG, Controls.ExtraTabStack:GetSizeY() + PADDING_EXTRA_TAB_BG);
	Controls.ExtraTabsShadow:SetSizeVal(Controls.ExtraTabStack:GetSizeX() + PADDING_EXTRA_TAB_SHADOW, Controls.ExtraTabStack:GetSizeY() + PADDING_EXTRA_TAB_SHADOW);
	
	m_TabSupport.SelectTab(defaultTab);
	m_TabSupport.EvenlySpreadTabs();
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = m_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > Controls.TabContainer:GetSizeX() then
		m_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else

		local callback = function()
			if(m_TabSupport.prevSelectedControl ~= nil) then
				m_TabSupport.prevSelectedControl[DATA_FIELD_SELECTION]:SetHide(true);
			end
			tabInst.Selection:SetHide(false);
			onClickCallback();
			CloseExtraTabs();
		end

		m_TabSupport.AddTab(tabInst.Button, callback);
	end

	return tabInst.Button;
end

function AddExtraTab(label:string, onClickCallback:ifunction)
	local extraTabInst:table = m_ExtraTabsIM:GetInstance();
	extraTabInst.Button:SetText(label);

	local callback = function()
		if(m_TabSupport.selectedControl ~= nil) then
			m_TabSupport.selectedControl[DATA_FIELD_SELECTION]:SetHide(true);
			m_TabSupport.SetSelectedTabVisually(nil);
		end
		for _,tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSelected(tabInst == extraTabInst);
		end
		onClickCallback();
	end

	extraTabInst.Button:RegisterCallback(Mouse.eLClick, callback);

	local textControl = extraTabInst.Button:GetTextControl();
	local textSize:number = textControl:GetSizeX();
	extraTabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	extraTabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	local tabSize:number = extraTabInst.Button:GetSizeX();
	if tabSize > m_MaxExtraTabSize then
		m_MaxExtraTabSize = tabSize;
	end

	table.insert(m_ExtraTabs, extraTabInst);
end

-- ===========================================================================
--	Called anytime player switches tabs
-- ===========================================================================
function ResetState(newView:ifunction)
	m_ActiveHeader = nil;
	m_ActiveViewUpdate = newView;
	Controls.OverallView:SetHide(true);
	Controls.ScoreView:SetHide(true);
	Controls.ScienceView:SetHide(true);
	Controls.CultureView:SetHide(true);
	Controls.DominationView:SetHide(true);
	Controls.ReligionView:SetHide(true);
	Controls.GenericView:SetHide(true);

	-- Reset tourism lens unless we're now view the Culture tab
	if newView ~= ViewCulture then
		ResetTourismLens();
	end
end

function ChangeActiveHeader(headerType:string, headerIM:table, parentControl:table)
	m_ActiveHeader = m_HeaderInstances[headerType];
	if(m_ActiveHeader == nil) then
		m_ActiveHeader = headerIM:GetInstance(parentControl);
		m_HeaderInstances[headerType] = m_ActiveHeader;
	end
end

function GetCivNameAndIcon(playerID:number, bColorUnmetPlayer:boolean)
	local name:string, icon:string;
	local playerConfig:table = PlayerConfigurations[playerID];
	if(playerID == m_LocalPlayerID or playerConfig:IsHuman() or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		name = Locale.Lookup(playerConfig:GetPlayerName());
		if playerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			icon = "ICON_" .. playerConfig:GetCivilizationTypeName();
		else
			icon = ICON_UNKNOWN_CIV;
		end
	else
		name = bColorUnmetPlayer and LOC_UNKNOWN_CIV_COLORED or LOC_UNKNOWN_CIV;
		icon = ICON_UNKNOWN_CIV;
	end
	return name, icon;
end

function ColorCivIcon(instance:table, playerID:number)
	if(playerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		local backColor, frontColor = UI.GetPlayerColors(playerID);
		local darkerBackColor = DarkenLightenColor(backColor,(-55),230);
		local brighterBackColor = DarkenLightenColor(backColor,80,255);
		instance.CivIcon:SetColor(frontColor);
		if(instance.CivIconBacking ~= nil) then
			instance.CivIconBacking:SetColor(backColor);
		else
			instance.CivBacking_Base:SetColor(backColor);
			instance.CivBacking_Lighter:SetColor(brighterBackColor);
			instance.CivBacking_Darker:SetColor(darkerBackColor);
		end
	else
		instance.CivIcon:SetColor(UNKNOWN_COLOR);
		if(instance.CivIconBacking ~= nil) then
			instance.CivIconBacking:SetColor(UNKNOWN_COLOR);
		else
			instance.CivBacking_Base:SetColor(backColor);
			instance.CivBacking_Lighter:SetColor(brighterBackColor);
			instance.CivBacking_Darker:SetColor(darkerBackColor);
		end
	end
end

-- ===========================================================================
--	Called to update a generic header instance
-- ===========================================================================
function PopulateGenericHeader(resizeCallback:ifunction, title:string, subTitle:string, details:string, headerIcon:string, advisorIcon:string)
	
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(headerIcon, SIZE_HEADER_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateGenericHeader: icon=\""..headerIcon.."\", iconSize="..tostring(SIZE_HEADER_ICON));
	else
		m_ActiveHeader.HeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end

	m_ActiveHeader.HeaderLabel:SetText(Locale.ToUpper(Locale.Lookup(title)));
	if(subTitle ~= nil and subTitle ~= "") then
		m_ActiveHeader.HeaderSubLabel:SetHide(false);
		m_ActiveHeader.HeaderSubLabel:SetText(Locale.Lookup(subTitle));
	else
		m_ActiveHeader.HeaderSubLabel:SetHide(true);
	end

	m_ActiveHeader.AdvisorText:SetText(details and Locale.Lookup(details) or "");
	
	m_ActiveHeader.ExpandHeaderButton:RegisterCallback(Mouse.eLClick, OnExpandHeader);
	m_ActiveHeader.ContractHeaderButton:RegisterCallback(Mouse.eLClick, OnContractHeader);
	
	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] == nil) then 
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = true;
	end

	m_ActiveHeader[DATA_FIELD_HEADER_RESIZED] = resizeCallback;
	RealizeHeaderSize();
end

-- ===========================================================================
--	Called anytime player presses expand/contract button on a Header Instance 
-- ===========================================================================
function OnExpandHeader(data1:number, data2:number, control:table)
	if(control == m_ActiveHeader.ExpandHeaderButton) then
		m_ActiveHeader.AdvisorIcon:SetHide(false);
		m_ActiveHeader.AdvisorText:SetHide(false);
		m_ActiveHeader.AdvisorTextBG:SetHide(false);
		m_ActiveHeader.ExpandHeaderButton:SetHide(true);
		m_ActiveHeader.ContractHeaderButton:SetHide(false);
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = true;
		RealizeHeaderSize();
	end
end
function OnContractHeader(data1:number, data2:number, control:table)
	if(control == m_ActiveHeader.ContractHeaderButton) then
		m_ActiveHeader.AdvisorIcon:SetHide(true);
		m_ActiveHeader.AdvisorText:SetHide(true);
		m_ActiveHeader.AdvisorTextBG:SetHide(true);
		m_ActiveHeader.ExpandHeaderButton:SetHide(false);
		m_ActiveHeader.ContractHeaderButton:SetHide(true);
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = false;
		RealizeHeaderSize();
	end
end

-- ===========================================================================
--	Called anytime header changes size (when it's expanded / contracted)
-- ===========================================================================
function RealizeHeaderSize()
	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local textBubbleHeight:number = m_ActiveHeader.AdvisorText:GetSizeY() + PADDING_ADVISOR_TEXT_BG;
		if(textBubbleHeight > SIZE_HEADER_MAX_Y) then
			textBubbleHeight = SIZE_HEADER_MAX_Y;
		elseif textBubbleHeight < SIZE_HEADER_MIN_Y then
			textBubbleHeight = SIZE_HEADER_MIN_Y;
		end
		m_ActiveHeader.AdvisorTextBG:SetSizeY(textBubbleHeight);
		m_ActiveHeader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + textBubbleHeight);
		m_ActiveHeader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + textBubbleHeight);
		m_ActiveHeader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + textBubbleHeight);
		m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT] = textBubbleHeight;
	else
		m_ActiveHeader.HeaderFrame:SetSizeY(SIZE_HEADER_DEFAULT);
		m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT] = SIZE_HEADER_DEFAULT;
	end
	-- Center header label if sub label is not present
	if(m_ActiveHeader.HeaderSubLabel:IsHidden()) then
		m_ActiveHeader.HeaderLabel:SetOffsetY(25);
	else
		m_ActiveHeader.HeaderLabel:SetOffsetY(18);
	end
	if(m_ActiveHeader[DATA_FIELD_HEADER_RESIZED] ~= nil) then
		m_ActiveHeader[DATA_FIELD_HEADER_RESIZED]();
	end
end

-- ===========================================================================
--	Utility to reduce code duplication
-- ===========================================================================
function RealizeStackAndScrollbar(stackControl:table, scrollbarControl:table, offsetStackIfScrollbarHidden:boolean)
	stackControl:CalculateSize();
	stackControl:ReprocessAnchoring();
	scrollbarControl:CalculateInternalSize();
	scrollbarControl:ReprocessAnchoring();
	scrollbarControl:SetScrollValue(0);
	if(offsetStackIfScrollbarHidden ~= nil) then
		if(scrollbarControl:GetScrollBar():IsHidden()) then
			stackControl:SetOffsetX(OFFSET_HIDDEN_SCROLLBAR);
		else
			stackControl:SetOffsetX(0);
		end
	end
end

-- ===========================================================================
--	Called when Overall tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewOverall()
	ResetState(ViewOverall);
	Controls.OverallView:SetHide(false);

	m_OverallIM:ResetInstances();

	-- Add default victory types in a pre-determined order
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_TECHNOLOGY", "SCIENCE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CULTURE", "CULTURE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CONQUEST", "DOMINATION");
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_RELIGIOUS", "RELIGION");
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
		local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
			PopulateOverallInstance(m_OverallIM:GetInstance(), victoryType);

		end
	end

	Controls.OverallViewStack:CalculateSize();
	Controls.OverallViewStack:ReprocessAnchoring();
	Controls.OverallViewScrollbar:CalculateInternalSize();
	Controls.OverallViewScrollbar:ReprocessAnchoring();

	if(Controls.OverallViewScrollbar:GetScrollBar():IsHidden()) then
		Controls.OverallViewStack:SetOffsetX(-3);
	else
		Controls.OverallViewStack:SetOffsetX(-5);
	end
end


function PopulateOverallInstance(instance:table, victoryType:string, typeText:string)
	
	local victoryInfo:table= GameInfo.Victories[victoryType];
	
	instance.VictoryLabel:SetText(Locale.ToUpper(Locale.Lookup(victoryInfo.Name)));
	instance.VictoryLabelUnderline:SetSizeX(instance.VictoryLabel:GetSizeX() + PADDING_VICTORY_LABEL_UNDERLINE);
	
	local icon:string;
	local color:number;
	if typeText ~= nil then
		icon = "ICON_VICTORY_" .. typeText;
		color = UI.GetColorValue("COLOR_VICTORY_" .. typeText);
	else
		icon = victoryInfo.Icon or ICON_GENERIC;
		color = UI.GetColorValue("White");
	end
	instance.VictoryBanner:SetColor(color);
	instance.VictoryLabelGradient:SetColor(color);

	if icon ~= nil then
		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(icon, SIZE_VICTORY_ICON_SMALL);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon in PopulateOverallInstance: icon=\""..icon.."\", iconSize="..tostring(SIZE_VICTORY_ICON_SMALL));
		else
			instance.VictoryIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			instance.VictoryIcon:SetHide(false);
		end
	else
		instance.VictoryIcon:SetHide(true);
	end

	-- Tiebreak score functions
	local firstTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_DOMINATION_SCORE";
	local firstTiebreakerFunction = function(p)
		return p:GetScore();
	end;
	local secondTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_DOMINATION_SCORE";
	local secondTiebreakerFunction = function(p)
		return p:GetScore();
	end;
	if (victoryType == "VICTORY_TECHNOLOGY") then
		firstTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_SCIENCE_NUM_TECHS";
		firstTiebreakerFunction = function(p)
			return p:GetStats():GetNumTechsResearched();
		end;
		secondTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_SCIENCE_SCIENCE_RATE";
		secondTiebreakerFunction = function(p)
			return p:GetTechs():GetScienceYield();
		end;
	elseif (victoryType == "VICTORY_CULTURE") then
		firstTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_TOURISM_RATE";
		firstTiebreakerFunction = function(p)
			return p:GetStats():GetTourism();
		end;
		secondTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_CULTURE_RATE";
		secondTiebreakerFunction = function(p)
			return p:GetCulture():GetCultureYield();
		end;
	elseif (victoryType == "VICTORY_CONQUEST") then
		firstTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_DOMINATION_MILITARY_STRENGTH";
		firstTiebreakerFunction = function(p)
			return p:GetStats():GetMilitaryStrengthWithoutTreasury();
		end;
	elseif (victoryType == "VICTORY_RELIGIOUS") then
		firstTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_RELIGION_CITIES_FOLLOWING_RELIGION";
		firstTiebreakerFunction = function(p)
			return p:GetStats():GetNumCitiesFollowingReligion();
		end;
		secondTiebreakerText = "LOC_WORLD_RANKINGS_OVERVIEW_RELIGION_FAITH_RATE";
		secondTiebreakerFunction = function(p)
			return p:GetReligion():GetFaithYield();
		end;
	end

	-- Team tiebreaker score functions
	local firstTeamTiebreakerFunction = function(playerData, playerCount)
		local averageScore:number = 0;

		-- Add player scores
		for playerID, player in pairs(playerData) do
			averageScore = averageScore + player.FirstTiebreakScore;
		end

		-- Divide by player count
		averageScore = averageScore / playerCount;
		
		return averageScore;
	end;
	local secondTeamTiebreakerFunction = function(playerData, playerCount)
		local averageScore:number = 0;

		-- Add player scores
		for playerID, player in pairs(playerData) do
			averageScore = averageScore + player.SecondTiebreakScore;
		end

		-- Divide by player count
		averageScore = averageScore / playerCount;
		
		return averageScore;
	end;

	-- Gather team data
	local teamData:table = {};
	for teamID, team in pairs(Teams) do
		if (teamID >= 0) then
			-- If progress is nil, then the team is not capable of earning a victory (ex: city-state teams and barbarian teams).
			-- Skip any team that is incapable of earning a victory.
			local progress = Game.GetVictoryProgressForTeam(victoryType, teamID);
			if(progress ~= nil) then
				-- PlayerData
				local playerData:table = {};
				local playerCount:number = 0;
				for i, playerID in ipairs(team) do
					if IsAliveAndMajor(playerID) then
						local pPlayer = Players[playerID];
						playerData[playerID] = {
							Player = pPlayer,
							FirstTiebreakScore = firstTiebreakerFunction(pPlayer),
							SecondTiebreakScore = secondTiebreakerFunction(pPlayer),
							FirstTiebreakSummary = Locale.Lookup(firstTiebreakerText, Round(firstTiebreakerFunction(pPlayer), 1)),
							SecondTiebreakSummary = Locale.Lookup(secondTiebreakerText, Round(secondTiebreakerFunction(pPlayer), 1)),
						};

						playerCount = playerCount + 1;
					end
				end

				table.insert(teamData, {
					-- Team Data
					TeamID = teamID,
					TeamScore = progress,
					PlayerData = playerData,
					PlayerCount = playerCount,
					FirstTeamTiebreakScore = firstTeamTiebreakerFunction(playerData, playerCount);
					SecondTeamTiebreakScore = secondTeamTiebreakerFunction(playerData, playerCount);
				});
			end
		end
	end

	-- Sort teams by score
	table.sort(teamData, function(a, b)
		if (a.TeamScore == b.TeamScore) then
			if (a.FirstTeamTiebreakScore == b.FirstTeamTiebreakScore) then
				if (a.SecondTeamTiebreakScore == b.SecondTeamTiebreakScore) then
					return a.TeamID > b.TeamID;
				end
				return a.SecondTeamTiebreakScore > b.SecondTeamTiebreakScore;
			end
			return a.FirstTeamTiebreakScore > b.FirstTeamTiebreakScore;
		end
		return a.TeamScore > b.TeamScore;
	end);

	-- Ensure we have Instance Managers for the player meters
	local playersIM:table = instance[DATA_FIELD_OVERALL_PLAYERS_IM];
	if(playersIM == nil) then
		playersIM = InstanceManager:new("OverallPlayerInstance", "CivIconBackingFaded", instance.PlayerStack);
		instance[DATA_FIELD_OVERALL_PLAYERS_IM] = playersIM;
	end
	playersIM:ResetInstances();

	-- Populate top team/player icon
	if teamData[1].PlayerCount > 1 then
		PopulateOverallTeamIconInstance(instance, teamData[1], TEAM_ICON_SIZE_TOP_TEAM, TEAM_RIBBON_SIZE_TOP_TEAM);
	else
		PopulateOverallPlayerIconInstance(instance, teamData[1], SIZE_OVERALL_TOP_PLAYER_ICON);
	end

	-- Populate other team/player icons
	if #teamData > 1 then
		for i = 2, #teamData, 1 do
			local playerInstance:table = playersIM:GetInstance();
			if teamData[i].PlayerCount > 1 then
				PopulateOverallTeamIconInstance(playerInstance, teamData[i], TEAM_ICON_SIZE, TEAM_RIBBON_SIZE);
			else
				PopulateOverallPlayerIconInstance(playerInstance, teamData[i], SIZE_OVERALL_PLAYER_ICON);
			end
		end
	end

	-- Determine if local player is leading
	local isLocalPlayerLeading:boolean = false;
	local leadingTeam:table = teamData[1];
	for playerID, data in pairs(teamData[1].PlayerData) do
		if playerID == m_LocalPlayerID then
			isLocalPlayerLeading = true;
		end
	end

	-- Populate leading and local player labels
	if isLocalPlayerLeading then
		-- You or your team is leading
		instance.VictoryPlayer:SetText("");
		if teamData[1].PlayerCount > 1 then
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_TEAM_SIMPLE"));
		else
			instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_YOU_SIMPLE"));
		end
	else
		-- Set top team/player text
		local topName:string = "";
		if teamData[1].PlayerCount > 1 then
			topName = Locale.Lookup("LOC_WORLD_RANKINGS_TEAM", GameConfiguration.GetTeamName(teamData[1].TeamID));
		else
			local topPlayerID:number = Teams[teamData[1].TeamID][1];
			if(m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(topPlayerID))then
				topName = Locale.Lookup(GameInfo.Civilizations[PlayerConfigurations[Teams[teamData[1].TeamID][1]]:GetCivilizationTypeID()].Name);
			else
				topName = LOC_UNKNOWN_CIV;
			end
		end
		instance.VictoryLeading:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_FIRST_PLACE_OTHER_SIMPLE", topName));

		-- Set local team/player text
		for teamPosition, team in ipairs(teamData) do
			for playerID, data in pairs(team.PlayerData) do
				if playerID == m_LocalPlayerID then
					local localPlayerPositionText:string = Locale.Lookup("LOC_WORLD_RANKINGS_" .. teamPosition .. "_PLACE");
					local localPlayerDescription:string = "";

					if team.PlayerCount > 1 then
						localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_TEAM_SIMPLE", localPlayerPositionText);
					else
						localPlayerDescription = Locale.Lookup("LOC_WORLD_RANKINGS_OTHER_PLACE_SIMPLE", localPlayerPositionText);
					end

					instance.VictoryPlayer:SetText(localPlayerDescription);
				end
			end
		end
	end

	instance.ButtonBG:SetSizeY(SIZE_OVERALL_BG_HEIGHT + math.max(instance.PlayerStack:GetSizeY(), SIZE_OVERALL_INSTANCE));
end

function PopulateOverallTeamIconInstance(instance:table, teamData:table, iconSize:number, ribbonSize:number)
	-- Update team icon
	local teamColor:number = GetTeamColor(teamData.TeamID);
	local teamIconName:string = TEAM_ICON_PREFIX .. iconSize;
	instance.CivIcon:SetSizeVal(iconSize, iconSize);
	instance.CivIcon:SetTexture(teamIconName);
	instance.CivIconFaded:SetSizeVal(iconSize, iconSize);
	instance.CivIconFaded:SetTexture(teamIconName);
	instance.CivIcon:SetPercent(teamData.TeamScore);
	instance.CivIcon:SetColor(teamColor);
	instance.CivIconBacking:SetPercent(teamData.TeamScore);
	instance.CivIconBacking:SetColor(teamColor);

	-- Determine if this is the local players team
	instance.LocalPlayer:SetHide(true);
	for playerID, data in pairs(teamData.PlayerData) do
		if playerID == m_LocalPlayerID then
			instance.LocalPlayer:SetHide(false);
		end
	end

	-- Update team ribbon
	local teamRibbonName = TEAM_RIBBON_PREFIX .. tostring(teamData.TeamID);
	instance.TeamRibbon:SetIcon(teamRibbonName, ribbonSize);
	instance.TeamRibbon:SetHide(false);
	instance.TeamRibbon:SetColor(teamColor);

	-- Update tooltip
	SetTeamTooltip(instance.CivIcon, teamData);
end

function PopulateOverallPlayerIconInstance(instance:table, teamData:table, iconSize:number)
	-- Take the player ID from the first team member who should be the only team member
	local playerID:number = Teams[teamData.TeamID][1];
	local playerData:table = teamData.PlayerData[playerID];
	if(playerData ~= nil) then
		ColorCivIcon(instance, playerID);

		local civName:string, civIcon:string = GetCivNameAndIcon(playerID);

		local details:string;
		if playerData.FirstTiebreakSummary == playerData.SecondTiebreakSummary then
			details = playerData.FirstTiebreakSummary;
		else
			details = playerData.FirstTiebreakSummary .. "[NEWLINE]" .. playerData.SecondTiebreakSummary;
		end

		local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, iconSize);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon in PopulateOverallPlayerIconInstance: icon=\""..civIcon.."\", iconSize="..tostring(iconSize));
		else
			instance.CivIcon:SetSizeVal(iconSize, iconSize);
			instance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			instance.CivIconFaded:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			instance.CivIcon:SetPercent(teamData.TeamScore);
			instance.CivIconBacking:SetPercent(teamData.TeamScore);
			SetLeaderTooltip(instance, playerID, details);
		end

		instance.LocalPlayer:SetHide(playerID ~= m_LocalPlayerID);
		instance.TeamRibbon:SetHide(true);
	end
end

function SetTeamTooltip(control:table, teamData)
	control:SetToolTipType("TeamTooltip");
	control:SetToolTipCallback(function() UpdateTeamTooltip(control, teamData); end);
end

function UpdateTeamTooltip(control, teamData)
	if m_TeamTooltip.TooltipIM == nil then
		m_TeamTooltip.TooltipIM = InstanceManager:new("TeamTooltipInstance", "BG", m_TeamTooltip.CivStack);
	end

	m_TeamTooltip.TooltipIM:ResetInstances();
	
	-- Tracks the widest instance
	local maxWidth:number = 0;

	-- Create an instance for each met player on this team
	for playerID, playerData in pairs(teamData.PlayerData) do
		if m_LocalPlayerID == playerID or m_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			local civInstance:table = m_TeamTooltip.TooltipIM:GetInstance();

			-- Hide/show necessary controls
			civInstance.LeaderIcon:SetHide(false);
			civInstance.YouIndicator:SetHide(false);
			civInstance.LeaderName:SetHide(false);
			civInstance.UnmetLabel:SetHide(true);

			-- Update local player indicator
			civInstance.YouIndicator:SetHide(playerID ~= m_LocalPlayerID);
		
			local playerConfig:table = PlayerConfigurations[playerID];
			local leaderTypeName:string = playerConfig:GetLeaderTypeName();
			if(leaderTypeName ~= nil) then
				-- Update player icon
				local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_"..leaderTypeName, SIZE_LEADER_ICON);
				if(textureSheet == nil or textureSheet == "") then
					UI.DataError("Could not find icon in UpdateLeaderTooltip: icon=\"".."ICON_"..leaderTypeName.."\", iconSize="..tostring(SIZE_LEADER_ICON));
				else
					civInstance.LeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
				end

				-- Update description string
				local desc:string;
				local leaderDesc:string = playerConfig:GetLeaderName();
				local civDesc:string = playerConfig:GetCivilizationDescription();
				if GameConfiguration.IsAnyMultiplayer() and playerData.Player:IsHuman() then
					local name = Locale.Lookup(playerConfig:GetPlayerName());
					desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc) .. " (" .. name .. ")";
				else
					desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc);
				end

				if playerData.FirstTiebreakSummary and playerData.FirstTiebreakSummary ~= "" then
					desc = desc .. "[NEWLINE]" .. playerData.FirstTiebreakSummary;
				end
				
				if playerData.SecondTiebreakSummary and playerData.SecondTiebreakSummary ~= "" and playerData.SecondTiebreakSummary ~= playerData.FirstTiebreakSummary then
					desc = desc .. "[NEWLINE]" .. playerData.SecondTiebreakSummary;
				end
			
				civInstance.LeaderName:SetText(desc);
				civInstance.BG:DoAutoSize();
			
				-- Track the most wide instance so we can widen smaller instances to match
				if civInstance.BG:GetSizeX() > maxWidth then
					maxWidth = civInstance.BG:GetSizeX();
				end
			end
		end
	end

	-- Create an unmet instance for each unmet player on this team
	for playerID, playerData in pairs(teamData.PlayerData) do
		if m_LocalPlayerID ~= playerID and not m_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			local civInstance:table = m_TeamTooltip.TooltipIM:GetInstance();

			-- Hide/show necessary controls
			civInstance.LeaderIcon:SetHide(true);
			civInstance.YouIndicator:SetHide(true);
			civInstance.LeaderName:SetHide(true);
			civInstance.UnmetLabel:SetHide(false);

			-- Set the unmet text based on whether this is human or AI
			local playerConfig:table = PlayerConfigurations[playerID];
			if GameConfiguration.IsAnyMultiplayer() and playerData.Player:IsHuman() then
				civInstance.UnmetLabel:SetText(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER") .. " (" .. playerConfig:GetPlayerName() .. ")");
			else
				civInstance.UnmetLabel:SetText(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER"));
			end

			civInstance.BG:DoAutoSize();
		end
	end

	-- Widen all instances to match up
	for i=1,m_TeamTooltip.TooltipIM.m_iCount,1 do
		local instance:table = m_TeamTooltip.TooltipIM:GetAllocatedInstance(i);
		if instance and instance.BG:GetSizeX() < maxWidth then
			instance.BG:SetSizeX(maxWidth);
		end
	end
end

function SetLeaderTooltip(instance:table, playerID:number, details:string)
	local pPlayer:table = Players[playerID];
	local playerConfig:table = PlayerConfigurations[playerID];
	if(playerID ~= m_LocalPlayerID and m_LocalPlayer ~= nil and not m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		instance.CivIcon:SetToolTipType();
		instance.CivIcon:ClearToolTipCallback();
		if GameConfiguration.IsAnyMultiplayer() and pPlayer:IsHuman() then
			instance.CivIcon:SetToolTipString(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER") .. " (" .. playerConfig:GetPlayerName() .. ")");
		else
			instance.CivIcon:SetToolTipString(Locale.Lookup("LOC_DIPLOPANEL_UNMET_PLAYER"));
		end
	else
		instance.CivIcon:SetToolTipType("CivTooltip");
		instance.CivIcon:SetToolTipCallback(function() UpdateLeaderTooltip(instance, playerID, details); end);
	end
end

function UpdateLeaderTooltip(instance:table, playerID:number, details:string)
	local pPlayer:table = Players[playerID];
	local playerConfig:table = PlayerConfigurations[playerID];
	if(pPlayer ~= nil and playerConfig ~= nil) then

		m_CivTooltip.YouIndicator:SetHide(playerID ~= m_LocalPlayerID);

		local leaderTypeName:string = playerConfig:GetLeaderTypeName();
		if(leaderTypeName ~= nil) then
			local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_"..leaderTypeName, SIZE_LEADER_ICON);
			if(textureSheet == nil or textureSheet == "") then
				UI.DataError("Could not find icon in UpdateLeaderTooltip: icon=\"".."ICON_"..leaderTypeName.."\", iconSize="..tostring(SIZE_LEADER_ICON));
			else
				m_CivTooltip.LeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			end

			local desc:string;
			local leaderDesc:string = playerConfig:GetLeaderName();
			local civDesc:string = playerConfig:GetCivilizationDescription();
			if GameConfiguration.IsAnyMultiplayer() and pPlayer:IsHuman() then
				local name = Locale.Lookup(playerConfig:GetPlayerName());
				desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc) .. " (" .. name .. ")";
			else
				desc = Locale.Lookup("LOC_DIPLOMACY_DEAL_PLAYER_PANEL_TITLE", leaderDesc, civDesc);
			end
			
			if (details ~= nil and details ~= "") then
				desc = desc .. "[NEWLINE]" .. details;
			end
			m_CivTooltip.LeaderName:SetText(desc);
			m_CivTooltip.BG:DoAutoSize();
		end
	end
end

-- ===========================================================================
--	Called when Score tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScore()
	ResetState(ViewScore);
	Controls.ScoreView:SetHide(false);

	ChangeActiveHeader("VICTORY_SCORE", m_GenericHeaderIM, Controls.ScoreViewHeader);
	local subTitle:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_CONDITION", Game.GetMaxGameTurns());
	PopulateGenericHeader(RealizeScoreStackSize, SCORE_TITLE, subTitle, SCORE_DETAILS, ICON_GENERIC);

	-- Gather data
	local scoreData:table = GatherScoreData();

	-- Sort teams
	table.sort(scoreData, function(a, b) return a.TeamScore > b.TeamScore; end);

	m_ScoreIM:ResetInstances();
	m_ScoreTeamIM:ResetInstances();

	for i, teamData in ipairs(scoreData) do
		if #teamData.PlayerData > 1 then
			-- Sort players before displaying
			table.sort(teamData.PlayerData, function(a, b) return a.PlayerScore> b.PlayerScore; end);

			-- Display as team
			PopulateScoreTeamInstance(m_ScoreTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			PopulateScoreInstance(m_ScoreIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeScoreStackSize();
end

function GatherScoreData()
	local data:table = {};

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, PlayerData = {}, TeamScore = 0 };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID, PlayerScore = pPlayer:GetScore(), Categories = {} };

					-- Add player score to team score
					teamData.TeamScore = teamData.TeamScore + playerData.PlayerScore;

					-- Look up category scores
					local scoreCategories = GameInfo.ScoringCategories;
					local numCategories:number = #scoreCategories;
					for i = 0, numCategories - 1 do
						if scoreCategories[i].Multiplier > 0 or m_isDebugForceShowAllScoreCategories then
							table.insert(playerData.Categories, { CategoryID = i, CategoryScore = pPlayer:GetCategoryScore(i) });
						end
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateScoreTeamInstance(instance:table, teamData:table)
	
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ScoreInstance", "ButtonBG", instance.ScorePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateScoreInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end

	-- Update combined team score
	instance.TeamScore:SetText(tostring(teamData.TeamScore));
end

function PopulateScoreInstance(instance:table, playerData:table)
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	instance.Score:SetText(playerData.PlayerScore);
	

	if(m_ShowScoreDetails) then
		instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DETAILS);
		
		local detailsText:string = "";
		for i, category in ipairs(playerData.Categories) do
			local categoryInfo:table = GameInfo.ScoringCategories[category.CategoryID];
			detailsText = detailsText .. Locale.Lookup(categoryInfo.Name) .. ": " .. category.CategoryScore;

			-- Add new lines between categories but not at the end
			if i <= #playerData.Categories then
				detailsText = detailsText .. "[NEWLINE]";
			end
		end

		instance.Details:SetText(detailsText);
		instance.Details:SetHide(false);
	else
		instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DEFAULT);
		instance.Details:SetHide(true);
	end
end

function RealizeScoreStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT];
		Controls.ScoreViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ScoreViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.ScoreViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ScoreViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.ScoreViewStack, Controls.ScoreViewScrollbar, true);

	local textSize:number = Controls.ScoreDetailsButton:GetTextControl():GetSizeX();
	Controls.ScoreDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end

function ToggleScoreDetails()
	m_ShowScoreDetails = not m_ShowScoreDetails;
	Controls.ScoreDetailsCheck:SetCheck(m_ShowScoreDetails);
	ViewScore();
end

-- ===========================================================================
--	Called when Science tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScience()
	ResetState(ViewScience);
	Controls.ScienceView:SetHide(false);

	ChangeActiveHeader("VICTORY_TECHNOLOGY", m_ScienceHeaderIM, Controls.ScienceViewHeader);
	PopulateGenericHeader(RealizeScienceStackSize, SCIENCE_TITLE, "", SCIENCE_DETAILS, SCIENCE_ICON);
	
	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0, 0, 0 }; -- initialize with 3 elements
	local finishedProjects:table = { {}, {}, {} };
	
	local bHasSpaceport:boolean = false;
	if (m_LocalPlayer ~= nil) then
		for _,district in m_LocalPlayer:GetDistricts():Members() do
			if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
				bHasSpaceport = true;
				break;
			end
		end

		local pPlayerStats:table = m_LocalPlayer:GetStats();
		local pPlayerCities:table = m_LocalPlayer:GetCities();
		for _, city in pPlayerCities:Members() do
			local pBuildQueue:table = city:GetBuildQueue();
			-- 1st milestone - satelite launch
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EARTH_SATELLITE_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
			progressResults[1] = currentProgress / totalCost;

			-- 2nd milestone - moon landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MOON_LANDING_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
			progressResults[2] = currentProgress / totalCost;
		
			-- 3rd milestone - mars landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MARS_COLONY_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
			progressResults[3] = currentProgress / totalCost;
		end
	end

	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";
			if(nextStep == "") then
				nextStep = GetNextStepForScienceProject(m_LocalPlayer, SCIENCE_PROJECTS[i], bHasSpaceport, finishedProjects[i]);
			end
		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. SCIENCE_REQUIREMENTS[i];
		if(i < 3) then progressText = progressText .. "[NEWLINE]"; end
	end

	m_ActiveHeader.AdvisorTextCentered:SetText(progressText);
	m_ActiveHeader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP", nextStep));

	m_ScienceIM:ResetInstances();
	m_ScienceTeamIM:ResetInstances();

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			if #team > 1 then
				PopulateScienceTeamInstance(m_ScienceTeamIM:GetInstance(), teamID);
			else
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateScienceInstance(m_ScienceIM:GetInstance(), pPlayer);
				end
			end
		end
	end

	RealizeScienceStackSize();
end

function GetNextStepForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	if(not bHasSpaceport) then 
		return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name));
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(not playerTech:HasTech(tech.Index)) then
				return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name));
			end
		end

		if(not finishedProjects[i]) then
			return Locale.Lookup(projectInfo.Name);
		end
	end
	return "";
end

function PopulateTeamInstanceShared(instance, teamID)
	-- Update team color
	local teamColor:number = GetTeamColor(teamID);
	instance.TeamButton:SetColor(teamColor);
	instance.TeamIconBacking:SetColor(teamColor);
	instance.TeamIcon:SetColor(teamColor);
	
	-- Update team ribbon
	local teamRibbonName:string = TEAM_RIBBON_PREFIX .. tostring(teamID);
	instance.TeamRibbon:SetIcon(teamRibbonName, TEAM_RIBBON_SIZE);
	instance.TeamRibbon:SetColor(teamColor);

	-- Update team name
	instance.TeamName:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_TEAM", GameConfiguration.GetTeamName(teamID)));

	-- Update Team Tooltip
	local teamData:table = { PlayerData = {} };
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			teamData.PlayerData[playerID] = { Player = Players[playerID] };
		end
	end
	SetTeamTooltip(instance.TeamIcon, teamData);
end

function PopulatePlayerInstanceShared(instance, playerID)
	local civName, civIcon:string = GetCivNameAndIcon(playerID, true);

	-- Update civ icon and leader tooltip
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(civIcon, SIZE_CIV_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulatePlayerInstanceShared: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_CIV_ICON));
	else
		instance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		SetLeaderTooltip(instance, playerID);
	end
	ColorCivIcon(instance, playerID);

	-- Update player name
	if m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID) or m_LocalPlayerID == playerID then
		instance.CivName:SetText(civName);
		TruncateStringWithTooltip(instance.CivName, 180, civName);
	else
		instance.CivName:SetText(LOC_UNKNOWN_CIV);
	end

	-- Update local player indicator
	if instance.LocalPlayer then
		instance.LocalPlayer:SetHide(playerID ~= m_LocalPlayerID);
	end
end

function PopulateScienceTeamInstance(instance:table, teamID:number)

	PopulateTeamInstanceShared(instance, teamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ScienceInstance", "ButtonBG", instance.SciencePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	local teamProgressData:table = {};
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			local pPlayer:table = Players[playerID];
			local progressData = PopulateScienceInstance(instance.PlayerStackIM:GetInstance(), pPlayer);
			if progressData then
				table.insert(teamProgressData, progressData);
			end
		end
	end

	-- Sort team progress data
	table.sort(teamProgressData, function(a, b)
		-- Compare stage 1 progress
		local aScore = a.projectProgresses[1] / a.projectTotals[1];
		local bScore = b.projectProgresses[1] / b.projectTotals[1];
		if aScore == bScore then
			-- Compare stage 2 progress
			aScore = a.projectProgresses[2] / a.projectTotals[2];
			bScore = b.projectProgresses[2] / b.projectTotals[2];
			if aScore == bScore then
				-- Compare stage 3 progress
				aScore = a.projectProgresses[3] / a.projectTotals[3];
				bScore = b.projectProgresses[3] / b.projectTotals[3];
				if aScore == bScore then
					return a.playerID < b.playerID;
				end
			end
		end
		return aScore > bScore;
	end);

	-- Populate the team progress with the progress of the furthest player
	if teamProgressData and #teamProgressData > 0 then
		PopulateScienceProgressMeters(instance, teamProgressData[1]);
	end
end

function PopulateScienceInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	
	-- Progress Data to be returned from function
	local progressData = nil; 
	local bHasMet = m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID);
	if (bHasMet == true or playerID == Game.GetLocalPlayer()) then

		local bHasSpaceport:boolean = false;
		for _,district in pPlayer:GetDistricts():Members() do
			if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
				bHasSpaceport = true;
				break;
			end
		end

		local pPlayerStats:table = pPlayer:GetStats();
		local pPlayerCities:table = pPlayer:GetCities();
		local projectTotals:table = { 0, 0, 0 };
		local projectProgresses:table = { 0, 0, 0 };
		local finishedProjects:table = { {}, {}, {} };
		for _, city in pPlayerCities:Members() do
			local pBuildQueue:table = city:GetBuildQueue();

			-- 1st milestone - satelite launch
			for i, projectInfo in ipairs(EARTH_SATELLITE_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				finishedProjects[1][i] = false;
				if projectProgress ~= 0 then
					projectTotals[1] = projectTotals[1] + projectCost;
					projectProgresses[1] = projectProgresses[1] + projectProgress;
					finishedProjects[1][i] = projectProgress == projectCost;
				end
			end

			-- 2nd milestone - moon landing
			for i, projectInfo in ipairs(MOON_LANDING_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				finishedProjects[2][i] = false;
				if projectProgress ~= 0 then
					projectTotals[2] = projectTotals[2] + projectCost;
					projectProgresses[2] = projectProgresses[2] + projectProgress;
					finishedProjects[2][i] = projectProgress == projectCost;
				end
			end

			-- 3rd milestone - mars landing
			for i, projectInfo in ipairs(MARS_COLONY_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				finishedProjects[3][i] = false;
				if projectProgress ~= 0 then
					projectTotals[3] = projectTotals[3] + projectCost;
					projectProgresses[3] = projectProgresses[3] + projectProgress;
					finishedProjects[3][i] = projectProgress == projectCost;
				end
			end
		end

		-- Save data to be returned
		progressData = {};
		progressData.playerID = playerID;
		progressData.projectTotals = projectTotals;
		progressData.projectProgresses = projectProgresses;
		progressData.bHasSpaceport = bHasSpaceport;
		progressData.finishedProjects = finishedProjects;

		PopulateScienceProgressMeters(instance, progressData);
	else -- Unmet civ
		for i = 1, 3 do
			instance["ObjBar_" .. i]:SetPercent(0);
			instance["ObjFill_" .. i]:SetHide(true);
			instance["ObjHidden_" .. i]:SetHide(false);
			instance["ObjToggle_ON_" .. i]:SetHide(true);
			instance["ObjToggle_ON_" .. i]:SetToolTipString("");
			instance["ObjToggle_OFF_" .. i]:SetToolTipString("");
		end
	end

	return progressData;
end

function PopulateScienceProgressMeters(instance:table, progressData:table)
	for i = 1, 3 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(progressData.projectProgresses[i] == 0);
		instance["ObjBar_" .. i]:SetPercent(progressData.projectProgresses[i] / progressData.projectTotals[i]);
		instance["ObjToggle_ON_" .. i]:SetHide(progressData.projectTotals[i] == 0 or progressData.projectProgresses[i] ~= progressData.projectTotals[i]);
	end
		
	local pPlayer = Players[progressData.playerID];
	instance.ObjBG_1:SetToolTipString(GetTooltipForScienceProject(pPlayer, EARTH_SATELLITE_PROJECT_INFOS, progressData.bHasSpaceport, progressData.finishedProjects[1]));
	instance.ObjBG_2:SetToolTipString(GetTooltipForScienceProject(pPlayer, MOON_LANDING_PROJECT_INFOS, nil, progressData.finishedProjects[2]));
	instance.ObjBG_3:SetToolTipString(GetTooltipForScienceProject(pPlayer, MARS_COLONY_PROJECT_INFOS, nil, progressData.finishedProjects[3]));
end

function GetTooltipForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	local result:string = "";

	-- Only show spaceport for first tooltip
	if bHasSpaceport ~= nil then
		if(bHasSpaceport) then 
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name)) .. "[NEWLINE]";
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(playerTech:HasTech(tech.Index)) then
				result = result .. "[ICON_CheckmarkBlue]";
			else
				result = result .. "[ICON_Bolt]";
			end
			result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name)) .. "[NEWLINE]";
		end

		if(finishedProjects[i]) then
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup(projectInfo.Name);
		if(i < numProjectInfos) then result = result .. "[NEWLINE]"; end
	end

	return result;
end

function RealizeScienceStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT];
		m_ActiveHeader.AdvisorTextCentered:SetOffsetY(OFFSET_SCIENCE_REQUIREMENTS_Y + m_ActiveHeader.AdvisorText:GetSizeY() + PADDING_HEADER);
		m_ActiveHeader.AdvisorTextNextStep:SetOffsetY(m_ActiveHeader.AdvisorTextCentered:GetOffsetY() + m_ActiveHeader.AdvisorTextCentered:GetSizeY() + PADDING_HEADER);
		m_ActiveHeader.NextStepHighlight:SetOffsetY(-m_ActiveHeader.AdvisorTextNextStep:GetSizeY() + PADDING_NEXT_STEP_HIGHLIGHT);
		headerHeight = headerHeight + m_ActiveHeader.AdvisorTextCentered:GetSizeY() + m_ActiveHeader.AdvisorTextNextStep:GetSizeY() + (PADDING_HEADER * 2);
		m_ActiveHeader.AdvisorTextBG:SetSizeY(headerHeight);
		m_ActiveHeader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		m_ActiveHeader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		m_ActiveHeader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);
		Controls.ScienceViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ScienceViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
		m_ActiveHeader.AdvisorTextCentered:SetHide(false);
		m_ActiveHeader.AdvisorTextNextStep:SetHide(false);
	else
		Controls.ScienceViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ScienceViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		m_ActiveHeader.AdvisorTextCentered:SetHide(true);
		m_ActiveHeader.AdvisorTextNextStep:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.ScienceViewStack, Controls.ScienceViewScrollbar, true);

	--local textSize:number = Controls.ScienceDetailsButton:GetTextControl():GetSizeX();
	--Controls.ScienceDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end

-- ===========================================================================
function ResetTourismLens()
	if UILens.IsLensActive("TourismWithUnits") then
		UILens.SetActive("Default");
	end
end

-- ===========================================================================
--	Called when Culture tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function SetCultureHeaderState(state:number)
	m_CultureHeaderState = state;
	ViewCulture();
end

function ViewCulture()
	ResetState(ViewCulture);
	Controls.CultureView:SetHide(false);

	ChangeActiveHeader("VICTORY_CULTURE", m_CultureHeaderIM, Controls.CultureViewHeader);

	-- Active the Tourism lens if it isn't already
	if not UILens.IsLensActive("TourismWithUnits") then
		UILens.SetActive("TourismWithUnits");
	end

	local detailsText:string;
	if(m_CultureHeaderState == CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY) then
		detailsText = CULTURE_VICTORY_DETAILS;
		m_ActiveHeader.DomesticTourism:SetText(CULTURE_DOMESTIC_TOURISTS);
		m_ActiveHeader.VisitingTourism:SetText(CULTURE_VISITING_TOURISTS);
	else
		UI.DataError("Unknown m_CultureHeaderState in ViewCulture: " .. tostring(m_CultureHeaderState));
	end

	PopulateGenericHeader(RealizeCultureStackSize, CULTURE_TITLE, "", detailsText, CULTURE_ICON);

	-- Gather data
	local cultureData:table = GatherCultureData();

	-- Sort by team
	table.sort(cultureData, function(a, b) return a.BestNumVisitingUs / a.BestNumRequiredTourists > b.BestNumVisitingUs / b.BestNumRequiredTourists; end);

	m_CultureIM:ResetInstances();
	m_CultureTeamIM:ResetInstances();

	for i, teamData in ipairs(cultureData) do
		if #teamData.PlayerData > 1 then
			-- Display as team
			PopulateCultureTeamInstance(m_CultureTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			PopulateCultureInstance(m_CultureIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeCultureStackSize();
end

function GatherCultureData()
	local data:table = {};

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, PlayerData = {}, BestNumVisitingUs = 0, BestNumRequiredTourists = 1 };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { 
						PlayerID = playerID, 
						NumRequiredTourists = 0,
						NumStaycationers = pPlayer:GetCulture():GetStaycationers(),
						NumVisitingUs = pPlayer:GetCulture():GetTouristsTo() };

					-- Determine number of tourist needed for victory
					-- Has to be one more than every other players number of domestic tourists
					for i, player in ipairs(Players) do
						if i ~= playerID and IsAliveAndMajor(i)  and player:GetTeam() ~= teamID then
							local iStaycationers = player:GetCulture():GetStaycationers();
							if iStaycationers >= playerData.NumRequiredTourists then
								playerData.NumRequiredTourists = iStaycationers + 1;
							end
						end
					end

					-- See if this player has the best score for this team
					local currentTeamScore:number = teamData.BestNumVisitingUs / teamData.BestNumRequiredTourists;
					local playerScore:number = playerData.NumVisitingUs / playerData.NumRequiredTourists;
					if currentTeamScore < playerScore or (currentTeamScore == playerScore and teamData.BestNumRequiredTourists < playerData.NumRequiredTourists) then
						teamData.BestNumVisitingUs = playerData.NumVisitingUs;
						teamData.BestNumRequiredTourists = playerData.NumRequiredTourists;
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateCultureTeamInstance(instance:table, teamData:table)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("CultureInstance", "ButtonBG", instance.CulturePlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateCultureInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end

	-- Show score for player closet to winning
	instance.VisitingTourists:SetText(teamData.BestNumVisitingUs .. "/" .. teamData.BestNumRequiredTourists);
end

function PopulateCultureInstance(instance:table, playerData:table)
	local pPlayer:table = Players[playerData.PlayerID];
	
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	instance.VisitingTourists:SetText(playerData.NumVisitingUs .. "/" .. playerData.NumRequiredTourists);
	instance.TouristsFill:SetPercent(playerData.NumVisitingUs / playerData.NumRequiredTourists);
	instance.VisitingUsContainer:SetHide(playerData.PlayerID == m_LocalPlayerID);

	local backColor, _ = UI.GetPlayerColors(playerData.PlayerID);
	local brighterBackColor = DarkenLightenColor(backColor,35,255);
	if(playerData.PlayerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerData.PlayerID)) then
		instance.DomesticTouristsIcon:SetColor(brighterBackColor);
	else
		instance.DomesticTouristsIcon:SetColor(RGBAValuesToABGRHex(1, 1, 1, 0.35));
	end
	instance.DomesticTourists:SetText(playerData.NumStaycationers);

	if (m_LocalPlayer ~= nil) then
		instance.VisitingUsTourists:SetText(m_LocalPlayer:GetCulture():GetTouristsFrom(playerData.PlayerID));
		instance.VisitingUsTourists:SetToolTipString(m_LocalPlayer:GetCulture():GetTouristsFromTooltip(playerData.PlayerID));
		instance.VisitingUsIcon:SetToolTipString(m_LocalPlayer:GetCulture():GetTouristsFromTooltip(playerData.PlayerID));
	end
end

function RealizeCultureStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader.AdvisorText:GetSizeY() + PADDING_ADVISOR_TEXT_BG;

		if(m_CultureHeaderState == CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY) then
			m_ActiveHeader.HowToAttractTourists:SetOffsetY(headerHeight);
			headerHeight = headerHeight + math.max(m_ActiveHeader.DomesticTourism:GetSizeY(), m_ActiveHeader.DomesticTourismIcon:GetSizeY()) + (PADDING_HEADER * 2);
			headerHeight = headerHeight + math.max(m_ActiveHeader.VisitingTourism:GetSizeY(), m_ActiveHeader.VisitingTourismIcon:GetSizeY()) + PADDING_HEADER;
			m_ActiveHeader.HowToAttractTourists:SetHide(false);
		else
			UI.DataError("Unknown m_CultureHeaderState in ViewCulture: " .. tostring(m_CultureHeaderState));
		end

		m_ActiveHeader.AdvisorTextBG:SetSizeY(headerHeight);
		m_ActiveHeader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		m_ActiveHeader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		m_ActiveHeader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);

		m_ActiveHeader.StateBG:SetOffsetY(headerHeight + PADDING_CULTURE_HEADER);

		headerHeight = headerHeight + m_ActiveHeader.StateBG:GetSizeY() + PADDING_HEADER;

		m_ActiveHeader.NextState:SetOffsetX(m_ActiveHeader.StateBG:GetSizeX());
		
		Controls.CultureViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.CultureViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.CultureViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.CultureViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		m_ActiveHeader.HowToAttractTourists:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.CultureViewStack, Controls.CultureViewScrollbar, true);
end

-- ===========================================================================
--	Called when Domination tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewDomination()
	ResetState(ViewDomination);
	Controls.DominationView:SetHide(false);

	ChangeActiveHeader("VICTORY_CONQUEST", m_GenericHeaderIM, Controls.DominationViewHeader);
	PopulateGenericHeader(RealizeDominationStackSize, DOMINATION_TITLE, "", DOMINATION_DETAILS, DOMINATION_ICON);

	local dominationData:table = {};
	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, TotalCapturedCapitals = 0, PlayerData = {} };

			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer = Players[playerID];
					local pCities = pPlayer:GetCities();

					-- Don't show player if they haven't founded a capital city yet
					local pCapital = pCities:GetCapitalCity();
					if(pCapital ~= nil) then
						local playerData:table = {};
						playerData.PlayerID				= playerID;
						playerData.HasOriginalCapital	= false;
						playerData.CapturedCapitals		= {};

						local data = {};
						for _, city in pCities:Members() do
							local originalOwnerID:number = city:GetOriginalOwner();
							local pOriginalOwner:table = Players[originalOwnerID];
							if(playerID ~= originalOwnerID and pOriginalOwner:IsMajor() and city:IsOriginalCapital()) then
								table.insert(playerData.CapturedCapitals, originalOwnerID);
								teamData.TotalCapturedCapitals = teamData.TotalCapturedCapitals + 1;
							elseif(playerID == originalOwnerID and pOriginalOwner:IsMajor() and city:IsOriginalCapital()) then
								playerData.HasOriginalCapital = true;
							end
						end

						table.insert(teamData.PlayerData, playerData);
					end
				end
			end

			table.insert(dominationData, teamData);
		end
	end

	m_DominationIM:ResetInstances();
	m_DominationTeamIM:ResetInstances();

	-- Sort players within teams by dominated capitals
	for i, teamData in ipairs(dominationData) do 
		table.sort(teamData.PlayerData, function(a, b) return #a.CapturedCapitals > #b.CapturedCapitals end);
	end

	-- Sort teams by most combined dominated capitals
	table.sort(dominationData, function(a, b) return a.TotalCapturedCapitals > b.TotalCapturedCapitals end);

	-- Populate teams
	for i, teamData in ipairs(dominationData) do
		if #teamData.PlayerData > 1 then
			PopulateDominationTeamInstance(m_DominationTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData == 1 then
			PopulateDominationInstance(m_DominationIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeDominationStackSize();
end

function PopulateDominationTeamInstance(instance:table, teamData:table)
	
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Update captured captials icon stack
	local dominatedCitiesIM:table = instance[DATA_FIELD_DOMINATED_CITIES_IM];
	if(dominatedCitiesIM == nil) then
		dominatedCitiesIM = InstanceManager:new("DominatedCapitalInstance", "CivIconBacking", instance.CapitalsCapturedStack);
		instance[DATA_FIELD_DOMINATED_CITIES_IM] = dominatedCitiesIM;
	end
	dominatedCitiesIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		for _, dominatedPlayerID in pairs(playerData.CapturedCapitals) do
			local dominatedInstance = dominatedCitiesIM:GetInstance();
			ColorCivIcon(dominatedInstance, dominatedPlayerID);
			
			local civName:string, civIcon:string = GetCivNameAndIcon(dominatedPlayerID, true);
			textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, SIZE_RELIGION_CIV_ICON);
			if(textureSheet == nil or textureSheet == "") then
				UI.DataError("Could not find icon for dominated civ in PopulateDominationInstance: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_RELIGION_CIV_ICON));
			else
				dominatedInstance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
				SetLeaderTooltip(dominatedInstance, dominatedPlayerID);
			end
		end
	end

	-- Update captured capitals label
	instance.CapitalsCaptured:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_SUMMARY", teamData.TotalCapturedCapitals));

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("DominationInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateDominationInstance(instance.PlayerStackIM:GetInstance(), playerData);
	end
end

function PopulateDominationInstance(instance:table, playerData:table)
	local pPlayer:table = Players[playerData.PlayerID];

	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	instance.HasCapital:SetHide(not playerData.HasOriginalCapital);
	instance.HasCapital:SetToolTipString(DOMINATION_HAS_ORIGINAL_CAPITAL);

	local dominatedCitiesIM:table = instance[DATA_FIELD_DOMINATED_CITIES_IM];
	if(dominatedCitiesIM == nil) then
		dominatedCitiesIM = InstanceManager:new("DominatedCapitalInstance", "CivIconBacking", instance.CapitalsCapturedStack);
		instance[DATA_FIELD_DOMINATED_CITIES_IM] = dominatedCitiesIM;
	end
	dominatedCitiesIM:ResetInstances();

	for _, dominatedPlayerID in pairs(playerData.CapturedCapitals) do
		local dominatedInstance = dominatedCitiesIM:GetInstance();
		ColorCivIcon(dominatedInstance, dominatedPlayerID);
			
		local civName:string, civIcon:string = GetCivNameAndIcon(dominatedPlayerID, true);
		textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, SIZE_RELIGION_CIV_ICON);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon for dominated civ in PopulateDominationInstance: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_RELIGION_CIV_ICON));
		else
			dominatedInstance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			SetLeaderTooltip(dominatedInstance, dominatedPlayerID);
		end
	end

	instance.CapitalsCaptured:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_SUMMARY", #playerData.CapturedCapitals));
end

function RealizeDominationStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT];
		Controls.DominationViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.DominationViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.DominationViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.DominationViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.DominationViewStack, Controls.DominationViewScrollbar, true);
end

-- ===========================================================================
--	Called when Religion tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewReligion()
	ResetState(ViewReligion);
	Controls.ReligionView:SetHide(false);

	ChangeActiveHeader("VICTORY_RELIGIOUS", m_GenericHeaderIM, Controls.ReligionViewHeader);
	PopulateGenericHeader(RealizeReligionStackSize, RELIGION_TITLE, "", RELIGION_DETAILS, RELIGION_ICON);

	m_ReligionIM:ResetInstances();
	m_ReligionTeamIM:ResetInstances();

	local religionData:table, totalCivs:number = GatherReligionData();

	for i, teamData in ipairs(religionData) do
		if #teamData.PlayerData > 1 then
			-- Display as team
			PopulateReligionTeamInstance(m_ReligionTeamIM:GetInstance(), teamData, totalCivs);
		elseif #teamData.PlayerData > 0 then
			-- Display as single civ
			if teamData.PlayerData[1].ReligionType > 0 then
				PopulateReligionInstance(m_ReligionIM:GetInstance(), teamData.PlayerData[1], totalCivs);
			end
		end
	end

	RealizeReligionStackSize();
end

function GatherReligionData()
	local data:table = {};
	local totalCivs:number = 0;

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, PlayerData = {}, ReligionTypes = {}, ConvertedCivs = {} };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					totalCivs = totalCivs + 1;
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID, ConvertedCivs = {} };
					
					local pReligion = pPlayer:GetReligion();
					if pReligion ~= nil then
						playerData.ReligionType = pReligion:GetReligionTypeCreated();
						if playerData.ReligionType ~= -1 then
							
							-- Add religion to team religions if unique
							local containsReligion:boolean = false;
							for i, religionType in ipairs(teamData.ReligionTypes) do
								if religionType == playerData.ReligionType then
									containsReligion = true;
								end
							end
							if not containsReligion then
								table.insert(teamData.ReligionTypes, playerData.ReligionType );
							end

							-- Determine which civs our religion has taken over
							for otherID, player in ipairs(Players) do
								if IsAliveAndMajor(otherID) then
									local pOtherReligion = player:GetReligion();
									if pOtherReligion ~= nil then
										local otherReligionType:number = pOtherReligion:GetReligionInMajorityOfCities();
										if otherReligionType == playerData.ReligionType then
											table.insert(playerData.ConvertedCivs, otherID);
											
											-- Add convert civs to team converted civs if unique
											local containsCiv:boolean = false;
											for i, convertedCivID in ipairs(teamData.ConvertedCivs) do
												if convertedCivID == otherID then
													containsCiv = true;
												end
											end
											if not containsCiv then
												table.insert(teamData.ConvertedCivs, otherID );
											end
										end
									end
								end
							end
						end
					end

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data, totalCivs;	
end

function PopulateReligionTeamInstance(instance:table, teamData:table, totalCivs:number)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("ReligionInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		if playerData.ReligionType > 0 then
			PopulateReligionInstance(instance.PlayerStackIM:GetInstance(), playerData, totalCivs);
		end
	end

	local convertedCivsIM:table = instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM];
	if(convertedCivsIM == nil) then
		convertedCivsIM = InstanceManager:new("ConvertedReligionInstance", "CivIconBacking", instance.CivsConvertedStack);
		instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM] = convertedCivsIM;
	end

	convertedCivsIM:ResetInstances();

	for i, convertedCivID in ipairs(teamData.ConvertedCivs) do
		local convertedInstance:table = convertedCivsIM:GetInstance();

		ColorCivIcon(convertedInstance, convertedCivID);

		local civName:string, civIcon:string = GetCivNameAndIcon(convertedCivID, true);
		textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, SIZE_RELIGION_CIV_ICON);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon for converted religion in PopulateReligionInstance: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_RELIGION_CIV_ICON));
		else
			convertedInstance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			SetLeaderTooltip(convertedInstance, convertedCivID);
		end
	end

	instance.CivsConverted:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_CONVERT_SUMMARY", #teamData.ConvertedCivs .. "/" .. totalCivs, "LOC_WORLD_RANKINGS_RELIGION_TEAMS_RELIGIONS"));
end

function PopulateReligionInstance(instance:table, playerData:table, totalCivs:number)

	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	local religionData = GameInfo.Religions[playerData.ReligionType];
	local religionColor:number = UI.GetColorValue(religionData.Color);
	
	instance.ReligionName:SetColor(religionColor);
	instance.ReligionName:SetText(Game.GetReligion():GetName(playerData.ReligionType));
	instance.ReligionBG:SetSizeX(instance.ReligionName:GetSizeX() + PADDING_RELIGION_NAME_BG);
	instance.ReligionBG:SetColor(religionColor);

	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_" .. religionData.ReligionType, SIZE_RELIGION_ICON_SMALL);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateReligionInstance: icon=\"".."ICON_" .. religionData.ReligionType.."\", iconSize="..tostring(SIZE_RELIGION_ICON_SMALL) );
	else
		instance.ReligionIcon:SetColor(religionColor);
		instance.ReligionIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end
	
	local convertedCivsIM:table = instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM];
	if(convertedCivsIM == nil) then
		convertedCivsIM = InstanceManager:new("ConvertedReligionInstance", "CivIconBacking", instance.CivsConvertedStack);
		instance[DATA_FIELD_RELIGION_CONVERTED_CIVS_IM] = convertedCivsIM;
	end

	convertedCivsIM:ResetInstances();

	for i, convertedCivID in ipairs(playerData.ConvertedCivs) do
		local convertedInstance:table = convertedCivsIM:GetInstance();

		ColorCivIcon(convertedInstance, convertedCivID);

		local civName:string, civIcon:string = GetCivNameAndIcon(convertedCivID, true);
		textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, SIZE_RELIGION_CIV_ICON);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find icon for converted religion in PopulateReligionInstance: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_RELIGION_CIV_ICON));
		else
			convertedInstance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
			SetLeaderTooltip(convertedInstance, convertedCivID);
		end
	end

	if #playerData.ConvertedCivs == 0 then
		instance.ButtonBG:SetSizeY(SIZE_RELIGION_BG_HEIGHT + instance.CivsConvertedStack:GetSizeY());
	else
		instance.ButtonBG:SetSizeY(PADDING_RELIGION_BG_HEIGHT + instance.CivsConvertedStack:GetSizeY());
	end

	instance.CivsConverted:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_CONVERT_SUMMARY", #playerData.ConvertedCivs .. "/" .. totalCivs, Game.GetReligion():GetName(playerData.ReligionType)));
end

function RealizeReligionStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT];
		Controls.ReligionViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.ReligionViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.ReligionViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.ReligionViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.ReligionViewStack, Controls.ReligionViewScrollbar, true);
end

-- ===========================================================================
--	Called when Generic (custom victory type) tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewGeneric(victoryType:string)
	ResetState(function() ViewGeneric(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
	PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);

	local genericData:table = GatherGenericData();

	m_GenericIM:ResetInstances();
	m_GenericTeamIM:ResetInstances();

	for i, teamData in ipairs(genericData) do
		if #teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(m_GenericTeamIM:GetInstance(), teamData, victoryType);
		else
			PopulateGenericInstance(m_GenericIM:GetInstance(), teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function GatherGenericData()
	local data:table = {};

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, PlayerData = {} };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID };

					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateGenericTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateGenericInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, false);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then

		local detailsText:string = "";
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, REQUIREMENT_CONTEXT);
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
			else
				local requirementState:string = GameEffects.GetRequirementState(requirementID);
				local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
				if requirementState == "Met" or requirementState == "AlwaysMet" then
					detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
				else
					detailsText = detailsText .. "[ICON_Bolt]";
				end
				detailsText = detailsText .. requirementDetails.ID;
			end
		end
		instance.Details:SetText(detailsText);
	else
		instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonFrame:SetSizeY(itemSize);
end

function PopulateGenericInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	local civName, civIcon:string = GetCivNameAndIcon(playerData.PlayerID, true);

	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(civIcon, SIZE_CIV_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateViewAncientRivalsInstance: icon=\""..civIcon.."\", iconSize="..tostring(SIZE_CIV_ICON));
	else
		instance.CivIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		SetLeaderTooltip(instance, playerData.PlayerID);
	end

	ColorCivIcon(instance, playerData.PlayerID);
	instance.CivName:SetText(civName);
	instance.LocalPlayer:SetHide(playerData.PlayerID ~= m_LocalPlayerID);
	
	if showTeamDetails then
		local requirementSetID:number = Game.GetVictoryRequirements(Players[playerData.PlayerID]:GetTeam(), victoryType);
		if requirementSetID ~= nil and requirementSetID ~= -1 then

			local detailsText:string = "";
			local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
			for _, requirementID in ipairs(innerRequirements) do

				if detailsText ~= "" then
					detailsText = detailsText .. "[NEWLINE]";
				end

				local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, REQUIREMENT_CONTEXT);
				local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

				if requirementText ~= nil then
					detailsText = detailsText .. requirementText;
				else
					local requirementState:string = GameEffects.GetRequirementState(requirementID);
					local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
					if requirementState == "Met" or requirementState == "AlwaysMet" then
						detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
					else
						detailsText = detailsText .. "[ICON_Bolt]";
					end
					detailsText = detailsText .. requirementDetails.ID;
				end
			end
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonBG:SetSizeY(itemSize);
end

function RealizeGenericStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT];
		Controls.GenericViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.GenericViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
	else
		Controls.GenericViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.GenericViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
	end

	RealizeStackAndScrollbar(Controls.GenericViewStack, Controls.GenericViewScrollbar, true);
end

-- ===========================================================================
--	Logic that governs extra tabs
-- ===========================================================================
function ToggleExtraTabs()
	local shouldHide:boolean = not Controls.ExtraTabs:IsHidden();
	Controls.ExtraTabs:SetHide(shouldHide);
	Controls.ExpandExtraTabs:SetSelected(not shouldHide);
end

function CloseExtraTabs()
	Controls.ExtraTabs:SetHide(true);
	Controls.ExpandExtraTabs:SetSelected(false);
	for _,tabInst in pairs(m_ExtraTabs) do
		tabInst.Button:SetSelected(false);
	end
end

-- ===========================================================================
--	Update player data and refresh the display state
-- ===========================================================================
function UpdatePlayerData()
	if (Game.GetLocalPlayer() ~= -1) then
		m_LocalPlayer = Players[Game.GetLocalPlayer()];
		m_LocalPlayerID = m_LocalPlayer:GetID();
	else
		m_LocalPlayer = nil;
		m_LocalPlayerID = -1;
	end
end
function UpdateData()
	UpdatePlayerData();
	if(m_LocalPlayer ~= nil and m_ActiveViewUpdate ~= nil) then
		m_ActiveViewUpdate();
	end
end

-- ===========================================================================
--	SCREEN EVENTS
-- ===========================================================================
function Open()
	-- dont show panel if there is no local player
	local localPlayerID = Game.GetLocalPlayer();
	if (localPlayerID == -1) then
		return
	end

	UpdateData();
	m_AnimSupport.Show();
	UI.PlaySound("CityStates_Panel_Open");
	-- Ensure we're the only partial screen currenly up
	LuaEvents.WorldRankings_CloseCityStates();
end

-- ===========================================================================
function Close()	
	m_AnimSupport.Hide();
    if not ContextPtr:IsHidden() then
        UI.PlaySound("CityStates_Panel_Close");
    end
	LuaEvents.WorldRankings_Close();

	-- Don't reset lens if activating a modal lens. MinimapPanel will handle activating the proper lens.
	if UI.GetInterfaceMode() ~= InterfaceModeTypes.VIEW_MODAL_LENS then
		ResetTourismLens();
	end
end

-- ===========================================================================
function Toggle()	
	if(m_AnimSupport.IsVisible()) then
		Close();
	else
		Open();
	end
end

-- ===========================================================================
--	HOT-RELOADING EVENTS
-- ===========================================================================
function OnInit(isReload:boolean)
	if isReload then
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);
	end
end
function OnShutdown()
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden", ContextPtr:IsHidden());
	if(m_TabSupport ~= nil and m_TabSupport.selectedControl ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "selectedTabText", m_TabSupport.selectedControl:GetTextControl():GetText());
	end
	if(m_ActiveHeader ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "activeHeaderExpanded", m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]);
	end
end
function OnGameDebugReturn(context:string, contextTable:table)
	if context == RELOAD_CACHE_ID and contextTable["isHidden"] ~= nil and not contextTable["isHidden"] then
		Open();
		-- Select previously selected tab
		local selectedTabText:string = contextTable["selectedTabText"];
		for _, tab in pairs(m_TabSupport.tabControls) do
			if tab:GetTextControl():GetText() == selectedTabText then
				m_TabSupport.SelectTab(tab);
			end
		end

		if(m_ActiveHeader ~= nil) then
			m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = contextTable["activeHeaderExpanded"];
			if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
				OnExpandHeader(0, 0, m_ActiveHeader.ExpandHeaderButton);
			else
				OnContractHeader(0, 0, m_ActiveHeader.ContractHeaderButton);
			end
		end
	end
end

-- ===========================================================================
--	Hot-seat functionality
-- ===========================================================================
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
--	Game Events
-- ===========================================================================
function OnCapitalCityChanged()
	if(m_AnimSupport.IsVisible()) then
		m_AnimSupport.Hide();
	end
end

-- ===========================================================================
--	Game Engine Event
-- ===========================================================================
function OnInterfaceModeChanged(eOldMode:number, eNewMode:number)
	if m_AnimSupport.IsVisible() and eNewMode == InterfaceModeTypes.VIEW_MODAL_LENS then
		Close();
	end
end

-- ===========================================================================
--	LUA Event
--	Explicit close (from partial screen hooks), part of closing everything,
-- ===========================================================================
function OnCloseAllExcept( contextToStayOpen:string )
	if contextToStayOpen == ContextPtr:GetID() then return; end
	Close();
end

-- ===========================================================================
--	INIT (Generic)
-- ===========================================================================
function Initialize()

	-- Animation Controller
	m_AnimSupport = CreateScreenAnimation(Controls.SlideAnim, Close);

	-- Hot-Reload Events
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetShutdown(OnShutdown);
	LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);

	-- UI Callbacks
	ContextPtr:SetInputHandler(m_AnimSupport.OnInputHandler, true);

	Controls.CloseButton:SetOffsetY(50);		-- Move close button down to account for TabHeader
	Controls.CloseButton:RegisterCallback(Mouse.eLClick, Close);
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ExpandExtraTabs:RegisterCallback(Mouse.eLClick, ToggleExtraTabs);
	Controls.ScoreDetailsCheck:RegisterCallback(Mouse.eLClick, ToggleScoreDetails);
	Controls.ScoreDetailsButton:RegisterCallback(Mouse.eLClick, ToggleScoreDetails);
	Controls.ScoreDetailsButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.Title:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_TITLE"));
	Controls.TabHeader:ChangeParent(Controls.Background);		-- To make it render beneath the banner image

	-- Game Events
	Events.CapitalCityChanged.Add(OnCapitalCityChanged);
	Events.InterfaceModeChanged.Add( OnInterfaceModeChanged );
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
	Events.SystemUpdateUI.Add(m_AnimSupport.OnUpdateUI);	

	-- Lua Events
	LuaEvents.PartialScreenHooks_ToggleWorldRankings.Add(Toggle);
	LuaEvents.PartialScreenHooks_OpenWorldRankings.Add(Open);
	LuaEvents.PartialScreenHooks_CloseWorldRankings.Add(Close);
	LuaEvents.PartialScreenHooks_CloseAllExcept.Add(OnCloseAllExcept);
	LuaEvents.PartialScreenHooks_ViewScore.Add(ViewScore);
	LuaEvents.PartialScreenHooks_ViewScience.Add(ViewScience);
	LuaEvents.PartialScreenHooks_ViewCulture.Add(ViewCulture);
	LuaEvents.PartialScreenHooks_ViewDomination.Add(ViewDomination);
	LuaEvents.PartialScreenHooks_ViewReligion.Add(ViewReligion);

	UpdatePlayerData();
	PopulateTabs();
end
Initialize();
