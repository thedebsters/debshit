function onCreate()
	if isStoryMode and not seenCutscene then
		setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', true)
		precacheImage('emergency')
		makeAnimatedLuaSprite('emergency', 'emergency', 0, 0)
		scaleObject('emergency', 0.8, 0.8)
		setObjectCamera('emergency', 'camOther')
		addAnimationByPrefix('emergency', 'emergency', 'emergency meeting', 24, false) -- wow
		screenCenter('emergency')
		addLuaSprite('emergency', true)
		setProperty('cameraSpeed', 0)
		setProperty('camHUD.alpha', 0)
		addCharacterToList('cyan', 'dad')
	end
end

local num = 1
function onStepHit()
	if curSection >= 29 and curSection <= 50 and curSection ~= 36 then
		num = num + 1
		if num == 7 or num == 11 or num == 12 or num == 13 or num == 15 or num == 16 then
			triggerEvent("Add Camera Zoom", 0.015 / 2, 0.03 / 2)
			setProperty('camZoomingDecay', getProperty('camZoomingDecay') + 0.2)
		end
	end
end

local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		playSound('emergency')
		playAnim('emergency', 'emergency', false) -- wow
		runHaxeCode([[
		
		game.getLuaObject('emergency').animation.finishCallback = function(name)
							{
								game.cameraSpeed = 1;
								game.startCountdown();
								FlxTween.tween(game.getLuaObject('emergency'), {alpha: 0}, Conductor.crochet / 1000, {onComplete: function(twn)
									{
										game.remove(game.getLuaObject('emergency'));
										game.getLuaObject('emergency').destroy();
									}
								});
								FlxTween.tween(game.camHUD, {alpha: 1}, Conductor.crochet / 1000);
							};
		
					]]) -- i mean it works
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onSectionHit() -- to be reused
	if sectHitFuncs[curSection] then 
		sectHitFuncs[curSection]() -- Executes function at curStep in sectHitFuncs
	end
	num = 1
	if curSection >= 29 and curSection <= 50 and curSection ~= 36 then
		setProperty('camZoomingDecay', 1)
	end
end

sectHitFuncs = {

	[28] = function()
		runHaxeCode([[

		game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
		game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
		game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
		
		game.boyfriendCameraOffset[0] -= 30;
		game.opponentCameraOffset[0] += 30;
		game.opponentCameraOffset[1] += 30;
		game.boyfriendCameraOffset[1] += 30;
					]])
	end,
	
	[29] = function()
		setProperty('defaultCamZoom', 0.8)
		setProperty('camZoomingMult', 1.5)
		setProperty('camZoomingDecay', 1)
	end,
	
	[53] = function()
		setProperty('cameraSpeed', 0)
		setProperty('camZoomingDecay', 0)
		setProperty('camZooming', false)
		setProperty('camZoomingMult', 0)
		setProperty('opponentCameraOffset[0]', 0)
		setProperty('boyfriendCameraOffset[0]', 0)
		setProperty('defaultCamZoom', 0.75)
		setProperty('iconP1.scale.x', 1)
		setProperty('iconP1.scale.y', 1)
		setProperty('iconP2.scale.x', 1)
		setProperty('iconP2.scale.y', 1)
		setProperty('camHUD.zoom', 1)
		for i,j in pairs({'dad', 'gf'}) do
			setProperty(j..'.stunned', true)
		end
		runHaxeCode([[ 
			game.snapCamFollowToPos(game.gf.getMidpoint().x, game.gf.getMidpoint().y - 50); 
			FlxG.camera.zoom = 0.7;
			
			game.dad.holdTimer = 0;
			game.dad.singDuration = 50;
			game.gf.dance();
			game.dad.dance();
			game.boyfriend.dance();
			
			game.boyfriend.animation.curAnim.finish();
			game.dad.animation.curAnim.finish();
			game.gf.animation.curAnim.finish();
			game.getLuaObject('boppers').animation.curAnim.finish();
		]])
	end,
	
	[57] = function()
		setProperty('cameraSpeed', 1)
		setProperty('camZoomingMult', 1.2)
		setProperty('camZoomingDecay', 1.2)
		for i,j in pairs({'gf', 'dad'}) do
			setProperty(j..'.stunned', false)
		end
		playAnim('boppers', 'b', false)
		runHaxeCode([[
			game.boyfriend.dance();
			game.gf.dance();
			game.dad.singDuration = 4;
					]])
	end,
	
	[65] = function()
		runHaxeCode([[
		
			game.defaultCamZoom = 0.6;
			game.camZoomingMult = 0;
			game.camZoomingDecay = 0.7;
			
			game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
			game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
			game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
			
					]])
		setProperty('gf.stunned', true)
		setProperty('dad.stunned', true)
		setProperty('boyfriend.danceEveryNumBeats', 500)
	end,
	
}

local moved = false
function onBeatHit()
	
	if curSection == 28 or curSection == 51 then
		triggerEvent("Add Camera Zoom") -- why chart 4 events when u can make code do that for u
	end
	
	if curSection == 52 then
		moved = not moved
		runHaxeCode([[ 
			game.defaultCamZoom += 0.1; 
			game.cameraSpeed += 0.5;
					]])
		if moved then
		runHaxeCode([[
			game.boyfriendCameraOffset[0] -= 5;
			game.moveCamera(false);
					]])
		else
		runHaxeCode([[
			game.opponentCameraOffset[0] -= 5;
			game.moveCamera(true);
					]])
		end
	end
	
	if (curSection >= 53 and curSection < 57) or curBeat >= 261 then
		runHaxeCode([[ game.boyfriend.animation.curAnim.finish(); ]])
		setProperty('iconP1.scale.x', 1)
		setProperty('iconP1.scale.y', 1)
		setProperty('iconP2.scale.x', 1)
		setProperty('iconP2.scale.y', 1)
	end
	
end

local cutsceneEnd = false
function onEndSong()
	if not cutsceneEnd and isStoryMode then
		setProperty('camHUD.alpha', 0)
		setProperty('camZoomingDecay', 2)
		triggerEvent("Add Camera Zoom", 0.015 * 5)
		setProperty('opponentCameraOffset[1]', 0)
		playSound('kill')
		playAnim('boppers', 'die', false)
		setProperty('boppers.offset.x', 200)
		setProperty('boppers.offset.y', 115)
		playAnim('dad', 'die', false)
		setProperty('dad.specialAnim', true)
		setProperty('camZooming', true)
		addHaxeLibrary('Paths')
		runHaxeCode([[
			
			var color = 0xFFFF0000;
			if(!ClientPrefs.flashing) color = 0x2FFF0000;
			FlxG.camera.flash(color, 0.3, null, true);
			
			new FlxTimer().start(game.dad.animation.curAnim.delay * 28.4, function(tmr:FlxTimer) 
			{
				FlxG.sound.play(Paths.sound('kill'));
				game.defaultCamZoom = 0.8;
				game.camZoomingDecay = 0.55;
				game.cameraSpeed = 0.55;
				game.health = 1;
				
				FlxG.camera.flash(color, 0.1, null, true);
				FlxG.camera.zoom = 0.9 * 1.2 * 1.2;
				game.snapCamFollowToPos(game.dad.getMidpoint().x, game.dad.getMidpoint().y - 100);
				dadC = new Character(0, 0, 'cyan');
				game.startCharacterPos(dadC);
				game.dadGroup.add(dadC);
				game.camFollow.set(dadC.getMidpoint().x + 150, dadC.getMidpoint().y - 100);
				game.camFollow.x += dadC.cameraPosition[0] + game.opponentCameraOffset[0];
				game.camFollow.y += dadC.cameraPosition[1] + game.opponentCameraOffset[1];
				dadC.visible = false;
			});
			
			new FlxTimer().start(game.dad.animation.curAnim.delay * 47.5, function(tmr:FlxTimer) 
			{
				FlxG.sound.play(Paths.sound('b'));
			});
			
			game.dad.animation.finishCallback = function(name)
			{
			
				if(name == 'die')
				{
					game.triggerEventNote('Change Character', 'dad', 'cyan');
					game.dad.playAnim('enter', false);
					game.dad.specialAnim = true;
					FlxG.sound.play(Paths.sound('land'));
					game.dad.animation.finishCallback = function(name)
						{
							game.endSong();
						};
						
					/*new FlxTimer().start(game.dad.animation.curAnim.delay * 9.5, function(tmr:FlxTimer) {
						game.gf.playAnim('transform', false);
						
						new FlxTimer().start(game.gf.animation.curAnim.delay * 10, function(tmr:FlxTimer) 
						{
							FlxG.sound.play(Paths.sound('transform'));
						});
						
						new FlxTimer().start(game.gf.animation.curAnim.delay * 58, function(tmr:FlxTimer) 
						{
							FlxG.sound.play(Paths.sound('pistol'));
						});
						
						
						
					});*/
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 35, function(tmr:FlxTimer) 
					{
						FlxG.sound.play(Paths.sound('d0'));
					});
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 35, function(tmr:FlxTimer) 
					{
						FlxG.sound.play(Paths.sound('d0'));
					});
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 2.5, function(tmr:FlxTimer) 
					{
						game.remove(game.dadGroup, true);
						game.insert(game.members.indexOf(game.getLuaObject('stagefront')) + 1, game.dadGroup);
					});
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 48, function(tmr:FlxTimer) 
					{
						FlxG.sound.play(Paths.sound('d1'));
						
					});
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 16, function(tmr:FlxTimer) 
					{
						FlxG.sound.play(Paths.sound('s0'));
					});
					
					new FlxTimer().start(game.dad.animation.curAnim.delay * 25, function(tmr:FlxTimer) 
					{
						FlxG.sound.play(Paths.sound('s1'));
						FlxTween.tween(game.camHUD, {alpha: 1}, 1);
					});
					
					
				}
			};
					
					]]) -- i mean it works
		cutsceneEnd = true
		return Function_Stop;
	end
	return Function_Continue;
end