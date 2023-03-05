function onCreatePost()
makeAnimatedLuaSprite('healthTS','TS_healthbar',340,640)
addAnimationByPrefix('healthTS','idle','health_move',24,true)
addLuaSprite('healthTS',true)
if downscroll then
    setProperty('healthTS.y',80)
end
setObjectCamera('healthTS','camHUD')
setProperty('healthBarBG.visible',false)
setObjectOrder('healthTS',getObjectOrder('healthBar')+1)
setProperty('camGame.visible',true)
end