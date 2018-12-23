dynamicvehicles = {}

include("libs/buildhandle.lua")
include("libs/errorhandle.lua")

-- Load all the objects.
dynamicvehicles.Objects = {}
local f,d = file.Find("autorun/dynamicvehicles/objects/*.lua","LUA")
for k,v in pairs(f) do include("objects/"..v) end


-- A vehicle template if you want it.
--[[
hook.Add("InitPostEntity","dynamicvehiclesserverhandle",function()
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
        {Name="baseturret",Pos=Vector(0,2,1)}
    })
    if a==nil then dynamicvehicles.errorhandle.error(c,d,e) end
end)
]]--