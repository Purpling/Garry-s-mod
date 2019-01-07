Installation:

1. Put dynamicvehicles into lua/autorun
2. Create a lua file in lua/autorun
3. Put this in the new lua file:
  if SERVER then include("dynamicvehicles/init.lua") end
  if SERVER then AddCSLuaFile("dynamicvehicles/cl_init.lua") end
  if CLIENT then include("dynamicvehicles/cl_init.lua") end
