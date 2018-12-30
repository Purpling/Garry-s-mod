dynamicvehicles.buildhandle = {}
local filepath = "dynamicvehicles/buildhandle" -- Error handling.


-- Function to cleanup an errored vehicle.
function dynamicvehicles.buildhandle.cleanup(vehicle)
    -- Run through the vehicle and delete it.
    for k,v in pairs(vehicle) do
        if type(v)=="entity" then v:Remove() else
            -- If it's not an entity kick an error and move on.
            dynamicvehicles.errorhandle.error(1,"Not an entity.",filepath..":cleanup")
        end
    end
end

-- Function to setup a new vehicle.
function dynamicvehicles.buildhandle.setup(vehicle,blueprint)
    -- Setup each entity of the vehicle.
    for k,v in pairs(vehicle) do
        if dynamicvehicles.Objects[blueprint[k].Name]!=nil then
            -- Run the object on the entity.
            local tbl = dynamicvehicles.Objects[blueprint[k].Name](v,blueprint[k])
            if type(tbl)=="Vehicle" then vehicle[k] = tbl tbl = {} end
            -- If it returns data then act on it.
            for n,i in pairs(tbl||{}) do
                if i[1]=="weld" then

                end
                if i[1]=="axis" then
                    if #i[2]==10 then
                        for c,e in pairs(vehicle) do
                            local pos = e:GetPos()
                            local pass = false
                            if i[2][1]=="x" then pos[1] = i[2][2]:GetPos()[1] if pos==i[2][2]:GetPos() then pass = true end end
                            if i[2][1]=="y" then pos[2] = i[2][2]:GetPos()[2] if pos==i[2][2]:GetPos() then pass = true end end
                            if i[2][1]=="z" then pos[3] = i[2][2]:GetPos()[3] if pos==i[2][2]:GetPos() then pass = true end end
                            if pass then constraint.Axis(e,i[2][2],i[2][3],i[2][4],i[2][5],i[2][6],i[2][7],i[2][8],i[2][9],i[2][10]) end
                        end
                        local po = i[2][2]:GetPhysicsObject()
                        if po:IsValid() then po:EnableMotion(true) po:Wake() end
                    else dynamicvehicles.errorhandle.error(2,"{Axis} Function requires 10, it's getting "..#i[2],filepath..":setup") end
                end
            end
        else
            -- If the object does not exist, cleanup and error out.
            dynamicvehicles.buildhandle.cleanup(vehicle)
            return false,4,"Object not found.",filepath..":setup"
        end
    end
    return true
end

-- Function to build from blueprint.
function dynamicvehicles.buildhandle.build(blueprint,offset,rotation)
    offset = offset||Vector(0,0,0) rotation = rotation||Angle(0,0,0) -- Optional values.
    local vehicle = {} -- The entity version of the blueprint.
    local level,error,path = 0,"","" -- Error handling.

    for k,v in pairs(blueprint) do
        -- Spawn the entity, adding it to the vehicle table.
        vehicle[k] = ents.Create("prop_physics")
        vehicle[k]:SetPos(offset+v.Pos*24)
        vehicle[k]:SetModel("models/hunter/blocks/cube025x025x025.mdl")
        vehicle[k]:Spawn()

        -- Freeze the entity for setup.
        local po = vehicle[k]:GetPhysicsObject()
        if po:IsValid() then po:EnableMotion(false) else
            -- If the entity can't be frozen, cleanup and error out.
            dynamicvehicles.buildhandle.cleanup(vehicle)
            return nil,blueprint,4,"Entity is nil.",filepath..":build;1"
        end
    end
    
    local t = true -- Error handling.
    -- Setup the vehicle.
    t,level,error,path = dynamicvehicles.buildhandle.setup(vehicle,blueprint)
    if !t then return nil,blueprint,level,error,path end -- If the setup errored out copy it.

    -- Vehicle is done so now we add the core.
    vehicle[0] = ents.Create("prop_physics")
    vehicle[0]:SetPos(offset)
    vehicle[0]:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    vehicle[0]:SetColor(Color(0,0,0,0))
    vehicle[0]:Spawn()
    vehicle[0].vehicle = vehicle
    vehicle[0].blueprint = blueprint
	vehicle[0]:SetSolid(SOLID_NONE)
    vehicle[0]:SetRenderMode(RENDERMODE_TRANSALPHA)
    -- Freeze the entity for attaching.
    local po = vehicle[0]:GetPhysicsObject()
    if po:IsValid() then po:EnableMotion(false) else
        -- If the entity can't be frozen, cleanup and error out.
        dynamicvehicles.buildhandle.cleanup(vehicle)
        return nil,blueprint,4,"Entity is nil.",filepath..":build;2"
    end

    -- When the vehicle exists attach everything and unfreeze.
    if #vehicle>1 then
        for k,v in pairs(vehicle) do
            for n,i in pairs(vehicle) do
                if i!=v then
                    constraint.Weld(v,i,0,0,0,false,false)
                    if k>0&&n>0 then constraint.NoCollide(v,i,0,0) end
                end
            end
        end
    end
    for k,v in pairs(vehicle) do
        local po = v:GetPhysicsObject()
        if po:IsValid() then po:EnableMotion(true) po:Wake() else
            -- If the entity can't be unfrozen, cleanup and error out.
            dynamicvehicles.buildhandle.cleanup(vehicle)
            return nil,blueprint,4,"Entity is nil.",filepath..":build;3"
        end
    end

    -- When the vehicle is done return the data.
    return vehicle,blueprint
end