dynamicvehicles.healthhandle = {}
local filepath = "dynamicvehicles/healthhandle" -- Error handling.


-- To be called by a vehicle to check its state.
function dynamicvehicles.healthhandle.check(vehicle,blueprint)
    local health,state = 0,0
    -- Run through the vehicle and check each part.
    for k,v in pairs(blueprint) do
        if vehicle[k]!=nil then
            if vehicle[k].health!=nil then
                state = state + vehicle[k].health
                health = health + dynamicvehicles.Object[v.Name].health
            end
        end
    end
    -- Return the state of the vehicle.
    return (100/health)*state
end

-- To be called by a turret to hit something.
function dynamicvehicles.healthhandle.shoot(vehicle,turret)
    if type(vehicle.vehicle[turret])!="Entity" then return nil,3,"Not an entity.",filepath..":shoot" end
    -- Create the trace data.
    local trace = {}
    trace.start = vehicle.vehicle[turret].turret:GetPos()
    trace.endpos = vehicle.vehicle[turret].turret:GetPos()+(vehicle.vehicle[turret].turret:GetForward()*dynamicvehicles.Object[vehicle.blueprint[turret].Name].range)
    trace.filter = {vehicle.vehicle[turret].turret}
    for k,v in pairs(vehicle.vehicle) do
        trace.filter[#trace.filter+1] = v
    end
    trace.mask = MASK_SHOT_HULL

    -- Run the trace and check it.
    local tr = util.TraceLine(trace)
    if tr.Entity==nil then return nil,1,"No entity hit with trace.",filepath..":shoot" end
    if tr.Entity.health==nil then return nil,2,"Entity doesn't have health.",filepath..":shoot" end
    tr.Entity.health = tr.Entity.health - dynamicvehicles.Object[vehicle.blueprint[turret].Name].damage
    if tr.Entity.health<1 then tr.Entity:Remove() end
    return tr.Entity
end