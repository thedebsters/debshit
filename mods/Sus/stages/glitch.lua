function onCreatePost()

	makeLuaSprite('stageback', 'glitch/BG', -667.85, 408.75)
	
	makeAnimatedLuaSprite('GYbopper', 'glitch/gray', -170, 425.3 * 2.015)
	makeAnimatedLuaSprite('GNbopper', 'glitch/green', -667.85 + getProperty('stageback.width') / 1.6, 408.75 * 1.055)
	
	addAnimationByPrefix('GYbopper', 'b', 'gray dance', 24, false)
	addAnimationByPrefix('GNbopper', 'b', 'fortegreen dance', 24, false)
	
	addLuaSprite('stageback', false)
	addLuaSprite('GYbopper', false)
	addLuaSprite('GNbopper', false)
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-dead-imposter');
end

function onCountdownTick(t)
	if t % 2 == 0 then
		playAnim('GYbopper', 'b', false)
		playAnim('GNbopper', 'b', false)
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('GYbopper', 'b', false)
		playAnim('GNbopper', 'b', false)
	end
end