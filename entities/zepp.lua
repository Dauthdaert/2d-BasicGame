local ent = ents.Derive("base")



function ent:setPos( x, y)
	self.x = x
	self.y = y
	self.fixed_y = y
	self.ang = 0
	self.falling = false
end
function ent:load( x, y)
	self:setPos( x, y)
	self.image = love.graphics.newImage("textures/zepp.png")
	self.birth = love.timer.getTime() + math.random( 0, 156)
	self.size = math.random( 4, 7)
end

function ent:update(dt)
	self.y = self.fixed_y + math.sin(love.timer.getTime() - self.birth)*(self.size*3)
	self.x = self.x + (self.size*9)*dt

	if (self.x >= 1024) then
		ents.Destroy( self.id )
	end

	if self.falling then
		self.fixed_y = self.fixed_y + 32*dt
		self.ang = self.ang + math.pi*0.025*dt

		if self.y >= 300 then
			startBGExplosion( self.x + 512*(self.size/20), self.y + 128*(self.size/20), 1 )
			self.falling = false
			ents.Destroy( self.id )
		end
	end
end

function ent:Die()
	ents.Create( "zepp", -math.random(128, 256), 128)
end

function ent:Fall()
	self.falling = true
end

function ent:draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	love.graphics.draw( self.image, self.x, self.y, self.ang, self.size/20, self.size/20, 0, 0 )
end

return ent;
