local path = "autorun/dynamicvehicles/"
dynamicvehicles = {}

--include("libs/clienthandle.lua")
    local f,d = file.Find(path.."mods/*","LUA")
    dynamicvehicles.Modifications = {}
    for k,v in pairs(d) do
        include(path.."mods/"..v.."/cl_init.lua")
    end

-- If there is a mods folder search it, if you find something try to run it.
if file.Exists(path.."mods","LUA") then print("is")
    dynamicvehicles.Modifications = {}
    local f,d = file.Find(path.."mods/*","LUA")
    for k,v in pairs(d) do
        if file.Exists(path.."mods/"..v.."/cl_init.lua","LUA") then
            include(path.."mods/"..v.."/cl_init.lua")
        end
    end
end