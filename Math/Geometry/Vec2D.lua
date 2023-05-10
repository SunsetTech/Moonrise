local OOP = require"Moonrise.OOP"

---@class Moonrise.Math.Geometry.Vec2D
---@operator call:Moonrise.Math.Geometry.Vec2D
---@field public X number
---@field public Y number
local Vec2D = OOP.Declarator.Shortcuts"Math.Vec2D"

---@param Instance Moonrise.Math.Geometry.Vec2D
---@param X number
---@param Y number
function Vec2D:Initialize(Instance, X, Y)
	Instance.X = X or 0
	Instance.Y = Y or 0
end

---@param R Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Vec2D:Add(R)
	return Vec2D(self.X + R.X, self.Y + R.Y)
end

---@param R Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Vec2D:Sub(R)
	return Vec2D(self.X - R.X, self.Y - R.Y)
end

---@param S Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Vec2D:Scale(S)
	return Vec2D(self.X*S, self.Y*S)
end

---@param To Moonrise.Math.Geometry.Vec2D
---@return number
function Vec2D:Dist(To)
	return math.sqrt((To.X-self.X)^2 + (To.Y-self.Y)^2)
end

---@param Over Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Vec2D:Project(Over)
	return Over:Add(Over:Sub(self))
end

---@return number
function Vec2D:Magnitude()
	return self:Dist(Vec2D())
end

---@return Moonrise.Math.Geometry.Vec2D
function Vec2D:Normalize()
	local Magnitude = self:Magnitude()
	
	return Vec2D(self.X/Magnitude, self.Y/Magnitude)
end

return Vec2D
