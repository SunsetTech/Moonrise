local OOP = require"Moonrise.OOP"

local Vec2D = require"Moonrise.Math.Geometry.Vec2D"

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

function Line:Project(Over)
	return Line(self.Start:Project(Over), self.End:Project(Over))
end

function Line:Closest(To)
	return self.Start:Dist(To) <= self.End:Dist(To) and self.Start or self.End
end

function Line:Furthest(From)
	return self.Start:Dist(From) >= self.End:Dist(From) and self.Start or self.End
end

return Line
