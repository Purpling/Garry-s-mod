--[[
    Author: Zephri
    SteamId64: 76561198068611817
]]--
local File = "pilotseat" -- Name of the file.
local Name = "Pilot Seat" -- Name of the object.
local Type = "seat" -- Type of the object.
local Health = 1000 -- Health of the object.
local Model = "models/nova/airboat_seat.mdl" -- Model of the object.

dynamicvehicles.Object[File] = {name=Name,type=Type,health=Health,model=Model}
dynamicvehicles.Objects[File] = function(entity,info)
    entity.type = Type
    entity.health = Health
    entity:SetPos(entity:GetPos()+Vector(0,0,-12))

    local prop = ents.Create("prop_vehicle_prisoner_pod")
    prop:SetModel(Model)
    prop:SetPos(entity:GetPos())
    prop:SetAngles(entity:GetAngles())
    prop:Spawn() prop:Activate()
    local po = prop:GetPhysicsObject()
    if po:IsValid() then po:EnableMotion(false) end
    
    entity:Remove()
    return prop
end