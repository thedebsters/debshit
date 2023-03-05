function onBeatHit()
doTweenY('icons', 'iconP2', getProperty('iconP2.y') - 10, crochet*0.00045, 'circOut')
if curBeat %2 == 0 then
setProperty('iconP2.flipX', true)
else
setProperty('iconP2.flipX', false)
end
end
function onTweenCompleted(tag)
if tag == 'icons' then
doTweenY('icons2', 'iconP2', getProperty('iconP1.y'), crochet*0.00045, 'circIn')
end
end 