local chance = 0
local num = 0
local hitCount = 1
function onCreate()
	num = getRandomFloat(0.1, 2) -- sometimes he'll be a god, sometimes he'll be shite
end

function opponentNoteHit(id, dir, nt, sus)
	if not sus then
		hitCount = hitCount + 0.1
		chance = chance + 1 * hitCount
		runTimer('rechance', (crochet / 1000) / (chance * num), 1)
	end
end

function onTimerCompleted(t)
	if t == 'rechance' then
		chance = 0
	end
end

function onUpdatePost(elapsed)
	for a = 0, getProperty('notes.length') - 1 do
		local nD = getPropertyFromGroup('notes', a, 'noteData')
		local sT = getPropertyFromGroup('notes', a, 'strumTime')
		local mP = getPropertyFromGroup('notes', a, 'mustPress')
		local sus = getPropertyFromGroup('notes', a, 'isSustainNote')
		local aS = getPropertyFromGroup('notes', a, 'animSuffix')
		local GF = getPropertyFromGroup('notes', a, 'gfNote')
		if not mP and not sus and (sT - getSongPosition()) / getProperty('songSpeed') < 1 and getPropertyFromGroup('notes', a, 'active') and getPropertyFromGroup('notes', i, 'sustainLength') <= 0 and (not GF and getProperty('dad.hasMissAnimations') or getProperty('gf.hasMissAnimations')) and getRandomBool(chance) then
			setPropertyFromGroup('notes', a, 'ignoreNote', true)
			setPropertyFromGroup('notes', a, 'active', false)
			setProperty('vocals.volume', 0)
			hitCount = 1
			local char = not GF and 'dad' or 'gf'
			playAnim(char, getProperty('singAnimations['..nD..']')..'miss'..aS)
			setProperty(char..'.specialAnim', true)
			runHaxeCode([[

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			strum = game.opponentStrums.members[]]..nD..[[];
			strum.playAnim('pressed');
			strum.resetAnim = 0.15;

						]])
		end
	end
end