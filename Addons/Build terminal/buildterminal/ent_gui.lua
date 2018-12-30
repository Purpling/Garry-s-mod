-- Making sure the menu is setup correctly.
dynamicvehicles.Modifications.buildterminal.menu = vgui.Create("DFrame")
dynamicvehicles.Modifications.buildterminal.menu:SetVisible(false)
hook.Add("InitPostEntity","buildterminalmenu",function()
    dynamicvehicles.Modifications.buildterminal.menu = vgui.Create("DFrame")
    dynamicvehicles.Modifications.buildterminal.menu:SetVisible(false)
end)

-- Sorting out the menu information.
local Main = nil net.Receive("spawnterminalmenuopen",function()
    local Menu = dynamicvehicles.Modifications.buildterminal.menu
    if !Menu:IsValid() then
		net.Start("spawnterminalmenuclosed")
		net.SendToServer()
        return
    end
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
    Menu:SetTitle("")
    Menu:SetPaintShadow(false)
    Menu:SetBackgroundBlur(false)
    Menu:SetIsMenu(false)
    Menu:SetScreenLock(true)
    Menu:SetDraggable(false)
    Menu:SetSizable(false)
    Menu:ShowCloseButton(true)
    Menu:SetDeleteOnClose(false)
    function Menu:OnClose()
        net.Start("spawnterminalmenuclosed")
        net.SendToServer()
    end
    Menu.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(125,125,125,255)) --background
    end

    -- Start of the menu system.
    if Main!=nil then Main:Remove() end
    Main = vgui.Create("DPropertySheet",Menu) Main:Dock(1)

    -- The main menu for everyone.
    local Sub = vgui.Create("DPanel",Main)
    Sub.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(175,175,175,255)) --background
    end
    local Build = vgui.Create("DPanel",Sub)
    Build:SetPos((ScrW()/2)-13,0)
    Build:SetSize((ScrW()/2)-13,ScrH()-70)
    Build.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0)) --background
    end
    local leftmousestart,leftmouseend,rightmousestart,rightmouseend = {0,0},{0,0},{0,0},{0,0}
    local function updatecontainer()
        local Container = vgui.Create("DPanel",Sub)
        Container:SetPos((ScrW()/2)-13,0)
        Container:SetSize((ScrW()/2)-13,ScrH()-70)
        Container.Paint = function(s,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(150,150,150,255)) --background
        end
        local text = vgui.Create("DLabel",Container) text:SetPos(0,0)
        text:SetText(leftmousestart[1]..","..leftmousestart[2])
        text = vgui.Create("DLabel",Container) text:SetPos(0,30)
        text:SetText(leftmouseend[1]..","..leftmouseend[2])
        text = vgui.Create("DLabel",Container) text:SetPos(0,60)
        text:SetText(rightmousestart[1]..","..rightmousestart[2])
        text = vgui.Create("DLabel",Container) text:SetPos(0,90)
        text:SetText(rightmouseend[1]..","..rightmouseend[2])
        Build:MoveToFront()
    end updatecontainer()
    function Build:OnMousePressed(MOUSE_LEFT) leftmousestart = {gui.MousePos()} end
    function Build:OnMouseReleased(MOUSE_LEFT) leftmouseend = {gui.MousePos()} updatecontainer() end
    function Build:OnMousePressed(MOUSE_RIGHT) rightmousestart = {gui.MousePos()} end
    function Build:OnMouseReleased(MOUSE_RIGHT) rightmouseend = {gui.MousePos()} updatecontainer() end
    Main:AddSheet("Building Terminal",Sub,"icon16/bricks.png")

    -- Vip only.
    if dynamicvehicles.Modifications.buildterminal.vip then
        Sub = vgui.Create("DPanel",Main)
        Sub.Paint = function(s,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(175,175,175,255)) --background
        end
        Main:AddSheet("Vip Access",Sub,"icon16/medal_gold_3.png")
    end

    -- Settings menu area that is staff only.
    if dynamicvehicles.Modifications.buildterminal.staff then
        Sub = vgui.Create("DPanel",Main)
        Sub.Paint = function(s,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(175,175,175,255)) --background
        end
        Main:AddSheet("Admin Settings",Sub,"icon16/cog.png")
    end

    Menu:SetVisible(true)
    Menu:MakePopup()
end)