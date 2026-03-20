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
        Name = "",
        Image = "rbxassetid://117924028123190"
    },
    KeySystem = {
        Note = "PIG HUB — ซื้อคีย์ติดต่อแอดมิน",
        API = {
            {
                Type = "platoboost",
                ServiceId = 1930,
                Secret = "92633672-2f11-4637-87fe-6d825b425df7",
            },
        },
    },
})

-- ซ่อน OpenButton (ปุ่ม PIG HUB ลอยบนหน้าจอ) ผ่าน WindUI API
pcall(function() Window:EditOpenButton({Enabled = false}) end)
-- ซ่อนข้อความชื่อผู้เล่นใต้ UI ผ่าน WindUI API
task.spawn(function()
    task.wait(0.3)
    pcall(function()
        -- หา TextLabel ที่แสดง UserId/ชื่อใน SideBar แล้วซ่อน
        if Window and Window.SideBar then
            for _, obj in ipairs(Window.SideBar:GetDescendants()) do
                if obj:IsA("TextLabel") then
                    local t = obj.Text or ""
                    if t:find(tostring(LocalPlayer.UserId)) or t == LocalPlayer.Name or t == LocalPlayer.DisplayName then
                        obj.Text = ""
                        obj.Visible = false
                    end
                end
            end
        end
    end)
end)

local LogoGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
LogoGui.Name = "PigHub_Logo"
LogoGui.ResetOnSpawn = false
LogoGui.DisplayOrder = 999
local LogoBtn = Instance.new("ImageButton", LogoGui)
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0, 15, 1, -65)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Image = "rbxassetid://120437295686483"
LogoBtn.Active = true
LogoBtn.Draggable = true

local function ToggleUI()
    if Window.Toggle then 
        Window:Toggle() 
    else 
        Window.UI.Enabled = not Window.UI.Enabled 
    end
end
LogoBtn.MouseButton1Click:Connect(ToggleUI)
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

-- ========== ระบบวิ่งเร็ว ==========
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

-- ========== ระบบ ANTI LOOK ==========
getgenv().AntiLookEnabled = false
getgenv().AntiLookStrength = 12
local AntiLookConnection = nil

local function setupAntiLook()
    if AntiLookConnection then AntiLookConnection:Disconnect() end

    AntiLookConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrp or not head then return end

        -- บันทึก CFrame จริง
        local realHRPCF  = hrp.CFrame
        local realHeadCF = head.CFrame

        -- คำนวณตำแหน่งหลอก — สุ่มทิศทางรอบตัว
        local str = getgenv().AntiLookStrength
        local angle = math.rad(tick() * 800 % 360)
        local fakeOffset = Vector3.new(
            math.cos(angle) * str,
            math.random(-3, 3),
            math.sin(angle) * str
        )

        -- ย้าย HRP และ Head ไปตำแหน่งหลอก
        pcall(function() hrp.CFrame  = realHRPCF  + fakeOffset end)
        pcall(function() head.CFrame = realHeadCF + fakeOffset end)

        -- รอ 1 frame แล้วดึงกลับ
        RunService.RenderStepped:Wait()

        pcall(function() hrp.CFrame  = realHRPCF end)
        pcall(function() head.CFrame = realHeadCF end)
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
        -- คืน head กลับตำแหน่งจริงถ้าหลุด
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp  = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                if hrp and head then
                    head.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0)
                end
            end
        end)
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

-- ========== ระบบ SILENT AIM ==========
local SilentAimEnabled = false
local FOVRadius = 200
local CurrentTarget = nil
local SelectedAimPart = "Head"
local excludedPlayerNames = {}

local HISTORY_SIZE = 6
local PREDICT_FACTOR = 1.2
local SKY_Y_THRESHOLD = 150
local SMOOTH_ALPHA = 0.75
local PositionHistory = {}
local TracerSmoothedPos = Vector3.new()

local function isPlayerExcluded(playerName)
    for _, name in ipairs(excludedPlayerNames) do
        if name ~= "" and string.find(string.lower(playerName), string.lower(name)) then
            return true
        end
    end
    return false
end

local function getPing()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return 0.1 end
    local stats = gui:FindFirstChild("NetworkStats")
    if not stats then return 0.1 end
    local label = stats:FindFirstChild("PingLabel")
    if not label then return 0.1 end
    local num = tonumber(label.Text:match("%d+"))
    if not num then return 0.1 end
    local ping = num / 1000
    return (ping >= 0 and ping <= 2) and ping or 0.1
end

local function getClosestTarget()
    local closest = nil
    local shortestDist = FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if head and hum and hum.Health > 0 and hrp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist <= FOVRadius and dist < shortestDist and not isPlayerExcluded(player.Name) then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
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

Players.PlayerRemoving:Connect(function(p) PositionHistory[p] = nil end)

local function calculateVelocity(player)
    local hist = PositionHistory[player]
    if not hist or #hist < 2 then return Vector3.new() end
    local totalVel = Vector3.new()
    local count = 0
    for i = 2, #hist do
        local dt = hist[i].time - hist[i-1].time
        if dt > 0 then
            totalVel = totalVel + (hist[i].pos - hist[i-1].pos) / dt
            count = count + 1
        end
    end
    if count == 0 then return Vector3.new() end
    local avgVel = totalVel / count
    if avgVel.Y > SKY_Y_THRESHOLD then
        return Vector3.new(avgVel.X * 1.15, math.clamp(avgVel.Y * 0.85, 0, 400), avgVel.Z * 1.15)
    end
    return avgVel
end

local function predictPosition(targetPart, hrp)
    if not targetPart then return Vector3.zero end
    local char = targetPart.Parent
    local player = char and Players:GetPlayerFromCharacter(char)
    if not player then return targetPart.Position end
    local velocity = calculateVelocity(player) or Vector3.zero
    local ping = getPing()
    return targetPart.Position + (velocity * ping * PREDICT_FACTOR)
end

local function isBehindWall(startPos, endPos)
    if not startPos or not endPos then return false end
    local direction = endPos - startPos
    if direction.Magnitude < 1 then return false end
    local ignoreList = {}
    local myChar = LocalPlayer.Character
    if myChar then table.insert(ignoreList, myChar) end
    local tgtChar = CurrentTarget and CurrentTarget.Character
    if tgtChar then table.insert(ignoreList, tgtChar) end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(startPos, direction, params)
    return result ~= nil
end

local function isShotgun()
    if not LocalPlayer.Character then return false end
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local ammoType = tool:GetAttribute("AmmoType")
            if ammoType == "shotgun" or ammoType == "shootgun" then return true end
        end
    end
    return false
end

-- FOV แปดเหลี่ยมสีรุ้ง (8 เส้น)
local FOV_Lines = {}
for i = 1, 8 do
    FOV_Lines[i] = Drawing.new("Line")
    FOV_Lines[i].Thickness = 2
    FOV_Lines[i].Visible = false
end

-- เส้นชี้เป้าสีรุ้ง
local SA_Tracer = Drawing.new("Line")
SA_Tracer.Thickness = 1.5
SA_Tracer.Visible = false

-- แปดเหลี่ยมที่หัวเป้า (ปลายลูกศร)
local Target_Lines = {}
for i = 1, 8 do
    Target_Lines[i] = Drawing.new("Line")
    Target_Lines[i].Thickness = 1.5
    Target_Lines[i].Visible = false
end

local function hideFOV()
    for i = 1, 8 do
        FOV_Lines[i].Visible = false
        Target_Lines[i].Visible = false
    end
    SA_Tracer.Visible = false
end

RunService.RenderStepped:Connect(function()
    if not SilentAimEnabled then
        hideFOV()
        return
    end

    local t = tick()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- วาด FOV แปดเหลี่ยมสีรุ้งที่กึ่งกลางจอ
    for i = 1, 8 do
        local a1 = math.rad((i - 1) * 45)
        local a2 = math.rad(i * 45)
        FOV_Lines[i].From = center + Vector2.new(math.cos(a1) * FOVRadius, math.sin(a1) * FOVRadius)
        FOV_Lines[i].To   = center + Vector2.new(math.cos(a2) * FOVRadius, math.sin(a2) * FOVRadius)
        FOV_Lines[i].Color = Color3.fromHSV((t * 0.4 + i / 8) % 1, 1, 1)
        FOV_Lines[i].Visible = true
    end

    CurrentTarget = getClosestTarget()

    if CurrentTarget and CurrentTarget.Character then
        local char = CurrentTarget.Character
        local hum = char:FindFirstChild("Humanoid")
        local targetPart = char:FindFirstChild(SelectedAimPart) or char:FindFirstChild("Head")

        if hum and hum.Health > 0 and targetPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local tPos = Vector2.new(screenPos.X, screenPos.Y)

                -- เส้นชี้เป้าสีรุ้ง
                SA_Tracer.From = center
                SA_Tracer.To = tPos
                SA_Tracer.Color = Color3.fromHSV((t * 0.5) % 1, 1, 1)
                SA_Tracer.Visible = true

                -- แปดเหลี่ยมสีรุ้งที่หัวเป้า (ปลายลูกศร)
                local headTop, _ = Camera:WorldToViewportPoint(targetPart.Position + Vector3.new(0, 0.6, 0))
                local headBot, _ = Camera:WorldToViewportPoint(targetPart.Position - Vector3.new(0, 0.6, 0))
                local sz = math.clamp((Vector2.new(headTop.X, headTop.Y) - Vector2.new(headBot.X, headBot.Y)).Magnitude, 8, 28)

                for i = 1, 8 do
                    local a1 = math.rad((i - 1) * 45)
                    local a2 = math.rad(i * 45)
                    Target_Lines[i].From = tPos + Vector2.new(math.cos(a1) * sz, math.sin(a1) * sz)
                    Target_Lines[i].To   = tPos + Vector2.new(math.cos(a2) * sz, math.sin(a2) * sz)
                    Target_Lines[i].Color = Color3.fromHSV((t * 0.4 + i / 8) % 1, 1, 1)
                    Target_Lines[i].Visible = true
                end
            else
                SA_Tracer.Visible = false
                for i = 1, 8 do Target_Lines[i].Visible = false end
            end
        else
            SA_Tracer.Visible = false
            for i = 1, 8 do Target_Lines[i].Visible = false end
        end
    else
        SA_Tracer.Visible = false
        for i = 1, 8 do Target_Lines[i].Visible = false end
    end
end)

-- hookfunction Silent Aim
local _SA_Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send")
local _oldFire
pcall(function()
    _oldFire = hookfunction(_SA_Remote.FireServer, function(self, ...)
        if self ~= _SA_Remote then return _oldFire(self, ...) end
        local args = {...}
        if SilentAimEnabled and args[2] == "shoot_gun" and CurrentTarget then
            local char = CurrentTarget.Character
            local head = char and char:FindFirstChild("Head")
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChild("Humanoid")
            if head and hrp and hum and hum.Health > 0 then
                local aimPos = predictPosition(head, hrp)
                local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                local myPos  = myHead and myHead.Position

                if isShotgun() then
                    if myPos then args[4] = CFrame.new(myPos, aimPos) end
                    local pellets = {}
                    for i = 1, 6 do
                        local spread = Vector3.new(
                            math.random(-2,2)*0.03,
                            math.random(-2,2)*0.03,
                            math.random(-2,2)*0.03
                        )
                        table.insert(pellets, {{Instance=head, Normal=Vector3.new(0,1,0), Position=aimPos+spread}})
                    end
                    args[5] = pellets
                else
                    local blocked = myPos and isBehindWall(myPos, aimPos)
                    if myPos then
                        args[4] = blocked and CFrame.new(math.huge, math.huge, math.huge) or CFrame.new(myPos, aimPos)
                    end
                    args[5] = {{[1]={Instance=head, Normal=Vector3.new(0,1,0), Position=aimPos}}}
                end
            end
        end
        return _oldFire(self, unpack(args))
    end)
end)

-- ========== ระบบ GUN MOD ==========
local GunsFolder = ReplicatedStorage:WaitForChild("Items"):WaitForChild("gun")
local MeleeFolder2 = ReplicatedStorage:WaitForChild("Items"):WaitForChild("melee")

getgenv().FireRateValue  = 1000
getgenv().AccuracyValue  = 1
getgenv().RecoilValue    = 0
getgenv().DurabilityValue = 999999999
getgenv().AutoValue      = true
getgenv().GunModsAutoApply = false

local FistsBuffEnabled = false
local OriginalMeleeValues = {}

local function isGunTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return GunsFolder:FindFirstChild(tool.Name) ~= nil or tool.Name:match("Gun") or tool:FindFirstChild("Handle") ~= nil
end

local function applyGodGun(tool)
    if not tool or not isGunTool(tool) then return end
    pcall(function()
        tool:SetAttribute("fire_rate",  getgenv().FireRateValue)
        tool:SetAttribute("accuracy",   getgenv().AccuracyValue)
        tool:SetAttribute("Recoil",     getgenv().RecoilValue)
        tool:SetAttribute("Durability", getgenv().DurabilityValue)
        tool:SetAttribute("automatic",  getgenv().AutoValue)
    end)
    task.spawn(function()
        for _ = 1, 20 do
            local attrNames = tool:GetAttributes()
            local keys = {}
            for k in pairs(attrNames) do table.insert(keys, k) end
            table.sort(keys)
            if #keys >= 11 then
                local targetKey = keys[11]
                for _ = 1, 5 do
                    pcall(function() tool:SetAttribute(targetKey, true) end)
                    task.wait(0.01)
                end
            end
            task.wait(0.1)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not getgenv().GunModsAutoApply then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and isGunTool(tool) then
            pcall(applyGodGun, tool)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    repeat
        task.wait(0.1)
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then
                task.spawn(applyGodGun, tool)
            end
        end
    until not getgenv().GunModsAutoApply
end)

-- Melee Buff
local meleeNames2 = {}
for _, v in ipairs(MeleeFolder2:GetChildren()) do
    table.insert(meleeNames2, v.Name)
end

local function isMeleeTool2(tool)
    if not tool:IsA("Tool") then return false end
    if tool.Name == "Fists" then return true end
    for _, name in ipairs(meleeNames2) do
        if tool.Name == name then return true end
    end
    return false
end

local function modifyFists(tool, enable)
    if not tool then return end
    local attrs = tool:GetAttributes()
    local keys = {}
    for k in pairs(attrs) do table.insert(keys, k) end
    table.sort(keys)
    if #keys >= 7 then
        local k6, k7 = keys[6], keys[7]
        if enable then
            if OriginalMeleeValues[k6] == nil then OriginalMeleeValues[k6] = tool:GetAttribute(k6) end
            if OriginalMeleeValues[k7] == nil then OriginalMeleeValues[k7] = tool:GetAttribute(k7) end
            tool:SetAttribute(k6, 360)
            tool:SetAttribute(k7, 20)
        else
            if OriginalMeleeValues[k6] then tool:SetAttribute(k6, OriginalMeleeValues[k6]) end
            if OriginalMeleeValues[k7] then tool:SetAttribute(k7, OriginalMeleeValues[k7]) end
        end
    end
end

local function checkAndModifyFists()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not char or not bp then return end
    for _, t in ipairs(char:GetChildren()) do
        if isMeleeTool2(t) then modifyFists(t, FistsBuffEnabled) end
    end
    for _, t in ipairs(bp:GetChildren()) do
        if isMeleeTool2(t) then modifyFists(t, FistsBuffEnabled) end
    end
end

RunService.Heartbeat:Connect(function()
    if FistsBuffEnabled then checkAndModifyFists() end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if FistsBuffEnabled then checkAndModifyFists() end
end)

-- ========== ระบบ ESP ==========

-- ===== BOX ESP =====
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
local BOX_STATIC_COLORS = {
    green  = Color3.fromRGB(60,255,100),
    white  = Color3.fromRGB(255,255,255),
    red    = Color3.fromRGB(255,60,60),
    blue   = Color3.fromRGB(60,150,255),
    yellow = Color3.fromRGB(255,220,0),
}

local ShowBoxESP = false
local PlayerBoxESP = {}

local function getBoxColor(espData, lineKey)
    if BOX_COLOR_MODE == "rainbow" then
        local offsets = {top=0,bottom=2,left=4,right=6}
        return rainbowColors[((espData.colorIndex + (offsets[lineKey] or 0)) % #rainbowColors) + 1]
    end
    return BOX_STATIC_COLORS[BOX_COLOR_MODE] or Color3.fromRGB(255,255,255)
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
    box.top.Color=rainbowColors[1]
    box.bottom.Color=rainbowColors[3]
    box.left.Color=rainbowColors[5]
    box.right.Color=rainbowColors[7]
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

RunService.RenderStepped:Connect(function()
    if not ShowBoxESP then
        for _,espData in pairs(PlayerBoxESP) do
            if espData and espData.box then
                for _,line in pairs(espData.box) do line.Visible=false end
            end
        end
        return
    end
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
end)

for _,player in ipairs(Players:GetPlayers()) do
    if player~=LocalPlayer then task.spawn(function() createBoxESP(player) end) end
end
Players.PlayerAdded:Connect(function(player)
    if player~=LocalPlayer then task.wait(0.5) createBoxESP(player) end
end)
Players.PlayerRemoving:Connect(removeBoxESP)

-- ===== NAME ESP =====
local ShowNameESP = false
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
    if not ShowNameESP then
        for _,espData in pairs(PlayerNameESP) do
            if espData and espData.display then espData.display.Visible=false end
        end
        return
    end
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
end)

task.spawn(function()
    task.wait(0.1)
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LocalPlayer then createNameESP(player) end
    end
end)
Players.PlayerAdded:Connect(function(player)
    if player~=LocalPlayer then task.wait(0.05) createNameESP(player) end
end)
Players.PlayerRemoving:Connect(removeNameESP)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    for player,espData in pairs(PlayerNameESP) do
        if player and player.Character then
            espData.character=player.Character
            espData.hrp=player.Character:FindFirstChild("HumanoidRootPart")
        end
    end
end)

-- ===== ITEM WEAPON ESP (Billboard เหนือหัวผู้เล่น) =====
local ShowItemESP = false
local ItemBillboards = {}
local WeaponRegistry = {}
local RarityColorsBB = {
    Common=Color3.fromRGB(255,255,255),
    Uncommon=Color3.fromRGB(99,255,52),
    Rare=Color3.fromRGB(51,170,255),
    Epic=Color3.fromRGB(237,44,255),
    Legendary=Color3.fromRGB(255,150,0),
    Omega=Color3.fromRGB(255,20,51)
}

local function registerItemsFromContainer(container)
    for _,item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") then
            local handle=item:FindFirstChild("Handle")
            local displayName=item:GetAttribute("DisplayName") or item.Name
            local itemId=item:GetAttribute("ItemId") or item:GetAttribute("Id") or item.Name
            local rarity=item:GetAttribute("RarityName") or "Common"
            local imageId=item:GetAttribute("ImageId") or "rbxassetid://7072725737"
            local key
            if handle then
                local mesh=handle:FindFirstChildOfClass("SpecialMesh")
                if mesh and mesh.MeshId~="" then
                    key=mesh.MeshId..(mesh.TextureId or "").."_RARITY_"..rarity
                elseif handle:IsA("MeshPart") and handle.MeshId~="" then
                    key=handle.MeshId..(handle.TextureID or "").."_RARITY_"..rarity
                end
            end
            if not key and itemId~="" and itemId~=item.Name then
                key="ITEMID_"..itemId.."_RARITY_"..rarity
            end
            if not key then key="NAME_"..displayName.."_"..item.Name.."_RARITY_"..rarity end
            WeaponRegistry[key]={Name=displayName,Rarity=rarity,ImageId=imageId,ToolName=item.Name}
        end
    end
end

pcall(function()
    local items=ReplicatedStorage:WaitForChild("Items",5)
    if items then
        for _,folder in ipairs(items:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Model") then
                registerItemsFromContainer(folder)
            end
        end
    end
end)

local function getWeaponKey(tool)
    local handle=tool:FindFirstChild("Handle")
    local displayName=tool:GetAttribute("DisplayName") or tool.Name
    local itemId=tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
    local rarity=tool:GetAttribute("RarityName") or "Common"
    if handle then
        local mesh=handle:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId~="" then return mesh.MeshId..(mesh.TextureId or "").."_RARITY_"..rarity end
        if handle:IsA("MeshPart") and handle.MeshId~="" then return handle.MeshId..(handle.TextureID or "").."_RARITY_"..rarity end
    end
    if itemId~="" and itemId~=tool.Name then return "ITEMID_"..itemId.."_RARITY_"..rarity end
    return "NAME_"..displayName.."_"..tool.Name.."_RARITY_"..rarity
end

local function buildBillboard(player)
    if not ShowItemESP or player==LocalPlayer then return end
    local char=player.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if ItemBillboards[player] then ItemBillboards[player]:Destroy() ItemBillboards[player]=nil end
    local bb=Instance.new("BillboardGui")
    bb.Adornee=hrp
    bb.Size=UDim2.new(0,90,0,20)
    bb.StudsOffset=Vector3.new(0,-5,0)
    bb.AlwaysOnTop=true
    bb.Parent=char
    local layout=Instance.new("UIListLayout",bb)
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Padding=UDim.new(0,5)
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    local tools={}
    for _,slot in ipairs({"Backpack","StarterGear","StarterPack"}) do
        local bag=player:FindFirstChild(slot)
        if bag then
            for _,t in ipairs(bag:GetChildren()) do
                if t:IsA("Tool") and t.Name~="Fists" then table.insert(tools,t) end
            end
        end
    end
    for _,t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name~="Fists" then table.insert(tools,t) end
    end
    for _,tool in ipairs(tools) do
        local key=getWeaponKey(tool)
        local info=WeaponRegistry[key]
        if info then
            local img=Instance.new("ImageLabel",bb)
            img.Size=UDim2.new(0,20,0,20)
            img.BackgroundTransparency=0.1
            img.Image=info.ImageId
            img.BackgroundColor3=Color3.fromRGB(240,248,255)
            Instance.new("UICorner",img).CornerRadius=UDim.new(0,10)
            local stroke=Instance.new("UIStroke",img)
            stroke.Color=RarityColorsBB[info.Rarity] or Color3.new(1,1,1)
            stroke.Thickness=2
        end
    end
    ItemBillboards[player]=bb
end

local function clearBillboard(player)
    if ItemBillboards[player] then
        ItemBillboards[player]:Destroy()
        ItemBillboards[player]=nil
    end
end

local function refreshAllBillboards()
    for _,player in ipairs(Players:GetPlayers()) do
        clearBillboard(player)
        if ShowItemESP then buildBillboard(player) end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if ShowItemESP then buildBillboard(player) end
    end)
end)
Players.PlayerRemoving:Connect(clearBillboard)
for _,player in ipairs(Players:GetPlayers()) do
    if player~=LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if ShowItemESP then buildBillboard(player) end
        end)
    end
end

-- ===== ITEM DROP ESP (ของที่ตกบนพื้น) =====
getgenv().ItemESPEnabled=false
getgenv().ItemESPMaxDist=500
local ItemESPDrawings={}
local RarityColors={
    Common=Color3.fromRGB(255,255,255),Uncommon=Color3.fromRGB(100,255,100),
    Rare=Color3.fromRGB(0,150,255),Epic=Color3.fromRGB(180,50,255),
    Legendary=Color3.fromRGB(255,150,0),Omega=Color3.fromRGB(255,0,50)
}

local function UpdateItemESP()
    if not getgenv().ItemESPEnabled then
        for _,draw in pairs(ItemESPDrawings) do
            if draw.Dot then draw.Dot.Visible=false end
            if draw.Label then draw.Label.Visible=false end
        end
        return
    end
    local dropped=workspace:FindFirstChild("DroppedItems")
    if not dropped then return end
    local myRoot=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _,item in ipairs(dropped:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChild("PickUpZone") then
            local pz=item.PickUpZone
            local pos,onScreen=Camera:WorldToViewportPoint(pz.Position)
            local dist=(myRoot.Position-pz.Position).Magnitude
            if not ItemESPDrawings[item] then
                ItemESPDrawings[item]={Dot=Drawing.new("Circle"),Label=Drawing.new("Text")}
            end
            local draw=ItemESPDrawings[item]
            if onScreen and dist<getgenv().ItemESPMaxDist then
                local color=Color3.new(1,1,1)
                local ok,template=pcall(function() return ReplicatedStorage.Items:FindFirstChild(item.Name,true) end)
                if ok and template then color=RarityColors[template:GetAttribute("RarityName")] or color end
                draw.Dot.Visible=true draw.Dot.Position=Vector2.new(pos.X,pos.Y)
                draw.Dot.Radius=3 draw.Dot.Color=color
                draw.Dot.Filled=true draw.Dot.Transparency=0.5
                draw.Label.Visible=true draw.Label.Position=Vector2.new(pos.X,pos.Y-18)
                draw.Label.Text=string.format("%s [%dm]",item.Name,math.floor(dist))
                draw.Label.Color=color draw.Label.Size=13
                draw.Label.Center=true draw.Label.Outline=true
            else
                draw.Dot.Visible=false draw.Label.Visible=false
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateItemESP)
task.spawn(function()
    while task.wait(1) do
        for item,draw in pairs(ItemESPDrawings) do
            if not item or not item.Parent or not item:FindFirstChild("PickUpZone") then
                if draw.Dot then draw.Dot:Remove() end
                if draw.Label then draw.Label:Remove() end
                ItemESPDrawings[item]=nil
            end
        end
    end
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
local PlayerTab  = Window:Tab({Title = "PLAYER",  Icon = "user"})
local ESPTab     = Window:Tab({Title = "ESP",     Icon = "eye"})
local PVPTab     = Window:Tab({Title = "PVP",     Icon = "crosshair"})
local GunModTab  = Window:Tab({Title = "GUN MOD", Icon = "layers"})
local QuestTab   = Window:Tab({Title = "QUEST",   Icon = "flag"})
local CustomTab  = Window:Tab({Title = "CUSTOM",  Icon = "settings"})

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
    Desc = "ระยะหลอกตำแหน่ง (ค่ายิ่งมาก ยิ่งไกล)",
    Step = 1,
    Value = {
        Min = 1,
        Max = 30,
        Default = 12
    },
    Callback = function(value)
        getgenv().AntiLookStrength = value
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
ESPTab:Section({Title = "Box ESP"})

ESPTab:Toggle({
    Title = "ESP Box",
    Desc = "กล่องครอบผู้เล่น",
    Default = false,
    Callback = function(v)
        ShowBoxESP = v
        if v then
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=LocalPlayer and not PlayerBoxESP[player] then createBoxESP(player) end
            end
        end
    end
})

ESPTab:Dropdown({
    Title = "Box Color",
    Desc = "เลือกสีของ ESP Box",
    Values = {"Rainbow","Green","White","Red","Blue","Yellow"},
    Default = 1,
    Callback = function(v) BOX_COLOR_MODE = v:lower() end
})

ESPTab:Section({Title = "Name ESP"})

ESPTab:Toggle({
    Title = "ESP Name",
    Desc = "แสดงชื่อผู้เล่น",
    Default = false,
    Callback = function(v) ShowNameESP = v end
})

ESPTab:Section({Title = "Item Weapon ESP"})

ESPTab:Toggle({
    Title = "ESP Item",
    Desc = "แสดงอาวุธที่ผู้เล่นถืออยู่เหนือหัว",
    Default = false,
    Callback = function(v)
        ShowItemESP = v
        refreshAllBillboards()
    end
})

ESPTab:Section({Title = "ดูของที่ตกอยู่ที่พื้น"})

ESPTab:Toggle({
    Title = "Item ESP",
    Desc = "แสดงชื่อและระยะของไอเท็มที่ตกอยู่บนพื้น",
    Default = false,
    Callback = function(v) getgenv().ItemESPEnabled = v end
})

ESPTab:Slider({
    Title = "Item ESP Distance",
    Desc = "ระยะที่จะแสดง Item ESP",
    Step = 25,
    Value = {Min = 50, Max = 1000, Default = 500},
    Callback = function(v) getgenv().ItemESPMaxDist = v end
})

ESPTab:Divider()

-- ========== PVP TAB ==========
PVPTab:Section({Title = "SILENT AIM"})

PVPTab:Toggle({
    Title = "Silent Aim",
    Desc = "ล็อคเป้าอัตโนมัติ + FOV แปดเหลี่ยมสีรุ้ง",
    Default = false,
    Callback = function(v)
        SilentAimEnabled = v
        if not v then
            hideFOV()
            CurrentTarget = nil
        end
    end
})

PVPTab:Slider({
    Title = "FOV Radius",
    Desc = "ขนาดวงล็อคเป้า",
    Step = 10,
    Value = {Min = 50, Max = 600, Default = 200},
    Callback = function(v) FOVRadius = v end
})

PVPTab:Dropdown({
    Title = "Aim Part",
    Desc = "เลือกจุดที่ต้องการเล็ง",
    Values = {"Head", "HumanoidRootPart", "UpperTorso"},
    Default = 1,
    Callback = function(v) SelectedAimPart = v end
})

PVPTab:Input({
    Title = "Safe Friend",
    Desc = "ใส่ชื่อผู้เล่นที่ไม่ต้องการล็อค (คั่นด้วยช่องว่าง)",
    Placeholder = "ชื่อผู้เล่น...",
    Callback = function(v)
        excludedPlayerNames = {}
        for name in string.gmatch(v, "%S+") do
            table.insert(excludedPlayerNames, name)
        end
    end
})

PVPTab:Divider()

-- ========== GUN MOD TAB ==========
GunModTab:Section({Title = "GUN MODS"})

GunModTab:Toggle({
    Title = "Auto Apply",
    Desc = "ใส่ค่าปืนอัตโนมัติตลอดเวลา",
    Default = false,
    Callback = function(v)
        getgenv().GunModsAutoApply = v
    end
})

GunModTab:Button({
    Title = "Apply Now",
    Desc = "กดเพื่อใส่ค่าปืนทันที",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and isGunTool(tool) then
                task.spawn(applyGodGun, tool)
            end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and isGunTool(tool) then
                    task.spawn(applyGodGun, tool)
                end
            end
        end
    end
})

GunModTab:Divider()

GunModTab:Slider({
    Title = "Fire Rate",
    Desc = "ความเร็วในการยิง",
    Step = 10,
    Value = {Min = 100, Max = 3000, Default = 1000},
    Callback = function(v) getgenv().FireRateValue = v end
})

GunModTab:Slider({
    Title = "Accuracy",
    Desc = "ความแม่นยำ (1 = แม่นสุด)",
    Step = 0.01,
    Value = {Min = 0, Max = 1, Default = 1},
    Callback = function(v) getgenv().AccuracyValue = v end
})

GunModTab:Slider({
    Title = "Recoil",
    Desc = "แรงสะท้อน (0 = ไม่สะท้อน)",
    Step = 0.1,
    Value = {Min = 0, Max = 10, Default = 0},
    Callback = function(v) getgenv().RecoilValue = v end
})

GunModTab:Slider({
    Title = "Durability",
    Desc = "ความทนทานของอาวุธ",
    Step = 1000,
    Value = {Min = 1000, Max = 999999, Default = 999999},
    Callback = function(v) getgenv().DurabilityValue = v end
})

GunModTab:Toggle({
    Title = "Auto Fire",
    Desc = "เปิดโหมดยิงอัตโนมัติ",
    Default = true,
    Callback = function(v) getgenv().AutoValue = v end
})

GunModTab:Divider()

GunModTab:Section({Title = "MELEE MODS"})

GunModTab:Toggle({
    Title = "Melee Aura (Wide Fists)",
    Desc = "เพิ่มระยะและมุมโจมตีระยะประชิด",
    Default = false,
    Callback = function(v)
        FistsBuffEnabled = v
        checkAndModifyFists()
    end
})

-- ========== ระบบ PIGHUB EFFECT (ลูกบอลหมุนรอบตัว) ==========
local PigHubEffectEnabled = false
local effectBalls = {}
local effectConnection = nil
local BALL_COUNT = 8
local ORBIT_RADIUS = 5
local ORBIT_SPEED = 2.5
local BALL_SIZE = Vector3.new(0.35, 0.35, 0.35)
local effectColors = {
    Color3.fromRGB(255,0,100),
    Color3.fromRGB(255,100,0),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,100),
    Color3.fromRGB(0,150,255),
    Color3.fromRGB(150,0,255),
    Color3.fromRGB(255,0,200),
    Color3.fromRGB(255,255,255),
}

local function createEffectBalls()
    for _, b in ipairs(effectBalls) do pcall(function() b:Destroy() end) end
    effectBalls = {}
    for i = 1, BALL_COUNT do
        local ball = Instance.new("Part")
        ball.Size = BALL_SIZE
        ball.Shape = Enum.PartType.Ball
        ball.Anchored = true
        ball.CanCollide = false
        ball.CastShadow = false
        ball.Material = Enum.Material.Neon
        ball.Color = effectColors[i]
        ball.Name = "PigHubBall_" .. i
        ball.Parent = workspace
        table.insert(effectBalls, ball)
    end
end

local function removeEffectBalls()
    if effectConnection then effectConnection:Disconnect() effectConnection = nil end
    for _, b in ipairs(effectBalls) do pcall(function() b:Destroy() end) end
    effectBalls = {}
end

local function startEffect()
    createEffectBalls()
    local t0 = tick()
    effectConnection = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local t = tick() - t0
        local colorT = (t * 0.5) % 1
        for i, ball in ipairs(effectBalls) do
            if not ball or not ball.Parent then continue end
            local angle = (math.pi * 2 / BALL_COUNT) * (i - 1) + (t * ORBIT_SPEED)
            -- วงโคจรรูปวงรีเอียง 3 มิติ
            local x = math.cos(angle) * ORBIT_RADIUS
            local y = math.sin(angle * 0.7) * 1.8
            local z = math.sin(angle) * ORBIT_RADIUS
            ball.Position = hrp.Position + Vector3.new(x, y + 1, z)
            -- ไล่สีรุ้งแต่ละลูก
            ball.Color = Color3.fromHSV(((colorT + (i / BALL_COUNT)) % 1), 1, 1)
            -- ขนาดเต้นตามเวลา
            local pulse = 0.25 + math.abs(math.sin(t * 3 + i)) * 0.15
            ball.Size = Vector3.new(pulse, pulse, pulse)
        end
    end)
end

local function togglePigHubEffect(state)
    PigHubEffectEnabled = state
    if state then
        startEffect()
    else
        removeEffectBalls()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if PigHubEffectEnabled then
        task.wait(0.5)
        removeEffectBalls()
        startEffect()
    end
end)


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

CustomTab:Divider()
CustomTab:Section({Title = "PIGHUB EFFECT"})

CustomTab:Toggle({
    Title = "PIGHUB Effect",
    Desc = "ลูกบอลสีรุ้งหมุนรอบตัว",
    Default = false,
    Callback = function(state)
        togglePigHubEffect(state)
    end
})

CustomTab:Slider({
    Title = "ขนาดวงโคจร",
    Desc = "ระยะห่างของลูกบอลจากตัวละคร",
    Step = 0.5,
    Value = {Min = 2, Max = 12, Default = 5},
    Callback = function(v)
        ORBIT_RADIUS = v
    end
})

CustomTab:Slider({
    Title = "ความเร็วหมุน",
    Desc = "ความเร็วในการหมุนวงโคจร",
    Step = 0.5,
    Value = {Min = 0.5, Max = 8, Default = 2.5},
    Callback = function(v)
        ORBIT_SPEED = v
    end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ! Silent Aim + Gun Mod พร้อมใช้งาน",
    Duration = 3
})