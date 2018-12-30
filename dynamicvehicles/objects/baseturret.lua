--[[
    Author: Zephri
    SteamId64: 76561198068611817
]]--
local File = "baseturret" -- Name of the file.
local Name = "Base turret" -- Name of the object.
local Type = "turret" -- Type of the object.
local Health = 250 -- Health of the object.
local Range = 10000 -- Range of the object.
local Damage = 100 -- Damage of the object.
local Model = "models/hunter/blocks/cube05x05x025.mdl" -- Model of the object.

dynamicvehicles.Object[File] = {name=Name,type=Type,health=Health,model=Model,range=Range,damage=Damage}
dynamicvehicles.Objects[File] = function(entity,info)
    entity.type = Type
    entity.health = Health
    entity:SetModel(Model)
    entity:PhysicsInit(SOLID_VPHYSICS)
    entity:SetPos(entity:GetPos()+Vector(0,0,-6))

    local prop = ents.Create("prop_physics")
    prop:SetPos(entity:GetPos()+Vector(0,0,3))
    prop:SetAngles(Angle(180,-90,0))
    prop:SetModel("models/combine_turrets/ground_turret.mdl")
    prop:Spawn() entity.turret = prop
	prop:SetMoveType(MOVETYPE_NONE)
	prop:SetSolid(SOLID_NONE)

    local lazer = ents.Create("prop_physics")
    lazer:SetPos(prop:GetPos()+Vector(1.25,41,18))
    lazer:SetAngles(prop:GetAngles()+Angle(180,0,0))
    lazer:SetModel("models/props_junk/harpoon002a.mdl")
    lazer:SetMaterial("models/props_combine/portalball001_sheet.mdl")
    lazer:SetColor(Color(255,0,0))
    lazer:Spawn()
	lazer:SetMoveType(MOVETYPE_NONE)
    lazer:SetSolid(SOLID_NONE)
    lazer:SetParent(prop)
    
    

    hook.Add("Think",tostring(prop),function()
        if entity:IsValid()&&prop:IsValid() then
            prop:SetPos(entity:GetPos()+Vector(0,0,3))
            local ang = entity:GetAngles()
            prop:SetAngles(Angle(ang[3],ang[2],ang[1])+Angle(180,-90,0))
        end
        if !entity:IsValid() then
            if prop:IsValid() then prop:Remove() end
            if lazer:IsValid() then lazer:Remove() end
            if !prop:IsValid()&&!lazer:IsValid() then
                hook.Remove("Think",tostring(prop))
            end
        end
    end)
end