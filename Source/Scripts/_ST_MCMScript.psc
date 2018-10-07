scriptname _ST_MCMScript extends SKI_ConfigBase

; Properties
Quest property STQuest auto
FormList Property LocationFormList auto
Formlist property lightList auto
Formlist property cellLightFormlist auto
Formlist property actorsWithShadowLights auto
bool property Install = false auto
bool property Uninstall = false auto

bool isQuestRunning
bool isThinking = false
bool DisableAll = false

; Options
int ID_BlacklistAdd
int ID_EnableMod
int ID_CandlelightShadows
int ID_Ext_Shadows
int ID_WearableLanterns
int ID_TorchShadows
int ID_MagelightShadows
int ID_CandlelightToggle
int ID_UninstallMod
int ID_InstallMod
int ID_NPC_EnableCandlelight ; NPC candlelight
int ID_Player_EnableCandlelight ; NPC candlelight
int ID_NPC_ToggleShadowsTorch ; NPC torch
int ID_Player_ToggleShadowsTorch
int ID_Int_Shadows
int ID_Slider_TorchBrightness
int ID_Slider_CandlelightBrightness
int ID_Slider_TorchLightRange
int ID_Slider_CandlelightRange
int ID_Slider_MaxLightSources
int ID_Slider_ActorUpdateFreq
int ID_ForceRefresh
int ID_Slider_npcLimitInterior
int ID_Slider_npcLimitExterior
int ID_Slider_npcApplyFrequency
int ID_Slider_lightDistanceLimit
int ID_Slider_reApplyFrequency
int ID_TogglePlayerUpdate
int ID_MagelightModuleOn
int ID_TorchModuleOn
int ID_CandlelightModuleOn

; Flags
int flags
int flagLantern
int flagUninstall
int flagDone
int flagEnable
int flagTorchEnable
int flagCandlelightEnable
int flagMagelightEnable

_ST_Handler property Handler auto


event OnPageReset(string a_page)

	SetFlags()

	SetCursorFillMode(TOP_TO_BOTTOM)

	; Show General page
	if (a_page == "General Settings" || a_page == "")

		if (!isQuestRunning)
			ID_InstallMod = AddToggleOption("Install Mod", isQuestRunning, flagDone)

		else

			AddHeaderOption("Mod Options")
			ID_EnableMod = AddToggleOption("Enable Mod", Handler.ToggleModEnable, flagEnable)
			ID_UninstallMod = AddToggleOption("Uninstall Mod", !isQuestRunning, flagUninstall)
			
			AddEmptyOption()

			AddHeaderOption("Compatibility")

			ID_WearableLanterns = AddToggleOption("Wearable Lanterns Shadows", Handler.ToggleWLLantern, flagLantern)
			AddToggleOption("Enhanced Lights and FX", Handler.isModLoaded("EnhancedLightsandFX.esp"), OPTION_FLAG_DISABLED)
			AddToggleOption("ELFX - Exteriors", Handler.isModLoaded("ELFX - Exteriors.esp"), OPTION_FLAG_DISABLED)
			
			Handler.addModdedLights()

		EndIf

	; Show Module Page
	elseif (a_page == "Module Settings")

		if (pageCheck())
			Return
		EndIf

		AddHeaderOption("Torch Options")
		ID_TorchModuleOn = AddToggleOption("Torch Module", Handler.TorchModuleOn, flagEnable)
		ID_Slider_TorchLightRange = AddSliderOption("Torch Light Range", Handler.TorchRange, "Level {0}", flagTorchEnable)
		ID_Slider_TorchBrightness = AddSliderOption("Torch Brightness", Handler.TorchBrightness, "Level {0}", flagTorchEnable)
		ID_TorchShadows = AddToggleOption("Torch Shadows", Handler.ToggleShadowsTorch, flagTorchEnable)
		ID_NPC_ToggleShadowsTorch = AddToggleOption("NPC Enable", Handler.npcEnableTorch, flagTorchEnable)
		ID_Player_ToggleShadowsTorch = AddToggleOption("Player Enable", Handler.playerEnableTorch, flagTorchEnable)

		SetCursorPosition(1)

		AddHeaderOption("Candlelight Settings")
		ID_CandlelightModuleOn = AddToggleOption("Candlelight Module", Handler.CandlelightModuleOn, flagEnable)
		ID_Slider_CandlelightRange = AddSliderOption("Candlelight Light Range", Handler.CandlelightRange, "Level {0}", flagCandlelightEnable)
		ID_Slider_CandlelightBrightness = AddSliderOption("Candlelight Brightness", Handler.CandlelightBrightness, "Level {0}", flagCandlelightEnable)
		ID_CandlelightToggle = AddToggleOption("Candlelight Toggle", Handler.ToggleCandlelightToggle, flagCandlelightEnable)
		ID_CandlelightShadows = AddToggleOption("Candlelight Shadows", Handler.ToggleShadowsCandlelight, flagCandlelightEnable)
		ID_NPC_EnableCandlelight = AddToggleOption("NPC Enable", Handler.npcEnableCandlelight, flagCandlelightEnable)
		ID_Player_EnableCandlelight = AddToggleOption("Player Enable", Handler.playerEnableCandlelight, flagCandlelightEnable)

		AddEmptyOption()

		AddHeaderOption("Magelight Settings")
		ID_MagelightModuleOn = AddToggleOption("Magelight Module", Handler.MagelightModuleOn, flagEnable)
		ID_MagelightShadows = AddToggleOption("Magelight Shadows", Handler.ToggleShadowsMagelight, flagMagelightEnable)

	; Show Location Page
	elseif (a_page == "Location Settings")

		if (pageCheck())
			Return
		EndIf

		AddHeaderOption("Performance Options")
		ID_Slider_MaxLightSources = AddSliderOption("Dynamic Light Limit", Handler.maxLightSources, "{0}", flagEnable)
		ID_Slider_npcLimitInterior = AddSliderOption("NPC Interior Limit", Handler.npcLimitInterior, "{0}", flagEnable)
		ID_Slider_npcLimitExterior = AddSliderOption("NPC Exterior limit", Handler.npcLimitExterior, "{0}", flagEnable)
		ID_Slider_ActorUpdateFreq = AddSliderOption("Actor Check Frequency", Handler.ActorUpdateInterval, "{0} seconds", flagEnable)
		ID_Slider_npcApplyFrequency = AddSliderOption("NPC Cloak Apply Frequency", Handler.npcApplyFrequency, "{0} seconds", flagEnable)
		ID_Slider_reApplyFrequency = AddSliderOption("Actor Effect Reapply Frequency", Handler.updateReApply, "{0} seconds", flagEnable)

		ID_Slider_lightDistanceLimit = AddSliderOption("Light Distance Limit", Handler.distance, "{0} units", flagEnable)
		ID_TogglePlayerUpdate = AddToggleOption("Player OnUpdate", Handler.TogglePlayerUpdate, flagEnable)

		SetCursorPosition(1)

		AddHeaderOption("Location Options")
		ID_Ext_Shadows = AddToggleOption("Exterior Shadows", Handler.ToggleShadowsExteriors, flagEnable)
		ID_Int_Shadows = AddToggleOption("Interior Shadows", Handler.ToggleShadowsInteriors, flagEnable)
		AddEmptyOption()

		AddHeaderOption("Blacklist")
		ID_BlacklistAdd = AddToggleOption("Add current location to blacklist", LocationFormList.HasForm(Game.GetPlayer().GetCurrentLocation()), flags)

		int index = LocationFormList.GetSize()

		while (index)
			index -= 1
			AddTextOption(LocationFormList.GetAt(index).GetName(), "Added", OPTION_FLAG_DISABLED)
		endWhile

	; Show Debug Page
	elseif (a_page == "Debug Information")

		if (pageCheck())
			Return
		EndIf

		int index = 0
		String cellName
		int size = Handler.cellLightSize

		if (Game.GetPlayer().IsInInterior())
			cellName = Handler.oldCell.GetName()
		else
			cellName = "Skyrim"
			size = 0
		endIf

		AddHeaderOption(cellName + " (" + size + " found)")
		ID_ForceRefresh = AddToggleOption("Force Refresh Now", false, flagEnable)

		if (Handler.lightNativeArray[0] == NONE || !Handler.Player.IsInInterior())
			AddTextOption("No dynamic lights found!", "", OPTION_FLAG_DISABLED)
		else

			index = 0

			while (Handler.lightNativeArray[index] != NONE)
				
				ObjectReference thisRef = Handler.lightNativeArray[index]
				String status = ""
				; Get to hex FormID string
				String HexForm = Handler.BinToHex(Handler.DecToBin(thisRef.GetFormID()))
				int bDistance = Game.GetPlayer().GetDistance(thisRef) as int

				if (bDistance <= Handler.distance)
					status = "Too close - "
				EndIf

				AddTextOption(HexForm, status + bDistance, OPTION_FLAG_DISABLED)
				index += 1
			endWhile
		EndIf

		SetCursorPosition(1)

		AddHeaderOption("Actors With Dynamic Lights")
		index = actorsWithShadowLights.GetSize()

		if (index == 0)
			AddTextOption("No actors!", "", OPTION_FLAG_DISABLED)
		else
			while (index)
				index -= 1
				ObjectReference thatActor = actorsWithShadowLights.GetAt(index) as ObjectReference
				String name = thatActor.GetBaseObject().GetName()

				int bDistance = Game.GetPlayer().GetDistance(thatActor) as int

				AddTextOption(name, bDistance, OPTION_FLAG_DISABLED)
			EndWhile
		endIf

		AddEmptyOption()

		AddHeaderOption("Mod Status")

		index = lightList.GetSize()
		AddTextOption("Total Lights Registered:", index, OPTION_FLAG_DISABLED)

		int stat = Handler.runCheck(Game.GetPlayer())

		if (stat == 1)
			AddTextOption("Shadows:", "Allowed", OPTION_FLAG_DISABLED)
		ElseIf (stat == 2)
			AddTextOption("Shadows:", "Busy...", OPTION_FLAG_DISABLED)
		Else
			AddTextOption("Shadows:", "Not allowed", OPTION_FLAG_DISABLED)
		EndIf

		if (Handler.checkLimit(Handler.getNpcLimit(), Handler.maxLightSources, Game.GetPlayer()))
			AddTextOption("Light limit:", "Reached", OPTION_FLAG_DISABLED)
		else
			AddTextOption("Light limit:", "Not reached", OPTION_FLAG_DISABLED)
		EndIf

		if (Handler.npcEnableTorch || Handler.npcEnableCandlelight)
			AddTextOption("Scripts running on NPCs:", "Yes", OPTION_FLAG_DISABLED)
		else
			AddTextOption("Scripts running on NPCs:", "No", OPTION_FLAG_DISABLED)
		EndIf

		if (Game.GetPlayer().HasSpell(Handler.MonitorAbility))
			AddTextOption("Script running on player:", "Yes", OPTION_FLAG_DISABLED)
		Else
			AddTextOption("Script running on player:", "No", OPTION_FLAG_DISABLED)
		endIf

		if (isThinking)
			ShowMessage("List updated! Thank you for your patience.", false, "Great!")
			isThinking = false
		EndIf
			
			
	endIf

endEvent


bool Function pageCheck()

	if (!isQuestRunning)
		AddTextOption("Mod not installed", "", OPTION_FLAG_DISABLED)

		return true
	EndIf

	return false

endFunction


event OnOptionHighlight(int a_option)

	if (a_option == ID_BlacklistAdd)
		SetInfoText("Disable shadows at your current interior location.")
	elseif (a_option == ID_CandlelightShadows)
		SetInfoText("Enable dynamic shadows cast from the Candlelight spell.")
	elseif (a_option == ID_Ext_Shadows)
		SetInfoText("Enable dynamic shadows cast from this mod in exterior locations.")
	elseIf (a_option == ID_Int_Shadows)
		SetInfoText("Enable dynamic shadows cast from this mod in interior locations.")
	elseif (a_option == ID_WearableLanterns)
		SetInfoText("Enable dynamic shadows cast by lanterns from the mod 'Wearable Lanterns' by Chesko.")
	elseif (a_option == ID_TorchShadows)
		SetInfoText("Enable dynamic shadows cast by torches.")
	elseif (a_option == ID_MagelightShadows)
		SetInfoText("Enable dynamic shadows cast by Magelight spell (during flight only).")
	elseif (a_option == ID_CandlelightToggle)
		SetInfoText("Cast Candlelight twice to remove the effect.")
	elseIf (a_option == ID_Slider_ActorUpdateFreq)
		SetInfoText("How often to check how many actors are using dynamic shadows.")
	elseIf (a_option == ID_Slider_MaxLightSources)
		SetInfoText("How many dynamic lights that can be a scene at once. This means that (Cell Lights)+(NPCs)+(PC) can't be above this limit.")
	elseIf (a_option == ID_Slider_npcLimitInterior)
		SetInfoText("Limit the amount of NPC's who can cast dynamic shadows in interior locations. WARNING: 1 is recommended to avoid crashes.")
	elseIf (a_option == ID_Slider_npcLimitExterior)
		SetInfoText("Limit the amount of NPC's who can cast dynamic shadows outside. NOTICE: Up to 3 is recommended. Funny stuff happens at 4, such as flickering lights.")
	elseIf (a_option == ID_Slider_npcApplyFrequency)
		SetInfoText("How often the cloak effect i applied to NPCs.")
	elseIf (a_option == ID_Slider_lightDistanceLimit)
		SetInfoText("Set distance between player and placed dynamic lights before this mod should disable its shadowy features. NOTICE: Minimum recommended amount is 4096 distance units. Set higher if you are speedrunning through dungeons.")
	ElseIf (a_option == ID_Slider_reApplyFrequency)
		SetInfoText("How often we should try to re-apply the effect on actors (including the player).")
	ElseIf (a_option == ID_TogglePlayerUpdate)
		SetInfoText("If the OnUpdate script should run on the player. Shadows will be reapplied/removed automtically.")
	ElseIf (a_option == ID_NPC_ToggleShadowsTorch || a_option == ID_NPC_EnableCandlelight)
		SetInfoText("Applies shadows and other settings to NPC's as well.\nWARNING: The engine doesn't like NPC's wearing dynamic shadows in interiors. If you get CTD's, go to 'Location Settings -> NPC Interior Limit' and change it to 0.")
	endif

endEvent


event OnOptionSelect(int a_option)

	if (a_option == ID_BlacklistAdd)
		if (LocationFormList.HasForm(Game.GetPlayer().GetCurrentLocation()))
			LocationFormList.RemoveAddedForm(Game.GetPlayer().GetCurrentLocation())
		else
			LocationFormList.AddForm(Game.GetPlayer().GetCurrentLocation())
		endif

	elseif (a_option == ID_EnableMod)
		Handler.ToggleModEnable = !Handler.ToggleModEnable

	elseIf (a_option == ID_CandlelightShadows)
		Handler.ToggleShadowsCandlelight = !Handler.ToggleShadowsCandlelight

	elseIf (a_option == ID_Ext_Shadows)
		Handler.ToggleShadowsExteriors = !Handler.ToggleShadowsExteriors

	elseIf (a_option == ID_WearableLanterns)
		Handler.ToggleWLLantern = !Handler.ToggleWLLantern
		Handler.AddTorchesToCheskosFormlist()

	elseIf (a_option == ID_TorchShadows)
		Handler.ToggleShadowsTorch = !Handler.ToggleShadowsTorch

	elseIf (a_option == ID_MagelightShadows)
		Handler.ToggleShadowsMagelight = !Handler.ToggleShadowsMagelight

	elseIf (a_option == ID_CandlelightToggle)
		Handler.ToggleCandlelightToggle = !Handler.ToggleCandlelightToggle

	elseIf (a_option == ID_UninstallMod)
		DisableAll = true
		Uninstall = true
		RegisterForSingleUpdate(0.1)
		ShowMessage("Please exit the pause menu and wait for the mod to uninstall.", false)

	elseIf (a_option == ID_InstallMod)
		DisableAll = true
		Install = true
		RegisterForSingleUpdate(0.1)
		ShowMessage("Please exit the pause menu and wait for the mod to install.", false)

	elseIf (a_option == ID_NPC_EnableCandlelight)
		Handler.npcEnableCandlelight = !Handler.npcEnableCandlelight

	elseIf (a_option == ID_NPC_ToggleShadowsTorch)
		Handler.npcEnableTorch = !Handler.npcEnableTorch

	elseIf (a_option == ID_Player_ToggleShadowsTorch)
		Handler.playerEnableTorch = !Handler.playerEnableTorch

	elseIf (a_option == ID_Player_EnableCandlelight)
		Handler.playerEnableCandlelight = !Handler.playerEnableCandlelight

	elseIf (a_option == ID_ForceRefresh)
		ShowMessage("Please wait up to 10 seconds after closing this dialogue. A popup will appear.", false, "Sure...")
		isThinking = true
		Handler.updateCellLightsFormList()

	elseIf (a_option == ID_Int_Shadows)
		Handler.ToggleShadowsInteriors = !Handler.ToggleShadowsInteriors

	ElseIf (a_option == ID_TogglePlayerUpdate)
		Handler.TogglePlayerUpdate = !Handler.TogglePlayerUpdate

	ElseIf (a_option == ID_TorchModuleOn)
		Handler.TorchModuleOn = !Handler.TorchModuleOn

	ElseIf (a_option == ID_CandlelightModuleOn)
		Handler.CandlelightModuleOn = !Handler.CandlelightModuleOn

	ElseIf (a_option == ID_MagelightModuleOn)
		Handler.MagelightModuleOn = !Handler.MagelightModuleOn

		if (!Handler.MagelightModuleOn && Game.GetPlayer().HasSpell(Handler.MagelightSpellDummy))
			Game.GetPlayer().RemoveSpell(Handler.MagelightSpellDummy)
			Game.GetPlayer().AddSpell(Handler.MagelightSpell)
		EndIf
	EndIf

	self.ForcePageReset()

endEvent


event OnOptionSliderOpen(int option)

	if (option == ID_Slider_TorchBrightness)	; Torch brightness
		SetSliderDialogStartValue(Handler.TorchBrightness)
		SetSliderDialogDefaultValue(0) 
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_CandlelightBrightness)	; Candlelight brightness
		SetSliderDialogStartValue(Handler.CandlelightBrightness)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_TorchLightRange)	; Torch range
		SetSliderDialogStartValue(Handler.TorchRange)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 2)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_CandlelightRange)	; Candlelight range
		SetSliderDialogStartValue(Handler.CandlelightRange)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 2)
		SetSliderDialogInterval(1)  

	elseIf (option == ID_Slider_MaxLightSources)
		SetSliderDialogStartValue(Handler.maxLightSources)
		SetSliderDialogDefaultValue(4)
		SetSliderDialogRange(1, 4)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_ActorUpdateFreq)
		SetSliderDialogStartValue(Handler.ActorUpdateInterval)
		SetSliderDialogDefaultValue(8)
		SetSliderDialogRange(2, 60)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_npcLimitInterior)
		SetSliderDialogStartValue(Handler.npcLimitInterior)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 4)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_npcLimitExterior)
		SetSliderDialogStartValue(Handler.npcLimitExterior)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 4)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_npcApplyFrequency)
		SetSliderDialogStartValue(Handler.npcApplyFrequency)
		SetSliderDialogDefaultValue(6)
		SetSliderDialogRange(1, 60)
		SetSliderDialogInterval(1)

	elseIf (option == ID_Slider_lightDistanceLimit)
		SetSliderDialogStartValue(Handler.distance)
		SetSliderDialogDefaultValue(4096)
		SetSliderDialogRange(3000, 8192)
		SetSliderDialogInterval(1)

	ElseIf (option == ID_Slider_reApplyFrequency)
		SetSliderDialogStartValue(Handler.updateReApply)
		SetSliderDialogDefaultValue(30)
		SetSliderDialogRange(4, 360)
		SetSliderDialogInterval(1)
		

	endIf

endEvent


event OnOptionSliderAccept(int option, float value)

	Actor Player = Game.GetPlayer()

	if (option == ID_Slider_TorchBrightness)
		Handler.TorchBrightness = value as int
		SetSliderOptionValue(option, value, "Level {0}")
		Handler.DispelCandlelight(Player, false)

		Handler.RemoveAllTorchesFrom(Player)
		Handler.SetSpells()

	elseIf (option == ID_Slider_CandlelightBrightness)
		Handler.CandlelightBrightness = value as int
		SetSliderOptionValue(option, value, "Level {0}")
		Handler.DispelCandlelight(Player, false)
		Handler.RemoveAllTorchesFrom(Player)
		Handler.SetSpells()

	elseIf (option == ID_Slider_TorchLightRange)
		Handler.TorchRange = value as int
		SetSliderOptionValue(option, value, "Level {0}")
		Handler.DispelCandlelight(Player, false)
		Handler.RemoveAllTorchesFrom(Player)
		Handler.SetSpells()

	elseIf (option == ID_Slider_CandlelightRange)
		Handler.CandlelightRange = value as int
		SetSliderOptionValue(option, value, "Level {0}")
		Handler.DispelCandlelight(Player, false)
		Handler.RemoveAllTorchesFrom(Player)
		Handler.SetSpells()

	elseIf (option == ID_Slider_MaxLightSources)
		Handler.maxLightSources = value as int
		SetSliderOptionValue(option, value, "{0}")

	elseIf (option == ID_Slider_ActorUpdateFreq)
		Handler.ActorUpdateInterval = value as int
		SetSliderOptionValue(option, value, "{0} seconds")

	elseIf (option == ID_Slider_npcApplyFrequency)
		Handler.npcApplyFrequency = value
		SetSliderOptionValue(option, value, "{0} seconds")

	ElseIf (option == ID_Slider_reApplyFrequency)

		Handler.updateReApply = value
		SetSliderOptionValue(option, value, "{0} seconds")	

	elseIf (option == ID_Slider_npcLimitExterior)
		Handler.npcLimitExterior = value as int
		SetSliderOptionValue(option, value, "{0}")

	elseIf (option == ID_Slider_npcLimitInterior)
		Handler.npcLimitInterior = value as int
		SetSliderOptionValue(option, value, "{0}")

	elseIf (option == ID_Slider_lightDistanceLimit)
		Handler.distance = value as Int
		SetSliderOptionValue(option, value, "{0} units")	

	endif

endEvent

Function SetFlags()

	bool WearableLanternsLoaded = Handler.isModLoaded("Chesko_WearableLantern.esp")
	bool WLPatchLoaded = Handler.isModLoaded("TorchesCastShadows_WLPatch.esp")

	isQuestRunning = STQuest.IsRunning()

	if (disableAll)
		flagTorchEnable = OPTION_FLAG_DISABLED
		flagCandlelightEnable = OPTION_FLAG_DISABLED
		flagMagelightEnable = OPTION_FLAG_DISABLED
		flags = OPTION_FLAG_DISABLED
		flagUninstall = OPTION_FLAG_DISABLED
		flagLantern = OPTION_FLAG_DISABLED
		flagDone = OPTION_FLAG_DISABLED
		flagEnable = OPTION_FLAG_DISABLED

		return
	endIf

	if (Handler.TorchModuleOn && isQuestRunning)
		flagTorchEnable = OPTION_FLAG_NONE
	else
		flagTorchEnable = OPTION_FLAG_DISABLED
	endIf

	if (Handler.CandlelightModuleOn && isQuestRunning)
		flagCandlelightEnable = OPTION_FLAG_NONE
	else
		flagCandlelightEnable = OPTION_FLAG_DISABLED
	endIf

	if (Handler.MagelightModuleOn && isQuestRunning)
		flagMagelightEnable = OPTION_FLAG_NONE
	else
		flagMagelightEnable = OPTION_FLAG_DISABLED
	endIf
		

	; Setting flags
	if (Game.GetPlayer().IsInInterior() && isQuestRunning)
		flags = OPTION_FLAG_NONE
	else
		flags =  OPTION_FLAG_DISABLED
	endif

	if (Handler.ToggleModEnable && isQuestRunning)
		flagUninstall = OPTION_FLAG_DISABLED
	else
		flagUninstall = OPTION_FLAG_NONE
	endif

	if (WearableLanternsLoaded && WLPatchLoaded && isQuestRunning)
		flagLantern = OPTION_FLAG_NONE
	else
		flagLantern = OPTION_FLAG_DISABLED
	endif

	if (isQuestRunning)
		flagDone = OPTION_FLAG_HIDDEN
		flagEnable = OPTION_FLAG_NONE
	else
		flagUninstall = OPTION_FLAG_HIDDEN
		flagDone = OPTION_FLAG_NONE
		flags = OPTION_FLAG_HIDDEN
		flagEnable = OPTION_FLAG_HIDDEN
		flagLantern = OPTION_FLAG_HIDDEN
		flagTorchEnable = OPTION_FLAG_HIDDEN
		flagCandlelightEnable = OPTION_FLAG_HIDDEN
		flagMagelightEnable = OPTION_FLAG_HIDDEN
	endif

endFunction


event OnUpdate()

	if (Install)
		Utility.Wait(1)
		Handler.Install()
		Install = False

	elseif(Uninstall)
		Utility.Wait(1)
		Handler.Uninstall()
		Uninstall = False

	endif

	disableAll = false

	UnregisterForUpdate()

endEvent