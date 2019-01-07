--[[
    Author: Zephri
    Steam: 76561198068611817
]]--

-- Change these values as you want.
hashsystem = {} -- Hold everything.
hashsystem.handle = {} -- Stores call functions.
local hashdatabase = {} -- Stores active hashes.
local hashlevel = 1000 -- Bigger the number more secure the hashes.
local hashseed = tostring(math.Round(math.random(0,hashlevel))) -- Seed for the hashes.
local lasthash = 0 -- Number used for last hash, gets more secure bigger the number.

--[[
    No need to change anything below.
]]--

-- Give a file it's own hash.
function hashsystem.generate(file)
    -- Return if the file will error.
    if type(file)!="string" then return nil,"File name is not a string." end
    if file=="" then return nil,"File name field is blank." end
    if hashdatabase[file]!=nil then return nil,"File hash already exists." end
    -- Generate the new hash, store it and return it, then update lasthash.
    local newhash = tostring(math.Round(util.SharedRandom(hashseed,0,hashlevel,lasthash),5))
    lasthash = math.Round(util.SharedRandom(newhash,0,hashlevel,lasthash))
    hashdatabase[file] = newhash
    return newhash
end

-- Relay data from one file to another.
function hashsystem.relay(hash,file,dest,data)
    -- Return if the file will error.
    if type(hash)!="string" then return nil,"Hash is not a string." end
    if hash=="" then return nil,"Hash field is blank." end
    if type(file)!="string" then return nil,"File name is not a string." end
    if file=="" then return nil,"File name field is blank." end
    if type(dest)!="string" then return nil,"Dest name is not a string." end
    if dest=="" then return nil,"Dest name field is blank." end
    if hashdatabase[dest]==nil then return false,"Dest hash doesn't exists." end
    if hashsystem.handle[dest]==nil then return false,"Dest can't handle." end
    if hashdatabase[file]!=hash then return false,"File hash wrong." end
    -- Run the dest handle call.
    return true,hashsystem.handle[dest](file,data)
end

-- Client only functions.
if CLIENT then

-- Sends data to the server a relays.
function hashsystem.transmit(hash,file,dest,data)
    -- Return if the file will error.
    if type(hash)!="string" then return nil,"Hash is not a string." end
    if hash=="" then return nil,"Hash field is blank." end
    if type(file)!="string" then return nil,"File name is not a string." end
    if file=="" then return nil,"File name field is blank." end
    if type(dest)!="string" then return nil,"Dest name is not a string." end
    if dest=="" then return nil,"Dest name field is blank." end
    if hashdatabase[dest]==nil then return false,"Dest hash doesn't exists." end
    if hashsystem.handle[dest]==nil then return false,"Dest can't handle." end
    if hashdatabase[file]!=hash then return false,"File hash wrong." end
    -- Run the dest handle call.
    net.Start("hashsystemserverreceive")
    net.WriteString(file)
    net.WriteString(dest)
    net.WriteTable({data})
    net.SendToServer()
    return true,"HASHVALUEHERE"
end

-- Gets data from the server and handles it.
net.Receive("hashsystemclientreceive",function()
    local file = net.ReadString()
    local dest = net.ReadString()
    local data = net.ReadTable()
    hashsystem.handle[dest](file,data[1])
end)

end

-- Tell everyone on client it's done.
-- Functions past here need server permissions.
if CLIENT then hook.Run("hashsystemloaded",nil) return end

-- Sends data to the client a relays.
function hashsystem.transmit(ply,hash,file,dest,data)
    -- Server only check, because error handling.
    if type(ply)=="Player"||type(ply)=="Entity" then if !ply:IsPlayer()||!ply:IsValid() then return nil,"Ply is an invalid player." end
    elseif type(ply)=="string" then if ply!="*" then return nil,"Ply is not understood, try sending '*'." end end
    -- Return if the file will error.
    if type(hash)!="string" then return nil,"Hash is not a string." end
    if hash=="" then return nil,"Hash field is blank." end
    if type(file)!="string" then return nil,"File name is not a string." end
    if file=="" then return nil,"File name field is blank." end
    if type(dest)!="string" then return nil,"Dest name is not a string." end
    if dest=="" then return nil,"Dest name field is blank." end
    if hashdatabase[dest]==nil then return false,"Dest hash doesn't exists." end
    if hashsystem.handle[dest]==nil then return false,"Dest can't handle." end
    if hashdatabase[file]!=hash then return false,"File hash wrong." end
    -- Run the dest handle call.
    net.Start("hashsystemclientreceive")
    net.WriteString(file)
    net.WriteString(dest)
    net.WriteTable({data})
    if ply!="*" then net.Send(ply) else net.Broadcast() end
    return true,"HASHVALUEHERE"
end

-- Gets data from the client and handles it.
net.Receive("hashsystemserverreceive",function()
    local file = net.ReadString()
    local dest = net.ReadString()
    local data = net.ReadTable()
    hashsystem.handle[dest](file,data[1])
end)
util.AddNetworkString("hashsystemserverreceive")
util.AddNetworkString("hashsystemclientreceive")

-- Tell everyone on server it's done.
hook.Run("hashsystemloaded",nil)