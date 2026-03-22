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

-- ป้องกันดักจับ script
local _t = tick
local _r = require
local _h = game.HttpGet
local _p = pcall

-- ========== KEY SYSTEM ==========
local _RAW = "https://raw.githubusercontent.com/kkehod-max/-42245678/refs/heads/main/keys.json"
local _HS  = game:GetService("HttpService")
local _XK  = 42  -- XOR key

local function _xor(s)
    local r = ""
    for i = 1, #s do r = r .. string.char(bit32.bxor(string.byte(s,i), _XK)) end
    return r
end

local function _getHWID()
    local id = "?"
    _p(function() id = tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
    if id == "?" or id == "" then id = tostring(game:GetService("Players").LocalPlayer.UserId) end
    return id
end

local function _fetch()
    local ok, raw = _p(function() return game:HttpGet(_RAW, true) end)
    if not ok or not raw then return nil end
    local jok, d = _p(_HS.JSONDecode, _HS, raw)
    if not jok then return nil end
    return d
end

local function _save(t) _p(writefile, "phs.txt", _HS:JSONEncode(t)) end
local function _load()
    local ok, v = _p(readfile, "phs.txt")
    if ok and v and v ~= "" then
        local jok, d = _p(_HS.JSONDecode, _HS, v)
        if jok and d then return d end
    end
    return nil
end

local function _fmt(s)
    if s <= 0 then return "หมดเวลา" end
    local d = math.floor(s/86400)
    local h = math.floor((s%86400)/3600)
    local m = math.floor((s%3600)/60)
    if d > 0 then return d.."วัน "..h.."ชม."
    elseif h > 0 then return h.."ชม. "..m.."น."
    else return m.."น. "..(s%60).."ว." end
end

local function _typeLabel(t)
    if t=="1day" then return "⏰ 1 วัน"
    elseif t=="1week" then return "📅 1 อาทิตย์"
    elseif t=="permanent" then return "♾️ ถาวร"
    elseif t=="admin" then return "👑 ADMIN"
    else return t end
end

-- สร้าง UI ใส่คีย์ (Modern Dark)
local function _showKey(cb)
    local G = Instance.new("ScreenGui")
    G.Name = "PHKS" G.ResetOnSpawn = false
    G.DisplayOrder = 9999 G.IgnoreGuiInset = true
    G.Parent = CoreGui

    -- overlay มืดโปร่งใส
    local OV = Instance.new("Frame", G)
    OV.Size = UDim2.new(1,0,1,0)
    OV.BackgroundColor3 = Color3.fromRGB(0,0,0)
    OV.BackgroundTransparency = 0.5
    OV.BorderSizePixel = 0

    -- card หลัก — เล็ก กะทัดรัด
    local Card = Instance.new("Frame", G)
    Card.Size = UDim2.new(0,290,0,280)
    Card.Position = UDim2.new(0.5,-145,0.5,-140)
    Card.BackgroundColor3 = Color3.fromRGB(8,7,14)
    Card.BorderSizePixel = 0
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0,14)
    -- border สีรุ้ง
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Thickness = 1.2
    CardStroke.Color = Color3.fromRGB(255,80,160)

    -- เส้นแบ่งบนสุด accent
    local AccentBar = Instance.new("Frame", Card)
    AccentBar.Size = UDim2.new(1,0,0,2)
    AccentBar.Position = UDim2.new(0,0,0,0)
    AccentBar.BorderSizePixel = 0
    AccentBar.BackgroundColor3 = Color3.fromRGB(255,80,160)
    Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0,14)
    local AccentGrad = Instance.new("UIGradient", AccentBar)
    AccentGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,80,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120,80,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,200,255)),
    })

    -- รูปโลโก้ เล็กลง
    local Logo = Instance.new("ImageLabel", Card)
    Logo.Size = UDim2.new(0,55,0,55)
    Logo.Position = UDim2.new(0.5,-27.5,0,16)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://117924028123190"

    -- ชื่อ
    local Title = Instance.new("TextLabel", Card)
    Title.Size = UDim2.new(1,0,0,28)
    Title.Position = UDim2.new(0,0,0,76)
    Title.BackgroundTransparency = 1
    Title.Text = "PIG HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    local TG = Instance.new("UIGradient", Title)
    TG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,120,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180,100,255)),
    })
    TG.Rotation = 90

    -- sub text
    local Sub = Instance.new("TextLabel", Card)
    Sub.Size = UDim2.new(1,-20,0,16)
    Sub.Position = UDim2.new(0,10,0,108)
    Sub.BackgroundTransparency = 1
    Sub.Text = "1day · 10฿    1week · 35฿    forever · 65฿"
    Sub.Font = Enum.Font.Gotham
    Sub.TextScaled = true
    Sub.TextColor3 = Color3.fromRGB(120,100,150)

    -- กล่อง input
    local IF = Instance.new("Frame", Card)
    IF.Size = UDim2.new(1,-24,0,38)
    IF.Position = UDim2.new(0,12,0,136)
    IF.BackgroundColor3 = Color3.fromRGB(16,13,26)
    IF.BorderSizePixel = 0
    Instance.new("UICorner", IF).CornerRadius = UDim.new(0,8)
    local IS = Instance.new("UIStroke", IF)
    IS.Thickness = 1

    local IB = Instance.new("TextBox", IF)
    IB.Size = UDim2.new(1,-14,1,0)
    IB.Position = UDim2.new(0,7,0,0)
    IB.BackgroundTransparency = 1
    IB.TextColor3 = Color3.fromRGB(230,230,255)
    IB.PlaceholderText = "enter key..."
    IB.PlaceholderColor3 = Color3.fromRGB(80,70,100)
    IB.Text = "" IB.TextScaled = true
    IB.Font = Enum.Font.Code
    IB.ClearTextOnFocus = false IB.BorderSizePixel = 0

    -- ปุ่ม
    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(1,-24,0,36)
    Btn.Position = UDim2.new(0,12,0,188)
    Btn.BackgroundColor3 = Color3.fromRGB(180,50,130)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Text = "ENTER"
    Btn.TextScaled = true Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
    local BtnGrad = Instance.new("UIGradient", Btn)
    BtnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220,60,160)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140,50,220)),
    })
    BtnGrad.Rotation = 90

    -- status
    local SL = Instance.new("TextLabel", Card)
    SL.Size = UDim2.new(1,-20,0,22)
    SL.Position = UDim2.new(0,10,0,234)
    SL.BackgroundTransparency = 1
    SL.Text = "" SL.TextScaled = true SL.Font = Enum.Font.Gotham

    -- animate border + input stroke
    task.spawn(function()
        local t = 0
        while G and G.Parent do
            t = t + 0.012
            local c = Color3.fromHSV(t%1, 0.75, 1)
            CardStroke.Color = c
            IS.Color = Color3.fromHSV((t+0.3)%1, 0.5, 0.8)
            AccentGrad.Rotation = (t * 60) % 360
            task.wait(0.05)
        end
    end)

    Btn.MouseButton1Click:Connect(function()
        local key = IB.Text:gsub("%s+","")
        if key == "" then
            SL.Text = "⚠ กรุณาใส่คีย์!" SL.TextColor3 = Color3.fromRGB(255,200,50) return
        end
        SL.Text = "⏳ กำลังตรวจสอบ..." SL.TextColor3 = Color3.fromRGB(180,180,255)
        task.spawn(function()
            -- admin
            if key == "PIGHUB4/2/55" then
                _save({key=key,type="admin",expires=nil,hwid=_getHWID()})
                SL.Text = "✅ ADMIN 👑" SL.TextColor3 = Color3.fromRGB(80,255,160)
                task.wait(0.8) G:Destroy() cb("admin",nil) return
            end
            local data = _fetch()
            if not data then
                SL.Text = "❌ เชื่อมต่อไม่ได้" SL.TextColor3 = Color3.fromRGB(255,80,80) return
            end
            local entry = data[key]
            if not entry then
                SL.Text = "❌ คีย์ไม่ถูกต้อง" SL.TextColor3 = Color3.fromRGB(255,80,80) return
            end
            if not entry.active then
                SL.Text = "❌ คีย์ถูกยกเลิก" SL.TextColor3 = Color3.fromRGB(255,80,80) return
            end
            local hwid = _getHWID()
            local locked = tostring(entry.hwid or "")
            if locked ~= "" and locked ~= "null" and locked ~= tostring(hwid) then
                SL.Text = "❌ คีย์ผูกเครื่องอื่นแล้ว" SL.TextColor3 = Color3.fromRGB(255,80,80) return
            end
            local ktype = tostring(entry.type or "permanent")
            local dur = tonumber(entry.duration) or -1
            local exp = nil
            if ktype == "permanent" or dur <= 0 then
                exp = nil
            else
                local saved = _load()
                if saved and saved.key == key and saved.expires then
                    exp = saved.expires
                else
                    exp = os.time() + dur
                end
            end
            if exp and os.time() > exp then
                SL.Text = "❌ คีย์หมดอายุแล้ว" SL.TextColor3 = Color3.fromRGB(255,80,80) return
            end
            _save({key=key,type=ktype,expires=exp,hwid=hwid})
            SL.Text = "✅ ".._typeLabel(ktype) SL.TextColor3 = Color3.fromRGB(80,255,160)
            task.spawn(function()
                local _UIS = game:GetService("UserInputService")
                local _HS2 = game:GetService("HttpService")
                local function getExecutor()
                    if syn then return "Synapse X"
                    elseif KRNL_LOADED then return "KRNL"
                    elseif Delta then return "Delta"
                    elseif getgenv().is_sirhurt_closure then return "Sir Hurt"
                    elseif pebc_execute then return "Comet"
                    elseif IS_ARCEUS then return "Arceus X"
                    else return "Unknown" end
                end
                local function getOS()
                    if _UIS.TouchEnabled and not _UIS.MouseEnabled then return "Mobile" else return "PC" end
                end
                local _p2 = game:GetService("Players").LocalPlayer
                local _jid = game.JobId
                local _link = "roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId=".._jid
                pcall(function()
                    request({
                        Url = "https://discord.com/api/webhooks/1484514595572813954/MPiRUvzd3xjFkh9v-Zohgx7GKq9D1aFoy3ioD0-HjCQV4HRp63EVPFlgl30Nh4TjErx1",
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = _HS2:JSONEncode({embeds = {{
                            title = "🐷 PIG HUB | Key Verified",
                            color = 0xFF69B4,
                            fields = {
                                {name = "👤 Player", value = _p2.Name.." ("..tostring(_p2.UserId)..")", inline = true},
                                {name = "💻 Executor", value = getExecutor(), inline = true},
                                {name = "📱 OS", value = getOS(), inline = true},
                                {name = "🔑 Key Type", value = _typeLabel(ktype), inline = true},
                                {name = "🌐 Job ID", value = _jid, inline = false},
                                {name = "🔗 Join Server", value = "[Click to Join](".._link..")", inline = false},
                            },
                            footer = {text = "PIG HUB Logger"},
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                        }}})
                    })
                end)
            end)
            task.wait(0.8) G:Destroy() cb(ktype, exp)
        end)
    end)
end

-- ตรวจ session
local _ktype, _kexp = "?", nil
local _done = false



-- ตรวจ session ก่อน ถ้าไม่มีค่อยแสดง key screen
local s = _load()
if s and s.key then
    if s.key == "PIGHUB4/2/55" then
        _ktype = "admin" _kexp = nil _done = true
    else
        -- ตรวจกับ GitHub ใน task.spawn
        task.spawn(function()
            local ok, data = pcall(_fetch)
            if ok and data then
                local entry = data[s.key]
                if entry and entry.active then
                    local hwid = _getHWID()
                    local locked = tostring(entry.hwid or "")
                    if locked == "" or locked == "null" or locked == hwid then
                        local exp = s.expires
                        if not exp or os.time() <= exp then
                            _ktype = s.type or "permanent"
                            _kexp  = exp
                            _done  = true
                            return
                        end
                    end
                end
            end
            -- session ไม่ valid แสดงหน้าคีย์
            _showKey(function(t, e)
                _ktype = t _kexp = e _done = true
            end)
        end)
    end
else
    -- ไม่มี session แสดงหน้าคีย์เลย
    _showKey(function(t, e)
        _ktype = t _kexp = e _done = true
    end)
end

repeat task.wait(0.05) until _done

-- แสดงแถบเวลาคีย์เล็กๆ
task.spawn(function()
    task.wait(0.5)
    local KG = Instance.new("ScreenGui", CoreGui)
    KG.Name = "PHKInfo" KG.ResetOnSpawn = false KG.DisplayOrder = 100
    local KF = Instance.new("Frame", KG)
    KF.Size = UDim2.new(0,155,0,20)
    KF.Position = UDim2.new(0,8,0,8)
    KF.BackgroundColor3 = Color3.fromRGB(10,8,18)
    KF.BackgroundTransparency = 0.2
    KF.BorderSizePixel = 0 KF.Active = true KF.Draggable = true
    Instance.new("UICorner", KF).CornerRadius = UDim.new(0,6)
    local KS = Instance.new("UIStroke", KF) KS.Thickness = 1
    local KL = Instance.new("TextLabel", KF)
    KL.Size = UDim2.new(1,-4,1,0) KL.Position = UDim2.new(0,2,0,0)
    KL.BackgroundTransparency = 1 KL.TextScaled = true
    KL.Font = Enum.Font.GothamBold

    -- ปุ่ม logout (แสดงเฉพาะ admin)
    if _ktype == "admin" then
        KF.Size = UDim2.new(0,200,0,20)
        local LogoutBtn = Instance.new("TextButton", KF)
        LogoutBtn.Size = UDim2.new(0,44,1,0)
        LogoutBtn.Position = UDim2.new(1,-44,0,0)
        LogoutBtn.BackgroundColor3 = Color3.fromRGB(180,30,60)
        LogoutBtn.BackgroundTransparency = 0.2
        LogoutBtn.BorderSizePixel = 0
        LogoutBtn.Text = "logout"
        LogoutBtn.TextColor3 = Color3.fromRGB(255,255,255)
        LogoutBtn.TextScaled = true
        LogoutBtn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", LogoutBtn).CornerRadius = UDim.new(0,6)
        KL.Size = UDim2.new(1,-48,1,0)
        LogoutBtn.MouseButton1Click:Connect(function()
            pcall(function() writefile("phs.txt", "") end)
            KG:Destroy()
            _showKey(function(t, e)
                _ktype = t _kexp = e
                -- สร้าง KInfo bar ใหม่
                task.spawn(function()
                    task.wait(0.3)
                    local KG2 = Instance.new("ScreenGui", CoreGui)
                    KG2.Name = "PHKInfo" KG2.ResetOnSpawn = false KG2.DisplayOrder = 100
                    local KF2 = Instance.new("Frame", KG2)
                    KF2.Size = UDim2.new(0,155,0,20)
                    KF2.Position = UDim2.new(0,8,0,8)
                    KF2.BackgroundColor3 = Color3.fromRGB(10,8,18)
                    KF2.BackgroundTransparency = 0.2
                    KF2.BorderSizePixel = 0 KF2.Active = true KF2.Draggable = true
                    Instance.new("UICorner", KF2).CornerRadius = UDim.new(0,6)
                    local KS2 = Instance.new("UIStroke", KF2) KS2.Thickness = 1
                    local KL2 = Instance.new("TextLabel", KF2)
                    KL2.Size = UDim2.new(1,-4,1,0) KL2.Position = UDim2.new(0,2,0,0)
                    KL2.BackgroundTransparency = 1 KL2.TextScaled = true
                    KL2.Font = Enum.Font.GothamBold
                    task.spawn(function()
                        local t2 = 0
                        while KG2 and KG2.Parent do
                            t2 = t2 + 0.01
                            KS2.Color = Color3.fromHSV(t2%1,0.6,1)
                            if _kexp == nil then
                                KL2.Text = _typeLabel(_ktype).." | ∞"
                                KL2.TextColor3 = Color3.fromRGB(80,255,160)
                            else
                                local rem = _kexp - os.time()
                                if rem <= 0 then
                                    KL2.Text = "❌ คีย์หมดอายุ"
                                    KL2.TextColor3 = Color3.fromRGB(255,80,80)
                                    task.wait(3)
                                    game:GetService("Players").LocalPlayer:Kick("คีย์หมดอายุ กรุณาซื้อใหม่")
                                    break
                                end
                                KL2.Text = _typeLabel(_ktype).." "..(_fmt(rem))
                                KL2.TextColor3 = rem < 3600 and Color3.fromRGB(255,150,50) or Color3.fromRGB(180,255,180)
                            end
                            task.wait(1)
                        end
                    end)
                end)
            end)
        end)
    end

    task.spawn(function()
        local t = 0
        while KG and KG.Parent do
            t = t + 0.01
            KS.Color = Color3.fromHSV(t%1,0.6,1)
            if _kexp == nil then
                KL.Text = _typeLabel(_ktype).." | ∞"
                KL.TextColor3 = Color3.fromRGB(80,255,160)
            else
                local rem = _kexp - os.time()
                if rem <= 0 then
                    KL.Text = "❌ คีย์หมดอายุ"
                    KL.TextColor3 = Color3.fromRGB(255,80,80)
                    task.wait(3)
                    game:GetService("Players").LocalPlayer:Kick("คีย์หมดอายุ กรุณาซื้อใหม่")
                    break
                end
                KL.Text = _typeLabel(_ktype).." "..(_fmt(rem))
                KL.TextColor3 = rem < 3600 and Color3.fromRGB(255,150,50) or Color3.fromRGB(180,255,180)
            end
            task.wait(1)
        end
    end)
end)


-- ========== WEBHOOK ส่งทุกครั้งที่รัน ==========
task.spawn(function()
    local _WH_URL = "https://discord.com/api/webhooks/1484514595572813954/MPiRUvzd3xjFkh9v-Zohgx7GKq9D1aFoy3ioD0-HjCQV4HRp63EVPFlgl30Nh4TjErx1"
    local _HS2 = game:GetService("HttpService")
    local _UIS2 = game:GetService("UserInputService")
    local _p2 = game:GetService("Players").LocalPlayer
    local function _getExec()
        if syn then return "Synapse X"
        elseif KRNL_LOADED then return "KRNL"
        elseif Delta then return "Delta"
        elseif getgenv and getgenv().is_sirhurt_closure then return "Sir Hurt"
        elseif pebc_execute then return "Comet"
        elseif IS_ARCEUS then return "Arceus X"
        else return "Unknown" end
    end
    local function _getOS()
        if _UIS2.TouchEnabled and not _UIS2.MouseEnabled then return "Mobile" else return "PC" end
    end
    local _jid = game.JobId
    local _link = "roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId=".._jid
    pcall(function()
        request({
            Url = _WH_URL,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = _HS2:JSONEncode({embeds={{
                title = "🐷 PIG HUB | Script Ran",
                color = 0xFF69B4,
                fields = {
                    {name="👤 Player", value=_p2.Name.." ("..tostring(_p2.UserId)..")", inline=true},
                    {name="💻 Executor", value=_getExec(), inline=true},
                    {name="📱 OS", value=_getOS(), inline=true},
                    {name="🔑 Key Type", value=_typeLabel(_ktype), inline=true},
                    {name="🌐 Job ID", value=_jid, inline=false},
                    {name="🔗 Join Server", value="[Click to Join](".._link..")", inline=false},
                },
                footer={text="PIG HUB Logger"},
                timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}})
        })
    end)
end)

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
    }
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

-- ========== ระบบ ANTI LOOK (แบบ god2) ==========
getgenv().AntiLookEnabled = false
getgenv().SkyAmount = 1500

local AntiLookConnection = nil
local AntiLookMoveConn = nil
local _antiLookOriginalCFrame = nil

local function setupAntiLook()
    if AntiLookConnection then AntiLookConnection:Disconnect() end
    if AntiLookMoveConn then AntiLookMoveConn:Disconnect() end

    AntiLookConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local Root = char:FindFirstChild("HumanoidRootPart")
        if not Root then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        -- บันทึก CFrame จริงของเรา
        local realCF = Root.CFrame

        -- สั่นแรงๆ ฝั่ง server เห็น (เปลี่ยน CFrame ไปมาเร็วมาก)
        local t = tick()
        local jx = math.sin(t * 80) * 6 + math.random(-3, 3)
        local jz = math.cos(t * 75) * 6 + math.random(-3, 3)
        local jy = math.sin(t * 60) * 2

        Root.CFrame = realCF * CFrame.new(jx, jy, jz)
        task.wait()

        -- คืน CFrame เดิมให้เราอยู่ที่เดิม (เราไม่เห็น)
        if Root and Root.Parent then
            Root.CFrame = realCF
        end
    end)

    -- เมื่อเดินให้ระบบยังทำงานได้ปกติ ไม่ค้าง
    AntiLookMoveConn = RunService.RenderStepped:Connect(function()
        if not getgenv().AntiLookEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local Root = char:FindFirstChild("HumanoidRootPart")
        if not Root then return end
        -- เก็บ velocity เดิมไว้ไม่ให้กระเด็น
        local vel = Root.AssemblyLinearVelocity
        task.wait()
        if Root and Root.Parent then
            Root.AssemblyLinearVelocity = vel
        end
    end)
end

local function toggleAntiLook(state)
    getgenv().AntiLookEnabled = state
    if state then
        setupAntiLook()
    else
        if AntiLookConnection then AntiLookConnection:Disconnect() AntiLookConnection = nil end
        if AntiLookMoveConn then AntiLookMoveConn:Disconnect() AntiLookMoveConn = nil end
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
local safeAdminEnabled = false -- ถ้าเปิด จะไม่ lock ผู้เล่นที่ใช้ admin key

-- รายชื่อ admin (sync จาก keys.json ไม่ได้ใน client, ใช้วิธีเก็บใน global แทน)
local adminPlayers = {} -- {[playerName] = true}

local function isPlayerExcluded(playerName)
    -- ตรวจ safe friend list
    for _, name in ipairs(excludedPlayerNames) do
        if name ~= "" and string.find(string.lower(playerName), string.lower(name)) then
            return true
        end
    end
    -- ตรวจ safe admin
    if safeAdminEnabled and adminPlayers[playerName] then
        return true
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
    if espData.distDisplay then espData.distDisplay:Remove() end
    PlayerNameESP[player]=nil
end

RunService.RenderStepped:Connect(function()
    if not ShowNameESP then
        for _,espData in pairs(PlayerNameESP) do
            if espData then
                if espData.display then espData.display.Visible=false end
                if espData.distDisplay then espData.distDisplay.Visible=false end
            end
        end
        return
    end
    for player,espData in pairs(PlayerNameESP) do
        if not espData then continue end
        if not player.Parent then removeNameESP(player) continue end
        if not espData.character and player.Character then
            espData.character=player.Character
            espData.hrp=player.Character:FindFirstChild("HumanoidRootPart")
        end
        if not espData.character or not espData.hrp then
            if espData.display then espData.display.Visible=false end
            if espData.distDisplay then espData.distDisplay.Visible=false end
            continue
        end
        -- ขึ้นบนหัว — offset +5.5 สตัด (เหนือ Item Weapon ESP)
        local headPos = espData.hrp.Position + Vector3.new(0, 5.5, 0)
        local pos,onScreen = Camera:WorldToViewportPoint(headPos)
        if onScreen and pos.Z > 0 then
            local distance = (Camera.CFrame.Position - espData.hrp.Position).Magnitude
            if distance <= 1500 then
                local distInt = math.floor(distance)
                -- ชื่อ
                espData.display.Text = player.Name
                espData.display.Position = Vector2.new(pos.X, pos.Y - 2)
                espData.display.Size = math.max(12, 20 - distInt/80)
                espData.display.Visible = true
                -- ระยะห่าง (แสดงใต้ชื่อ)
                if not espData.distDisplay then
                    local d = Drawing.new("Text")
                    d.Size=13 d.Center=true d.Outline=true
                    d.OutlineColor=Color3.new(0,0,0)
                    d.Font=2 d.Visible=false
                    espData.distDisplay = d
                end
                espData.distDisplay.Text = distInt.."m"
                espData.distDisplay.Color = distInt < 20 and Color3.fromRGB(255,80,80)
                    or distInt < 60 and Color3.fromRGB(255,200,50)
                    or Color3.fromRGB(120,255,120)
                espData.distDisplay.Position = Vector2.new(pos.X, pos.Y + 14)
                espData.distDisplay.Visible = true
            else
                espData.display.Visible=false
                if espData.distDisplay then espData.distDisplay.Visible=false end
            end
        else
            espData.display.Visible=false
            if espData.distDisplay then espData.distDisplay.Visible=false end
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
    if #tools == 0 then return end

    local bb=Instance.new("BillboardGui")
    bb.Adornee=hrp
    bb.Size=UDim2.new(0,math.max(90, #tools*28),0,26)
    bb.StudsOffset=Vector3.new(0,-3,0)
    bb.AlwaysOnTop=true
    bb.Parent=char

    local layout=Instance.new("UIListLayout",bb)
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Padding=UDim.new(0,3)
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.VerticalAlignment=Enum.VerticalAlignment.Center

    for _,tool in ipairs(tools) do
        local key=getWeaponKey(tool)
        local info=WeaponRegistry[key]
        local rarity=tool:GetAttribute("RarityName") or "Common"
        local rarityColor=RarityColorsBB[rarity] or Color3.new(1,1,1)
        local displayName=tool:GetAttribute("DisplayName") or tool.Name

        if info and info.ImageId and info.ImageId~="rbxassetid://7072725737" then
            -- มีรูปใน registry
            local img=Instance.new("ImageLabel",bb)
            img.Size=UDim2.new(0,22,0,22)
            img.BackgroundTransparency=0.1
            img.Image=info.ImageId
            img.BackgroundColor3=Color3.fromRGB(20,20,30)
            Instance.new("UICorner",img).CornerRadius=UDim.new(0,4)
            local stroke=Instance.new("UIStroke",img)
            stroke.Color=rarityColor stroke.Thickness=2
            local tip=Instance.new("TextLabel",img)
            tip.Size=UDim2.new(1,0,0,10)
            tip.Position=UDim2.new(0,0,1,1)
            tip.BackgroundTransparency=1
            tip.Text=displayName
            tip.TextScaled=true
            tip.Font=Enum.Font.GothamBold
            tip.TextColor3=rarityColor
        else
            -- fallback แสดงชื่อตรงๆ
            local lbl=Instance.new("TextLabel",bb)
            lbl.Size=UDim2.new(0,math.max(50,#displayName*7),0,18)
            lbl.BackgroundColor3=Color3.fromRGB(15,15,25)
            lbl.BackgroundTransparency=0.2
            lbl.Text=displayName
            lbl.TextScaled=true
            lbl.Font=Enum.Font.GothamBold
            lbl.TextColor3=rarityColor
            Instance.new("UICorner",lbl).CornerRadius=UDim.new(0,4)
            local stroke=Instance.new("UIStroke",lbl)
            stroke.Color=rarityColor stroke.Thickness=1.5
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

-- Auto refresh Item Weapon ESP ทุก 5-6 วิ ป้องกันบล็อก
task.spawn(function()
    while task.wait(math.random(5,6)) do
        if ShowItemESP then
            for _,player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function() clearBillboard(player) end)
                    task.wait(0.1)
                    pcall(function() buildBillboard(player) end)
                end
            end
        end
    end
end)

-- ===== ITEM DROP ESP (ของที่ตกบนพื้น) =====
getgenv().ItemESPEnabled=false
getgenv().ItemESPMaxDist=99999 -- ไกลสุดอัตโนมัติ

-- ========== ระบบ AutoSkip Crate ==========
local AutoSkipEnabled = false
local function TrySkipCrate()
    local ok, CrateController = pcall(function()
        return require(ReplicatedStorage.Modules.Game.CrateSystem.Crate)
    end)
    if not (ok and CrateController) then return end
    task.spawn(function()
        local spinning = CrateController.spinning
        if not spinning then return end
        local waited = 0
        while not spinning.get() do
            if waited > 3 then break end
            task.wait(0.05) waited = waited + 0.05
        end
        if spinning.get() then
            pcall(function() CrateController.skip_spin() end)
        end
    end)
end
local function SetupAutoSkip()
    local rf = ReplicatedStorage:WaitForChild("Remotes",5)
    if not rf then return end
    local sr = rf:WaitForChild("Send",5)
    if not (sr and sr:IsA("RemoteEvent")) then return end
    sr.OnClientEvent:Connect(function()
        if AutoSkipEnabled then TrySkipCrate() end
    end)
end
SetupAutoSkip()
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) SetupAutoSkip() end)
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
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
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
    local time = tick() * 2.5
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
        local c = text:sub(i, i)
        local col = getRainbowColorForMoney(i * 0.15)
        local hex = string.format("#%02x%02x%02x", math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255))
        rainbowText = rainbowText .. string.format('<font color="%s"><b>%s</b></font>', hex, c)
    end
    return rainbowText
end

-- rainbow สำหรับตัวเลขทั่วไปใน UI
local function rainbowNum(n, prefix)
    prefix = prefix or ""
    local text = prefix .. tostring(n)
    local out = ""
    for i = 1, #text do
        local c = text:sub(i,i)
        local col = Color3.fromHSV(((tick()*2)+(i*0.12))%1, 1, 1)
        local hex = string.format("#%02x%02x%02x", math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255))
        out = out .. string.format('<font color="%s"><b>%s</b></font>', hex, c)
    end
    return out
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
    Desc = "ความแรง (500-3000)",
    Step = 100,
    Value = {Min = 500, Max = 3000, Default = 1500},
    Callback = function(value)
        getgenv().SkyAmount = value
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
    Title = "Item ESP (พื้น)",
    Desc = "แสดงชื่อและระยะของไอเท็มที่ตกอยู่บนพื้น (ไกลสุดอัตโนมัติ)",
    Default = false,
    Callback = function(v) getgenv().ItemESPEnabled = v end
})

ESPTab:Divider()
ESPTab:Section({Title = "AUTO SKIP CRATE"})

ESPTab:Toggle({
    Title = "Auto Skip Spin",
    Desc = "ข้ามแอนิเมชันหมุนตู้อัตโนมัติ",
    Default = false,
    Callback = function(v)
        AutoSkipEnabled = v
        if v then TrySkipCrate() end
    end
})

ESPTab:Button({
    Title = "Skip Now",
    Desc = "กดข้ามการหมุนทันที",
    Callback = function() TrySkipCrate() end
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

PVPTab:Toggle({
    Title = "Safe Admin",
    Desc = "เปิด = silent aim จะไม่ล็อคผู้เล่นที่ลงทะเบียนเป็น admin ไว้",
    Default = false,
    Callback = function(v) safeAdminEnabled = v end
})

PVPTab:Input({
    Title = "ลงทะเบียน Admin Player",
    Desc = "ใส่ชื่อผู้เล่นที่เป็น admin ของค่าย (คั่นด้วยช่องว่าง)",
    Placeholder = "ชื่อผู้เล่น...",
    Callback = function(v)
        adminPlayers = {}
        for name in string.gmatch(v, "%S+") do
            adminPlayers[name] = true
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
    Callback = function(state) toggleFPSBooster(state) end
})

CustomTab:Dropdown({
    Title = "Boost Mode",
    Desc = "เลือกโหมดการเพิ่ม FPS",
    Values = {"โหมด 1: ลบหมอก", "โหมด 2: ลบหมอก+แสงเงา", "โหมด 3: ลบทุกอย่าง+Terrain เรียบ"},
    Default = 1,
    Callback = function(value)
        if value == "โหมด 1: ลบหมอก" then fpsBoosterMode = 1
        elseif value == "โหมด 2: ลบหมอก+แสงเงา" then fpsBoosterMode = 2
        elseif value == "โหมด 3: ลบทุกอย่าง+Terrain เรียบ" then fpsBoosterMode = 3 end
        if fpsBoosterEnabled then applyFPSBooster(fpsBoosterMode) end
    end
})

CustomTab:Divider()
CustomTab:Section({Title = "ลดความแหลก (Anti-Noise)"})

CustomTab:Slider({
    Title = "ลด Bloom",
    Desc = "ลดแสงเรืองรอบๆ (0 = ไม่มี Bloom)",
    Step = 0.05,
    Value = {Min = 0, Max = 1, Default = 1},
    Callback = function(v)
        pcall(function()
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") then
                    effect.Intensity = v
                end
            end
        end)
    end
})

CustomTab:Slider({
    Title = "ลด Blur",
    Desc = "ลดความเบลอของภาพ (0 = คมชัดสุด)",
    Step = 1,
    Value = {Min = 0, Max = 24, Default = 24},
    Callback = function(v)
        pcall(function()
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("BlurEffect") then
                    effect.Size = v
                end
            end
        end)
    end
})

CustomTab:Slider({
    Title = "ลด Sun Rays",
    Desc = "ลดแสงซันเรย์ (0 = ไม่มี)",
    Step = 0.05,
    Value = {Min = 0, Max = 1, Default = 1},
    Callback = function(v)
        pcall(function()
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("SunRaysEffect") then
                    effect.Intensity = v
                end
            end
        end)
    end
})

CustomTab:Slider({
    Title = "ลด ColorCorrection",
    Desc = "ลด Saturation สีสด (0 = ขาวดำ)",
    Step = 0.1,
    Value = {Min = -1, Max = 1, Default = 0},
    Callback = function(v)
        pcall(function()
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("ColorCorrectionEffect") then
                    effect.Saturation = v
                end
            end
        end)
    end
})

CustomTab:Button({
    Title = "Reset Visual",
    Desc = "คืนค่าภาพทั้งหมดกลับปกติ",
    Callback = function()
        pcall(function()
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") then effect.Intensity = 1 end
                if effect:IsA("BlurEffect") then effect.Size = 24 end
                if effect:IsA("SunRaysEffect") then effect.Intensity = 1 end
                if effect:IsA("ColorCorrectionEffect") then effect.Saturation = 0 end
            end
        end)
    end
})

CustomTab:Divider()
CustomTab:Section({Title = "PIGHUB EFFECT"})

CustomTab:Toggle({
    Title = "PIGHUB Effect",
    Desc = "ลูกบอลสีรุ้งหมุนรอบตัว",
    Default = false,
    Callback = function(state) togglePigHubEffect(state) end
})

CustomTab:Slider({
    Title = "ขนาดวงโคจร",
    Desc = "ระยะห่างของลูกบอลจากตัวละคร",
    Step = 0.5,
    Value = {Min = 2, Max = 12, Default = 5},
    Callback = function(v) ORBIT_RADIUS = v end
})

CustomTab:Slider({
    Title = "ความเร็วหมุน",
    Desc = "ความเร็วในการหมุนวงโคจร",
    Step = 0.5,
    Value = {Min = 0.5, Max = 8, Default = 2.5},
    Callback = function(v) ORBIT_SPEED = v end
})

-- ========== Rainbow Tab Selector ==========
task.spawn(function()
    task.wait(1)
    pcall(function()
        local hue = 0
        RunService.RenderStepped:Connect(function()
            hue = (hue + 0.003) % 1
            if Window and Window.SideBar then
                for _, obj in ipairs(Window.SideBar:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        if obj.Text ~= "" and not obj.Text:find("PIG") then
                            local offset = (obj.AbsolutePosition.Y / 400) * 0.3
                            obj.TextColor3 = Color3.fromHSV((hue + offset) % 1, 0.9, 1)
                        end
                    end
                end
            end
        end)
    end)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PIG HUB",
    Text = "โหลดสำเร็จ! Silent Aim + Gun Mod พร้อมใช้งาน",
    Duration = 3
})