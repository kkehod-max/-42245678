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
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== ระบบ Bypass กันแบน (จาก god2.txt - รันเบื้องหลัง) ==========
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
        
        -- Bypass การคลิก
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
    
    -- เรียกใช้ bypass
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
    
    -- Bypass Emotes UI
    task.spawn(function()
        local success, EmotesUI = pcall(function()
            return require(ReplicatedStorage.Modules.Game.Emotes.EmotesUI)
        end)
        local success2, EmotesList = pcall(function()
            return require(ReplicatedStorage.Modules.Game.Emotes.EmotesList)
        end)
        local success3, CoreUI = pcall(function()
            return require(ReplicatedStorage.Modules.Core.UI)
        end)
        
        if success and success2 and success3 then
            for _, emote in pairs(EmotesList) do
                local button = CoreUI.get("EmoteTemplate").Parent:FindFirstChild(emote.name)
                if button then
                    if button:FindFirstChild("UnlocksAtText") then
                        button.UnlocksAtText.Visible = false
                    end
                    if button:FindFirstChild("EmoteName") then
                        button.EmoteName.Visible = true
                    end
                    CoreUI.on_click(button, function() end)
                end
            end
        end
    end)
    
    -- Bypass Tween (จาก god2.txt)
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
    
    -- Bypass BuyPrompt
    task.spawn(function()
        local success, BuyPromptUI = pcall(function()
            return require(ReplicatedStorage.Modules.Game.UI.BuyPromptUI)
        end)
        if success then
            local sellBtn = BuyPromptUI.get("SellPromptSellButton")
            if sellBtn then
                local hold = sellBtn:FindFirstChild("HoldStroke", true)
                if hold then
                    hold.Enabled = false
                    local uiGrad = hold:FindFirstChildOfClass("UIGradient")
                    if uiGrad then
                        uiGrad.Enabled = false
                    end
                end
                for _, v in pairs(sellBtn:GetDescendants()) do
                    if v:IsA("NumberValue") then
                        v.Value = 1
                    end
                end
            end
        end
    end)
end

-- เรียกใช้ระบบ Bypass (รันเบื้องหลัง)
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

local ANTI_LOOK_SETTINGS = {
    enabled = false,
    skyAmount = 3000,
    visualShakeIntensity = 200,
    visualShakeSpeed = 50,
    visualYMin = -200,
    visualYMax = 500
}

RunService.Heartbeat:Connect(function()
    if not ANTI_LOOK_SETTINGS.enabled then return end
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local originalVel = hrp.Velocity
    local angle = math.rad(tick() * 1500 % 360)
    local x = math.cos(angle) * ANTI_LOOK_SETTINGS.skyAmount
    local z = math.sin(angle) * ANTI_LOOK_SETTINGS.skyAmount
    local yVel = math.random(280, 480)

    hrp.Velocity = Vector3.new(x, yVel, z)
    RunService.RenderStepped:Wait()
    hrp.Velocity = originalVel
end)

local decoyParts = {}
local visualShakeConnection = nil

local function createDecoy()
    for _, part in ipairs(decoyParts) do
        pcall(function() part:Destroy() end)
    end
    decoyParts = {}
    
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            local decoy = Instance.new("Part")
            decoy.Name = "VisualDecoy_" .. part.Name
            decoy.Size = part.Size
            decoy.CFrame = part.CFrame
            decoy.Color = part.Color
            decoy.Material = part.Material
            decoy.Transparency = 0.5
            decoy.Anchored = true
            decoy.CanCollide = false
            decoy.Parent = workspace
            table.insert(decoyParts, decoy)
        end
    end
end

local function updateVisualShake()
    if not ANTI_LOOK_SETTINGS.enabled then
        for _, part in ipairs(decoyParts) do
            pcall(function() part:Destroy() end)
        end
        decoyParts = {}
        if visualShakeConnection then
            visualShakeConnection:Disconnect()
            visualShakeConnection = nil
        end
        return
    end
    
    if #decoyParts == 0 then
        createDecoy()
    end
    
    if visualShakeConnection then
        visualShakeConnection:Disconnect()
    end
    
    visualShakeConnection = RunService.Heartbeat:Connect(function()
        if not ANTI_LOOK_SETTINGS.enabled then
            if visualShakeConnection then
                visualShakeConnection:Disconnect()
                visualShakeConnection = nil
            end
            return
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local time = tick() * ANTI_LOOK_SETTINGS.visualShakeSpeed
        
        for i, part in ipairs(decoyParts) do
            local originalPart = char:FindFirstChild(part.Name:gsub("VisualDecoy_", ""))
            if originalPart and originalPart:IsA("BasePart") then
                local shakeX = math.sin(time + i) * ANTI_LOOK_SETTINGS.visualShakeIntensity * 2
                local shakeZ = math.cos(time * 1.3 + i) * ANTI_LOOK_SETTINGS.visualShakeIntensity * 2
                
                local yOffset = 0
                local rand = math.random()
                if rand > 0.8 then
                    yOffset = ANTI_LOOK_SETTINGS.visualYMin
                elseif rand > 0.6 then
                    yOffset = ANTI_LOOK_SETTINGS.visualYMax
                elseif rand > 0.3 then
                    yOffset = math.sin(time * 2.5 + i) * ANTI_LOOK_SETTINGS.visualShakeIntensity * 3
                end
                
                part.CFrame = originalPart.CFrame * CFrame.new(shakeX, yOffset, shakeZ)
            end
        end
    end)
end

local function toggleAntiLookUltimate(state)
    ANTI_LOOK_SETTINGS.enabled = state
    updateVisualShake()
    
    if state then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ANTI LOOK",
            Text = "เปิดใช้งานแล้ว",
            Duration = 2
        })
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if ANTI_LOOK_SETTINGS.enabled then
        createDecoy()
    end
end)

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
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "กันตาย",
        Text = "เลือดน้อยกว่า 30 ลงใต้พื้นแล้ว",
        Duration = 2
    })
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
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "กันตาย",
        Text = "เลือดมากกว่า 30 กลับขึ้นพื้น",
        Duration = 2
    })
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

-- รัน resizeZones ทุกครั้งที่มีไอเท็มใหม่
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
                -- ส่งคำขอเก็บของ
                pcall(function()
                    remoteGet:InvokeServer("pickup_dropped_item", item)
                end)
                
                -- ทำให้ไอเท็มลอยมาหา
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

-- ========== ระบบ SILENT AIM (แก้ไขใหม่) ==========
local silentAimEnabled = false
local FOVRadius = 150
local SelectedAimPart = "Head"
local Prediction = 0.14
local CurrentTarget = nil

-- สร้าง FOV 8 เหลี่ยม
local FOVLines = {}
for i = 1, 8 do
    FOVLines[i] = Drawing.new("Line")
    FOVLines[i].Thickness = 2
    FOVLines[i].Visible = false
    FOVLines[i].Transparency = 1
end

-- เส้นชี้เป้า
local Tracer = Drawing.new("Line")
Tracer.Thickness = 2
Tracer.Transparency = 1
Tracer.Visible = false

-- ระบบติดตามความเร็ว (Prediction)
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

local function predictPosition(targetPart)
    if not targetPart then return Vector3.zero end
    
    local character = targetPart.Parent
    local player = character and Players:GetPlayerFromCharacter(character)
    if not player then return targetPart.Position end
    
    local velocity = calculateVelocity(player) or Vector3.zero
    return targetPart.Position + (velocity * Prediction)
end

local function getRainbowColor(offset)
    local time = tick() * 2
    return Color3.fromHSV((time + offset) % 1, 1, 1)
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(SelectedAimPart)
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart and humanoid and humanoid.Health > 0 and hrp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                    local distanceFromCenter = (screenVector - center).Magnitude
                    
                    if distanceFromCenter <= FOVRadius then
                        if distanceFromCenter < shortestDistance then
                            shortestDistance = distanceFromCenter
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Hook Remote สำหรับ Silent Aim
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local send = remotes:WaitForChild("Send")

local oldFire
if send and send.FireServer then
    oldFire = hookfunction(send.FireServer, function(self, ...)
        local args = {...}
        
        if silentAimEnabled and CurrentTarget and CurrentTarget.Character then
            local targetPart = CurrentTarget.Character:FindFirstChild(SelectedAimPart)
            if targetPart then
                local aimPos = predictPosition(targetPart)
                
                -- แก้ไข CFrame การยิง
                if args[4] and typeof(args[4]) == "CFrame" then
                    local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                    if myHead then
                        args[4] = CFrame.new(myHead.Position, aimPos)
                    end
                end
                
                -- แก้ไข HitPart
                if args[5] and args[5][1] and args[5][1][1] then
                    args[5][1][1]["Instance"] = targetPart
                    args[5][1][1]["Position"] = aimPos
                end
            end
        end
        
        return oldFire(self, unpack(args))
    end)
end

-- อัปเดต FOV และ Tracer ทุกเฟรม
RunService.RenderStepped:Connect(function()
    -- รีเซ็ต FOV ทุกครั้ง
    for i = 1, 8 do
        FOVLines[i].Visible = false
    end
    Tracer.Visible = false
    
    if silentAimEnabled then
        -- หาเป้าใกล้สุด
        CurrentTarget = getClosestTarget()
        
        -- วาด FOV 8 เหลี่ยมสีรุ้ง (แม้ไม่มีเป้า)
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local radius = FOVRadius
        
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
            FOVLines[i].Color = getRainbowColor(i * 0.1)
            FOVLines[i].Visible = true
        end
        
        -- วาดเส้นชี้เป้าสีรุ้ง (ถ้ามีเป้า)
        if CurrentTarget and CurrentTarget.Character then
            local targetPart = CurrentTarget.Character:FindFirstChild(SelectedAimPart)
            if targetPart then
                local aimPos = predictPosition(targetPart)
                local screenPos, onScreen = Camera:WorldToViewportPoint(aimPos)
                
                if onScreen then
                    Tracer.From = center
                    Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    Tracer.Color = getRainbowColor(0)
                    Tracer.Visible = true
                end
            end
        end
    end
end)

-- ========== ระบบ ESP (ปรับปรุงใหม่) ==========
local espEnabled = false
local espPlayers = {}
local espConnections = {}

local function getRainbowColorForLine(lineIndex)
    local time = tick() * 1.5
    -- แต่ละเส้นได้ offset ต่างกัน
    local offsets = {
        top = 0,
        bottom = 0.25,
        left = 0.5,
        right = 0.75
    }
    return Color3.fromHSV((time + offsets[lineIndex]) % 1, 1, 1)
end

-- ฟังก์ชันสร้าง ESP ให้ผู้เล่น
local function createESP(player)
    if player == LocalPlayer then return end
    
    -- ลบของเก่าถ้ามี
    if espPlayers[player] then
        for _, drawing in pairs(espPlayers[player]) do
            pcall(function() drawing:Remove() end)
        end
        espPlayers[player] = nil
    end
    
    -- สร้าง Text objects
    local nameText = Drawing.new("Text")
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.new(0, 0, 0)
    nameText.Color = Color3.new(1, 1, 1)
    nameText.Font = 2
    nameText.Visible = false
    
    local distanceText = Drawing.new("Text")
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.new(0, 0, 0)
    distanceText.Color = Color3.new(0.8, 0.8, 0.8)
    distanceText.Font = 2
    distanceText.Visible = false
    
    local healthText = Drawing.new("Text")
    healthText.Size = 14
    healthText.Center = true
    healthText.Outline = true
    healthText.OutlineColor = Color3.new(0, 0, 0)
    healthText.Color = Color3.new(0, 1, 0)
    healthText.Font = 2
    healthText.Visible = false
    
    -- เส้นกรอบ 4 เส้น (แต่ละเส้นสีต่างกัน)
    local boxTop = Drawing.new("Line")
    boxTop.Thickness = 2
    boxTop.Visible = false
    
    local boxBottom = Drawing.new("Line")
    boxBottom.Thickness = 2
    boxBottom.Visible = false
    
    local boxLeft = Drawing.new("Line")
    boxLeft.Thickness = 2
    boxLeft.Visible = false
    
    local boxRight = Drawing.new("Line")
    boxRight.Thickness = 2
    boxRight.Visible = false
    
    local drawings = {
        name = nameText,
        distance = distanceText,
        health = healthText,
        top = boxTop,
        bottom = boxBottom,
        left = boxLeft,
        right = boxRight
    }
    
    -- สร้าง connection สำหรับอัปเดตตำแหน่ง
    local connection = RunService.RenderStepped:Connect(function()
        if not espEnabled or not player or not player.Character then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            return
        end
        
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if not hrp or not humanoid or humanoid.Health <= 0 then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            return
        end
        
        -- คำนวณตำแหน่งบนหน้าจอ
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2, 0))
        if not onScreen or pos.Z <= 0 then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            return
        end
        
        -- คำนวณระยะทาง
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = myPos and (hrp.Position - myPos.Position).Magnitude or 0
        
        -- ขนาดกล่องคงที่ (ไม่ขึ้นกับระยะ)
        local boxWidth = 40
        local boxHeight = 60
        
        local centerX = pos.X
        local centerY = pos.Y - boxHeight/2 - 20  -- ยกขึ้นนิดหน่อย
        
        -- อัปเดตกล่อง
        local topLeft = Vector2.new(centerX - boxWidth/2, centerY)
        local topRight = Vector2.new(centerX + boxWidth/2, centerY)
        local bottomLeft = Vector2.new(centerX - boxWidth/2, centerY + boxHeight)
        local bottomRight = Vector2.new(centerX + boxWidth/2, centerY + boxHeight)
        
        -- แต่ละเส้นได้สีรุ้งไม่เหมือนกัน
        drawings.top.From = topLeft
        drawings.top.To = topRight
        drawings.top.Color = getRainbowColorForLine("top")
        drawings.top.Visible = true
        
        drawings.bottom.From = bottomLeft
        drawings.bottom.To = bottomRight
        drawings.bottom.Color = getRainbowColorForLine("bottom")
        drawings.bottom.Visible = true
        
        drawings.left.From = topLeft
        drawings.left.To = bottomLeft
        drawings.left.Color = getRainbowColorForLine("left")
        drawings.left.Visible = true
        
        drawings.right.From = topRight
        drawings.right.To = bottomRight
        drawings.right.Color = getRainbowColorForLine("right")
        drawings.right.Visible = true
        
        -- ชื่อ (เหนือหัว)
        drawings.name.Text = player.Name
        drawings.name.Position = Vector2.new(centerX, centerY - 20)
        drawings.name.Visible = true
        
        -- ระยะทาง (ใต้กล่อง)
        drawings.distance.Text = string.format("%.0fm", dist)
        drawings.distance.Position = Vector2.new(centerX, centerY + boxHeight + 20)
        drawings.distance.Visible = true
        
        -- สุขภาพ (ใต้เท้า)
        local footPos, footOnScreen = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        if footOnScreen then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local healthColor = Color3.new(1 - healthPercent, healthPercent, 0)
            drawings.health.Text = string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
            drawings.health.Position = Vector2.new(footPos.X, footPos.Y + 10)
            drawings.health.Color = healthColor
            drawings.health.Visible = true
        else
            drawings.health.Visible = false
        end
    end)
    
    espPlayers[player] = drawings
    espConnections[player] = connection
end

-- ฟังก์ชันลบ ESP
local function removeESP(player)
    if espPlayers[player] then
        for _, drawing in pairs(espPlayers[player]) do
            pcall(function() drawing:Remove() end)
        end
        espPlayers[player] = nil
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
end

-- ฟังก์ชันเปิด/ปิด ESP ทั้งหมด
local function toggleESP(state)
    espEnabled = state
    
    if state then
        -- สร้าง ESP ให้ผู้เล่นทั้งหมด
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                task.spawn(function() createESP(player) end)
            end
        end
    else
        -- ลบ ESP ทั้งหมด
        for player, _ in pairs(espPlayers) do
            removeESP(player)
        end
    end
end

-- เชื่อมต่อ Events
Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            createESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- อัปเดต ESP เมื่อตัวละครเปลี่ยน
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    end
end)

local PlayerTab = Window:Tab({Title = "PLAYER", Icon = "user"})
local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})
local PVPTab = Window:Tab({Title = "PVP", Icon = "crosshair"})

-- ========== PLAYER TAB ==========
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
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "INFINITE STAMINA",
                Text = "เปิดใช้งานแล้ว",
                Duration = 2
            })
        else
            getgenv().InfiniteStamina = false
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "INFINITE STAMINA",
                Text = "ปิดใช้งานแล้ว",
                Duration = 2
            })
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

local AntiLookUltimateToggle = PlayerTab:Toggle({
    Title = "Anti Look",
    Desc = "ป้องกันล็อคเป้า + คนอื่นเห็นตัวสั่น",
    Default = false,
    Callback = function(state)
        toggleAntiLookUltimate(state)
    end
})

PlayerTab:Divider()

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
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "กันตาย",
            Text = state and "เปิดใช้งานแล้ว" or "ปิดใช้งานแล้ว",
            Duration = 2
        })
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
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ดูดของ",
                Text = "เปิดใช้งานแล้ว",
                Duration = 2
            })
        else
            if magnetConnection then
                magnetConnection:Disconnect()
                magnetConnection = nil
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ดูดของ",
                Text = "ปิดใช้งานแล้ว",
                Duration = 2
            })
        end
    end
})

PlayerTab:Divider()

-- ========== ESP TAB ==========
ESPTab:Section({Title = "PLAYER ESP"})

local ESPToggle = ESPTab:Toggle({
    Title = "ESP Players",
    Desc = "แสดงกรอบ 4 เส้นสีรุ้ง | ชื่อ | ระยะทาง | สุขภาพใต้เท้า",
    Default = false,
    Callback = function(state)
        toggleESP(state)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ESP",
            Text = state and "เปิดใช้งานแล้ว" or "ปิดใช้งานแล้ว",
            Duration = 2
        })
    end
})

ESPTab:Divider()

ESPTab:Button({
    Title = "ESP Info",
    Desc = "กรอบ 4 เส้นสีรุ้ง | ชื่อเหนือหัว | ระยะใต้กล่อง | สุขภาพใต้เท้า",
    Callback = function() end
})

-- ========== PVP TAB ==========
PVPTab:Section({Title = "SILENT AIM"})

local SilentAimToggle = PVPTab:Toggle({
    Title = "Silent Aim",
    Desc = "เปิดใช้งาน Silent Aim (FOV 8 เหลี่ยมสีรุ้ง)",
    Default = false,
    Callback = function(state)
        silentAimEnabled = state
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SILENT AIM",
            Text = state and "เปิดใช้งานแล้ว (สีรุ้ง)" or "ปิดใช้งานแล้ว",
            Duration = 2
        })
    end
})

PVPTab:Slider({
    Title = "FOV Radius",
    Desc = "ปรับขนาดวงเล็ง",
    Step = 5,
    Value = {
        Min = 50,
        Max = 500,
        Default = 150
    },
    Callback = function(value)
        FOVRadius = value
    end
})

PVPTab:Dropdown({
    Title = "Aim Part",
    Desc = "เลือกส่วนที่ต้องการเล็ง",
    Values = {"Head", "HumanoidRootPart"},
    Default = 1,
    Callback = function(value)
        SelectedAimPart = value
    end
})

PVPTab:Slider({
    Title = "Prediction",
    Desc = "ความแม่นยำ (0.05 - 0.35)",
    Step = 0.01,
    Value = {
        Min = 0.05,
        Max = 0.35,
        Default = 0.14
    },
    Callback = function(value)
        Prediction = value
    end
})

PVPTab:Divider()

PVPTab:Button({
    Title = "FOV Info",
    Desc = "FOV 8 เหลี่ยมสีรุ้ง | เส้นชี้เป้าสีรุ้ง",
    Callback = function() end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ (ESP สีรุ้ง + Silent Aim)",
    Duration = 3
})