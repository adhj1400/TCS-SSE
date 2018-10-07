Scriptname _ST_actorScript extends activemagiceffect

; Properties
Spell Property MonitorAbility Auto
_ST_Handler property Handler auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (Handler.ToggleModEnable && (Handler.npcEnableCandlelight || Handler.npcEnableTorch))
		akTarget.AddSpell(MonitorAbility, false)
	endIf
EndEvent
