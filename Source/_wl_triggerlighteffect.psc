scriptname _WL_TriggerLightEffect extends ActiveMagicEffect

Spell property LanternSpell auto
Spell property LanternSpellShadow auto
Spell property AuxSpell auto
FormList property LocationFormList auto
_ST_Handler property Handler auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	bool hasSpell = akTarget.HasSpell(LanternSpellShadow)
	bool hasTorch = Handler.isAnyTorchEquipped(akCaster)

	if (Handler.ToggleWLLantern && Handler.Conditions(akCaster) && (!hasSpell) && akCaster == Game.GetPlayer() && Handler.CheckOtherFX(akCaster, 3, false) && !hasTorch)
		akTarget.AddSpell(LanternSpellShadow, false)
		Handler.CurrLanternSpellShadow = LanternSpellShadow
		Handler.AddToActorFormlist(akTarget)
	elseif !akTarget.HasSpell(LanternSpell)
		akTarget.AddSpell(LanternSpell, false)
		Handler.CurrLanternSpellStatic = LanternSpell
	endif

	if AuxSpell != None
		if !akTarget.HasSpell(AuxSpell)
			akTarget.AddSpell(AuxSpell, false)
		endif
	endif
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if akTarget.HasSpell(LanternSpell)
		akTarget.RemoveSpell(LanternSpell)
	endif

	if akTarget.HasSpell(LanternSpellShadow)
		akTarget.RemoveSpell(LanternSpellShadow)
		Handler.RemoveFromActorFormlist(akTarget)
	endif

	if AuxSpell != None
		if akTarget.HasSpell(AuxSpell)
			akTarget.RemoveSpell(AuxSpell)
		endif
	endif 
endEvent