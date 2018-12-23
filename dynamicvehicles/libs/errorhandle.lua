dynamicvehicles.errorhandle = {}

-- Get an error message and print it to console.
function dynamicvehicles.errorhandle.error(level,error,path)
    if level==1 then
        MsgC(Color(50,255,50),"[Minor] "..error.." ("..path..")\n")
    elseif level==2 then
        MsgC(Color(255,200,50),"[Moderate] "..error.." ("..path..")\n")
    elseif level==3 then
        MsgC(Color(255,50,50),"[Major] "..error.." ("..path..")\n")
    elseif level==4 then
        MsgC(Color(255,255,255),"[Critical] "..error.." ("..path..")\n")
    elseif level==5 then
        MsgC(Color(200,50,255),"[Unknowen] "..error.." ("..path..")\n")
    else
        -- If the level is not one of the 5 then make it 5.
        dynamicvehicles.errorhandle.error(5,error,path)
    end
end