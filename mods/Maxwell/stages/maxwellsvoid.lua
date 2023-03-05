function onCreate()
	-- background shit
	makeLuaSprite('maxwellsvoid', 'maxwellsvoid', -600, -300);
	setScrollFactor('maxwellsvoid', 0.9, 0.9);
	
	addLuaSprite('maxwellsvoid', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end