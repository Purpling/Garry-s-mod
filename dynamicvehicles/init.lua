local path = "autorun/dynamicvehicles/"

-- Allowing for early error handling.
if file.Exists(path.."libs/errorhandle.lua","LUA") then
    dynamicvehicles = {} include("libs/errorhandle.lua")
end

-- Check core files/folders exist.
local list = {"libs","objects","libs/buildhandle.lua","libs/buildhandle.lua"}
for k,v in pairs(list) do local halt = false
    if !file.Exists(path..v,"LUA") then
        if dynamicvehicles!=nil&&dynamicvehicles.errorhandle!=nil then
            dynamicvehicles.errorhandle.error(4,v.." does not exist!","!Core!")
        end
        halt = true
    end
end if halt then return nil end
dynamicvehicles = {}

-- Load the librarys.
include(path.."libs/buildhandle.lua")
include(path.."libs/errorhandle.lua")

-- Load all the objects.
dynamicvehicles.Objects = {}
local f,d = file.Find(path.."objects/*.lua","LUA")
for k,v in pairs(f) do include(path.."objects/"..v) end

-- If there is a mods folder search it, if you find something try to run it.
if file.Exists(path.."mods","LUA") then
    f,d = file.Find(path.."mods/*.lua","LUA")
    for k,v in pairs(d) do
        if file.Exists(path.."mods/"..v.."/init.lua","LUA") then
            include(path.."mods/"..v.."/init.lua")
        end
    end
end


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