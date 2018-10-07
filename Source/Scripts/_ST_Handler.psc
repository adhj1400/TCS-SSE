Scriptname _ST_Handler extends ReferenceAlias

; Magiceffects --------------------------------
MagicEffect property FX400 auto
MagicEffect property FX400bright auto
MagicEffect property FX400Shadow auto
MagicEffect property FX400Shadowbright auto
MagicEffect property FX600 auto
MagicEffect property FX600bright auto
MagicEffect property FX600Shadow auto
MagicEffect property FX600Shadowbright auto
MagicEffect property FX900 auto
MagicEffect property FX900bright auto
MagicEffect property FX900Shadow auto
MagicEffect property FX900Shadowbright auto
MagicEffect property LightFFAimed auto
MagicEffect CurrCanFX
MagicEffect CurrCanFXShadow

; Spells --------------------------------------
Spell property CandlelightSpell auto
Spell property CandlelightDummy auto
Spell property MagelightSpell auto
Spell property MagelightSpellDummy auto
Spell property MagelightSpellShadow auto
Spell property CandlelightSpell400 auto
Spell property CandlelightSpell400bright auto
Spell property CandlelightSpell400Shadow auto
Spell property CandlelightSpell400Shadowbright auto
Spell property CandlelightSpell600 auto
Spell property CandlelightSpell600bright auto
Spell property CandlelightSpell600Shadow auto
Spell property CandlelightSpell600Shadowbright auto
Spell property CandlelightSpell900 auto
Spell property CandlelightSpell900bright auto
Spell property CandlelightSpell900Shadow auto
Spell property CandlelightSpell900Shadowbright auto
Spell property LanternEffect400 auto
Spell property LanternEffect600 auto
Spell property LanternEffect900 auto
Spell property LanternEffect1200 auto
Spell property LanternEffect400S auto
Spell property LanternEffect600S auto
Spell property LanternEffect900S auto
Spell property LanternEffect1200S auto
Spell Property MonitorAbility Auto
Spell property CurrLanternSpellStatic auto
Spell property CurrLanternSpellShadow auto
Spell CurrCandlelightSpell
Spell CurrCandlelightSpellShadow

; Lights -------------------------------------
Light Property Torch01 auto
Light property TorchLight600 auto
Light property TorchLight600bright auto
Light property TorchLight600Shadow auto
Light property TorchLight600Shadowbright auto
Light property TorchLight900 auto
Light property TorchLight900bright auto
Light property TorchLight900Shadow auto
Light property TorchLight900Shadowbright auto
Light property TorchLight1200 auto
Light property TorchLight1200bright auto
Light property TorchLight1200Shadow auto
Light property TorchLight1200Shadowbright auto
Light CurrTorchLight
Light CurrTorchLightShadow

; Variables ----------------------------------
float property ActorUpdateInterval = 8.0 auto
float property updateReApply = 30.0 auto
float Property npcApplyFrequency = 4.0 Auto
bool Property CandlelightModuleOn = true Auto
bool Property MagelightModuleOn = True Auto
bool Property TorchModuleOn = True Auto
bool property ToggleModEnable = true auto
bool property ToggleShadowsTorch = true auto
bool property ToggleShadowsCandlelight = true auto
bool property ToggleShadowsMagelight = true auto 	; Magelight shadow on/off
bool property ToggleShadowsExteriors = true auto
bool property ToggleShadowsInteriors = true auto
bool property ToggleCandlelightToggle = false auto
bool property ToggleWLLantern = false auto
bool Property npcEnableCandlelight = false Auto
bool Property npcEnableTorch = false Auto
bool Property playerEnableCandlelight = true Auto
bool Property playerEnableTorch = true Auto
bool Property TogglePlayerUpdate = true Auto
bool Property runOnce = false Auto
bool Property RunHandlerOnUpdate = false Auto
int property CandlelightBrightness = 0 auto
int property CandlelightRange = 1 auto
int property TorchBrightness = 0 auto
int property TorchRange = 0 auto
int property npcLimitInterior = 1 auto
int property npcLimitExterior = 3 auto
int property maxLightSources = 4 auto
int property distance = 4096 auto		; The min distance between the player and the lightsource
int Property cellLightSize auto

; Formlists ----------------------------------
Formlist Property actorsWithShadowLights auto
FormList Property cellLightFormlist auto ; must be created and linked in CK
Formlist property LocationFormList auto
Formlist property lightList auto

; Other --------------------------------------
Cell property oldCell auto
Quest property STQuest auto
ObjectReference[] Property lightNativeArray auto
bool property wearableLantersEnabled = false auto
Actor property Player auto

import StringUtil	; For dec->hex conversion


Event OnInit()
	Install()
endEvent


Function AddTorchesToCheskosFormlist ()

	FormList _WL_HeldLanterns = Game.GetFormFromFile(0x005404, "Chesko_WearableLantern.esp") as FormList
    
    if (!_WL_HeldLanterns.HasForm(TorchLight600))
        _WL_HeldLanterns.AddForm(TorchLight600)
    endIf
    if (!_WL_HeldLanterns.HasForm(TorchLight600bright))
		_WL_HeldLanterns.AddForm(TorchLight600bright)
	EndIf
	if (!_WL_HeldLanterns.HasForm(TorchLight600Shadow))
		_WL_HeldLanterns.AddForm(TorchLight600Shadow)
	EndIf
	if (!_WL_HeldLanterns.HasForm(TorchLight600Shadowbright))
		_WL_HeldLanterns.AddForm(TorchLight600Shadowbright)
	EndIf
	if (!_WL_HeldLanterns.HasForm(TorchLight900))
		_WL_HeldLanterns.AddForm(TorchLight900)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight900bright))
		_WL_HeldLanterns.AddForm(TorchLight900bright)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight900Shadow))
		_WL_HeldLanterns.AddForm(TorchLight900Shadow)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight900Shadowbright))
		_WL_HeldLanterns.AddForm(TorchLight900Shadowbright)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight1200))
		_WL_HeldLanterns.AddForm(TorchLight1200)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight1200bright))
		_WL_HeldLanterns.AddForm(TorchLight1200bright)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight1200Shadow))
		_WL_HeldLanterns.AddForm(TorchLight1200Shadow)
	endIf
	if (!_WL_HeldLanterns.HasForm(TorchLight1200Shadowbright))
		_WL_HeldLanterns.AddForm(TorchLight1200Shadowbright)
    endif

EndFunction


Function Install()
	if (!STQuest.IsRunning())
		STQuest.Start()
	EndIf

	Player = Game.GetPlayer()
	wearableLantersEnabled = isModLoaded("Chesko_WearableLantern.esp")

	SetSpells()
	updateCellLightsFormList()
	oldCell = Player.GetParentCell()

	Player.AddSpell(MonitorAbility, false)
	addModdedLights()

	if (wearableLantersEnabled)
		AddTorchesToCheskosFormlist()
	EndIf

	ToggleModEnable = True
	Debug.Notification("Customizable Lights Installed!")

endFunction


; *******
; Return current candlelight setting.
; *******
Spell function GetCandlelightSpellShadow()
	return CurrCandlelightSpellShadow
endFunction

Spell function GetCandlelightSpellStatic()
	return CurrCandlelightSpell
endFunction


; *******
; Return current torch setting.
; *******
Light function GetCurrentTorchStatic()
	return CurrTorchLight
endFunction

Light function GetCurrentTorchShadows()
	return CurrTorchLightShadow
endFunction


; *******
; Return current magelight setting.
; *******
MagicEffect function GetCandlelightMagicEffectStatic()
	return CurrCanFX
endFunction

MagicEffect function GetCandlelightMagicEffectShadow()
	return CurrCanFXShadow
endFunction


; *******
; Return if thisActor has a shadow casting torch equipped.
; *******
bool Function getIsShadowTorchEquipped(actor thisActor, bool isShadowTorchEquipped)
	return isAnyTorchEquipped(thisActor) && isShadowTorchEquipped
EndFunction


bool Function isAnyTorchEquipped(actor thisActor)
	return thisActor.GetEquippedItemType(0) == 11
EndFunction


bool Function hasCandlelightShadows(actor bActor)

	if (bActor.HasMagicEffect(FX400Shadow))
		return true
	elseIf(bActor.HasMagicEffect(FX400Shadowbright))
		return true
	elseIf(bActor.HasMagicEffect(FX600Shadow))
		return true
	elseIf(bActor.HasMagicEffect(FX600Shadowbright))
		return true
	elseIf(bActor.HasMagicEffect(FX900Shadow))
		return true
	elseIf(bActor.HasMagicEffect(FX900Shadowbright))
		return true
	endIf

	return false

endFunction


; *******
; Set spell and torch property settings.
; *******
Function SetSpells()

	int R = TorchRange
	int B = TorchBrightness
	int X = CandlelightRange
	int Y = CandlelightBrightness

	if (R == 0 && B == 0)
		CurrTorchLight= TorchLight600
		CurrTorchLightShadow = TorchLight600Shadow
	elseif (R == 0 && B == 1)
		CurrTorchLight = TorchLight600bright
		CurrTorchLightShadow = TorchLight600Shadowbright
	elseif (R == 1 && B == 0)
		CurrTorchLight = TorchLight900
		CurrTorchLightShadow = TorchLight900Shadow
	elseif (R == 1 && B == 1)
		CurrTorchLight = TorchLight900bright
		CurrTorchLightShadow = TorchLight900Shadowbright
	elseif (R ==2 && B == 0)
		CurrTorchLight = TorchLight1200
		CurrTorchLightShadow = TorchLight1200Shadow
	elseif (R ==2 && B == 1)
		CurrTorchLight = TorchLight1200bright
		CurrTorchLightShadow = TorchLight1200Shadowbright
	endif

	if (X == 0 && Y == 1)
		CurrCandlelightSpell = CandlelightSpell400
		CurrCandlelightSpellShadow = CandlelightSpell400Shadow
		CurrCanFX = FX400
		CurrCanFXShadow = FX400Shadow
	elseif (X == 0 && Y == 0)
		CurrCandlelightSpell = CandlelightSpell400bright
		CurrCandlelightSpellShadow = CandlelightSpell400Shadowbright
		CurrCanFX = FX400bright
		CurrCanFXShadow = FX400Shadowbright
	elseif (X == 1 && Y == 1)
		CurrCandlelightSpell = CandlelightSpell600
		CurrCandlelightSpellShadow = CandlelightSpell600Shadow
		CurrCanFX = FX600
		CurrCanFXShadow = FX600Shadow
	elseif (X == 1 && Y == 0)
		CurrCandlelightSpell = CandlelightSpell600bright
		CurrCandlelightSpellShadow = CandlelightSpell600Shadowbright
		CurrCanFX = FX600bright
		CurrCanFXShadow = FX600Shadowbright
	elseif (X ==2 && Y == 1)
		CurrCandlelightSpell = CandlelightSpell900
		CurrCandlelightSpellShadow = CandlelightSpell900Shadow
		CurrCanFX = FX900
		CurrCanFXShadow = FX900Shadow
	elseif (X ==2 && Y == 0)
		CurrCandlelightSpell = CandlelightSpell900bright
		CurrCandlelightSpellShadow = CandlelightSpell900Shadowbright
		CurrCanFX = FX900bright
		CurrCanFXShadow = FX900Shadowbright
	endif

endFunction


; *******
; Converts skyrim distance units to meters.
; *******
int Function UnitsToMeters(int units)
	return ((units * 1.43)/100) as int
EndFunction


Function DispelCandlelight(Actor bActor, bool shadowOnly)

	if (bActor.HasMagicEffect(FX400) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell400)
	elseif (bActor.HasMagicEffect(FX400bright) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell400bright)
	elseif (bActor.HasMagicEffect(FX400Shadow))
		bActor.DispelSpell(CandlelightSpell400Shadow)
	elseif (bActor.HasMagicEffect(FX400Shadowbright))
		bActor.DispelSpell(CandlelightSpell400Shadowbright)
	elseif (bActor.HasMagicEffect(FX600) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell600)
	elseif (bActor.HasMagicEffect(FX600bright) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell600bright)
	elseif (bActor.HasMagicEffect(FX600Shadow))
		bActor.DispelSpell(CandlelightSpell600Shadow)
	elseif (bActor.HasMagicEffect(FX600Shadowbright))
		bActor.DispelSpell(CandlelightSpell600Shadowbright)
	elseif (bActor.HasMagicEffect(FX900) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell900)
	elseif (bActor.HasMagicEffect(FX900bright) && !shadowOnly)
		bActor.DispelSpell(CandlelightSpell900bright)
	elseif (bActor.HasMagicEffect(FX900Shadow))
		bActor.DispelSpell(CandlelightSpell900Shadow)
	elseif (bActor.HasMagicEffect(FX900Shadowbright))
		bActor.DispelSpell(CandlelightSpell900Shadowbright)
	endif

EndFunction


; *******
; Decide if shadow casting is allowed
; *******
Bool Function Conditions(Actor Target)

	int result = runCheck(Target)
	bool status = false

	if (result == 1)
		status = True
	EndIf

	return status

endFunction


; *******
; The function is already in use, disabled until done.
; *******
STATE Busy

	Bool Function Conditions(Actor Target) ; Fires when another actor is scanning or updateCell is running.
		return false
	endFunction

endState

; Remove monitorspell from actors not present in same cell as player
Function cleanActorFL()
	int iIndex = actorsWithShadowLights.GetSize()

	while (iIndex > 0)
		iIndex -= 1
		Actor bActorRef = actorsWithShadowLights.GetAt(iIndex) as Actor

		if (bActorRef.GetParentCell() != Player.GetParentCell())
			bActorRef.DispelSpell(MonitorAbility)
			actorsWithShadowLights.RemoveAddedForm(bActorRef)
		endIf
	endWhile
EndFunction


; *******
; Run conditions. 0 : false, 1 : true, 2 : busy
; *******
int function runCheck(actor Target)

	bool bInside = Player.IsInInterior()
	int result

	; If we are inside, check for cell change
	if (bInside && Player.GetParentCell() != oldCell)
		RunHandlerOnUpdate = true
		RegisterForSingleUpdate(0)
		oldCell = Player.GetParentCell()		
		cleanActorFL()
		runOnce = false 	; Set to false when new interior cell

		return 2
	ElseIf (!bInside && !runOnce)
		runOnce = true
		cleanActorFL()

		return 2
	EndIf
		
	; If the location is not allowed, cell hasnt been updated OR player is too far away
	if (LocationFormList.HasForm(Target.GetCurrentLocation()) || Target.GetDistance(Player) > 4096)
		return 0
	endIf

	int npcLimit = getNpcLimit()

	if(checkLimit(npcLimit, maxLightSources, Target))
		return 0
	endIf

	bool inInterior = Target.IsInInterior()

	if(ToggleModEnable && ((inInterior && ToggleShadowsInteriors) || (!inInterior && ToggleShadowsExteriors)))
		return 1
	endif

	return 0

endFunction


int Function getNpcLimit()

	if (Player.IsInInterior())
		return npcLimitInterior
	else
		return npcLimitExterior
	endIf

EndFunction


int Function getCellLightSize(actor bActor, int limit)

	int index = 0
	int total = 0

	while (lightNativeArray[index])

		if(bActor.GetDistance(lightNativeArray[index]) < distance)

			total += 1

			if (total > limit)	; slightly enhances performance

				return total

			endIf
		endIf

		index += 1

	endWhile

	return total

endFunction


bool function checkLimit(int npcLimit, int limit, actor bActor)

	int totalAmount = getCellLightSize(Player, limit)
	int actorAmount = 0

	if (totalAmount >= limit)
		return True
	endIf

	if (bActor == Player)
		npcLimit += 1
	endIf

	actorAmount = actorsWithShadowLights.GetSize() + 1	; Check actors (+ 1 symbolizes bActor)

	if (actorsWithShadowLights.HasForm(bActor))

		limit += 1	; used to ignore this actor in case shadows already equipped
		npcLimit += 1

		if (actorsWithShadowLights.HasForm(Player))
			npcLimit += 1
		EndIf

	endIf

	if (totalAmount + actorAmount > limit)
		return true
	elseif (actorAmount > npcLimit)
		return true
	endIf

	return false	 ; Allow

endFunction


; ************
; Scans the cell and sorts and places all shadow casting lights in a formlist
; ************
Function updateCellLightsFormList()

	gotoState("Busy")

	lightNativeArray = new ObjectReference[128]

	; We scan from the player, since that is what i important
	int index = 0
	int innerIndex = 0
	int size = lightList.GetSize()
	Cell kCell = Player.GetParentCell()
	ObjectReference thisLight
	cellLightSize = 0


	while (index < size)
		thisLight = kCell.GetNthRef(index, 31)

		if (lightList.HasForm(thisLight.getBaseObject()))
			lightNativeArray[innerIndex] = thisLight
			
			innerIndex += 1
		endIf

		index +=1

	endWhile

	cellLightSize = innerIndex

	gotoState("Waiting")

endFunction


bool Function equipTorch(Actor bActor, bool isShadowTorchEquipped)
	; Unequip the default torch
	bActor.UnequipItem(Torch01, false, true)

	; Get which torch to equip
	Light torchToEquip

	; Check what kind of torch to equip according to settings
	if (ToggleShadowsTorch && Conditions(bActor) && CheckOtherFX(bActor, 0, isShadowTorchEquipped))
		torchToEquip = GetCurrentTorchShadows()
		isShadowTorchEquipped = true
	else
		torchToEquip = GetCurrentTorchStatic()
		isShadowTorchEquipped = false
	endIf

	; Add the torch before equipping it
	if (bActor.GetItemCount(torchToEquip) < 1)
		bActor.AddItem(torchToEquip, 1, true)
		Utility.Wait(1)	; Wait for 1 second just to be sure
	endIf

	; Equip correct torch
	bActor.EquipItem(torchToEquip, false, true)

	return isShadowTorchEquipped

EndFunction


; ******
; Uninstalling procedure
; ******
Function Uninstall ()

	ToggleModEnable = false

	if(Player.HasSpell(CandlelightDummy))
		Player.RemoveSpell(CandlelightDummy)
		Player.AddSpell(CandlelightSpell, false)
	endif

	Utility.Wait(1)
	
	if (Player.HasSpell(MagelightSpellDummy))
		Player.RemoveSpell(MagelightSpellDummy)
		Player.AddSpell(MagelightSpell, false)
	endIf

	Player.UnEquipAll()

	DispelCandlelight(Player, false)

	RemoveAllTorchesFrom(Player)

	STQuest.Stop()

	Debug.Notification("Customizable Lights succesfully uninstalled.")

endFunction


; ******
; Check what spells akActor is influenced by currently. 
; ******
Bool Function CheckOtherFX(actor akActor, int x, bool isShadowTorchEquipped)

	; Torch
	if (x == 0)

		If (akActor.HasMagicEffect(GetCandlelightMagicEffectShadow()))
			akActor.DispelSpell(GetCandlelightSpellShadow())
			return false
		elseif (akActor.HasMagicEffect(GetCandlelightMagicEffectStatic()))
			return false
		elseif(wearableLantersEnabled && HasLanternFX(akActor))
			return false
		endif
	; Magelight
	elseif(x == 1)

		If (akActor.HasSpell(GetCandlelightSpellShadow()))
			return false
		elseIf (getIsShadowTorchEquipped(akActor, isShadowTorchEquipped))
			return false
		elseif (wearableLantersEnabled && HasLanternFX(akActor))
			return false
		endif
	; Candlelight
	elseif(x == 2)

		If (getIsShadowTorchEquipped(akActor, isShadowTorchEquipped))		; Check if torch-shadows are active
			akActor.UnequipItem(GetCurrentTorchShadows(), false, true)
			akActor.EquipItem(GetCurrentTorchStatic(), false, true)
			return false
		elseIf (akActor.IsEquipped(GetCurrentTorchStatic()))
			return false
		elseif (wearableLantersEnabled && HasLanternFX(akActor))
			return false
		endif
	; Wearable lanterns
	elseif(x == 3)

		If (akActor.HasMagicEffect(GetCandlelightMagicEffectShadow()))
			akActor.DispelSpell(GetCandlelightSpellShadow())
			return false
		elseif (akActor.HasMagicEffect(GetCandlelightMagicEffectStatic()))
			return false
		elseIf (getIsShadowTorchEquipped(akActor, isShadowTorchEquipped))
			akActor.UnequipItem(GetCurrentTorchShadows(), false, true)
			akActor.EquipItem(GetCurrentTorchStatic(), false, true)
			return false
		endif
	endif

	return true

endFunction


; ******
; Adds array contents to a formlist
; ******
Function AddToFormList(Light[] formToAdd, FormList fl)

	int index = formToAdd.length

	while(index)
		index -= 1

		if (!fl.HasForm(formToAdd[index]))

			fl.AddForm(formToAdd[index])

		endIf

	endWhile
	
EndFunction


Function AddToActorFormlist(actor bActor)
	if (!actorsWithShadowLights.HasForm(bActor))
		actorsWithShadowLights.AddForm(bActor)
	endIf
EndFunction


Function RemoveFromActorFormlist(actor bActor)
	if (actorsWithShadowLights.HasForm(bActor))
		actorsWithShadowLights.RemoveAddedForm(bActor)
	EndIf
EndFunction


; ******
; Check if modName is loaded (true) or not loaded (false).
; ******
bool Function isModLoaded(string modName)
	return Game.GetModByName(modName) != 255
endFunction


; ******
; Check if the player is using a Lantern from Chesko's "Wearable Lanterns"
; ******
bool Function HasLanternFX(Actor akActor)
	if (!wearableLantersEnabled)
		return false
	endIf

	If (akActor.HasSpell(LanternEffect400S))
		return true
	elseIf (akActor.HasSpell(LanternEffect600S))
		return true
	elseIf (akActor.HasSpell(LanternEffect900S))
		return true
	elseIf (akActor.HasSpell(LanternEffect1200S))
		return true
	elseIf (akActor.HasSpell(LanternEffect400))
		return true
	elseIf (akActor.HasSpell(LanternEffect600))
		return true
	elseIf (akActor.HasSpell(LanternEffect900))
		return true
	elseIf (akActor.HasSpell(LanternEffect1200))
		return true
	endif

	return false

endFunction


; ******
; Casts modded magelight spell by thisActor. isShadowTorchEquipped need to be passed by the actor.
; ******
Function castMagelight (actor thisActor, bool isShadowTorchEquipped)

	if (ToggleShadowsMagelight && Conditions(thisActor) && CheckOtherFX(thisActor, 1, isShadowTorchEquipped))
		MagelightSpellShadow.Cast(thisActor)
	else
		MagelightSpell.Cast(thisActor)
	endIf

endFunction


; ******
; Casts modded candlelight spell by thisActor. -::- Returns true if shadows were cast.
; ******
Bool Function castCandlelight (actor thisActor, bool isShadowTorchEquipped)

	if (!ToggleModEnable || !((thisActor == Player && playerEnableCandlelight) || (thisActor != Player && npcEnableCandlelight)))
		CandlelightSpell600bright.cast(thisActor, thisActor)	; Cast fake default candlelight to simulate being deactivated
		return false
	endIf

	if (ToggleCandlelightToggle && thisActor.HasMagicEffect(GetCandlelightMagicEffectStatic()))
		thisActor.DispelSpell(GetCandlelightSpellStatic())
	elseif (ToggleCandlelightToggle && thisActor.HasMagicEffect(GetCandlelightMagicEffectShadow()))
		thisActor.DispelSpell(GetCandlelightSpellShadow())
	else

		if (ToggleShadowsCandlelight && Conditions(thisActor) && CheckOtherFX(thisActor, 2, isShadowTorchEquipped))
			if(thisActor.HasMagicEffect(GetCandlelightMagicEffectStatic()))
				thisActor.DispelSpell(GetCandlelightSpellStatic())
			endif

			GetCandlelightSpellShadow().Cast(thisActor, thisActor)	; cast spell
			return true
		else
			if(thisActor.HasMagicEffect(GetCandlelightMagicEffectShadow()))
				thisActor.DispelSpell(GetCandlelightSpellShadow())
			endif

			GetCandlelightSpellStatic().Cast(thisActor, thisActor)
			return false
		endIf
	endif

	return false

endFunction


; ******
; Unequips the current shadowTorch.
; ******
Function unequipShadows (actor bActor)

	bActor.unequipitem(GetCurrentTorchShadows(), false, true)
	bActor.equipitem(GetCurrentTorchStatic(), false, true)

	if (actorsWithShadowLights.HasForm(bActor))
		actorsWithShadowLights.RemoveAddedForm(bActor)
	endIf

endFunction


; ******
; Removes all moded torches from the bActor.
; ******
Function RemoveAllTorchesFrom(actor bActor)

	if (bActor.GetItemCount(TorchLight600) > 0)
		bActor.RemoveItem(TorchLight600, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight600bright) > 0)
		bActor.RemoveItem(TorchLight600bright, 1, true)
	endif
	 if (bActor.GetItemCount(TorchLight600Shadow) > 0)
		bActor.RemoveItem(TorchLight600Shadow, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight600Shadowbright) > 0)
		bActor.RemoveItem(TorchLight600Shadowbright, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight900) > 0)
		bActor.RemoveItem(TorchLight900, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight900bright) > 0)
		bActor.RemoveItem(TorchLight900bright, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight900Shadow) > 0)
		bActor.RemoveItem(TorchLight900Shadow, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight900Shadowbright) > 0)
		bActor.RemoveItem(TorchLight900Shadowbright, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight1200) > 0)
		bActor.RemoveItem(TorchLight1200, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight1200bright) > 0)
		bActor.RemoveItem(TorchLight1200bright, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight1200Shadow) > 0)
		bActor.RemoveItem(TorchLight1200Shadow, 1, true)
	endif
	if (bActor.GetItemCount(TorchLight1200Shadowbright) > 0)
		bActor.RemoveItem(TorchLight1200Shadowbright, 1, true)
	endif

endFunction


; ******
; Add forms from other mods into the list of lights for compatibility.
; ******
Function addModdedLights()

	if (isModLoaded("EnhancedLightsandFX.esp"))

		light[] lightArray = new light[32]

		lightArray[0] = Game.GetFormFromFile(0x00000D5C, "EnhancedLightsandFX.esp") as light
		lightArray[1] = Game.GetFormFromFile(0x00000D61, "EnhancedLightsandFX.esp") as light
		lightArray[2] = Game.GetFormFromFile(0x00000D62, "EnhancedLightsandFX.esp") as light
		lightArray[3] = Game.GetFormFromFile(0x0000CE9C, "EnhancedLightsandFX.esp") as light
		lightArray[4] = Game.GetFormFromFile(0x0000F374, "EnhancedLightsandFX.esp") as light
		lightArray[5] = Game.GetFormFromFile(0x00023CA5, "EnhancedLightsandFX.esp") as light
		lightArray[6] = Game.GetFormFromFile(0x00053FE9, "EnhancedLightsandFX.esp") as light
		lightArray[7] = Game.GetFormFromFile(0x0006473E, "EnhancedLightsandFX.esp") as light
		lightArray[8] = Game.GetFormFromFile(0x00077B70, "EnhancedLightsandFX.esp") as light
		lightArray[9] = Game.GetFormFromFile(0x0008BD01, "EnhancedLightsandFX.esp") as light
		lightArray[10] = Game.GetFormFromFile(0x0008C86C, "EnhancedLightsandFX.esp") as light
		lightArray[11] = Game.GetFormFromFile(0x000909AA, "EnhancedLightsandFX.esp") as light
		lightArray[12] = Game.GetFormFromFile(0x0009AFEE, "EnhancedLightsandFX.esp") as light
		lightArray[13] = Game.GetFormFromFile(0x000A63D1, "EnhancedLightsandFX.esp") as light
		lightArray[14] = Game.GetFormFromFile(0x000A6937, "EnhancedLightsandFX.esp") as light
		lightArray[15] = Game.GetFormFromFile(0x000A974E, "EnhancedLightsandFX.esp") as light
		lightArray[16] = Game.GetFormFromFile(0x000A9B40, "EnhancedLightsandFX.esp") as light
		lightArray[17] = Game.GetFormFromFile(0x000B1B1B, "EnhancedLightsandFX.esp") as light
		lightArray[18] = Game.GetFormFromFile(0x000B4528, "EnhancedLightsandFX.esp") as light
		lightArray[19] = Game.GetFormFromFile(0x000B6B8D, "EnhancedLightsandFX.esp") as light
		lightArray[20] = Game.GetFormFromFile(0x000C9A09, "EnhancedLightsandFX.esp") as light
		lightArray[21] = Game.GetFormFromFile(0x000CB008, "EnhancedLightsandFX.esp") as light
		lightArray[22] = Game.GetFormFromFile(0x000D296E, "EnhancedLightsandFX.esp") as light
		lightArray[23] = Game.GetFormFromFile(0x000D72C2, "EnhancedLightsandFX.esp") as light
		lightArray[24] = Game.GetFormFromFile(0x000D8E77, "EnhancedLightsandFX.esp") as light
		lightArray[25] = Game.GetFormFromFile(0x000DC1D6, "EnhancedLightsandFX.esp") as light
		lightArray[26] = Game.GetFormFromFile(0x000DCCD2, "EnhancedLightsandFX.esp") as light
		lightArray[27] = Game.GetFormFromFile(0x000DE8F8, "EnhancedLightsandFX.esp") as light
		lightArray[28] = Game.GetFormFromFile(0x000E9ABE, "EnhancedLightsandFX.esp") as light
		lightArray[29] = Game.GetFormFromFile(0x000F3812, "EnhancedLightsandFX.esp") as light
		lightArray[30] = Game.GetFormFromFile(0x0010A359, "EnhancedLightsandFX.esp") as light
		lightArray[31] = Game.GetFormFromFile(0x001471E7, "EnhancedLightsandFX.esp") as light
		
		AddToFormList(lightArray, lightList)
	EndIf

	if (isModLoaded("ELFX - Exteriors.esp"))
		light[] lightArray = new Light[1]

		lightArray[0] = Game.GetFormFromFile(0x0000D263, "ELFX - Exteriors.esp") as light

		AddToFormList(lightArray, lightList)
	endIf

endFunction


; ******
; Converts binary to hexadecimal.
; ******
String Function binToHex (String bin)

	string parseString

	int index = 0

	while(index + 4 <= GetLength(bin))
		; get the 4 current characters in the string to check
		string subString = Substring(bin, index, 4)

		if (subString == "0000")
			parseString = parseString + "0"
		elseIf (subString == "0001")
			parseString = parseString + "1"
		elseIf (subString == "0010")
			parseString = parseString + "2"
		elseIf (subString == "0011")
			parseString = parseString + "3"
		elseIf (subString == "0100")
			parseString = parseString + "4"
		elseIf (subString == "0101")
			parseString = parseString + "5"
		elseIf (subString == "0110")
			parseString = parseString + "6"
		elseIf (subString == "0111")
			parseString = parseString + "7"
		elseIf (subString == "1000")
			parseString = parseString + "8"
		elseIf (subString == "1001")
			parseString = parseString + "9"
		elseIf (subString == "1010")
			parseString = parseString + "A"
		elseIf (subString == "1011")
			parseString = parseString + "B"
		elseIf (subString == "1100")
			parseString = parseString + "C"
		elseIf (subString == "1101")
			parseString = parseString + "D"
		elseIf (subString == "1110")
			parseString = parseString + "E"
		elseIf (subString == "1111")
			parseString = parseString + "F"
		endIf

		index += 4

	endWhile

	parseString = addMissingZeroes(parseString, 8)

	return parseString

endFunction


; ******
; Converts decimal to binary.
; ******
String Function DecToBin (int Dec)

	string parseString

	while (dec > 0)
		parseString = dec % 2 + parseString
		dec = dec/2
	endWhile

	int missingZeroes = 4 - GetLength(parseString) % 4
	parseString = addMissingZeroes(parseString, 4)

	return parseString

endFunction


; ******
; Adds zeroes to begining of string.
; ******
String Function addMissingZeroes(string parseString, int moduloVar)

	int missingZeroes = moduloVar - GetLength(parseString) % moduloVar

	while(missingZeroes > 0)
		parseString = "0" + parseString
		missingZeroes -= 1
	endWhile

	return parseString

endFunction


String Function getModNameFromForm(String formID)
	return Game.GetModName(SubString(formID, 0, 2) as int)
EndFunction


Event OnUpdate()

	if (RunHandlerOnUpdate)
		updateCellLightsFormList()
		RunHandlerOnUpdate = false
	endIf

EndEvent
