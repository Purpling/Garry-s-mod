AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	-- Dealing with the model.
	if !self.vip then self:SetModel("models/props_combine/combine_intmonitor001.mdl")
	elseif self.vip then self:SetModel("models/props_combine/combine_monitorbay.mdl")
	else self:SetModel("models/props_combine/combine_interface001.mdl") end

	-- Setting up the normal ent here.
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	-- Build the spawn area here
end

function ENT:OnRemove()
	-- Remove spawn area here
end

function ENT:Think()
	-- Check spawn area clear here
end

function ENT:Use(a,c)
	-- Open the gui for the player here
end