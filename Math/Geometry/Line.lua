local OOP = require"Moonrise.OOP"

local Vec2D = require"Moonrise.Math.Geometry.Vec2D"

---@class Moonrise.Math.Geometry.Line
---@operator call:Moonrise.Math.Geometry.Line
---@field Start Moonrise.Math.Geometry.Vec2D
---@field End Moonrise.Math.Geometry.Vec2D
local Line = OOP.Declarator.Shortcuts"Math.Line"

function Line:Initialize(Instance, Start, End)
	Instance.Start = Start
	Instance.End = End
end

---@return number
function Line:Rise()
	return self.End.Y - self.Start.Y
end

---@return number
function Line:Run()
	return self.End.X - self.Start.X
end

---@return number
function Line:Slope()
	return 
		  self:Rise()
		/ self:Run()
end

---@return Moonrise.Math.Geometry.Vec2D
function Line:Midpoint()
	return self.Start:Add(
		 self.End
		:Sub(self.Start)
		:Scale(0.5)
	)
end

---@param With Moonrise.Math.Geometry.Line
---@return Moonrise.Math.Geometry.Vec2D?
function Line:Intersection(With)
	local Determinant = (self.Start.X - self.End.X) * (With.Start.Y - With.End.Y) - (self.Start.Y - self.End.Y) * (With.Start.X - With.End.X)
	if Determinant == 0 then
		return nil
	else
		local A = self.Start.X * self.End.Y - self.Start.Y * self.End.X
		local B = With.Start.X * With.End.Y - With.Start.Y * With.End.X
		local X = (A * (With.Start.X - With.End.X) - (self.Start.X - self.End.X) * B) / Determinant
		local Y = (A * (With.Start.Y - With.End.Y) - (self.Start.Y - self.End.Y) * B) / Determinant
		
		return Vec2D(X, Y)
	end
end

---@param Over Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Line
function Line:Project(Over)
	return Line(self.Start:Project(Over), self.End:Project(Over))
end

---@param To Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Line:Closest(To)
	return self.Start:Dist(To) <= self.End:Dist(To) and self.Start or self.End
end

---@param From Moonrise.Math.Geometry.Vec2D
---@return Moonrise.Math.Geometry.Vec2D
function Line:Furthest(From)
	return self.Start:Dist(From) >= self.End:Dist(From) and self.Start or self.End
end

return Line
