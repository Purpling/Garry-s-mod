-- Something if you want to see how the system works.
-- Change the false into a true to use.
if false then
    hook.Add("hashsystemloaded","Waitingforhashsystem",function()
        
        hashsystem.handle["testfile"] = function(file,data) print(data) end

        if CLIENT then return end

        local hash,error = hashsystem.generate("testfile")
        print(hash)
        print(error)

        if error==nil then
            hashsystem.relay(hash,"testfile","testfile","works")
        end
    end)
end