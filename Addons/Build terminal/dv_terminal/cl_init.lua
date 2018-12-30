include("shared.lua")

function ENT:Draw()
	local ply = LocalPlayer()
	self:DrawModel()

	if ply:GetPos():Distance(self:GetPos()) then
		self.CanDraw = true
	else
		self.CanDraw = false
	end
end

function ENT:Initialize()
	-- Setting up the values here.
	self.beingused = nil
	self.spawnable = true
	self.spawnarea = {
		x = 0,
		y = -250,
		z = 0,
		w = 100,
		l = 100,
		h = 50
	}

	-- Displaying the spawn area.
	local function dsa()
		local s = Vector(self.spawnarea.w,self.spawnarea.l,self.spawnarea.h)
		local o = self:GetPos()+Vector(self.spawnarea.x,self.spawnarea.y,self.spawnarea.z)
		local _,c = self:GetModelBounds() local p = (o+Vector(0,0,c[3]/2))+(self:GetForward()*100)
		if #ents.FindInBox(p-s,p+s)>0 then self.spawnable = false else self.spawnable = true end
		if self.spawnable then
			cam.Start3D()
			render.DrawLine(p-s+Vector(0,s[2]*2,0),p+Vector(0,s[2],s[3])-Vector(s[1],0,0),Vector(0,255,0,255))
			render.DrawLine(p-s+Vector(s[1]*2,0,0),p+Vector(s[1],0,s[3])-Vector(0,s[2],0),Vector(0,255,0,255))
			render.DrawLine(p-s,p+Vector(s[1],0,0)-Vector(0,s[2],s[3]),Vector(0,255,0,255))
			render.DrawLine(p-s,p+Vector(0,s[2],0)-Vector(s[1],0,s[3]),Vector(0,255,0,255))
			render.DrawLine(p-s,p+Vector(0,0,s[3])-Vector(s[1],s[2],0),Vector(0,255,0,255))
			render.DrawLine(p-s+Vector(0,0,s[3]*2),p+Vector(s[1],0,s[3])-Vector(0,s[2],0),Vector(0,255,0,255))
			render.DrawLine(p-s+Vector(0,0,s[3]*2),p+Vector(0,s[2],s[3])-Vector(s[1],0,0),Vector(0,255,0,255))
			render.DrawLine(p+s,p-Vector(s[1],0,0)+Vector(0,s[2],s[3]),Vector(0,255,0,255))
			render.DrawLine(p+s,p-Vector(0,s[2],0)+Vector(s[1],0,s[3]),Vector(0,255,0,255))
			render.DrawLine(p+s,p-Vector(0,0,s[3])+Vector(s[1],s[2],0),Vector(0,255,0,255))
			render.DrawLine(p+s-Vector(0,0,s[3]*2),p-Vector(s[1],0,s[3])+Vector(0,s[2],0),Vector(0,255,0,255))
			render.DrawLine(p+s-Vector(0,0,s[3]*2),p-Vector(0,s[2],s[3])+Vector(s[1],0,0),Vector(0,255,0,255))
			cam.End3D()
		else
			cam.Start3D()
			render.DrawLine(p-s+Vector(0,s[2]*2,0),p+Vector(0,s[2],s[3])-Vector(s[1],0,0),Vector(255,0,0,255))
			render.DrawLine(p-s+Vector(s[1]*2,0,0),p+Vector(s[1],0,s[3])-Vector(0,s[2],0),Vector(255,0,0,255))
			render.DrawLine(p-s,p+Vector(s[1],0,0)-Vector(0,s[2],s[3]),Vector(255,0,0,255))
			render.DrawLine(p-s,p+Vector(0,s[2],0)-Vector(s[1],0,s[3]),Vector(255,0,0,255))
			render.DrawLine(p-s,p+Vector(0,0,s[3])-Vector(s[1],s[2],0),Vector(255,0,0,255))
			render.DrawLine(p-s+Vector(0,0,s[3]*2),p+Vector(s[1],0,s[3])-Vector(0,s[2],0),Vector(255,0,0,255))
			render.DrawLine(p-s+Vector(0,0,s[3]*2),p+Vector(0,s[2],s[3])-Vector(s[1],0,0),Vector(255,0,0,255))
			render.DrawLine(p+s,p-Vector(s[1],0,0)+Vector(0,s[2],s[3]),Vector(255,0,0,255))
			render.DrawLine(p+s,p-Vector(0,s[2],0)+Vector(s[1],0,s[3]),Vector(255,0,0,255))
			render.DrawLine(p+s,p-Vector(0,0,s[3])+Vector(s[1],s[2],0),Vector(255,0,0,255))
			render.DrawLine(p+s-Vector(0,0,s[3]*2),p-Vector(s[1],0,s[3])+Vector(0,s[2],0),Vector(255,0,0,255))
			render.DrawLine(p+s-Vector(0,0,s[3]*2),p-Vector(0,s[2],s[3])+Vector(s[1],0,0),Vector(255,0,0,255))
			cam.End3D()
		end
	end
	hook.Add("HUDPaint",tostring(self).."spawnarea",function() dsa() end)
end

function ENT:OnRemove()
	hook.Remove("HUDPaint",tostring(self).."spawnarea")
end