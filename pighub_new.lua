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
CustomTab:Section({Title = "KEY INFO"})

local _keyInfoVisible = true
CustomTab:Toggle({
    Title = "แสดงเวลาคีย์",
    Desc = "เปิด/ปิดแถบแสดงเวลาคีย์",
    Default = true,
    Callback = function(v)
        _keyInfoVisible = v
        task.spawn(function()
            local cg = game:GetService("CoreGui")
            local gui = cg:FindFirstChild("PigHubKeyInfo")
            if gui then gui.Enabled = v end
        end)
    end
})

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
