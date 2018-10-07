Scriptname _ST_CanTrackerScript extends activemagiceffect  

; Properties
Formlist Property actorsWithShadowLights auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	actorsWithShadowLights.AddForm(akTarget)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	actorsWithShadowLights.RemoveAddedForm(akTarget)
EndEvent
