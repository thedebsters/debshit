function onCreatePost()

	makeLuaSprite('stageback', 'BG', -667.85, 408.75)
	makeLuaSprite('stagefront', 'table', 213.05, 732.7 * 1.68)
	
	makeAnimatedLuaSprite('boppers', 'tableboppers', 172.9 * 1, 706.3 * 1.7)
	
	addAnimationByPrefix('boppers', 'b', 'full table dance', 24, false)
	addAnimationByPrefix('boppers', 'die', 'full table die', 24, false)
	addAnimationByPrefix('boppers', 'dead', 'full table dead', 24, false)
	
	addLuaSprite('stageback', false)
	addLuaSprite('stagefront', true)
	addLuaSprite('boppers', true)
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-dead-imposter');
	
end

function onCountdownTick(t)
	if t % 2 == 0 and getProperty('boppers.animation.curAnim.name') == 'b' then
		playAnim('boppers', 'b', false)
	end
end

function onBeatHit()
	if curBeat % 2 == 0 and not getProperty('gf.stunned') and getProperty('boppers.animation.curAnim.name') == 'b' then
		playAnim('boppers', 'b', false)
	end
end