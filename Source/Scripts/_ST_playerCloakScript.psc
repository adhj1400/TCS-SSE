Scriptname _ST_playerCloakScript extends ReferenceAlias

Spell Property CloakAbility Auto
Actor Property PlayerRef Auto

_ST_Handler property Handler auto

Event OnInit()
	RegisterForSingleUpdate(1)
EndEvent


Event OnUpdate()
	if (Handler.npcEnableCandlelight || Handler.npcEnableTorch)
		PlayerRef.AddSpell(CloakAbility, false)
		; How long you would like to keep the cloak active
		Utility.Wait(1)
		PlayerRef.RemoveSpell(CloakAbility)
	EndIf
	; How long until the cloak activates again
	RegisterForSingleUpdate(Handler.npcApplyFrequency)
	
EndEvent
