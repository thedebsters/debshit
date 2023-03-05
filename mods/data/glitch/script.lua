local shadname = "error"
function onCreatePost()
	if not shadersEnabled then close() end
	initLuaShader(shadname)
	makeLuaSprite("grapshad")
	setSpriteShader("grapshad", shadname)
end

function onSectionHit()
	if curSection == 16 then
		runHaxeCode([[game.dad.shader = game.getLuaObject("grapshad").shader;]]) 
	elseif curSection == 32 then
		runHaxeCode([[game.dad.shader = null;]]) 
	elseif curSection == 72 then
		runHaxeCode([[game.dad.shader = game.getLuaObject("grapshad").shader;]]) 
	end
end

function onUpdatePost(elapsed)
    setShaderFloat("grapshad", "iTime", getSongPosition())
end
