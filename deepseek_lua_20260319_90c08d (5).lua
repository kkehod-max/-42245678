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

-- ========== ส่วนของ MAIN UI และระบบต่างๆ ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- โหลด WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- สร้างหน้าต่างหลัก
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

-- ปุ่มเปิด/ปิด UI
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

-- ========== ระบบวิ่งเร็ว (จาก god2.txt) ==========
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

-- ========== ระบบกระโดดสูง ==========
local jumpEnabled = false
local jumpPower = 70
local jumpConnection = nil

-- ========== ระบบ Sit System ==========
local sitActive = false
local sitHeight = -3
local sitConnection = nil
local sitTimer = nil

local function stopSitSystem()
    sitActive = false
    if sitConnection then
        sitConnection:Disconnect()
        sitConnection = nil
    end
    if sitTimer then
        sitTimer:Cancel()
        sitTimer = nil
    end
    
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.Sit = false
    end
end

local function startSitSystem()
    stopSitSystem()
    
    local c = LocalPlayer.Character
    if not c or not c:FindFirstChild("Humanoid") then
        return
    end
    
    sitActive = true
    c.Humanoid.Sit = true
    
    sitConnection = RunService.Heartbeat:Connect(function()
        if sitActive and c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(0, sitHeight, 0)
        end
    end)
    
    sitTimer = task.delay(2, function()
        stopSitSystem()
    end)
end

-- ========== ระบบ ANTI LOOK ULTIMATE ==========
local ANTI_LOOK_SETTINGS = {
    enabled = false,
    skyAmount = 3000,
    visualShakeIntensity = 200,
    visualShakeSpeed = 50,
    visualYMin = -200,
    visualYMax = 500
}

-- ระบบ Anti Look แบบเดิม
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

-- ระบบ Visual Shake
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
            Title = "ANTI LOOK ULTIMATE",
            Text = "เปิดใช้งานแล้ว! (ตั้งค่าสูงสุด)",
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

-- ========== ระบบ AUTO UNDERWORLD (Auto Safe Mode) ==========
local autoUnderworldEnabled = false
local underworldActive = false
local underworldConnection = nil
local underworldPosition = nil
local UNDERWORLD_DEPTH = -250  -- ความลึกใต้พื้น
local FLY_SPEED = 200  -- ความเร็วในการบินวน
local FLY_RADIUS = 50  -- รัศมีในการบินวน

local function teleportToUnderworld()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    -- บันทึกตำแหน่งเดิมไว้ (เฉพาะ X, Z แต่ Y จะเป็นค่าใต้พื้น)
    underworldPosition = Vector3.new(hrp.Position.X, UNDERWORLD_DEPTH, hrp.Position.Z)
    
    -- วาร์ปไปใต้พื้น
    hrp.CFrame = CFrame.new(underworldPosition)
    
    -- ทำให้ Humanoid นั่งเพื่อไม่ให้ขยับเอง
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = true
    end
    
    -- สร้าง connection สำหรับบินวนใต้พื้น
    if underworldConnection then
        underworldConnection:Disconnect()
    end
    
    underworldConnection = RunService.Heartbeat:Connect(function()
        if not underworldActive or not autoUnderworldEnabled then
            return
        end
        
        local currentChar = LocalPlayer.Character
        if not currentChar or not currentChar:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local currentHRP = currentChar.HumanoidRootPart
        local time = tick() * 5  -- ความเร็วในการหมุน
        
        -- คำนวณตำแหน่งวงกลมเพื่อบินวน
        local circleX = math.cos(time) * FLY_RADIUS
        local circleZ = math.sin(time) * FLY_RADIUS
        
        -- ถ้า server ดึงตัวละครกลับขึ้นไปบนพื้น ให้วาร์ปกลับลงมาทันที
        if currentHRP.Position.Y > UNDERWORLD_DEPTH + 50 then
            currentHRP.CFrame = CFrame.new(underworldPosition)
        else
            -- บินวนเป็นวงกลมใต้พื้น
            local flyPos = Vector3.new(
                underworldPosition.X + circleX,
                UNDERWORLD_DEPTH + math.sin(time * 3) * 20,  -- ขยับขึ้นลงเล็กน้อย
                underworldPosition.Z + circleZ
            )
            currentHRP.CFrame = CFrame.new(flyPos)
        end
        
        -- เพิ่มความเร็วในการเคลื่อนที่ (ทำให้ดูเหมือนบินเร็ว)
        currentHRP.Velocity = Vector3.new(
            math.cos(time) * FLY_SPEED,
            math.sin(time * 2) * 30,
            math.sin(time) * FLY_SPEED
        )
    end)
end

local function returnFromUnderworld()
    underworldActive = false
    if underworldConnection then
        underworldConnection:Disconnect()
        underworldConnection = nil
    end
    
    local char = LocalPlayer.Character
    if char then
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.Sit = false
        end
        -- รีเซ็ตความเร็ว
        if char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

-- ฟังก์ชันตรวจสอบเลือดผู้เล่น
local function checkHealthAndAct()
    if not autoUnderworldEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local currentHealth = humanoid.Health
    
    -- ถ้าเลือดน้อยกว่า 30 และยังไม่ active ให้เปิดระบบ
    if currentHealth < 30 and currentHealth > 0 and not underworldActive then
        underworldActive = true
        teleportToUnderworld()
        
        -- แจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚠️ AUTO UNDERWORLD",
            Text = "เลือดน้อยกว่า 30! กำลังลงใต้พื้นอัตโนมัติ",
            Duration = 2
        })
        
    -- ถ้าเลือดมากกว่าหรือเท่ากับ 30 และกำลัง active อยู่ ให้ปิดระบบ
    elseif currentHealth >= 30 and underworldActive then
        underworldActive = false
        returnFromUnderworld()
        
        -- แจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ AUTO UNDERWORLD",
            Text = "เลือดมากกว่า 30 แล้ว กลับสู่พื้นผิว",
            Duration = 2
        })
    end
end

-- ตรวจสอบเลือดทุกเฟรม
RunService.Heartbeat:Connect(checkHealthAndAct)

-- ตรวจสอบเมื่อเลือดเปลี่ยน
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        checkHealthAndAct()
    end)
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        checkHealthAndAct()
    end)
end

-- ========== สร้าง TAB Player ==========
local PlayerTab = Window:Tab({Title = "PLAYER", Icon = "user"})

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

-- ========== ระบบ Jump Power ==========
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

-- ========== ระบบ Sit System ==========
PlayerTab:Section({Title = "SIT SYSTEM"})

PlayerTab:Button({
    Title = "🚀 ลงใต้พื้น 2 วิ",
    Desc = "กดปุ่มนี้เพื่อนั่งและลงใต้พื้นอัตโนมัติ (ปิดใน 2 วินาที)",
    Callback = function()
        startSitSystem()
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sit System",
            Text = "กำลังลงใต้พื้น... (ปิดอัตโนมัติใน 2 วินาที)",
            Duration = 1.5
        })
    end
})

local SitHeightSlider = PlayerTab:Slider({
    Title = "Sit Height",
    Desc = "ปรับระดับความลึก (ค่าติดลบ = ลง, ค่าบวก = ขึ้น)",
    Step = 0.1,
    Value = {
        Min = -5,
        Max = 4,
        Default = -3
    },
    Callback = function(value)
        sitHeight = value
    end
})

PlayerTab:Divider()

-- ========== ระบบ ANTI LOOK ULTIMATE ==========
PlayerTab:Section({Title = "ANTI LOOK ULTIMATE"})

local AntiLookUltimateToggle = PlayerTab:Toggle({
    Title = "🔥 ANTI LOOK ULTIMATE",
    Desc = "เปิดครั้งเดียว: ป้องกันล็อคเป้า + คนอื่นเห็นคุณสั่นจมดินขึ้นฟ้า",
    Default = false,
    Callback = function(state)
        toggleAntiLookUltimate(state)
    end
})

PlayerTab:Button({
    Title = "Current Settings",
    Desc = "<b><font color='#FF5500'>Server Shake: 3000  |  Visual Intensity: 200  |  Speed: 50<br>Underground: -200  |  Sky: 500</font></b>",
    Callback = function() end
})

PlayerTab:Divider()

-- ========== ระบบ AUTO UNDERWORLD (Auto Safe Mode) ==========
PlayerTab:Section({Title = "🛡️ AUTO UNDERWORLD"})

local AutoUnderworldToggle = PlayerTab:Toggle({
    Title = "Auto Underworld",
    Desc = "เลือด < 30: ลงใต้พื้นบินวนอัตโนมัติ | เลือด >= 30: กลับขึ้นมา",
    Default = false,
    Callback = function(state)
        autoUnderworldEnabled = state
        if not state and underworldActive then
            underworldActive = false
            returnFromUnderworld()
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "AUTO UNDERWORLD",
            Text = state and "✅ เปิดใช้งานแล้ว" or "❌ ปิดใช้งานแล้ว",
            Duration = 2
        })
    end
})

PlayerTab:Button({
    Title = "⚙️ Settings",
    Desc = "<b><font color='#FFAA00'>Blood Threshold: 30  |  Depth: -250  |  Fly Speed: 200</font></b>",
    Callback = function() end
})

PlayerTab:Divider()

-- แสดงสถานะทั้งหมด
PlayerTab:Button({
    Title = "Current Stats",
    Desc = "<b><font color='#00FF88'>Speed: " .. (speedValue * 20) .. "x  |  Jump: " .. jumpPower .. "  |  Sit: " .. sitHeight .. 
            "<br>Anti Look: " .. tostring(ANTI_LOOK_SETTINGS.enabled) .. 
            "  |  Auto Underworld: " .. tostring(autoUnderworldEnabled) .. 
            (underworldActive and "  |  🛡️ ACTIVE" or "") .. "</font></b>",
    Callback = function() end
})

-- แจ้งเตือนเมื่อโหลดสำเร็จ
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ! ระบบทั้งหมดพร้อมใช้งาน",
    Duration = 3
})