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

-- ========== ระบบวิ่งเร็ว (ปรับใหม่ ช้าลง) ==========
local walkSpeedEnabled = false
local speedMultiplier = 3
local walkConnection = nil
local walkQueue = Vector3.new(0,0,0)
local STEP_SPEED = 0.12

local function setupWalkSpeed(char)
    if walkConnection then
        walkConnection:Disconnect()
        walkConnection = nil
    end
    
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return end
    
    walkConnection = RunService.Heartbeat:Connect(function()
        if not walkSpeedEnabled or not char or not hrp or not humanoid then return end
        if humanoid.Health <= 0 then return end
        
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0.01 then
            local targetMove = moveDir * (speedMultiplier * 0.08)
            walkQueue = walkQueue + targetMove
            
            while walkQueue.Magnitude > STEP_SPEED do
                local moveStep = walkQueue.Unit * STEP_SPEED
                hrp.CFrame = hrp.CFrame + moveStep
                walkQueue = walkQueue - moveStep
                task.wait()
            end
        else
            walkQueue = Vector3.new(0,0,0)
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

-- ========== ระบบ ANTI-LOOK (แรงขึ้น ป้องกันโปร) ==========
getgenv().AntiLookEnabled = false
getgenv().AntiLookStrength = 2500
getgenv().AntiLookSpeed = 2000
getgenv().AntiLookRandomness = 3

local AntiLookConnections = {}
local AntiLookParts = {}

local function setupAntiLook()
    local heartbeatConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        if not LocalPlayer.Character then return end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- ดึงทุกส่วนของตัวละครมาสั่นพร้อมกัน
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part ~= hrp then
                local angle = math.rad(tick() * getgenv().AntiLookSpeed % 360)
                local strength = getgenv().AntiLookStrength
                
                -- ทำให้แต่ละส่วนสั่นไม่พร้อมกัน
                local partAngle = angle + (part.Name:len() * 0.5)
                local xOffset = math.cos(partAngle) * strength
                local zOffset = math.sin(partAngle) * strength
                local yOffset = math.sin(partAngle * 2) * (strength * 0.3)
                
                -- บันทึก CFrame เดิมแล้วคืนค่าทีหลัง
                local originalCF = part.CFrame
                part.CFrame = part.CFrame * CFrame.new(xOffset, yOffset, zOffset)
                
                -- คืนค่าในเฟรมถัดไป
                task.spawn(function()
                    RunService.RenderStepped:Wait()
                    part.CFrame = originalCF
                end)
            end
        end
        
        -- สั่น HumanoidRootPart แรงๆ
        local originalVel = hrp.Velocity
        local angle = math.rad(tick() * getgenv().AntiLookSpeed % 360)
        local x = math.cos(angle) * getgenv().AntiLookStrength
        local z = math.sin(angle) * getgenv().AntiLookStrength
        local y = math.random(300, 600) * (math.sin(angle * 2) + 1)
        
        hrp.Velocity = Vector3.new(x, y, z)
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

-- ========== ระบบกันตาย (ลึกขึ้น + ค้างถาวร) ==========
local antiDeathEnabled = false
local antiDeathActive = false
local antiDeathConnection = nil
local safePosition = nil
local SAFE_DEPTH = 35 -- ลึกขึ้น
local GROUND_CHECK_DEPTH = 50

local function findGroundHeight(pos)
    local ray = Ray.new(pos + Vector3.new(0, 20, 0), Vector3.new(0, -GROUND_CHECK_DEPTH, 0))
    local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit and hitPos.Y or pos.Y - SAFE_DEPTH
end

local function enterSafeMode()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- ดึงทั้งตัวละครลงไปใต้พื้น
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
        end
    end
    
    local groundY = findGroundHeight(hrp.Position)
    safePosition = Vector3.new(hrp.Position.X, groundY - SAFE_DEPTH, hrp.Position.Z)
    
    -- วาร์ปทั้งตัวลงไป
    hrp.CFrame = CFrame.new(safePosition)
    
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = false
        char.Humanoid.PlatformStand = true
    end
    
    -- ทำให้ทุกส่วน Anchored เพื่อป้องกันการดึงกลับ
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = true
        end
    end
    
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
    end
    
    -- คอยตรวจจับและดึงกลับตลอด
    antiDeathConnection = RunService.Heartbeat:Connect(function()
        if not antiDeathActive or not antiDeathEnabled then return end
        
        local currentChar = LocalPlayer.Character
        if not currentChar then return end
        
        local currentHRP = currentChar:FindFirstChild("HumanoidRootPart")
        if not currentHRP then return end
        
        -- รีแอนชัวร์ทุกส่วนตลอด
        for _, part in ipairs(currentChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        
        local currentGround = findGroundHeight(currentHRP.Position)
        local targetY = currentGround - SAFE_DEPTH
        
        -- ถ้าถูกดึงกลับ ให้ดึงลงมาอีก
        if currentHRP.Position.Y > targetY + 3 then
            currentHRP.CFrame = CFrame.new(Vector3.new(currentHRP.Position.X, targetY, currentHRP.Position.Z))
        end
        
        -- เคลื่อนที่ช้าๆ ใต้พื้น
        local time = tick() * 1.5
        local offset = Vector3.new(
            math.sin(time) * 5,
            math.sin(time * 2) * 2,
            math.cos(time) * 5
        )
        currentHRP.CFrame = CFrame.new(safePosition + offset)
    end)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "กันตาย",
        Text = "ลงใต้พื้นแล้ว (ลึก " .. SAFE_DEPTH .. " หน่วย)",
        Duration = 2
    })
end

local function exitSafeMode()
    antiDeathActive = false
    if antiDeathConnection then
        antiDeathConnection:Disconnect()
        antiDeathConnection = nil
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    -- ปลด Anchored ทุกส่วน
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
        end
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local groundY = findGroundHeight(hrp.Position)
    local returnPos = Vector3.new(hrp.Position.X, groundY + 3, hrp.Position.Z)
    
    hrp.CFrame = CFrame.new(returnPos)
    
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "กันตาย",
        Text = "กลับขึ้นพื้น",
        Duration = 2
    })
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

-- ========== ระบบ SILENT AIM ==========
getgenv().SilentAimEnabled = false
getgenv().FOV_Radius = 300
getgenv().AimPart = "Head"
getgenv().Prediction = 0.14
getgenv().RGB_Speed = 2

local FOVLines = {}
for i = 1, 8 do
    FOVLines[i] = Drawing.new("Line")
    FOVLines[i].Thickness = 2
    FOVLines[i].Visible = false
    FOVLines[i].Color = Color3.fromRGB(255, 255, 255)
end

local Tracer = Drawing.new("Line")
Tracer.Thickness = 2
Tracer.Visible = false
Tracer.Color = Color3.fromRGB(255, 0, 0)

local function GetRainbowColor(offset)
    local time = tick() * getgenv().RGB_Speed
    return Color3.fromHSV((time + offset) % 1, 1, 1)
end

local function isShotgun()
    local char = LocalPlayer.Character
    if not char then return false end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local ammoType = tool:GetAttribute("AmmoType")
            if ammoType == "shotgun" or ammoType == "shootgun" then
                return true
            end
            
            local name = tool.Name:lower()
            if name:find("shotgun") or name:find("shootgun") or name:find("spas") or name:find("db") then
                return true
            end
        end
    end
    return false
end

local function isBehindWall(startPos, targetPos, targetChar)
    if not startPos or not targetPos then return false end
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    if distance < 1 then return false end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    
    local result = workspace:Raycast(startPos, direction, params)
    
    return result ~= nil
end

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
                    
                    local shotgun = isShotgun()
                    local behindWall = isBehindWall(myPos, targetPart.Position, targetPlayer.Character)
                    
                    local wallbangEnabled = false
                    
                    if shotgun then
                        wallbangEnabled = false
                    else
                        wallbangEnabled = behindWall
                    end
                    
                    if args[4] and typeof(args[4]) == "CFrame" then
                        if wallbangEnabled then
                            args[4] = CFrame.new(myPos, aimPos) * CFrame.new(0, 0, -1000)
                        else
                            args[4] = CFrame.new(myPos, aimPos)
                        end
                    end
                    
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

RunService.RenderStepped:Connect(function()
    for i = 1, 8 do
        FOVLines[i].Visible = false
    end
    Tracer.Visible = false
    
    if getgenv().SilentAimEnabled then
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local radius = getgenv().FOV_Radius
        
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

-- ========== ระบบ ESP (ขนาดเล็ก คงที่) ==========
local ShowBoxESP = false
local ShowNameESP = false
local ShowHealthESP = false
local ShowDistanceESP = false
local ShowItemESP = false
local ShowGroundItemESP = false

-- Box ESP (ขนาดเล็ก คงที่)
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
local BOX_SIZE = 45 -- เล็กลง (จาก 80 เหลือ 45)

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
        line.Thickness=1.5 -- เล็กลง
        line.Visible=false
        line.ZIndex=1
    end
    PlayerBoxESP[player]={box=box,colorIndex=1,lastColorChange=tick()}
end

-- ... (ส่วน ESP ที่เหลือเหมือนเดิม แต่ใช้ BOX_SIZE = 45)

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

-- ========== ฟังก์ชันสีรุ้งสำหรับตัวเลขเงิน ==========
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
local PlayerTab = Window:Tab({Title = "PLAYER 👤", Icon = "user"})
local ESPTab = Window:Tab({Title = "ESP 👁️", Icon = "eye"})
local PVPTab = Window:Tab({Title = "PVP ⚔️", Icon = "crosshair"})
local QuestTab = Window:Tab({Title = "QUEST 📜", Icon = "flag"})
local CustomTab = Window:Tab({Title = "CUSTOM ⚙️", Icon = "settings"})

-- ========== PLAYER TAB ==========
PlayerTab:Section({Title = "💰 Player Stats"})

local BankBalance = PlayerTab:Button({
    Title = "🏦 Bank", 
    Desc = "<b><font color='#FF69B4'>$0</font></b>", 
    Callback = function() end
})

local HandBalance = PlayerTab:Button({
    Title = "💵 Cash", 
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

PlayerTab:Section({Title = "🎭 ซ่อนชื่อและเลเวล"})
PlayerTab:Button({
    Title = "เปิดใช้ระบบ",
    Desc = "คลิกเพื่อเปิดระบบซ่อนชื่อและเลเวล",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/3BxE2aGP/raw", true))()
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "🏃 MOVEMENT"})

local WalkSpeedToggle = PlayerTab:Toggle({
    Title = "Walk Speed",
    Desc = "เปิดใช้งานวิ่งเร็ว (ป้องกันดึงกลับ)",
    Default = false,
    Callback = function(state)
        walkSpeedEnabled = state
    end
})

local SpeedSlider = PlayerTab:Slider({
    Title = "Speed Multiplier",
    Desc = "ปรับความเร็ว (1-5) แนะนำ 3",
    Step = 0.5,
    Value = {
        Min = 1,
        Max = 5,
        Default = 3
    },
    Callback = function(value)
        speedMultiplier = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "⚡ INFINITE STAMINA"})

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

PlayerTab:Section({Title = "🦘 JUMP POWER"})

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

PlayerTab:Section({Title = "🪑 SIT SYSTEM"})

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

PlayerTab:Section({Title = "🛡️ ANTI LOOK (แรงขึ้น)"})

local AntiLookToggle = PlayerTab:Toggle({
    Title = "Anti Look",
    Desc = "ป้องกันล็อคเป้า (แรงขึ้น ป้องกันโปร)",
    Default = false,
    Callback = function(state)
        toggleAntiLook(state)
    end
})

PlayerTab:Slider({
    Title = "Strength",
    Desc = "ความแรงในการสั่น (2000-4000)",
    Step = 100,
    Value = {
        Min = 2000,
        Max = 4000,
        Default = 2500
    },
    Callback = function(value)
        getgenv().AntiLookStrength = value
    end
})

PlayerTab:Slider({
    Title = "Speed",
    Desc = "ความเร็วในการสั่น (1500-3000)",
    Step = 100,
    Value = {
        Min = 1500,
        Max = 3000,
        Default = 2000
    },
    Callback = function(value)
        getgenv().AntiLookSpeed = value
    end
})

PlayerTab:Divider()

PlayerTab:Section({Title = "💀 กันตาย (ลึกขึ้น)"})

local AntiDeathToggle = PlayerTab:Toggle({
    Title = "กันตาย",
    Desc = "เลือด < 30: ลงใต้พื้น (ลึก 35) | เลือด >= 30: กลับขึ้นมา",
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

PlayerTab:Section({Title = "🧲 ดูดของ"})

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
QuestTab:Section({Title = "📋 QUEST MANAGER"})

QuestTab:Button({
    Title = "🗑️ Clear All Quests",
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

QuestTab:Divider()

QuestTab:Button({
    Title = "ℹ️ Quest Info",
    Desc = "เคลียร์เควสทั้งหมดในหน้า Quests",
    Callback = function() end
})

-- ========== ESP TAB ==========
ESPTab:Section({Title = "👤 PLAYER ESP"})

local ESPBoxToggle = ESPTab:Toggle({
    Title = "ESP Box",
    Desc = "แสดงกล่องครอบผู้เล่น (สีรุ้ง) - ขนาดเล็ก คงที่",
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
ESPTab:Section({Title = "🎒 ITEM ESP"})

local ESPItemWeaponToggle = ESPTab:Toggle({
    Title = "ESP Item (Weapon)",
    Desc = "แสดงอาวุธที่ผู้เล่นถืออยู่เหนือหัว",
    Default = false,
    Callback = function(state)
        ShowItemESP = state
        if state then
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=LocalPlayer then
                    buildBillboard(player)
                end
            end
        else
            for _,billboard in pairs(ItemBillboards) do
                billboard:Destroy()
            end
            ItemBillboards = {}
        end
    end
})

local ESPGroundItemToggle = ESPTab:Toggle({
    Title = "ESP Ground Item",
    Desc = "แสดงชื่อและระยะของไอเท็มที่ตกอยู่บนพื้น",
    Default = false,
    Callback = function(state)
        getgenv().ItemESPEnabled = state
    end
})

local GroundItemDistSlider = ESPTab:Slider({
    Title = "Ground Item Distance",
    Desc = "ระยะที่จะแสดง Item ESP",
    Step = 25,
    Value = {
        Min = 50,
        Max = 1000,
        Default = 500
    },
    Callback = function(value)
        getgenv().ItemESPMaxDist = value
    end
})

ESPTab:Divider()

ESPTab:Button({
    Title = "ESP Info",
    Desc = "Box (เล็ก คงที่ 45) | Name | Health | Distance | Item Weapon | Ground Item",
    Callback = function() end
})

-- ========== PVP TAB ==========
PVPTab:Section({Title = "🎯 SILENT AIM"})

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
    Title = "🧱 Wallbang Info",
    Desc = "Shotgun: ปิดตลอด | ปืนอื่น: เปิดเมื่อเป้าหลังกำแพง",
    Callback = function() end
})

-- ========== CUSTOM TAB ==========
CustomTab:Section({Title = "🚀 FPS BOOSTER"})

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

CustomTab:Divider()

CustomTab:Button({
    Title = "Mode Description",
    Desc = "โหมด 1: ลบหมอก | โหมด 2: +ลบแสงเงา | โหมด 3: +ลบ Effect + Terrain เรียบ",
    Callback = function() end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ (Anti Look แรงขึ้น + กันตายลึกขึ้น + ESP เล็กลง)",
    Duration = 3
})