local OOP = require"Moonrise.OOP"

local Vec2D = OOP.Declarator.Shortcuts"Math.Vec2D"

function Vec2D:Initialize(Instance, X, Y)
	Instance.X = X or 0
	Instance.Y = Y or 0
end

function Vec2D:Add(R)
	return Vec2D(self.X + R.X, self.Y + R.Y)
end

function Vec2D:Sub(R)
	return Vec2D(self.X - R.X, self.Y - R.Y)
end

function Vec2D:Scale(S)
	return Vec2D(self.X*S, self.Y*S)
end

function Vec2D:Dist(To)
	return math.sqrt((To.X-self.X)^2 + (To.Y-self.Y)^2)
end

function Vec2D:Magnitude()
	return self:Dist(Vec2D())
end

function Vec2D:Normalize()
	local Magnitude = self:Magnitude()
	
	return Vec2D(self.X/Magnitude, self.Y/Magnitude)
end

function Vec2D:__gc()
	print"bye?"
	os.exit()
end

return Vec2D
