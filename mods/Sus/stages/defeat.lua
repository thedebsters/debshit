function onCreatePost()
	makeLuaSprite('stageback', 'defeat/BG', getProperty('dad.x') - getProperty('dad.width') + -192, -getProperty('dad.y') - getProperty('dad.height') + 967.65)
	
	makeLuaSprite('stagefront', 'defeat/filter', getProperty('dad.x') - getProperty('dad.width') + -192, -getProperty('dad.y') - getProperty('dad.height') + 967.65)
	
	addLuaSprite('stageback', false)
	addLuaSprite('stagefront', true)
	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-dead-imposter');
	
	for i,h in pairs({'healthBar', 'healthBarBG', 'iconP1', 'iconP2'}) do
		setProperty(h..'.visible', false)
	end
end

function noteMiss()
	noteMissPress()
end

function noteMissPress()
	setProperty('boyfriend.stunned', true)
	for i = 0, getProperty('notes.length') - 1 do
		setPropertyFromGroup('notes', i, 'ignoreNote', true)
		setPropertyFromGroup('notes', i, 'canBeHit', true)
	end
	runHaxeCode([[
	
		FlxG.sound.music.volume = 0;
		game.vocals.volume = 0;
		FlxG.sound.play(Paths.sound('black-death'));
		game.cameraSpeed = 0;
		game.introSoundsSuffix = 'empty';
		
		FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut});
		FlxTween.tween(FlxG.camera.target, {x: 315.1, y: 996.25}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut});
		FlxTween.tween(game.camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadIn});
		game.camZoomingMult = 0;
		game.camZoomingDecay = 0;
		
		game.dad.playAnim('death', true);
		game.dad.specialAnim = true;
		
		new FlxTimer().start(game.dad.animation.curAnim.delay * 15, function(tmr:FlxTimer) 
			{
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
				black.scrollFactor.set();
				black.alpha = 0;
				game.addBehindDad(black);
				FlxTween.tween(black, {alpha: 1}, game.dad.animation.curAnim.delay * 20);
			});
			
		game.dad.animation.finishCallback = function(name)
			{
				FlxG.camera.scroll.x += 800;
				FlxG.camera.scroll.y += 90;
				FlxG.camera.zoom = 0.75;
				game.health = -2;
			}
			
				]])
end