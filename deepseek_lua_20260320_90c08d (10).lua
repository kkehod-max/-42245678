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
CampName.TextColor3 = Color3.fromRGB(0, 200, 255)
CampName.TextScaled = true
CampName.Font = Enum.Font.GothamBold
CampName.TextTransparency = 1
CampName.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
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
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== ระบบ Bypass กันแบน ==========
local function setupBypass()
    -- Bypass Emotes
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
    
    -- Bypass Hotbar
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
    
    -- Bypass Tween
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
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Name = LocalPlayer.Name,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId
    }
})

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

local walkSpeedEnabled = false
local speedValue = 0.05
local moveConnection = nil

local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    if moveConnection then
        pcall(function() moveConnection:Disconnect() end)
    end
    
    moveConnection = RunService.RenderStepped:Connect(function()
        if walkSpeedEnabled and Humanoid and HumanoidRootPart then
            if Humanoid.MoveDirection.Magnitude > 0 then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + (Humanoid.MoveDirection.Unit * speedValue)
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

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

-- ========== ระบบ ANTI-LOOK ==========
getgenv().AntiLookEnabled = false
getgenv().AntiLookStrength = 1500
getgenv().AntiLookSpeed = 1500

local AntiLookConnections = {}
local function setupAntiLook()
    local heartbeatConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local originalVel = hrp.Velocity
        local angle = math.rad(tick() * getgenv().AntiLookSpeed % 360)
        local xOffset = math.cos(angle) * getgenv().AntiLookStrength
        local zOffset = math.sin(angle) * getgenv().AntiLookStrength
        local yOffset = math.random(200, 400)

        hrp.Velocity = Vector3.new(xOffset, yOffset, zOffset)
        RunService.RenderStepped:Wait()
        hrp.Velocity = originalVel
    end)
    table.insert(AntiLookConnections, heartbeatConn)

    local charConn = LocalPlayer.CharacterAdded:Connect(function() task.wait(1) end)
    table.insert(AntiLookConnections, charConn)
end

local function toggleAntiLook(state)
    getgenv().AntiLookEnabled = state
    for _, conn in ipairs(AntiLookConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    AntiLookConnections = {}
    if not state then return end
    setupAntiLook()
end

-- ========== ระบบกันตาย ==========
local antiDeathEnabled = false
local antiDeathActive = false
local antiDeathConnection = nil
local antiDeathPosition = nil
local UNDERWORLD_OFFSET = 15
local FLY_SPEED = 250
local FLY_RADIUS = 40

local function getGroundHeight(posX, posZ)
    local rayStart = Vector3.new(posX, 1000, posZ)
    local rayEnd = Vector3.new(posX, -1000, posZ)
    local ray = Ray.new(rayStart, (rayEnd - rayStart))
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    
    if hit and position then
        return position.Y
    end
    return 0
end

local function teleportToSafeZone()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local groundY = getGroundHeight(hrp.Position.X, hrp.Position.Z)
    
    antiDeathPosition = Vector3.new(hrp.Position.X, groundY - UNDERWORLD_OFFSET, hrp.Position.Z)
    
    hrp.CFrame = CFrame.new(antiDeathPosition)
    
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = false
        char.Humanoid.PlatformStand = false
    end
    
    hrp.Anchored = true
    
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
    end
    
    antiDeathConnection = RunService.Heartbeat:Connect(function()
        if not antiDeathActive or not antiDeathEnabled then
            return
        end
        
        local currentChar = LocalPlayer.Character
        if not currentChar or not currentChar:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local currentHRP = currentChar.HumanoidRootPart
        local time = tick() * 6
        
        local currentGroundY = getGroundHeight(currentHRP.Position.X, currentHRP.Position.Z)
        local targetY = currentGroundY - UNDERWORLD_OFFSET
        
        if currentHRP.Position.Y > targetY + 5 then
            currentHRP.Anchored = true
            currentHRP.CFrame = CFrame.new(Vector3.new(currentHRP.Position.X, targetY, currentHRP.Position.Z))
        end
        
        antiDeathPosition = Vector3.new(currentHRP.Position.X, targetY, currentHRP.Position.Z)
        
        local circleX = math.cos(time) * FLY_RADIUS
        local circleZ = math.sin(time * 1.3) * FLY_RADIUS
        
        local flyPos = Vector3.new(
            antiDeathPosition.X + circleX,
            targetY + math.sin(time * 4) * 5,
            antiDeathPosition.Z + circleZ
        )
        
        currentHRP.CFrame = CFrame.new(flyPos)
        
        currentHRP.Velocity = Vector3.new(
            math.cos(time * 2) * FLY_SPEED,
            math.sin(time * 5) * 20,
            math.sin(time * 2) * FLY_SPEED
        )
    end)
end

local function returnFromSafeZone()
    antiDeathActive = false
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
        antiDeathConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        if char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = false
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.Sit = false
            char.Humanoid.PlatformStand = false
        end
    end
end

local function checkHealthAndAct()
    if not antiDeathEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local currentHealth = humanoid.Health
    
    if currentHealth < 30 and currentHealth > 0 and not antiDeathActive then
        antiDeathActive = true
        teleportToSafeZone()
    elseif currentHealth >= 30 and antiDeathActive then
        antiDeathActive = false
        returnFromSafeZone()
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
            local groundY = getGroundHeight(hrp.Position.X, hrp.Position.Z)
            local targetY = groundY - UNDERWORLD_OFFSET
            
            if hrp.Position.Y > targetY + 5 then
                hrp.Anchored = true
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
                local groundY = getGroundHeight(hrp.Position.X, hrp.Position.Z)
                local targetY = groundY - UNDERWORLD_OFFSET
                
                if hrp.Position.Y > targetY + 5 then
                    hrp.Anchored = true
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

-- ========== ระบบ ESP (แบบสั้น) ==========
local ShowBoxESP = false
local ShowNameESP = false

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
        line.Thickness=2 line.Visible=false line.ZIndex=1
    end
    PlayerBoxESP[player]={box=box,colorIndex=1,lastColorChange=tick()}
end

local function removeBoxESP(player)
    local espData=PlayerBoxESP[player]
    if not espData then return end
    for _,line in pairs(espData.box) do line:Remove() end
    PlayerBoxESP[player]=nil
end

local function getCharacterBounds(character)
    if not character then return nil end
    local minX,maxX=math.huge,-math.huge
    local minY,maxY=math.huge,-math.huge
    for _,part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local pos,visible=Camera:WorldToViewportPoint(part.Position)
            if visible then
                minX=math.min(minX,pos.X) maxX=math.max(maxX,pos.X)
                minY=math.min(minY,pos.Y) maxY=math.max(maxY,pos.Y)
            end
        end
    end
    if minX==math.huge then
        local hrp=character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos,visible=Camera:WorldToViewportPoint(hrp.Position)
            if visible then
                local size=30
                minX=pos.X-size maxX=pos.X+size
                minY=pos.Y-size*1.5 maxY=pos.Y+size*0.5
            else return nil end
        else return nil end
    end
    local padding=3
    minX=minX-padding maxX=maxX+padding
    minY=minY-padding maxY=maxY+padding
    return {
        topLeft=Vector2.new(minX,minY),topRight=Vector2.new(maxX,minY),
        bottomLeft=Vector2.new(minX,maxY),bottomRight=Vector2.new(maxX,maxY)
    }
end

-- Name ESP
local PlayerNameESP = {}

local function createNameESP(player)
    if player==LocalPlayer or PlayerNameESP[player] then return end
    local nameDisplay=Drawing.new("Text")
    nameDisplay.Size=18 nameDisplay.Center=true nameDisplay.Outline=true
    nameDisplay.OutlineColor=Color3.new(0,0,0)
    nameDisplay.Color=Color3.new(1,1,1)
    nameDisplay.Font=2 nameDisplay.Visible=false
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
    local espData=PlayerNameESP[player]
    if not espData then return end
    if espData.display then espData.display:Remove() end
    PlayerNameESP[player]=nil
end

RunService.RenderStepped:Connect(function()
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
            local bounds=getCharacterBounds(character)
            if bounds then
                espData.box.top.From=bounds.topLeft espData.box.top.To=bounds.topRight
                espData.box.bottom.From=bounds.bottomLeft espData.box.bottom.To=bounds.bottomRight
                espData.box.left.From=bounds.topLeft espData.box.left.To=bounds.bottomLeft
                espData.box.right.From=bounds.topRight espData.box.right.To=bounds.bottomRight
                for _,line in pairs(espData.box) do line.Visible=true end
                if currentTime-espData.lastColorChange>0.15 then
                    espData.box.top.Color=getBoxColor(espData,"top")
                    espData.box.bottom.Color=getBoxColor(espData,"bottom")
                    espData.box.left.Color=getBoxColor(espData,"left")
                    espData.box.right.Color=getBoxColor(espData,"right")
                    espData.colorIndex=(espData.colorIndex%#rainbowColors)+1
                    espData.lastColorChange=currentTime
                end
            else
                for _,line in pairs(espData.box) do line.Visible=false end
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
            local pos,onScreen=Camera:WorldToViewportPoint(espData.hrp.Position+Vector3.new(0,3,0))
            if onScreen and pos.Z>0 then
                local distance=(Camera.CFrame.Position-espData.hrp.Position).Magnitude
                if distance<=1500 then
                    espData.display.Text=player.Name
                    espData.display.Position=Vector2.new(pos.X,pos.Y)
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
end)

-- Initialize ESP for existing players
for _,player in ipairs(Players:GetPlayers()) do
    if player~=LocalPlayer then 
        task.spawn(function() createBoxESP(player) end)
        task.spawn(function() createNameESP(player) end)
    end
end

-- Player added/removed connections
Players.PlayerAdded:Connect(function(player)
    if player~=LocalPlayer then 
        task.wait(0.5) 
        createBoxESP(player)
        createNameESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeBoxESP(player)
    removeNameESP(player)
end)

-- ========== ระบบ SILENT AIM + WALLBANG อัตโนมัติ ==========
getgenv().SilentAimEnabled = false
getgenv().FOV_Radius = 300
getgenv().AimPart = "Head"  -- ให้เลือกได้
getgenv().Prediction = 0.14
getgenv().RGB_Speed = 2

-- FOV 8 เหลี่ยมสีรุ้ง
local FOVLines = {}
for i = 1, 8 do
    FOVLines[i] = Drawing.new("Line")
    FOVLines[i].Thickness = 2
    FOVLines[i].Visible = false
    FOVLines[i].Color = Color3.fromRGB(255, 255, 255)
end

-- เส้นชี้เป้า
local Tracer = Drawing.new("Line")
Tracer.Thickness = 2
Tracer.Visible = false
Tracer.Color = Color3.fromRGB(255, 0, 0)

local function GetRainbowColor(offset)
    local time = tick() * getgenv().RGB_Speed
    return Color3.fromHSV((time + offset) % 1, 1, 1)
end

-- ฟังก์ชันตรวจสอบว่าเป็นปืนลูกซองหรือไม่
local function isShotgun()
    local char = LocalPlayer.Character
    if not char then return false end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local ammoType = tool:GetAttribute("AmmoType")
            if ammoType == "shotgun" or ammoType == "shootgun" then
                return true
            end
            
            -- ตรวจสอบจากชื่อ (เผื่อบางเกมไม่มี Attribute)
            local name = tool.Name:lower()
            if name:find("shotgun") or name:find("shootgun") or name:find("spas") or name:find("db") then
                return true
            end
        end
    end
    return false
end

-- ฟังก์ชันตรวจสอบว่าผู้เล่นอยู่หลังกำแพงหรือไม่
local function isBehindWall(startPos, targetPos, targetChar)
    if not startPos or not targetPos then return false end
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    if distance < 1 then return false end
    
    -- Raycast โดยไม่นับตัวเรากับตัวเป้า
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    
    local result = workspace:Raycast(startPos, direction, params)
    
    -- ถ้ามีสิ่งกีดขวาง แสดงว่าอยู่หลังกำแพง
    return result ~= nil
end

-- ฟังก์ชันหาเป้าใกล้สุด
local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fov = getgenv().FOV_Radius
    local aimPart = getgenv().AimPart
    
    local closest = nil
    local shortestDist = fov
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local targetPart = player.Character:FindFirstChild(aimPart)
        if not targetPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        
        if onScreen and screenPos.Z > 0 then
            local screenVector = Vector2.new(screenPos.X, screenPos.Y)
            local distFromCenter = (screenVector - center).Magnitude
            
            if distFromCenter <= fov and distFromCenter < shortestDist then
                shortestDist = distFromCenter
                closest = player
            end
        end
    end
    
    return closest
end

-- ระบบติดตามความเร็ว (เพื่อ Prediction)
local PositionHistory = {}
local HISTORY_SIZE = 6

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                PositionHistory[player] = PositionHistory[player] or {}
                table.insert(PositionHistory[player], {time = os.clock(), pos = hrp.Position})
                if #PositionHistory[player] > HISTORY_SIZE then
                    table.remove(PositionHistory[player], 1)
                end
            else
                PositionHistory[player] = nil
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    PositionHistory[player] = nil
end)

local function calculateVelocity(player)
    local hist = PositionHistory[player]
    if not hist or #hist < 2 then return Vector3.new() end
    
    local totalVel = Vector3.new()
    local count = 0
    for i = 2, #hist do
        local dt = hist[i].time - hist[i - 1].time
        if dt > 0 then
            totalVel = totalVel + (hist[i].pos - hist[i - 1].pos) / dt
            count = count + 1
        end
    end
    if count == 0 then return Vector3.new() end
    return totalVel / count
end

local function predictPosition(targetPart, player)
    if not targetPart then return targetPart.Position end
    
    local velocity = calculateVelocity(player) or Vector3.new()
    return targetPart.Position + (velocity * getgenv().Prediction)
end

-- Hook Remote
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local send = remotes:WaitForChild("Send")

local oldFire
if send and send.FireServer then
    oldFire = hookfunction(send.FireServer, function(self, ...)
        local args = {...}
        
        if getgenv().SilentAimEnabled then
            local targetPlayer = getClosestTarget()
            if targetPlayer and targetPlayer.Character then
                local targetPart = targetPlayer.Character:FindFirstChild(getgenv().AimPart)
                if targetPart then
                    local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                    if not myHead then return oldFire(self, unpack(args)) end
                    
                    local myPos = myHead.Position
                    local aimPos = predictPosition(targetPart, targetPlayer)
                    
                    -- ตรวจสอบว่าเป็นปืนลูกซองหรือไม่
                    local shotgun = isShotgun()
                    
                    -- ตรวจสอบว่าอยู่หลังกำแพงหรือไม่
                    local behindWall = isBehindWall(myPos, targetPart.Position, targetPlayer.Character)
                    
                    -- กำหนดค่า Wallbang
                    local wallbangEnabled = false
                    
                    if shotgun then
                        -- ลูกซอง: ปิด Wallbang ตลอด
                        wallbangEnabled = false
                    else
                        -- ปืนอื่น: เปิด Wallbang เมื่อเป้าหลังกำแพง, ปิดเมื่อเป้าไม่หลังกำแพง
                        wallbangEnabled = behindWall
                    end
                    
                    -- แก้ไข CFrame การยิง
                    if args[4] and typeof(args[4]) == "CFrame" then
                        if wallbangEnabled then
                            -- อยู่หลังกำแพง: ยิงทะลุ (ส่ง CFrame ไปไกลๆ)
                            args[4] = CFrame.new(myPos, aimPos) * CFrame.new(0, 0, -1000)
                        else
                            -- ไม่ได้อยู่หลังกำแพง: ยิงปกติ
                            args[4] = CFrame.new(myPos, aimPos)
                        end
                    end
                    
                    -- แก้ไข HitPart
                    if args[5] and type(args[5]) == "table" then
                        if args[5][1] and args[5][1][1] then
                            args[5][1][1]["Instance"] = targetPart
                            args[5][1][1]["Position"] = aimPos
                        end
                    end
                end
            end
        end
        
        return oldFire(self, unpack(args))
    end)
end

-- อัปเดต FOV และเส้นชี้เป้าทุกเฟรม
RunService.RenderStepped:Connect(function()
    -- ซ่อนทุกอย่างก่อน
    for i = 1, 8 do
        FOVLines[i].Visible = false
    end
    Tracer.Visible = false
    
    if getgenv().SilentAimEnabled then
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local radius = getgenv().FOV_Radius
        
        -- วาด FOV 8 เหลี่ยม
        for i = 1, 8 do
            local angle1 = math.rad((i - 1) * 45)
            local angle2 = math.rad(i * 45)
            
            local p1 = Vector2.new(
                center.X + math.cos(angle1) * radius,
                center.Y + math.sin(angle1) * radius
            )
            local p2 = Vector2.new(
                center.X + math.cos(angle2) * radius,
                center.Y + math.sin(angle2) * radius
            )
            
            FOVLines[i].From = p1
            FOVLines[i].To = p2
            FOVLines[i].Color = GetRainbowColor(i * 0.1)
            FOVLines[i].Visible = true
        end
        
        -- หาเป้าและวาดเส้นชี้เป้า
        local targetPlayer = getClosestTarget()
        if targetPlayer and targetPlayer.Character then
            local targetPart = targetPlayer.Character:FindFirstChild(getgenv().AimPart)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen and screenPos.Z > 0 then
                    Tracer.From = center
                    Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    Tracer.Color = GetRainbowColor(0)
                    Tracer.Visible = true
                end
            end
        end
    end
end)

-- ========== ระบบ FPS BOOSTER (ทำงานครั้งเดียว) ==========
local fpsBoosterEnabled = false
local fpsBoosterMode = 1
local fpsBoosterApplied = false  -- ตัวแปรตรวจสอบว่าเคยทำงานแล้วหรือยัง

local function applyFPSBooster(mode)
    if mode == 1 then
        -- โหมด 1: ลบหมอก
        pcall(function()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end)
        
    elseif mode == 2 then
        -- โหมด 2: ลบหมอก + ลบแสงเงา
        pcall(function()
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 1e10
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
        end)
        
    elseif mode == 3 then
        -- โหมด 3: ลบทุกอย่าง + Terrain เรียบ
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
    
    fpsBoosterApplied = true
end

local function toggleFPSBooster(state)
    fpsBoosterEnabled = state
    if state then
        -- ทำงานครั้งเดียวเมื่อเปิด
        applyFPSBooster(fpsBoosterMode)
    else
        -- ปิด: คืนค่าปกติ (ทำงานครั้งเดียว)
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
        fpsBoosterApplied = false
    end
end

-- ========== สร้าง Tabs ==========
local PlayerTab = Window:Tab({Title = "PLAYER", Icon = "user"})
local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})
local PVPTab = Window:Tab({Title = "PVP", Icon = "crosshair"})
local CustomTab = Window:Tab({Title = "CUSTOM", Icon = "settings"})

-- ========== PLAYER TAB ==========
-- ซ่อนชื่อและเลเวล
PlayerTab:Section({Title = "ซ่อนชื่อและเลเวล"})
PlayerTab:Button({
    Title = "เปิดใช้ระบบ",
    Desc = "คลิกเพื่อเปิดระบบซ่อนชื่อและเลเวล",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/3BxE2aGP/raw", true))()
    end
})

PlayerTab:Divider()

-- MOVEMENT
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
    Title = "Speed Multiplier",
    Desc = "ปรับความเร็วในการวิ่ง (สูงสุด 5x)",
    Step = 0.5,
    Value = {
        Min = 1,
        Max = 5,
        Default = 2
    },
    Callback = function(value)
        speedValue = value * 0.05
    end
})

PlayerTab:Divider()

-- INFINITE STAMINA
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

-- JUMP POWER
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

-- SIT SYSTEM
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

-- ANTI LOOK
PlayerTab:Section({Title = "ANTI LOOK"})

local AntiLookToggle = PlayerTab:Toggle({
    Title = "Anti Look",
    Desc = "ป้องกันล็อคเป้า + คนอื่นเห็นตัวสั่น",
    Default = false,
    Callback = function(state)
        toggleAntiLook(state)
    end
})

PlayerTab:Slider({
    Title = "Strength",
    Desc = "ความแรงในการสั่น",
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
    Desc = "ความเร็วในการสั่น",
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

-- กันตาย
PlayerTab:Section({Title = "กันตาย"})

local AntiDeathToggle = PlayerTab:Toggle({
    Title = "กันตาย",
    Desc = "เลือด < 30: ลงใต้พื้นอัตโนมัติ | เลือด >= 30: กลับขึ้นมา",
    Default = false,
    Callback = function(state)
        antiDeathEnabled = state
        if not state and antiDeathActive then
            antiDeathActive = false
            returnFromSafeZone()
        end
    end
})

PlayerTab:Divider()

-- ดูดของ
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

-- ========== ESP TAB ==========
ESPTab:Section({Title = "BOX ESP"})

local BoxESPToggle = ESPTab:Toggle({
    Title = "ESP Box",
    Desc = "แสดงกล่องครอบผู้เล่น (สีรุ้ง)",
    Default = false,
    Callback = function(state)
        ShowBoxESP = state
    end
})

ESPTab:Divider()

ESPTab:Section({Title = "NAME ESP"})

local NameESPToggle = ESPTab:Toggle({
    Title = "ESP Name",
    Desc = "แสดงชื่อผู้เล่น",
    Default = false,
    Callback = function(state)
        ShowNameESP = state
    end
})

ESPTab:Divider()

ESPTab:Button({
    Title = "ESP Info",
    Desc = "Box (สีรุ้ง) | Name",
    Callback = function() end
})

-- ========== PVP TAB ==========
PVPTab:Section({Title = "SILENT AIM"})

local SilentAimToggle = PVPTab:Toggle({
    Title = "Silent Aim",
    Desc = "เปิดใช้งาน Silent Aim (FOV 8 เหลี่ยมสีรุ้ง)",
    Default = false,
    Callback = function(state)
        getgenv().SilentAimEnabled = state
    end
})

PVPTab:Slider({
    Title = "FOV Radius",
    Desc = "ปรับขนาดวงเล็ง",
    Step = 5,
    Value = {
        Min = 50,
        Max = 500,
        Default = 300
    },
    Callback = function(value)
        getgenv().FOV_Radius = value
    end
})

PVPTab:Dropdown({
    Title = "Aim Part",
    Desc = "เลือกส่วนที่ต้องการเล็ง",
    Values = {"Head", "HumanoidRootPart"},
    Default = 1,
    Callback = function(value)
        getgenv().AimPart = value
    end
})

PVPTab:Slider({
    Title = "Prediction",
    Desc = "ความแม่นยำ (0.10 - 0.25)",
    Step = 0.01,
    Value = {
        Min = 0.10,
        Max = 0.25,
        Default = 0.14
    },
    Callback = function(value)
        getgenv().Prediction = value
    end
})

PVPTab:Slider({
    Title = "Rainbow Speed",
    Desc = "ความเร็วในการเปลี่ยนสี",
    Step = 0.5,
    Value = {
        Min = 1,
        Max = 5,
        Default = 2
    },
    Callback = function(value)
        getgenv().RGB_Speed = value
    end
})

PVPTab:Divider()

PVPTab:Button({
    Title = "Wallbang Info",
    Desc = "Shotgun: ปิดตลอด | ปืนอื่น: เปิดเมื่อเป้าหลังกำแพง",
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
        -- ถ้าเปิดอยู่ ให้ใช้โหมดใหม่ทันที (ทำงานครั้งเดียว)
        if fpsBoosterEnabled then
            applyFPSBooster(fpsBoosterMode)
        end
    end
})

CustomTab:Divider()

CustomTab:Button({
    Title = "Mode Description",
    Desc = "โหมด 1: ลบหมอก | โหมด 2: +ลบแสงเงา | โหมด 3: +ลบ Effect + Terrain เรียบ",
    Callback = function() end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ (Silent Aim + Wallbang อัตโนมัติ)",
    Duration = 3
})