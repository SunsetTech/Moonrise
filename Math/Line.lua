local Module = require"Moonrise.Import.Module"
local OOP = require"Moonrise.OOP"

local Vec2D = Module.Sister"Vec2D"

local Line = OOP.Declarator.Shortcuts"Math.Line"

function Line:Initialize(Instance, Start, End)
	Instance.Start = Start
	Instance.End = End
end

function Line:Rise()
	return self.End.Y - self.Start.Y
end

function Line:Run()
	return self.End.X - self.Start.X
end

function Line:Slope()
	return 
		  self:Rise()
		/ self:Run()
end

function Line:Midpoint()
	return self.Start:Add(
		 self.End
		:Sub(self.Start)
		:Scale(0.5)
	)
end

function Line:Intersection(With)
	local Determinant = (self.Start.X - self.End.X) * (With.Start.Y - With.End.Y) - (self.Start.Y - self.End.Y) * (With.Start.X - With.End.X)
	local A = self.Start.X * self.End.Y - self.Start.Y * self.End.X
	local B = With.Start.X * With.End.Y - With.Start.Y * With.End.X
	local X = (A * (With.Start.X - With.End.X) - (self.Start.X - self.End.X) * B) / Determinant
	local Y = (A * (With.Start.Y - With.End.Y) - (self.Start.Y - self.End.Y) * B) / Determinant
	
	return Vec2D(X, Y)
end

return Line
