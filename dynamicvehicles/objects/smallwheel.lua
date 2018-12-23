--[[
    Author: Zephri
    SteamId64: 76561198068611817
]]--
local File = "smallwheel" -- Name of the file.
local Name = "Small wheel" -- Name of the object.
local Model = "models/hunter/blocks/cube025x025x025.mdl" -- Model of the object.

dynamicvehicles.Objects[File] = function(entity,info)
    entity:SetModel(Model)
    entity:PhysicsInit(SOLID_VPHYSICS)
    
    local Pos = -3.5
    if info.Rot[1]==180||info.Rot[1]==270 then Pos = 3.5 end
    local Rot = info.Rot||Angle(0,0,0)

    local prop = ents.Create("prop_physics")
    prop:SetPos(entity:GetPos()+Vector(Pos,0,0))
    prop:SetAngles(Angle(90,0,0)+Rot)
    prop:SetModel("models/props_phx/wheels/metal_wheel1.mdl")
    prop:Spawn()
    local po = prop:GetPhysicsObject()
    if po:IsValid() then po:EnableMotion(false) end
    constraint.NoCollide(entity,prop,0,0)

    function entity:OnRemove() if prop:IsValid() then prop:Remove() end end

    return {{"axis",{"x",prop,0,0,Vector(90,0,0),Vector(0,0,0),0,0,0,0}}}
end