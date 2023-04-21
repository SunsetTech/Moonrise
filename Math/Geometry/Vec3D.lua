local OOP = require"Moonrise.OOP"

local Vec3D = OOP.Declarator.Shortcuts"Math.Vec3D"

function Vec3D:Initialize(Instance, X, Y, Z)
	Instance.X = X or 0
	Instance.Y = Y or 0
	Instance.Z = Z or 0
end

function Vec3D:Add(R)
	return Vec3D(self.X + R.X, self.Y + R.Y, self.Z + R.Z)
end

function Vec3D:Sub(R)
	return Vec3D(self.X - R.X, self.Y - R.Y, self.Z - R.Z)
end

function Vec3D:Scale(S)
	return Vec3D(self.X*S, self.Y*S, self.Z*S)
end

function Vec3D:Dist(To)
	return math.sqrt((To.X-self.X)^2 + (To.Y-self.Y)^2 + (To.Z-self.Z)^2)
end

function Vec3D:Magnitude()
	return self:Dist(Vec3D())
end

--[[function Vec3D:Normalize()
	local Magnitude = self:Magnitude()
	
	return Vec3D(self.X/Magnitude, self.Y/Magnitude)
end]]

function Vec3D:__gc()
	--print"bye?"
	--os.exit()
end

return Vec3D
