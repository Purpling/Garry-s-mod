netfix = {}
netfix.packages = {}
netfix.callids = {}
netfix.responses = {}
netfix.callbacks = {}

if SERVER then util.AddNetworkString("netfixreport") end

-- Used to catch reports to server.
net.Receive("netfixreport",function(a,b)
    local c,x,z = net.ReadString(),{},{}
    
    -- Decode the data for use.
    for d,e in pairs(string.Explode(";",net.ReadString())) do
        if x[d]==nil then x[d] = {} end
        for f,g in pairs(string.Explode(",",e)) do
            x[d][f] = g
        end
    end
    for d,e in pairs(string.Explode(";",c)) do
        z[d] = {} if e!="" then
            for f,g in pairs(string.Explode("",e)) do
                if g=="0" then
                    z[d][f] = "" net.ReadUInt(2)
                end
                if g=="1" then
                    z[d][f] = net.ReadString() -- possable compression
                end
                if g=="2" then
                    z[d][f] = tonumber(net.ReadString()) -- possable compression
                end
                if g=="3" then
                    z[d][f] = net.ReadEntity()
                end
                if g=="4" then
                    z[d][f] = net.ReadVector() -- possable compression
                end
                if g=="5" then
                    z[d][f] = net.ReadAngle() -- possable compression
                end
                if g=="6" then
                    z[d][f] = net.ReadTable() -- possable compression
                end
                if g=="7" then
                    local function b2b(a) if a==1 then return true else return false end end
                    z[d][f] = b2b(net.ReadBit())
                end
                if g=="8" then
                    z[d][f] = net.ReadColor() -- possable compression
                end
                if g=="9" then
                    z[d][f] = net.ReadMatrix()
                end
            end
        end
    end 

    -- Processing the data.
    for d,e in pairs(z) do for f,g in pairs(e) do
        if type(netfix.callbacks[tonumber(x[d][f])])=="function" then netfix.callbacks[tonumber(x[d][f])](g) end
    end end
end)

-- Used to load data into packages.
function netfix.handle(a,b,c,d,e) -- (Database name, key name, value, callback(data))
    if type(netfix.packages[a])!="table" then netfix.packages[a] = {} end
    if type(netfix.callids[a])!="table" then netfix.callids[a] = {} end
    if type(netfix.responses[a])!="table" then netfix.responses[a] = {} end
    netfix.packages[a][b] = c netfix.callids[a][b] = d netfix.responses[a][b] = e
end

-- Used to send packages to clients.
function netfix.chaseup(a,b) -- (Table of ids, player ent)
    local c = a a = {}

    -- Turns the table into a ref list.
    for d,e in pairs(c) do
        a[e] = true
    end c = {}

    -- Uses the ref list to add dbs to table.
    local y = {}
    for d,e in pairs(netfix.packages) do
        if a[d] then c[#c+1] = e y[#y+1] = d end
    end

    -- If no dbs then errorout.
    if #c==0 then return false end
    
    -- Use the table to create a key list.
    local z,x = "",""
    for d,e in pairs(c) do
        for f,g in pairs(e) do
            if type(g)=="string" then
                if #g==0 then
                    z = z.."0"
                else
                    z = z.."1"
                end
            end
            if type(g)=="number" then
                z = z.."2"
            end
            if type(g)=="entity"||type(g)=="Player" then
                z = z.."3"
            end
            if type(g)=="vector" then
                z = z.."4"
            end
            if type(g)=="angle" then
                z = z.."5"
            end
            if type(g)=="table" then
                z = z.."6"
            end
            if type(g)=="boolean" then
                z = z.."7"
            end
            if type(g)=="color" then
                z = z.."8"
            end
            if type(g)=="matrix" then
                z = z.."9"
            end
            x = x..netfix.callids[y[d]][f]..","
        end
        z = z..";" x = x..";"
    end

    -- Starts the netstring.
    net.Start("netfixreport")
    net.WriteString(z)
    net.WriteString(x)

    -- Run through the table adding each item to the netstring.
    for d,e in pairs(c) do
        for f,g in pairs(e) do
            if type(g)=="string" then
                if #g==0 then
                    net.WriteUInt(1,2) -- Bit instead?
                else
                    net.WriteString(g) -- possable compression
                end
            end
            if type(g)=="number" then
                net.WriteString(tostring(g)) -- possable compression
            end
            if type(g)=="entity"||type(g)=="Player" then
                net.WriteEntity(g)
            end
            if type(g)=="vector" then
                --net.WriteNormal(g)
                net.WriteVector(g) -- possable compression
            end
            if type(g)=="angle" then
                net.WriteAngle(g) -- possable compression
            end
            if type(g)=="table" then
                net.WriteTable(g) -- possable compression
            end
            if type(g)=="boolean" then
                net.WriteBit(g)
            end
            if type(g)=="color" then
                net.WriteColor(g) -- possable compression
            end
            if type(g)=="matrix" then
                net.WriteMatrix(g) -- possable compression
            end
        end
    end

    -- Sends the netstring.
    if SERVER then if type(b)=="Player" then net.Send(b) else net.Broadcast() end end
    if CLIENT then net.SendToServer() end

    -- Set the sent packages to nil.
    for d,e in pairs(netfix.packages) do
        if a[d] then netfix.packages[d] = nil end
    end

    return true
end

hook.Run("netfix_loaded")


--[[
if CLIENT then
    netfix.callbacks[10] = function(a) netfix.handle(10,1,LocalPlayer(),10,nil) netfix.chaseup({10}) end
end
if SERVER then
    netfix.callbacks[10] = function(a) netfix.responses[10][1](a) end
    netfix.handle(10,1,"",10,function(a) print("Player "..a:UserID().." = "..a:Name()) end)
    netfix.chaseup({10})
end
]]--