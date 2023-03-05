function onCreatePost()
	addHaxeLibrary('StoryMenuState')
	playAnim('boppers', 'dead', false)
	setProperty('boppers.offset.x', 200)
	setProperty('boppers.offset.y', 115)
	setProperty('defaultCamZoom', 0.8)
	setProperty('camZoomingMult', 1.2)
	setProperty('camZoomingDecay', 1.6)
	runHaxeCode([[
	
	FlxG.camera.zoom = 0.8;
	game.snapCamFollowToPos(game.dad.getMidpoint().x + 150 + game.dad.cameraPosition[0] + game.opponentCameraOffset[0], game.dad.getMidpoint().y - 100 + game.dad.cameraPosition[1] + game.opponentCameraOffset[1]);
	
	game.remove(game.dadGroup, true);
	game.insert(game.members.indexOf(game.getLuaObject('stagefront')) + 1, game.dadGroup);
				]])
	--setObjectOrder('dadGroup', getObjectOrder('stagefront'))
end

function opponentNoteHit(id, dir, nt, sus)
	if getPropertyFromGroup('notes', id, 'gfNote') then
		setPropertyFromGroup('opponentStrums', dir, 'colorSwap.hue', getPropertyFromGroup('notes', id, 'colorSwap.hue'))
		
	end
end


function onSpawnNote(id, dir, nt, sus)
	if getPropertyFromGroup('notes', id, 'gfNote') then
		runHaxeCode([[
			game.notes.members[]]..id..[[].colorSwap.hue += 0.055;
					]])
	end
end

function onBeatHit()
	if curSection >= 119 then
		setProperty('iconP1.scale.x', 1)
		setProperty('iconP1.scale.y', 1)
		setProperty('iconP2.scale.x', 1)
		setProperty('iconP2.scale.y', 1)
	end
end

function onSectionHit()
	if curSection == 33 then
		setTextString('botplayTxt', 'sus')
	elseif curSection == 34 then
		setTextString('botplayTxt', 'BOTPLAY')
		setProperty('camZoomingDecay', 1.5)
	elseif curSection == 76 then
		setProperty('camZooming', false)
		setProperty('cameraSpeed', 0)
		setProperty('camZoomingDecay', 0)
		setProperty('camZoomingMult', 1.5)
		runHaxeCode([[
		
			game.gf.playAnim('transform', false);
			game.gf.specialAnim = true;
			
			new FlxTimer().start(game.gf.animation.curAnim.delay * 10, function(tmr:FlxTimer) 
			{
				FlxG.sound.play(Paths.sound('transform'), 0.3);
			});
			
			new FlxTimer().start(game.gf.animation.curAnim.delay * 58, function(tmr:FlxTimer) 
			{
				FlxG.sound.play(Paths.sound('pistol'), 0.3);
			});
			
			game.gf.animation.finishCallback = function(name)
			{
				game.gf.idleSuffix = '-alt';
				game.gf.recalculateDanceIdle();
				game.camZoomingDecay = 1.1;
				game.camZoomingMult = 2;
				game.defaultCamZoom = 0.8;
				game.cameraSpeed = 1;
				game.girlfriendCameraOffset[0] += 30;
				game.boyfriendCameraOffset[0] -= 50;
				game.opponentCameraOffset[0] += 50;
				game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
				game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
				game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
				game.iconP2.changeIcon('cyand');
				game.gf.animation.finishCallback = null;
			};
												
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.crochet / 1000) * 4, {ease: FlxEase.quadOut});
						
			FlxTween.tween(game.camFollowPos, {x: (game.gf.getMidpoint().x + game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0]), y: (game.gf.getMidpoint().y - 20 + game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1])}, (Conductor.crochet / 1000) * 4, {ease: FlxEase.cubeOut});
		
					]])
		doTweenZoom('heheC', 'camHUD', 1.5, (crochet / 1000) * 4, 'quadOut')
	elseif curSection == 119 then
		runHaxeCode([[
		
			game.girlfriendCameraOffset[0] -= 30;
			
			game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
			game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
			game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
			
					]])
		setProperty('defaultCamZoom', 0.6)
		setProperty('camZoomingMult', 0)
		setProperty('gf.stunned', true)
		setProperty('dad.stunned', true)
		setProperty('boyfriend.danceEveryNumBeats', 500)
	end
end

local lol = false
function onEndSong()
	if not lol then

		makeLuaSprite('blackScreen', nil, -500, -300)
		makeGraphic('blackScreen', screenWidth * 2, screenHeight * 2, '000000')
		setScrollFactor('blackScreen', 0, 0)
		setProperty('camHUD.visible', false)
		addLuaSprite('blackScreen', true)
		removeLuaSprite('stagefront', true)
		removeLuaSprite('boppers', true)
		triggerEvent("Change Character", "boyfriend", "bf-lol")
		setObjectOrder('blackScreen', 29)
		setObjectOrder("boyfriend", 30)
		setProperty('cameraSpeed', 0)
		runHaxeCode([[
			game.remove(game.dadGroup, true);
			game.boyfriend.playAnim('idle', false);
			FlxG.camera.alpha = 1;
			FlxG.camera.visible = true;
			FlxG.sound.play(Paths.sound('kill'), 1);
			game.boyfriend.animation.finishCallback = function(name)
				{
					game.endSong();
				};
					]])
		lol = true
		return Function_Stop;
	end
	if getProperty('compaignMisses') <= 0 and isStoryMode then
		runHaxeCode([[
			StoryMenuState.weekCompleted.set('FCskeld', true);
			
			FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
			FlxG.save.flush();
					]])
	end
	return Function_Continue;
end

function onStepHit()
	if curStep == 1935 or curStep == 1943 or curStep == 1950 or curStep == 1958 then
		runHaxeCode([[
			
			FlxG.camera.alpha -= 0.3;
			game.camHUD.alpha -= 0.3;
			
					]])
	end
end