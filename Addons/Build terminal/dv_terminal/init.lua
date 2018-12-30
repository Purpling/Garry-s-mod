AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local Self = nil
function ENT:Initialize() Self = self
	-- Dealing with the model.
	if !self.vip then self:SetModel("models/props_combine/combine_intmonitor001.mdl")
	elseif self.vip then self:SetModel("models/props_combine/combine_monitorbay.mdl")
	else self:SetModel("models/props_combine/combine_interface001.mdl") end

	-- Setting up the normal ent here.
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	-- Setting up the values here.
	self.beingused = nil
	self.spawnarea = {
		x = 0,
		y = -250,
		z = 0,
		w = 100,
		l = 100,
		h = 50
	}
end

util.AddNetworkString("spawnterminalmenuopen")
function ENT:Use(a,c)
	if self.beingused==nil then
		self.beingused = c
		net.Start("spawnterminalmenuopen")
		net.Send(c)
	end
end
util.AddNetworkString("spawnterminalmenuclosed") local spawned = true
net.Receive("spawnterminalmenuclosed",function() Self.beingused = nil
	if spawned then spawned = false
		local o = Self:GetPos()+Vector(Self.spawnarea.x,Self.spawnarea.y,Self.spawnarea.z)
		local _,c = Self:GetModelBounds() local p = (o+Vector(0,0,c[3]/2))+(Self:GetForward()*100)
		local a,b,c,d,e = dynamicvehicles.buildhandle.build({
        {Name="1x1cube",Pos=Vector(-1,0,0)},
        {Name="1x1cube",Pos=Vector(0,0,0)},
        {Name="1x1cube",Pos=Vector(1,0,0)},
        {Name="1x1cube",Pos=Vector(-1,1,0)},
        {Name="1x1cube",Pos=Vector(0,1,0)},
        {Name="1x1cube",Pos=Vector(1,1,0)},
        {Name="1x1cube",Pos=Vector(-1,2,0)},
        {Name="1x1cube",Pos=Vector(0,2,0)},
        {Name="1x1cube",Pos=Vector(1,2,0)},
        {Name="1x1cube",Pos=Vector(-1,3,0)},
        {Name="1x1cube",Pos=Vector(0,3,0)},
        {Name="1x1cube",Pos=Vector(1,3,0)},
        {Name="1x1cube",Pos=Vector(-1,4,0)},
        {Name="1x1cube",Pos=Vector(0,4,0)},
        {Name="1x1cube",Pos=Vector(1,4,0)},
        {Name="smallwheel",Pos=Vector(-2,0,0),Rot=Angle(0,0,0)},
        {Name="smallwheel",Pos=Vector(2,0,0),Rot=Angle(180,0,0)},
        {Name="smallwheel",Pos=Vector(-2,4,0),Rot=Angle(0,0,0)},
        {Name="smallwheel",Pos=Vector(2,4,0),Rot=Angle(180,0,0)},
        {Name="baseturret",Pos=Vector(1,3,1)},
        {Name="baseturret",Pos=Vector(-1,3,1)},
        {Name="pilotseat",Pos=Vector(0,1,1)}
    },p) print("Built vehicle with "..#a.." objects.")
if a==nil then dynamicvehicles.errorhandle.error(c,d,e) end end end)