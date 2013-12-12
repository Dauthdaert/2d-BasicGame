function love.load()
	require("entities")
	require("explosion")
	--require("highscore")
	ents.startup()
	love.graphics.setBackgroundColor(0,0,0)
	savedir = love.filesystem.getSaveDirectory()
	print("" .. savedir .. "")
	counter = 0
	counterLimit = 30
	love.mouse.setVisible(false)
	Cloud = love.graphics.newImage("textures/cloud.png")
	Horizon = love.graphics.newImage("textures/ground.png")
	Enemy1 = love.graphics.newImage("textures/enemy1.png")
	Enemy2 = love.graphics.newImage("textures/enemy2.png")
	height = love.graphics.getHeight()
	width = love.graphics.getWidth()
	CloudX = 0 - 70
	for i = 1, 3 do
		ents.Create( "zepp", -math.random(128, 256), 128, true)
	end
	print("The game has started")
end
function love.focus(f)--used for auto pause
	if not f then
		print("Focus Lost")
	else
		print("Focus Gained")
	end
	gameIsPaused = not f
end
function love.update(dt)
	if gameIsPaused then return end--autopause
	height = love.graphics.getHeight()--dynamic texture changes
	width = love.graphics.getWidth()--dynamic texture changes
	CloudX = CloudX + width / 25 * dt--cloud speed
	if CloudX >= width + 135 then--cloud bounding
		CloudX = 0 - 73
	end
	counter = counter + dt
	if counter >= counterLimit then
		print("done")
		counter = 0
	end
	updateBGExplosions(dt)
	ents:update(dt)--entitie updates
	love.timer.sleep(0.02)--free up cpu
end
function love.draw()
	--Sky
	love.graphics.setColor( 88, 214, 220)
	love.graphics.rectangle("fill", 0, 0, width, height / 2)

	--Cloud
	love.graphics.setColor( 215, 215, 215)
	love.graphics.draw(Cloud, CloudX - 133, height / 7, 0, 1, 1, 0, 0)
	--Explosion
	drawBGExplosions()
	ents:drawBG()
	--Entite drawing
	ents.draw()
	--Land
	love.graphics.setColor( 22, 103, 29)
	love.graphics.rectangle("fill", 0, height / 2, width, height / 2)
	love.graphics.setColor( 255, 255, 255, 255)
	love.graphics.draw( Horizon, (800-1024)/2, height / 2 - 60, 0, 1, 1, 0, 0)
	--GunCrosshair
	local mouseX = love.mouse.getX()
	local mouseY = love.mouse.getY()
	love.graphics.setColor(56, 56, 56)
	love.graphics.circle("line", mouseX, mouseY, 60, 100)
	love.graphics.circle("line", mouseX, mouseY, 30, 100)
	love.graphics.circle("fill",mouseX, mouseY, 5, 100)
	love.graphics.line( mouseX, mouseY - 65, mouseX, mouseY +65)
	love.graphics.line(mouseX - 65, mouseY, mouseX + 65, mouseY)
end

function love.mousepressed( x, y, button)
	if button == "l" then--shooting
		ents.shoot( x, y)
	end
end

function insideBox( px, py, x, y, wx, wy)--bounding box function
	if px > x and px < x + wx then
		if py > y and py < y + wy then
			return true
		end
	end
	return false
end



function love.quit()
	--highscoresave()
	print("Thanks for playing, hope you had fun!")
end
