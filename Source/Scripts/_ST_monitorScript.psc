Scriptname _ST_monitorScript extends activemagiceffect  
{ The script monitoring each character affected by this mod. }

; Spells
Spell property CandlelightSpell auto
Spell property MagelightSpell auto
Spell property MagelightSpellDummy auto
Spell property MagelightSpellShadow auto
Spell Property MonitorAbility Auto

; Properties
bool property isShadowTorchEquipped = false auto
Light property Torch01 auto
Formlist Property actorsWithShadowLights auto
_ST_Handler property Handler auto

; Other
Actor Player
Actor thisActor
bool torchEquipped = false


Event OnEffectStart(Actor akTarget, Actor akCaster)
	thisActor = akTarget
	Player = Game.GetPlayer()
	AddInventoryEventFilter(Torch01)

EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Handler.DispelCandlelight(akTarget, false)
	Handler.RemoveAllTorchesFrom(akTarget)
	Handler.RemoveFromActorFormlist(akTarget)

EndEvent


Event OnDying(Actor akKiller)
	thisActor.DispelSpell(MonitorAbility)

EndEvent


Event OnObjectEquipped (Form akBaseObject, ObjectReference akReference)

	if (!Handler.ToggleModEnable)
		Return
	EndIf

	if (akBaseObject as light == Torch01 && Handler.TorchModuleOn)
		
		if (thisActor == Player && Handler.playerEnableTorch) || (thisActor != Player && Handler.npcEnableTorch)

			; Prevent re-equipping the torch (player only)
			if (thisActor == Player && torchEquipped)
				Utility.Wait(0.1)
				thisActor.unequipitem(Torch01, false, true)
				torchEquipped = false
				isShadowTorchEquipped = false
			Else
				; Update the new value by sending the old value, also equip proper torch
				isShadowTorchEquipped = Handler.equipTorch(thisActor, isShadowTorchEquipped)
				torchEquipped = true

				; If shadow torch is equipped, make continous checks
				modifyActorList()
				
			EndIf
		EndIf
		
	; Remove vanilla spell and add modded magelightspell
	ElseIf ((akBaseObject as spell == MagelightSpell) && Handler.MagelightModuleOn && (thisActor == Player))

		Player.RemoveSpell(MagelightSpell)
		Player.Addspell(MagelightSpellDummy, false)

	EndIf

EndEvent


Function modifyActorList ()

	if (isShadowTorchEquipped)
		actorsWithShadowLights.addForm(thisActor)
		RegisterForSingleUpdate(Handler.ActorUpdateInterval)
	ElseIf (Handler.isAnyTorchEquipped(thisActor))
		actorsWithShadowLights.RemoveAddedForm(thisActor)
		RegisterForSingleUpdate(Handler.updateReApply)
	EndIf

EndFunction


; ******
; Candlelight related. NOTE: Actor is added to the actorFormlist on EffectStart.
; ******
Event OnSpellCast(Form akSpell)

	if (!Handler.ToggleModEnable)
		Return
	EndIf

	if (akSpell as Spell == CandlelightSpell && Handler.CandlelightModuleOn)
		; Dispel default spell effect
		thisActor.DispelSpell(CandlelightSpell)

		; Cast the proper candlelight spell
		bool canShadow = Handler.castCandlelight(thisActor, isShadowTorchEquipped)

		; Check if shadow was casted, if so, registerforsingleupdate.
		if (canShadow)
			RegisterForSingleUpdate(Handler.ActorUpdateInterval)	; to maybe disable it later
		EndIf

	; If magelight (player only)
	ElseIf (akSpell as spell == MagelightSpellDummy && thisActor == Player)

		Handler.castMagelight(Player, isShadowTorchEquipped)

	EndIf

EndEvent


; ******
; We need to remove the torch from the inventory to prevent NPC's from equipping them directly.
; Torche01 will always be #1 in priority (i hope...).
; ******
Event OnItemRemoved(Form akBaseItem, int aiItmCount, ObjectReference akItmRef, ObjectReference akDestCont)
	
	if (akBaseItem == Torch01 && thisActor.GetItemCount(Torch01) == 0)
		Handler.RemoveAllTorchesFrom(thisActor)
	EndIf
		
EndEvent


; ******
; Check if actor is using a shadow torch atm, then check if they are far away from the
; player or if the player is around too many shadow casting light sources.
; Checks a bunch of Bools.
; ******
Event OnUpdate()

	if (!Handler.TogglePlayerUpdate && thisActor == Player)
		Return
	endIf

	If (Handler.ToggleShadowsTorch && Handler.isAnyTorchEquipped(thisActor))

		int allowed = Handler.runCheck(thisActor)

		if (isShadowTorchEquipped && allowed == 0)  ; Check if shadowtorch can still be used by this actor
			Handler.unequipShadows(thisActor)	; Re-equip all
			isShadowTorchEquipped = false
		elseif (allowed == 1)  ; Check if we can re apply shadows
			thisActor.EquipItem(Handler.GetCurrentTorchShadows(), false, true)
			isShadowTorchEquipped = true
		endIf

		modifyActorList()

	elseif (Handler.ToggleShadowsCandlelight && Handler.hasCandlelightShadows(thisActor))  ; Candlelight check

		if Player.GetDistance(thisActor) > 4096 || Handler.runCheck(thisActor) == 0
			Handler.DispelCandlelight(thisActor, true)
		endIf

	; WL check
	elseIf(Handler.ToggleWLLantern && thisActor.HasSpell(Handler.CurrLanternSpellShadow))

		; If too many lights
		if (Handler.runCheck(thisActor) == 0)
			; remove the current lantern effect and replace it with the corresponding static effect
			thisActor.RemoveSpell(Handler.CurrLanternSpellShadow)
			thisActor.AddSpell(Handler.CurrLanternSpellStatic, false)
			RegisterForSingleUpdate(Handler.updateReApply) 

		Else
			RegisterForSingleUpdate(Handler.ActorUpdateInterval)
		EndIf

	; If static light from WL
	elseIf(Handler.ToggleWLLantern && thisActor.HasSpell(Handler.CurrLanternSpellStatic))

		if (Handler.runCheck(thisActor) == 1)

			thisActor.RemoveSpell(Handler.CurrLanternSpellStatic)
			thisActor.AddSpell(Handler.CurrLanternSpellShadow, false)
			RegisterForSingleUpdate(Handler.ActorUpdateInterval) 

		Else
			RegisterForSingleUpdate(Handler.updateReApply)
		EndIf

		
	endIf

	if (!isShadowTorchEquipped && !Handler.hasCandlelightShadows(thisActor) && !Handler.HasLanternFX(thisActor))
		Handler.RemoveFromActorFormlist(thisActor)
	EndIf

EndEvent
