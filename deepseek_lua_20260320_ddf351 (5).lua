local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local DownloadGui = Instance.new("ScreenGui")
DownloadGui.Name = "PigHubLoad"
DownloadGui.Parent = CoreGui
DownloadGui.ResetOnSpawn = false
DownloadGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = DownloadGui

local CharImage = Instance.new("ImageLabel")
CharImage.Size = UDim2.new(0, 300, 0, 300)
CharImage.Position = UDim2.new(0.5, -150, 0.5, -170)
CharImage.BackgroundTransparency = 1
CharImage.Image = "rbxassetid://117924028123190"
CharImage.ImageTransparency = 1
CharImage.Parent = MainFrame

local CampName = Instance.new("TextLabel")
CampName.Size = UDim2.new(1, 0, 0, 70)
CampName.Position = UDim2.new(0, 0, 0.5, 140)
CampName.BackgroundTransparency = 1
CampName.Text = "PIG HUB"
CampName.TextColor3 = Color3.fromRGB(255, 105, 180)
CampName.TextScaled = true
CampName.Font = Enum.Font.GothamBold
CampName.TextTransparency = 1
CampName.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 182, 193))
})
Gradient.Rotation = 45
Gradient.Parent = CampName

task.spawn(function()
    local fadeInImage = TweenService:Create(CharImage, TweenInfo.new(1.5), {ImageTransparency = 0})
    fadeInImage:Play()
    fadeInImage.Completed:Wait()
    task.wait(0.5)

    local fadeInText = TweenService:Create(CampName, TweenInfo.new(2), {TextTransparency = 0})
    fadeInText:Play()

    local angle = 45
    while CampName.TextTransparency < 0.1 do
        angle = (angle + 1) % 360
        Gradient.Rotation = angle
        task.wait(0.03)
    end

    fadeInText.Completed:Wait()
    task.wait(2)

    local fadeOutImage = TweenService:Create(CharImage, TweenInfo.new(1), {ImageTransparency = 1})
    local fadeOutText = TweenService:Create(CampName, TweenInfo.new(1), {TextTransparency = 1})
    fadeOutImage:Play()
    fadeOutText:Play()
    fadeOutImage.Completed:Wait()

    DownloadGui:Destroy()
end)

repeat task.wait() until not CoreGui:FindFirstChild("PigHubLoad")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== ระบบ Bypass กันแบน ==========
local function setupBypass()
    local function hookButton(button)
        if not button then return end
        if button:FindFirstChild("UnlocksAtText") then
            button.UnlocksAtText.Visible = false
        end
        if button:FindFirstChild("EmoteName") then
            button.EmoteName.Visible = true
        end
        local CoreUI = require(ReplicatedStorage.Modules.Core.UI)
        CoreUI.on_click(button, function() end)
    end
    
    local function lockTool(tool)
        if tool and tool:IsA("Tool") then
            pcall(function() 
                tool:SetAttribute("Locked", true) 
            end)
        end
    end
    
    local function setupBackpack(backpack)
        if not backpack then return end
        for _, tool in ipairs(backpack:GetChildren()) do
            lockTool(tool)
        end
        backpack.ChildAdded:Connect(lockTool)
    end
    
    task.spawn(function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            setupBackpack(backpack)
        else
            LocalPlayer.ChildAdded:Connect(function(child)
                if child:IsA("Backpack") then
                    setupBackpack(child)
                end
            end)
        end
    end)
    
    local success, Util = pcall(function()
        return require(ReplicatedStorage.Modules.Core.Util)
    end)
    if success and Util then
        local _old_tween = Util.tween
        Util.tween = function(instance, tweenInfo, properties)
            if instance and instance:IsA("NumberValue") and properties and properties.Value ~= nil then
                instance.Value = properties.Value
                return { Cancel = function() end }
            end
            return _old_tween(instance, tweenInfo, properties)
        end
    end
end

task.spawn(setupBypass)

-- โหลด WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "PIG HUB",
    Icon = "rbxassetid://120437295686483",
    Author = "PIG TEAM",
    Folder = "PIG HUB",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Light",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    AccentColor = Color3.fromRGB(255, 105, 180),
    User = {
        Enabled = true,
        Name = LocalPlayer.Name,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId
    }
})

local function applyPinkTheme()
    pcall(function()
        if Window and Window.SideBar then
            Window.SideBar.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
        end
    end)
end
task.spawn(applyPinkTheme)

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "WindUI_Toggle"
ScreenGui.ResetOnSpawn = false
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,20,0.5,-25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://120437295686483"
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local function ToggleUI()
    if Window.Toggle then 
        Window:Toggle() 
    else 
        Window.UI.Enabled = not Window.UI.Enabled 
    end
end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(i, gp) 
    if not gp and i.KeyCode == Enum.KeyCode.T then 
        ToggleUI() 
    end 
end)

-- ========== ระบบพื้นฐาน ==========
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local jumpEnabled = false
local jumpPower = 70
local jumpConnection = nil

local sitEnabled = false
local sitHeight = 0
local sitConnection = nil

local function toggleSitSystem(state)
    sitEnabled = state
    
    if sitConnection then
        sitConnection:Disconnect()
        sitConnection = nil
    end
    
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.Sit = state
        
        if state then
            sitConnection = RunService.Heartbeat:Connect(function()
                if sitEnabled and c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(0, sitHeight, 0)
                end
            end)
        end
    end
end

-- ========== ระบบวิ่งเร็ว (แบบ god2.txt) ==========
local walkSpeedEnabled = false
local speedValue = 0.05
local moveConnection = nil

local function setupWalkSpeed(char)
    if moveConnection then
        pcall(function() moveConnection:Disconnect() end)
    end
    
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return end
    
    moveConnection = RunService.RenderStepped:Connect(function()
        if walkSpeedEnabled and char and hrp and humanoid and humanoid.Health > 0 then
            if humanoid.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection.Unit * speedValue)
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupWalkSpeed(char)
end)

if LocalPlayer.Character then
    setupWalkSpeed(LocalPlayer.Character)
end

-- ========== ระบบ ANTI LOOK
getgenv().AntiLookEnabled = false
getgenv().AntiLookStrength = 1500
getgenv().AntiLookSpeed = 1500

local AntiLookConnection = nil

local function setupAntiLook()
    if AntiLookConnection then
        AntiLookConnection:Disconnect()
    end
    
    AntiLookConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        if not LocalPlayer.Character then return end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local originalVel = hrp.Velocity
        local angle = math.rad(tick() * getgenv().AntiLookSpeed % 360)
        local x = math.cos(angle) * getgenv().AntiLookStrength
        local z = math.sin(angle) * getgenv().AntiLookStrength
        local yVel = math.random(200, 400)

        hrp.Velocity = Vector3.new(x, yVel, z)
        RunService.RenderStepped:Wait()
        hrp.Velocity = originalVel
    end)
end

local function toggleAntiLook(state)
    getgenv().AntiLookEnabled = state
    if state then
        setupAntiLook()
    else
        if AntiLookConnection then
            AntiLookConnection:Disconnect()
            AntiLookConnection = nil
        end
    end
end

-- ========== ระบบกันตาย (แบบง่าย) ==========
local antiDeathEnabled = false
local antiDeathActive = false
local antiDeathConnection = nil
local safePosition = nil
local SAFE_DEPTH = 20

local function findGroundHeight(pos)
    local ray = Ray.new(pos + Vector3.new(0, 20, 0), Vector3.new(0, -50, 0))
    local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit and hitPos.Y or pos.Y - SAFE_DEPTH
end

local function enterSafeMode()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local groundY = findGroundHeight(hrp.Position)
    safePosition = Vector3.new(hrp.Position.X, groundY - SAFE_DEPTH, hrp.Position.Z)
    
    hrp.CFrame = CFrame.new(safePosition)
    
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = false
    end
    
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
    end
    
    antiDeathConnection = RunService.Heartbeat:Connect(function()
        if not antiDeathActive or not antiDeathEnabled then return end
        
        local currentChar = LocalPlayer.Character
        if not currentChar then return end
        
        local currentHRP = currentChar:FindFirstChild("HumanoidRootPart")
        if not currentHRP then return end
        
        local currentGround = findGroundHeight(currentHRP.Position)
        local targetY = currentGround - SAFE_DEPTH
        
        if currentHRP.Position.Y > targetY + 3 then
            currentHRP.CFrame = CFrame.new(Vector3.new(currentHRP.Position.X, targetY, currentHRP.Position.Z))
        end
    end)
end

local function exitSafeMode()
    antiDeathActive = false
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
        antiDeathConnection = nil
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local groundY = findGroundHeight(hrp.Position)
    local returnPos = Vector3.new(hrp.Position.X, groundY + 2, hrp.Position.Z)
    
    hrp.CFrame = CFrame.new(returnPos)
end

local function checkHealthAndAct()
    if not antiDeathEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local currentHealth = humanoid.Health
    
    if currentHealth < 30 and currentHealth > 0 and not antiDeathActive then
        antiDeathActive = true
        enterSafeMode()
    elseif currentHealth >= 30 and antiDeathActive then
        antiDeathActive = false
        exitSafeMode()
    end
end

RunService.Heartbeat:Connect(checkHealthAndAct)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        checkHealthAndAct()
    end)
    
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp:GetPropertyChangedSignal("Position"):Connect(function()
        if antiDeathActive then
            local groundY = findGroundHeight(hrp.Position)
            local targetY = groundY - SAFE_DEPTH
            
            if hrp.Position.Y > targetY + 3 then
                hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, targetY, hrp.Position.Z))
            end
        end
    end)
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        checkHealthAndAct()
    end)
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp:GetPropertyChangedSignal("Position"):Connect(function()
            if antiDeathActive then
                local groundY = findGroundHeight(hrp.Position)
                local targetY = groundY - SAFE_DEPTH
                
                if hrp.Position.Y > targetY + 3 then
                    hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, targetY, hrp.Position.Z))
                end
            end
        end)
    end
end

-- ========== ระบบดูดของ ==========
local CLIENT_ZONE_SIZE = Vector3.new(120, 14, 120)
local SERVER_FAKE_RADIUS = 2000
local MAGNET_SPEED = 0.8
local magnetEnabled = false
local magnetConnection = nil

local remoteGet = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")

local function resizeZones()
    for _, item in pairs(workspace.DroppedItems:GetChildren()) do
        local zone = item:FindFirstChild("PickUpZone")
        if zone and zone:IsA("BasePart") then
            zone.Size = CLIENT_ZONE_SIZE
            zone.Transparency = 1
            zone.CanCollide = false
            zone.Anchored = true
        end
    end
end

resizeZones()
workspace.DroppedItems.ChildAdded:Connect(resizeZones)

local function startMagnet()
    if magnetConnection then
        magnetConnection:Disconnect()
    end
    
    magnetConnection = RunService.Heartbeat:Connect(function()
        if not magnetEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, item in pairs(workspace.DroppedItems:GetChildren()) do
            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
            if not prompt then continue end
            
            local dist = (hrp.Position - item.Position).Magnitude
            
            if dist <= SERVER_FAKE_RADIUS then
                pcall(function()
                    remoteGet:InvokeServer("pickup_dropped_item", item)
                end)
                
                if item:IsA("BasePart") then
                    item.CFrame = item.CFrame:Lerp(CFrame.new(hrp.Position), MAGNET_SPEED)
                else
                    local part = item:FindFirstChildWhichIsA("BasePart")
                    if part then
                        part.CFrame = part.CFrame:Lerp(CFrame.new(hrp.Position), MAGNET_SPEED)
                    end
                end
            end
        end
    end)
end

-- ========== ฟังก์ชันสร้าง Network (สำหรับ Quest) ==========
local function findCounterTable()
    if not getgc then return nil end
    for _, obj in ipairs(getgc(true)) do
        if typeof(obj) == "table" then
            if rawget(obj, "event") and rawget(obj, "func") then return obj end
        end
    end
    return nil
end

local function createNetwork()
    local CounterTable = findCounterTable()
    if not CounterTable then return nil end
    local Net = {}
    function Net.get(...)
        CounterTable.func = (CounterTable.func or 0) + 1
        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get"):InvokeServer(CounterTable.func, ...)
    end
    function Net.send(action)
        CounterTable.event = (CounterTable.event or 0) + 1
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send"):FireServer(CounterTable.event, action)
    end
    return Net
end

-- ========== ระบบ SILENT AIM (ปิดไว้ก่อนเพื่อทดสอบ) ==========
getgenv().SilentAimEnabled = false
-- ปิดการทำงานทั้งหมดไว้ก่อน

-- ========== ระบบ ESP (แบบย่อ) ==========
local ShowBoxESP = false
local ShowNameESP = false
local ShowHealthESP = false
local ShowDistanceESP = false

-- Box ESP
local PlayerBoxESP = {}
local rainbowColors = {
    Color3.fromRGB(255,0,0),
    Color3.fromRGB(255,127,0),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,0,255),
    Color3.fromRGB(75,0,130),
    Color3.fromRGB(148,0,211)
}
local BOX_COLOR_MODE = "rainbow"
local BOX_SIZE = 45

local function getBoxColor(espData, lineKey)
    if BOX_COLOR_MODE == "rainbow" then
        local offsets = {top=0,bottom=2,left=4,right=6}
        return rainbowColors[((espData.colorIndex + (offsets[lineKey] or 0)) % #rainbowColors) + 1]
    end
    return Color3.fromRGB(255,255,255)
end

local function createBoxESP(player)
    if player==LocalPlayer or PlayerBoxESP[player] then return end
    local box={
        top=Drawing.new("Line"),
        bottom=Drawing.new("Line"),
        left=Drawing.new("Line"),
        right=Drawing.new("Line")
    }
    for _,line in pairs(box) do
        line.Thickness=1.5
        line.Visible=false
        line.ZIndex=1
    end
    PlayerBoxESP[player]={box=box,colorIndex=1,lastColorChange=tick()}
end

local function removeBoxESP(player)
    local espData=PlayerBoxESP[player]
    if not espData then return end
    for _,line in pairs(espData.box) do line:Remove() end
    PlayerBoxESP[player]=nil
end

-- Health ESP
local PlayerHealthESP = {}

local function createHealthESP(player)
    if player==LocalPlayer or PlayerHealthESP[player] then return end
    local healthBarBg = Drawing.new("Square")
    healthBarBg.Filled = true
    healthBarBg.Transparency = 0.7
    healthBarBg.Color = Color3.fromRGB(0,0,0)
    healthBarBg.Visible = false
    
    local healthBarFg = Drawing.new("Square")
    healthBarFg.Filled = true
    healthBarFg.Transparency = 0.3
    healthBarFg.Visible = false
    
    PlayerHealthESP[player] = {bg=healthBarBg, fg=healthBarFg}
end

local function removeHealthESP(player)
    if PlayerHealthESP[player] then
        if PlayerHealthESP[player].bg then PlayerHealthESP[player].bg:Remove() end
        if PlayerHealthESP[player].fg then PlayerHealthESP[player].fg:Remove() end
        PlayerHealthESP[player] = nil
    end
end

-- Name ESP
local PlayerNameESP = {}

local function createNameESP(player)
    if player==LocalPlayer or PlayerNameESP[player] then return end
    local nameDisplay=Drawing.new("Text")
    nameDisplay.Size=16
    nameDisplay.Center=true
    nameDisplay.Outline=true
    nameDisplay.OutlineColor=Color3.new(0,0,0)
    nameDisplay.Color=Color3.new(1,1,1)
    nameDisplay.Font=2
    nameDisplay.Visible=false
    PlayerNameESP[player]={
        display=nameDisplay,
        character=player.Character,
        hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    }
    player.CharacterAdded:Connect(function(char)
        PlayerNameESP[player].character=char
        task.spawn(function()
            local hrp=char:WaitForChild("HumanoidRootPart",0.5)
            if hrp then PlayerNameESP[player].hrp=hrp end
        end)
    end)
end

local function removeNameESP(player)
    if PlayerNameESP[player] then
        if PlayerNameESP[player].display then PlayerNameESP[player].display:Remove() end
        PlayerNameESP[player]=nil
    end
end

-- Distance ESP
local PlayerDistanceESP = {}

local function createDistanceESP(player)
    if player==LocalPlayer or PlayerDistanceESP[player] then return end
    local distDisplay=Drawing.new("Text")
    distDisplay.Size=14
    distDisplay.Center=true
    distDisplay.Outline=true
    distDisplay.OutlineColor=Color3.new(0,0,0)
    distDisplay.Color=Color3.fromRGB(200,200,200)
    distDisplay.Font=2
    distDisplay.Visible=false
    PlayerDistanceESP[player]={
        display=distDisplay,
        character=player.Character,
        hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    }
    player.CharacterAdded:Connect(function(char)
        PlayerDistanceESP[player].character=char
        task.spawn(function()
            local hrp=char:WaitForChild("HumanoidRootPart",0.5)
            if hrp then PlayerDistanceESP[player].hrp=hrp end
        end)
    end)
end

local function removeDistanceESP(player)
    if PlayerDistanceESP[player] then
        if PlayerDistanceESP[player].display then PlayerDistanceESP[player].display:Remove() end
        PlayerDistanceESP[player]=nil
    end
end

-- ฟังก์ชันรวม Render ESP
local function renderESP()
    -- Box ESP
    if ShowBoxESP then
        local currentTime=tick()
        for player,espData in pairs(PlayerBoxESP) do
            if not espData or not espData.box then continue end
            local character=player.Character
            if not character or not character.Parent then
                for _,line in pairs(espData.box) do line.Visible=false end
                continue
            end
            
            local hrp=character:FindFirstChild("HumanoidRootPart")
            local humanoid=character:FindFirstChild("Humanoid")
            if not hrp or not humanoid or humanoid.Health<=0 then
                for _,line in pairs(espData.box) do line.Visible=false end
                continue
            end
            
            local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
            if not onScreen or pos.Z<=0 then
                for _,line in pairs(espData.box) do line.Visible=false end
                continue
            end
            
            local size = BOX_SIZE
            local centerX = pos.X
            local centerY = pos.Y - size/2
            
            local topLeft = Vector2.new(centerX - size/2, centerY)
            local topRight = Vector2.new(centerX + size/2, centerY)
            local bottomLeft = Vector2.new(centerX - size/2, centerY + size)
            local bottomRight = Vector2.new(centerX + size/2, centerY + size)
            
            espData.box.top.From = topLeft
            espData.box.top.To = topRight
            espData.box.bottom.From = bottomLeft
            espData.box.bottom.To = bottomRight
            espData.box.left.From = topLeft
            espData.box.left.To = bottomLeft
            espData.box.right.From = topRight
            espData.box.right.To = bottomRight
            
            for _,line in pairs(espData.box) do line.Visible=true end
            
            if currentTime-espData.lastColorChange>0.15 then
                espData.box.top.Color=getBoxColor(espData,"top")
                espData.box.bottom.Color=getBoxColor(espData,"bottom")
                espData.box.left.Color=getBoxColor(espData,"left")
                espData.box.right.Color=getBoxColor(espData,"right")
                espData.colorIndex=(espData.colorIndex%#rainbowColors)+1
                espData.lastColorChange=currentTime
            end
        end
    else
        for _,espData in pairs(PlayerBoxESP) do
            if espData and espData.box then
                for _,line in pairs(espData.box) do line.Visible=false end
            end
        end
    end
    
    -- Name ESP
    if ShowNameESP then
        for player,espData in pairs(PlayerNameESP) do
            if not espData or not espData.display then continue end
            if not player.Parent then removeNameESP(player) continue end
            if not espData.character and player.Character then
                espData.character=player.Character
                espData.hrp=player.Character:FindFirstChild("HumanoidRootPart")
            end
            if not espData.character or not espData.hrp then espData.display.Visible=false continue end
            
            local hrp=espData.hrp
            local humanoid=espData.character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health<=0 then espData.display.Visible=false continue end
            
            local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
            if onScreen and pos.Z>0 then
                local distance=(Camera.CFrame.Position-hrp.Position).Magnitude
                if distance<=1500 then
                    espData.display.Text=player.Name
                    espData.display.Position=Vector2.new(pos.X,pos.Y-30)
                    espData.display.Visible=true
                else
                    espData.display.Visible=false
                end
            else
                espData.display.Visible=false
            end
        end
    else
        for _,espData in pairs(PlayerNameESP) do
            if espData and espData.display then espData.display.Visible=false end
        end
    end
    
    -- Health ESP
    if ShowHealthESP then
        for player,espData in pairs(PlayerHealthESP) do
            if not espData then continue end
            if not player.Parent then removeHealthESP(player) continue end
            if not player.Character then
                espData.bg.Visible=false
                espData.fg.Visible=false
                continue
            end
            
            local hrp=player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid=player.Character:FindFirstChild("Humanoid")
            if not hrp or not humanoid or humanoid.Health<=0 then
                espData.bg.Visible=false
                espData.fg.Visible=false
                continue
            end
            
            local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,-2,0))
            if onScreen and pos.Z>0 then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local barWidth = 50
                local barHeight = 5
                
                espData.bg.Position = Vector2.new(pos.X - barWidth/2, pos.Y + 10)
                espData.bg.Size = Vector2.new(barWidth, barHeight)
                espData.bg.Visible = true
                
                espData.fg.Position = Vector2.new(pos.X - barWidth/2, pos.Y + 10)
                espData.fg.Size = Vector2.new(barWidth * healthPercent, barHeight)
                espData.fg.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                espData.fg.Visible = true
            else
                espData.bg.Visible=false
                espData.fg.Visible=false
            end
        end
    else
        for _,espData in pairs(PlayerHealthESP) do
            if espData then
                espData.bg.Visible=false
                espData.fg.Visible=false
            end
        end
    end
    
    -- Distance ESP
    if ShowDistanceESP then
        for player,espData in pairs(PlayerDistanceESP) do
            if not espData or not espData.display then continue end
            if not player.Parent then removeDistanceESP(player) continue end
            if not espData.character and player.Character then
                espData.character=player.Character
                espData.hrp=player.Character:FindFirstChild("HumanoidRootPart")
            end
            if not espData.character or not espData.hrp then espData.display.Visible=false continue end
            
            local hrp=espData.hrp
            local myHrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHrp then espData.display.Visible=false continue end
            
            local humanoid=espData.character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health<=0 then espData.display.Visible=false continue end
            
            local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and pos.Z>0 then
                local distance = (myHrp.Position - hrp.Position).Magnitude
                espData.display.Text = string.format("%.0fm", distance)
                espData.display.Position = Vector2.new(pos.X, pos.Y + 40)
                espData.display.Visible = true
            else
                espData.display.Visible = false
            end
        end
    else
        for _,espData in pairs(PlayerDistanceESP) do
            if espData and espData.display then espData.display.Visible=false end
        end
    end
end

-- เชื่อมต่อ RenderStepped
RunService.RenderStepped:Connect(renderESP)

-- Initialize ESP for existing players
for _,player in ipairs(Players:GetPlayers()) do
    if player~=LocalPlayer then 
        task.spawn(function() createBoxESP(player) end)
        task.spawn(function() createNameESP(player) end)
        task.spawn(function() createHealthESP(player) end)
        task.spawn(function() createDistanceESP(player) end)
    end
end

-- Player added/removed connections
Players.PlayerAdded:Connect(function(player)
    if player~=LocalPlayer then 
        task.wait(0.5) 
        createBoxESP(player)
        createNameESP(player)
        createHealthESP(player)
        createDistanceESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeBoxESP(player)
    removeNameESP(player)
    removeHealthESP(player)
    removeDistanceESP(player)
end)

-- ========== ระบบ FPS BOOSTER ==========
local fpsBoosterEnabled = false
local fpsBoosterMode = 1

local function applyFPSBooster(mode)
    if mode == 1 then
        pcall(function()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end)
        
    elseif mode == 2 then
        pcall(function()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
        end)
        
    elseif mode == 3 then
        pcall(function()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 1
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end)
    end
end

local function toggleFPSBooster(state)
    fpsBoosterEnabled = state
    if state then
        applyFPSBooster(fpsBoosterMode)
    else
        pcall(function()
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.ShadowSoftness = 0
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            
            workspace.Terrain.WaterWaveSize = 5
            workspace.Terrain.WaterWaveSpeed = 10
            workspace.Terrain.WaterReflectance = 0.5
            workspace.Terrain.WaterTransparency = 0
        end)
    end
end

-- ========== ฟังก์ชันแสดงเงิน ==========
local function getRainbowColorForMoney(offset)
    local time = tick() * 1.5
    return Color3.fromHSV((time + offset) % 1, 1, 1)
end

local function formatMoneyWithRainbow(amount)
    amount = tonumber(amount) or 0
    local text
    if amount >= 1000000 then 
        text = string.format("$%.1fM", amount/1000000)
    elseif amount >= 1000 then 
        text = string.format("$%.1fK", amount/1000)
    else 
        text = string.format("$%d", amount)
    end
    
    local rainbowText = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local color = getRainbowColorForMoney(i * 0.2)
        local hex = string.format("#%02x%02x%02x", color.R*255, color.G*255, color.B*255)
        rainbowText = rainbowText .. string.format('<font color="%s">%s</font>', hex, char)
    end
    return rainbowText
end

local function HandMoney()
    local success, value = pcall(function()
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return 0 end
        local topRight = PlayerGui:FindFirstChild("TopRightHud")
        if topRight then
            local holder = topRight:FindFirstChild("Holder")
            if holder and holder:FindFirstChild("Frame") and holder.Frame:FindFirstChild("MoneyTextLabel") then
                return tonumber(holder.Frame.MoneyTextLabel.Text:gsub("[$,]", "")) or 0
            end
        end
        return 0
    end)
    return success and value or 0
end

local function ATMMoney()
    local success, value = pcall(function()
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return 0 end
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and (v.Text:find("Bank") or v.Text:find("Balance")) then
                return tonumber(v.Text:gsub("[$,]", ""):gsub("Bank", ""):gsub("Balance", ""):gsub(":", ""):match("%d+")) or 0
            end
        end
        return 0
    end)
    return success and value or 0
end

-- ========== สร้าง Tabs ==========
local PlayerTab = Window:Tab({Title = "PLAYER", Icon = "user"})
local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})
local PVPTab = Window:Tab({Title = "PVP", Icon = "crosshair"})
local QuestTab = Window:Tab({Title = "QUEST", Icon = "flag"})
local CustomTab = Window:Tab({Title = "CUSTOM", Icon = "settings"})

-- ========== PLAYER TAB ==========
PlayerTab:Section({Title = "Player Stats"})

local BankBalance = PlayerTab:Button({
    Title = "Bank", 
    Desc = "<b><font color='#FF69B4'>$0</font></b>", 
    Callback = function() end
})

local HandBalance = PlayerTab:Button({
    Title = "Cash", 
    Desc = "<b><font color='#FFB6C1'>$0</font></b>", 
    Callback = function() end
})

task.spawn(function()
    while task.wait(0.5) do
        local bankAmount = ATMMoney()
        local handAmount = HandMoney()
        
        BankBalance:SetDesc(formatMoneyWithRainbow(bankAmount))
        HandBalance:SetDesc(formatMoneyWithRainbow(handAmount))
    end
end)

PlayerTab:Divider()

PlayerTab:Section({Title = "ซ่อนชื่อและเลเวล"})
PlayerTab:Button({
    Title = "เปิดใช้ระบบ",
    Desc = "คลิกเพื่อเปิดระบบซ่อนชื่อและเลเวล",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/3BxE2aGP/raw", true))()
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "MOVEMENT"})

local WalkSpeedToggle = PlayerTab:Toggle({
    Title = "Walk Speed",
    Desc = "เปิดใช้งานวิ่งเร็ว",
    Default = false,
    Callback = function(state)
        walkSpeedEnabled = state
    end
})

local SpeedSlider = PlayerTab:Slider({
    Title = "Speed Value",
    Desc = "ปรับความเร็ว (0.01-0.10)",
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 0.10,
        Default = 0.05
    },
    Callback = function(value)
        speedValue = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "INFINITE STAMINA"})

local Net = require(ReplicatedStorage.Modules.Core.Net)
local SprintModule = require(ReplicatedStorage.Modules.Game.Sprint)

local InfiniteStaminaToggle = PlayerTab:Toggle({
    Title = "Infinite Stamina",
    Desc = "เปิดใช้งานพลังงานไม่จำกัด",
    Default = false,
    Callback = function(state)
        if state then
            if not getgenv().Bypassed then
                local func = debug.getupvalue(Net.get, 2)
                debug.setconstant(func, 3, '__Bypass')
                debug.setconstant(func, 4, '__Bypass')
                getgenv().Bypassed = true
            end
            
            repeat task.wait() until getgenv().Bypassed

            RunService.Heartbeat:Connect(function()
                Net.send("set_sprinting_1", true)
            end)

            local consume_stamina = SprintModule.consume_stamina
            local SprintBar = debug.getupvalue(consume_stamina, 2).sprint_bar
            local __InfiniteStamina = SprintBar.update

            SprintBar.update = function(...)
                if getgenv().InfiniteStamina then
                    return __InfiniteStamina(function()
                        return 0.5
                    end)
                end
                return __InfiniteStamina(...)
            end
            
            getgenv().InfiniteStamina = true
        else
            getgenv().InfiniteStamina = false
        end
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "JUMP POWER"})

local JumpToggle = PlayerTab:Toggle({
    Title = "Jump Power",
    Desc = "เปิดใช้งานกระโดดสูง",
    Default = false,
    Callback = function(state)
        jumpEnabled = state
        
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        
        if state then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    char.HumanoidRootPart.Velocity = Vector3.new(
                        char.HumanoidRootPart.Velocity.X,
                        jumpPower,
                        char.HumanoidRootPart.Velocity.Z
                    )
                end
            end)
        end
    end
})

local JumpPowerSlider = PlayerTab:Slider({
    Title = "Jump Height",
    Desc = "ปรับความสูงในการกระโดด (สูงสุด 80)",
    Step = 5,
    Value = {
        Min = 20,
        Max = 80,
        Default = 70
    },
    Callback = function(value)
        jumpPower = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "SIT SYSTEM"})

PlayerTab:Toggle({
    Title = "เก็บของใต้ดิน",
    Desc = "เปิด: นั่งและจมลง | ปิด: กลับขึ้นมา",
    Default = false,
    Callback = function(state)
        toggleSitSystem(state)
    end
})

PlayerTab:Slider({
    Title = "ปรับ Height",
    Desc = "ปรับระดับความสูง (ค่าติดลบ = ลง)",
    Step = 0.1,
    Value = {
        Min = -5,
        Max = 4,
        Default = 0
    },
    Callback = function(value)
        sitHeight = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "ANTI LOOK"})

local AntiLookToggle = PlayerTab:Toggle({
    Title = "Anti Look",
    Desc = "ป้องกันล็อคเป้า",
    Default = false,
    Callback = function(state)
        toggleAntiLook(state)
    end
})

PlayerTab:Slider({
    Title = "Strength",
    Desc = "ความแรงในการสั่น (500-3000)",
    Step = 100,
    Value = {
        Min = 500,
        Max = 3000,
        Default = 1500
    },
    Callback = function(value)
        getgenv().AntiLookStrength = value
    end
})

PlayerTab:Slider({
    Title = "Speed",
    Desc = "ความเร็วในการสั่น (500-3000)",
    Step = 100,
    Value = {
        Min = 500,
        Max = 3000,
        Default = 1500
    },
    Callback = function(value)
        getgenv().AntiLookSpeed = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "กันตาย"})

local AntiDeathToggle = PlayerTab:Toggle({
    Title = "กันตาย",
    Desc = "เลือด < 30: ลงใต้พื้น | เลือด >= 30: กลับขึ้นมา",
    Default = false,
    Callback = function(state)
        antiDeathEnabled = state
        if not state and antiDeathActive then
            antiDeathActive = false
            exitSafeMode()
        end
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "ดูดของ"})

local MagnetToggle = PlayerTab:Toggle({
    Title = "ดูดของ",
    Desc = "ดูดของอัตโนมัติในรัศมี 2000 หน่วย",
    Default = false,
    Callback = function(state)
        magnetEnabled = state
        if state then
            startMagnet()
        else
            if magnetConnection then
                magnetConnection:Disconnect()
                magnetConnection = nil
            end
        end
    end
})

PlayerTab:Divider()

-- ========== QUEST TAB ==========
QuestTab:Section({Title = "QUEST MANAGER"})

QuestTab:Button({
    Title = "Clear All Quests",
    Desc = "เคลียร์เควสทั้งหมด",
    Callback = function()
        task.spawn(function()
            local player = LocalPlayer
            
            local Net = createNetwork()
            if not Net then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Quest Error",
                    Text = "ไม่สามารถเชื่อมต่อระบบ Quest ได้",
                    Duration = 3
                })
                return
            end
            
            local success, questUI = pcall(function()
                return player:WaitForChild("PlayerGui"):WaitForChild("Quests"):WaitForChild("QuestsHolder"):WaitForChild("QuestsScrollingFrame")
            end)
            
            if not success or not questUI then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Quest Error",
                    Text = "ไม่พบ UI เควส",
                    Duration = 3
                })
                return
            end
            
            local cleared = 0
            local total = 0
            
            for _, child in pairs(questUI:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
                    total = total + 1
                    
                    local success, result = pcall(function()
                        return Net.get("claim_quest", child.Name)
                    end)
                    
                    if success then
                        cleared = cleared + 1
                    end
                    
                    task.wait(0.15)
                end
            end
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Quest Clear",
                Text = "Cleared " .. cleared .. "/" .. total .. " quests",
                Duration = 5
            })
        end)
    end
})

-- ========== ESP TAB ==========
ESPTab:Section({Title = "PLAYER ESP"})

local ESPBoxToggle = ESPTab:Toggle({
    Title = "ESP Box",
    Desc = "แสดงกล่องครอบผู้เล่น (สีรุ้ง) - ขนาด 45",
    Default = false,
    Callback = function(state)
        ShowBoxESP = state
    end
})

local ESPNameToggle = ESPTab:Toggle({
    Title = "ESP Name",
    Desc = "แสดงชื่อผู้เล่น",
    Default = false,
    Callback = function(state)
        ShowNameESP = state
    end
})

local ESPHealthToggle = ESPTab:Toggle({
    Title = "ESP Health",
    Desc = "แสดงแถบเลือดใต้เท้า",
    Default = false,
    Callback = function(state)
        ShowHealthESP = state
    end
})

local ESPDistanceToggle = ESPTab:Toggle({
    Title = "ESP Distance",
    Desc = "แสดงระยะทาง",
    Default = false,
    Callback = function(state)
        ShowDistanceESP = state
    end
})

ESPTab:Divider()

-- ========== PVP TAB ==========
PVPTab:Section({Title = "SILENT AIM"})

PVPTab:Button({
    Title = "Silent Aim (ปิดทดสอบ)",
    Desc = "ปิดการใช้งานชั่วคราวเพื่อทดสอบ",
    Callback = function() end
})

-- ========== CUSTOM TAB ==========
CustomTab:Section({Title = "FPS BOOSTER"})

local FPSBoosterToggle = CustomTab:Toggle({
    Title = "FPS Booster",
    Desc = "เปิดใช้งานเพื่อเพิ่ม FPS (ทำงานครั้งเดียว)",
    Default = false,
    Callback = function(state)
        toggleFPSBooster(state)
    end
})

CustomTab:Dropdown({
    Title = "Boost Mode",
    Desc = "เลือกโหมดการเพิ่ม FPS",
    Values = {"โหมด 1: ลบหมอก", "โหมด 2: ลบหมอก+แสงเงา", "โหมด 3: ลบทุกอย่าง+Terrain เรียบ"},
    Default = 1,
    Callback = function(value)
        if value == "โหมด 1: ลบหมอก" then
            fpsBoosterMode = 1
        elseif value == "โหมด 2: ลบหมอก+แสงเงา" then
            fpsBoosterMode = 2
        elseif value == "โหมด 3: ลบทุกอย่าง+Terrain เรียบ" then
            fpsBoosterMode = 3
        end
        if fpsBoosterEnabled then
            applyFPSBooster(fpsBoosterMode)
        end
    end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ (ทดสอบ Silent Aim ปิดอยู่)",
    Duration = 3
})
