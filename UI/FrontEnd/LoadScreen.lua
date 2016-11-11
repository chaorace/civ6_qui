-- ===========================================================================
--
--	Loading screen as player goes from shell to game state.
--
-- ===========================================================================

include( "InputSupport" );
include( "InstanceManager" );
include( "SupportFunctions" );
include( "ToolTipHelper" );
include( "Civ6Common" );


-- ===========================================================================
--	Action Hotkeys
-- ===========================================================================
local m_actionHotkeyStartGame		:number = Input.GetActionId("StartGame");
local m_actionHotkeyStartGameAlt	:number = Input.GetActionId("StartGameAlt");



-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

local DARKEN_AMOUNT			:number = -25;
local MIN_BLACK_Y			:number = 2;	-- Minimum size for black boxes on row bars
local SIZE_BUILDING_ICON	:number = 32;
local SIZE_CIV_LOGO_ICON	:number = 256;	-- Size of the logo in the background
local SIZE_UNIT_ICON		:number = 32;
local TIMEOUT_LOAD			:number = 1000;	-- # of frames before a timeout occurs obtaining player data for load screen


-- ===========================================================================
--	MEMBERS / VARIABLES
-- ===========================================================================
local m_isLoadComplete				:boolean = false;
local m_isResyncLoad				:boolean = false;
local m_isTraitsFullDescriptions	:boolean = false;



-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

-- ===========================================================================
function OnActivateButtonClicked()
	Controls.BackgroundImage:UnloadTexture();
	Controls.Portrait:UnloadTexture();
	Events.LoadScreenClose();
	UI.PlaySound("STOP_SPEECH_DAWNOFMAN");
	UI.PlaySound("Stop_Main_Menu_Music");
	UI.PlaySound("Game_Begin_Button_Click");
	UI.PlaySound("Set_View_3D");
	UIManager:DequeuePopup( ContextPtr );

	Input.SetActiveContext( InputContext.World );

	if(UILens.IsPlayerLensSetToActive()) then
		UILens.SetActive("Default");
	end

    UI.SetExitOnClose(false);
end

-- ===========================================================================
--	Input Processing
-- ===========================================================================
function OnInput( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyUp then
        if wParam == Keys.VK_ESCAPE then
			if m_isLoadComplete then
				OnActivateButtonClicked();
				return true;
			end
        end
    end
    return false;	-- Don't consume all; let hotkey action system get a crack
end

-- ===========================================================================
--	Hotkey
-- ===========================================================================
function OnInputActionTriggered( actionId:number )
	if	actionId == m_actionHotkeyStartGame		or
		actionId == m_actionHotkeyStartGameAlt	then
		if m_isLoadComplete then
			OnActivateButtonClicked();
		end
	end		

end

-- ===========================================================================
function RegisterButtonCallbacks()
	Controls.ActivateButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end );
	Controls.ActivateButton:RegisterCallback( Mouse.eLClick, OnActivateButtonClicked );
	Controls.StartLabelButton:RegisterCallback( Mouse.eLClick, OnActivateButtonClicked );
	Controls.FallbackMessage:RegisterCallback( Mouse.eLClick, OnActivateButtonClicked );
end

-- ===========================================================================
function ClearButtonCallbacks()
	Controls.ActivateButton:ClearCallback( Mouse.eLClick );
	Controls.ActivateButton:ClearCallback( Mouse.eMouseEnter );
	Controls.FallbackMessage:ClearCallback( Mouse.eLClick );
	Controls.StartLabelButton:ClearCallback( Mouse.eLClick );
end

-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnShow()
	
	m_isLoadComplete	= false;
	m_isResyncLoad		= UI.IsResyncLoadInProgress(); -- Remember if this is a resync load for later.
	
	-- Adjust black bars	[
	local screenSizeX, screenSizeY	= UIManager:GetScreenSizeVal();	
	local backgroundSizeY	:number	= Controls.BackgroundImage:GetSizeY();	
	local blackY			:number = math.max( MIN_BLACK_Y, (screenSizeY - backgroundSizeY) * 0.5 );
	Controls.BarTop:SetSizeY( blackY );
	Controls.BarBottom:SetSizeY( blackY );

	UIManager:SetUICursor( 1 );
	Controls.FadeAnim:SetToBeginning();	
	Controls.ActivateButton:SetHide(true);	
	Controls.LoadingContainer:SetHide(false);

	-- Wait until game configuration data is ready before showing anything.
	Controls.BackgroundImage:SetHide(true);
	Controls.Banner:SetHide(true);
	Controls.Portrait:SetHide(true);
	
	-- Clear button callbacks until loading is complete.
	ClearButtonCallbacks();
end

-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnHide()
	UIManager:SetUICursor( 0 );
end

-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then		
		OnShow();
		OnLoadScreenContentReady();
		OnLoadGameViewStateDone();
	end
end

-- ===========================================================================
--	All game data exists for the player in order to fill out the screen.
--	Do it...
-- ===========================================================================
function OnLoadScreenContentReady()

	if (GameConfiguration:IsWorldBuilder()) then
		-- This needs to show some kind of World Builder splash screen.
		-- It can't show leaders, etc., they may not be initialized.
		return;
	end

	-- Because Game.GetLocalPlayer() not servicing yet use the network flavor;
	-- if in a hotseat mode the first slot may not be set to the human.
	local localPlayer	:number = Network.GetLocalPlayerID();
	if GameConfiguration.IsHotseat() then

		local maxPlayers :number = MapConfiguration.GetMaxMajorPlayers();
		for playerID = 0, maxPlayers-1,1 do
			local pPlayerConfig :table	= PlayerConfigurations[playerID];
			local slotStatus	:number = pPlayerConfig:GetSlotStatus();
			
			-- Potentially change the localPlayer number to the first human
			-- player in a slot.
			if slotStatus == SlotStatus.SS_TAKEN then
				localPlayer = playerID;	
				break;
			end
		end	
	end	

	local primaryColor, secondaryColor  = UI.GetPlayerColors( localPlayer );

	if primaryColor == nil then
		primaryColor = 0xff99aaaa;
		UI.DataError("NIL primary color; likely player object not ready... using default color.");
	end
	if secondaryColor == nil then
		secondaryColor = 0xffaa9999;
		UI.DataError("NIL secondary color; likely player object not ready... using default color.");
	end

	local backColor						= DarkenLightenColor(primaryColor, DARKEN_AMOUNT, 255);
	Controls.Banner:SetColor(backColor);
	
	local playerConfig		:table = PlayerConfigurations[localPlayer];
	if playerConfig == nil then
		UI.DataError("Received NIL playerConfig for player #"..tostring(localPlayer));
	end

	local leaderType	:string = playerConfig:GetLeaderTypeName();
	local backgroundName:string = leaderType .. "_BACKGROUND";
	local portraitName	:string = leaderType .. "_NEUTRAL";
	local leaderDetails :string = Locale.Lookup("LOC_LOADING_INFO_" .. leaderType);

	Controls.BackgroundImage:SetTexture( backgroundName );

	local LEADER_CONTAINER_X = 512;
	--local offsetX = 300 + math.floor((Controls.Portrait:GetSizeX() - LEADER_CONTAINER_X)/2);
	local offsetX = math.floor((Controls.Portrait:GetSizeX() - LEADER_CONTAINER_X)/2);
	if (offsetX > 0) then
		Controls.Portrait:SetOffsetX(offsetX);
	else
		Controls.Portrait:SetOffsetX(0);
	end
	--Controls.Portrait:ReprocessAnchoring();
	Controls.Portrait:SetTexture( portraitName );
	if (not Controls.Portrait:HasTexture()) then
		UI.DataError("We are lacking a texture for "..portraitName);
	end
	Controls.CivName:SetText( Locale.ToUpper( Locale.Lookup(playerConfig:GetCivilizationDescription())) );

	Controls.CivName:SetText( Locale.ToUpper( Locale.Lookup(playerConfig:GetCivilizationDescription())) );
	local debug = GameConfiguration.GetStartEra();
	local startEra = GameInfo.Eras[ GameConfiguration.GetStartEra() ];
	if startEra ~= nil then
		Controls.EraInfo:SetText( Locale.Lookup(startEra.Description) );
	end
	local kLeader	:table = GameInfo.Leaders[leaderType];
	if kLeader ~= nil then
		local leaderName:string = Locale.ToUpper(Locale.Lookup( kLeader.Name ));
		Controls.LeaderName:SetText( leaderName );
		Controls.LeaderInfo:SetText( leaderDetails );
	else
		UI.DataError("No leader in DB by leaderType '"..leaderType.."'");
	end

	local civType	:string = playerConfig:GetCivilizationTypeName();
	local iconName	:string = "ICON_"..civType;
	Controls.LogoContainer:SetColor(primaryColor);
	Controls.Logo:SetColor(secondaryColor);
	Controls.Logo:SetIcon(iconName);

	Controls.Logo:SetHide(false);
	Controls.BackgroundImage:SetHide(false);
	Controls.Banner:SetHide(false);
	Controls.Portrait:SetHide(false);

    -- start the voiceover
    local leaderID = playerConfig:GetLeaderTypeID();
    if not m_isResyncLoad then
        UI.SetSoundSwitchValue("Leader_Screen_Civilization", UI.GetCivilizationSoundSwitchValueByLeader(leaderID));
        UI.SetSoundSwitchValue("Civilization", UI.GetCivilizationSoundSwitchValueByLeader(leaderID));
        UI.SetSoundSwitchValue("Era_DawnOfMan", UI.GetEraSoundSwitchValue(GameConfiguration.GetStartEra()));
        UI.PlaySound("Play_DawnOfMan_Speech");
    end

	-- Obtain "uniques" from Civilization and for the chosen leader
	local uniqueAbilities;
	local uniqueUnits;
	local uniqueBuildings;
	uniqueAbilities, uniqueUnits, uniqueBuildings = GetLeaderUniqueTraits( leaderType );
	local CivUniqueAbilities, CivUniqueUnits, CivUniqueBuildings = GetCivilizationUniqueTraits( civType );
	
	-- Merge tables
	for i,v in ipairs(CivUniqueAbilities)	do table.insert(uniqueAbilities, v) end
	for i,v in ipairs(CivUniqueUnits)		do table.insert(uniqueUnits, v)		end
	for i,v in ipairs(CivUniqueBuildings)	do table.insert(uniqueBuildings, v) end

	-- Generate content
	for _, item in ipairs(uniqueAbilities) do
		--print( "ua:", item.TraitType, item.Name, item.Description, Locale.Lookup(item.Description));	--debug
		local instance:table = {};
		ContextPtr:BuildInstanceForControl("TextInfoInstance", instance, Controls.FeaturesStack );
		local headerText:string = Locale.ToUpper(Locale.Lookup( item.Name )); 
		instance.Header:SetText( headerText );
		instance.Description:SetText( Locale.Lookup( item.Description ) );
	end

	local size:number = SIZE_BUILDING_ICON;

    local instance:table = {};
	ContextPtr:BuildInstanceForControl("TextInfoInstance", instance, Controls.FeaturesStack );
	local headerText:string = "UNIQUE UNITS & BUILDINGS:"; 
	instance.Header:SetText( headerText );
	instance.Description:SetText( "" );

	for _, item in ipairs(uniqueUnits) do
		--print( "uu:", item.TraitType, item.Name, item.Description, Locale.Lookup(item.Description));	--debug
		local instance:table = {};
		ContextPtr:BuildInstanceForControl("IconInfoInstance", instance, Controls.FeaturesStack );
		iconAtlas = "ICON_"..item.Type;
		instance.Icon:SetIcon(iconAtlas);
        -- CQUI Change Unique Unit information into a Tooltip
		--instance.TextStack:SetOffsetX( size + 4 );
		--local headerText:string = Locale.ToUpper(Locale.Lookup( item.Name ));
		--instance.Header:SetText( headerText );
		instance.Icon:SetToolTipString( ToolTipHelper.GetToolTip(item.Type, localPlayer ) );
	end


	for _, item in ipairs(uniqueBuildings) do
		--print( "ub:", item.TraitType, item.Name, item.Description, Locale.Lookup(item.Description));	--debug
		local instance:table = {};
		ContextPtr:BuildInstanceForControl("IconInfoInstance", instance, Controls.FeaturesStack );
		instance.Icon:SetSizeVal(38,38);
		iconAtlas = "ICON_"..item.Type;
		instance.Icon:SetIcon(iconAtlas);
        -- CQUI Change Unique Unit information into a Tooltip
		--instance.TextStack:SetOffsetX( size + 4 );
		--local headerText:string = Locale.ToUpper(Locale.Lookup( item.Name ));
		--instance.Header:SetText( headerText );
		instance.Icon:SetToolTipString( ToolTipHelper.GetToolTip(item.Type, localPlayer ) );
	end

end

-- ===========================================================================
-- ENGINE Event
-- ===========================================================================
function OnBeforeMultiplayerInviteProcessing()
	-- We're about to process a game invite.  Get off the popup stack before we accidently break the invite!
	UIManager:DequeuePopup( ContextPtr );
end

-- ===========================================================================
--	ENGINE Event
-- ===========================================================================
function OnLoadGameViewStateDone()
	
	m_isLoadComplete = true;	
	print("OnLoadGameViewStateDone");
	
	UIManager:SetUICursor( 0 );	
	
	if m_isResyncLoad or GameConfiguration.IsAnyMultiplayer() then
		-- If this is a resync load, skip the Begin Game button.
		OnActivateButtonClicked();
	else
		-- Activate the Begin Game button.
		local strGameButtonName;


		if (GameConfiguration.IsSavedGame()) then
			strGameButtonName = Locale.Lookup("LOC_CONTINUE_GAME");		
		else
			strGameButtonName = Locale.Lookup("LOC_BEGIN_GAME");
		end

		Controls.StartLabelButton:SetText(strGameButtonName);
		Controls.ActivateButton:SetHide(false);
		Controls.LoadingContainer:SetHide(true);
		Controls.FadeAnim:SetToBeginning();
		Controls.FadeAnim:Play();
		UI.PlaySound("Game_Begin_Button_Appear");
        		
		Input.SetActiveContext( InputContext.Ready );

		-- If automation is running, continue on.
		if (Automation.IsActive()) then
			OnActivateButtonClicked();
		end
	end    
	
	Controls.FallbackMessage:SetText("Start Game");

	RegisterButtonCallbacks();

	-- Engine loading should be done at this point; enable input handling.	
	ContextPtr:SetInputHandler( OnInput );
	Events.InputActionTriggered.Add( OnInputActionTriggered );
end

-- ===========================================================================
function Initialize()

	Input.SetActiveContext( InputContext.Loading );

	-- EVENTS:
	ContextPtr:SetInitHandler( OnInit );
	-- Do not set input handler until content loading is done; otherwise engine will make LUA calls to engine during load (not recommended).
	ContextPtr:SetShowHandler( OnShow );
	ContextPtr:SetHideHandler( OnHide );	

	Events.LoadScreenContentReady.Add( OnLoadScreenContentReady );		-- Ready to show player info
	Events.LoadGameViewStateDone.Add( OnLoadGameViewStateDone );		-- Ready to start game
	Events.BeforeMultiplayerInviteProcessing.Add( OnBeforeMultiplayerInviteProcessing );

    UI.SetExitOnClose(true);

	Controls.Portrait:ReprocessAnchoring();
end
Initialize();