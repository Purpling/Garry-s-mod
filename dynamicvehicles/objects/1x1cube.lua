--[[
    Author: Zephri
    SteamId64: 76561198068611817
]]--
local File = "1x1cube" -- Name of the file.
local Name = "1x1 Cube" -- Name of the object.
local Type = "block" -- Type of the object.
local Health = 500 -- Health of the object.
local Model = "models/hunter/blocks/cube05x05x05.mdl" -- Model of the object.

dynamicvehicles.Object[File] = {name=Name,type=Type,health=Health,model=Model}
dynamicvehicles.Objects[File] = function(entity,info)
    entity.type = Type
    entity.health = Health
    entity:SetModel(Model)
    entity:PhysicsInit(SOLID_VPHYSICS)
end