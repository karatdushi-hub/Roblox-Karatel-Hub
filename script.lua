-- 🚨 СТАНДАРТНОЕ УВЕДОМЛЕНИЕ О ЗАПУСКЕ (ЧЕРЕЗ HINT)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚡ Karatel Hub",
    Text = "Скрипт успешно активирован!",
    Duration = 5,
    Button1 = "OK"
})

-- 💥 ОСНОВНОЙ СКРИПТ (ИСПРАВЛЕННЫЙ)
local p, g = game.Players.LocalPlayer, game
local u, r, P = g:GetService("UserInputService"), g:GetService("RunService"), g:GetService("PhysicsService")

-- Создаём группу NoClip
pcall(function() P:CreateCollisionGroup("NoClipGroup") end) or (P:RemoveCollisionGroup("NoClipGroup"); P:CreateCollisionGroup("NoClipGroup"))
P:CollisionGroupSetCollidable("NoClipGroup", "Default", false)

-- UI
local U = Instance.new("ScreenGui")
U.Name = "KaratelHub_UI"
U.ResetOnSpawn = false
U.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
U.Parent = p:WaitForChild("PlayerGui")

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 420, 0, 520)
M.Position = UDim2.new(0.5, -210, 0.5, -260)
M.BackgroundTransparency = 0.2
M.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
M.BorderSizePixel = 0
M.Draggable = true
M.Active = true
M.Parent = U

local T = Instance.new("Frame")
T.Size = UDim2.new(1, 0, 0, 40)
T.BackgroundTransparency = 0.3
T.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
T.BorderSizePixel = 0
T.Parent = M

local L = Instance.new("TextLabel")
L.Size = UDim2.new(1, -80, 1, 0)
L.BackgroundTransparency = 1
L.Text = "⚡ Karatel Hub | Ink Game"
L.TextColor3 = Color3.fromRGB(255, 255, 255)
L.TextSize = 18
L.Font = Enum.Font.GothamBold
L.Parent = T

local C = Instance.new("TextButton")
C.Size = UDim2.new(0, 40, 0, 40)
C.Position = UDim2.new(1, -40, 0, 0)
C.BackgroundTransparency = 0.3
C.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
C.Text = "✕"
C.TextColor3 = Color3.fromRGB(255, 255, 255)
C.TextSize = 24
C.Font = Enum.Font.SourceSansBold
C.Parent = T

local F = Instance.new("Frame")
F.Size = UDim2.new(1, 0, 1, -40)
F.Position = UDim2.new(0, 0, 0, 40)
F.BackgroundTransparency = 1
F.Parent = M

local tabs, tabBtns = {}, {}
local function createTab(name, idx)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0, 40)
    btn.Position = UDim2.new(0, idx*105, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = F

    local cont = Instance.new("ScrollingFrame")
    cont.Size = UDim2.new(1, 0, 1, 0)
    cont.Position = UDim2.new(0, 0, 0, 40)
    cont.BackgroundTransparency = 1
    cont.Visible = false
    cont.CanvasSize = UDim2.new(0, 0, 0, 400)
    cont.ScrollBarThickness = 4
    cont.Parent = F

    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(30,30,30)
            b.TextColor3 = Color3.fromRGB(200,200,200)
        end
        for _,c in pairs(tabs) do c.Visible = false end
        btn.BackgroundColor3 = Color3.fromRGB(255,165,0)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        cont.Visible = true
    end)

    table.insert(tabBtns, btn)
    table.insert(tabs, cont)
    if #tabs == 1 then
        btn.BackgroundColor3 = Color3.fromRGB(255,165,0)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        cont.Visible = true
    end
    return cont
end

local function btn(parent, text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.Parent = parent
    b.MouseButton1Click:Connect(cb)
    return b
end

local function toggle(parent, text, y, def, cb)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextSize = 16
    lbl.Parent = parent

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0.3, 0, 0, 30)
    tog.Position = UDim2.new(0.7, 0, 0, y)
    tog.Text = def and "ON" or "OFF"
    tog.TextColor3 = def and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    tog.BackgroundColor3 = Color3.fromRGB(50,50,50)
    tog.BorderSizePixel = 0
    tog.Font = Enum.Font.SourceSans
    tog.TextSize = 16
    tog.Parent = parent

    tog.MouseButton1Click:Connect(function()
        def = not def
        tog.Text = def and "ON" or "OFF"
        tog.TextColor3 = def and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
        cb(def)
    end)
    return tog
end

local function input(parent, text, y, def, cb)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextSize = 16
    lbl.Parent = parent

    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(0.3, 0, 0, 30)
    inp.Position = UDim2.new(0.7, 0, 0, y)
    inp.Text = tostring(def)
    inp.BackgroundColor3 = Color3.fromRGB(50,50,50)
    inp.TextColor3 = Color3.fromRGB(255,255,255)
    inp.Font = Enum.Font.SourceSans
    inp.TextSize = 16
    inp.Parent = parent

    local apply = Instance.new("TextButton")
    apply.Size = UDim2.new(0.2, 0, 0, 30)
    apply.Position = UDim2.new(1, -70, 0, y)
    apply.Text = "Apply"
    apply.TextColor3 = Color3.fromRGB(255,255,255)
    apply.BackgroundColor3 = Color3.fromRGB(70,70,70)
    apply.BorderSizePixel = 0
    apply.Font = Enum.Font.SourceSans
    apply.TextSize = 14
    apply.Parent = parent

    apply.MouseButton1Click:Connect(function()
        cb(tonumber(inp.Text) or def)
    end)
    return inp
end

local mTab = createTab("Movement", 0)
local cTab = createTab("Combat", 1)
local vTab = createTab("Visuals", 2)
local sTab = createTab("Safety", 3)

local noClip, fly, esp, killAura, safeMode, autoTp = false, false, false, false, false, false
local ws, jp, flySpd = 16, 50, 50

-- Movement
btn(mTab, "↑ Teleport +100", 10, function()
    local char = p.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
    end
end)

btn(mTab, "↓ Teleport -40", 60, function()
    local char = p.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, -40, 0)
    end
end)

toggle(mTab, "NoClip", 110, false, function(state)
    noClip = state
    local char = p.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                P:SetPartCollisionGroup(part, state and "NoClipGroup" or "Default")
            end
        end
    end
end)

toggle(mTab, "Fly", 160, false, function(state) fly = state end)

input(mTab, "WalkSpeed", 210, 16, function(val)
    ws = val
    local char = p.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end)

input(mTab, "JumpPower", 260, 50, function(val)
    jp = val
    local char = p.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
    end
end)

input(mTab, "Fly Speed", 310, 50, function(val) flySpd = val end)

-- Combat
toggle(cTab, "Kill Aura", 10, false, function(state) killAura = state end)

-- Visuals
toggle(vTab, "ESP (Hide'n Seek)", 10, false, function(state) esp = state end)

-- Safety
toggle(sTab, "Safe Mode (<20 HP)", 10, false, function(state) safeMode = state end)
toggle(sTab, "Auto Teleport (10s)", 60, false, function(state) autoTp = state end)

-- Закрытие
C.MouseButton1Click:Connect(function() U:Destroy() end)
u.InputBegan:Connect(function(inp, gp)
    if inp.KeyCode == Enum.KeyCode.G and not gp then
        U.Enabled = not U.Enabled
    end
end)

-- Основной цикл
local lastTp = 0
r.Heartbeat:Connect(function(dt)
    local char = p.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    hum.WalkSpeed = ws
    hum.JumpPower = jp

    -- Fly
    if fly then
        local vel = Vector3.new(0,0,0)
        if u:IsKeyDown(Enum.KeyCode.W) then vel = vel + hrp.CFrame.LookVector * flySpd end
        if u:IsKeyDown(Enum.KeyCode.S) then vel = vel - hrp.CFrame.LookVector * flySpd end
        if u:IsKeyDown(Enum.KeyCode.A) then vel = vel - hrp.CFrame.RightVector * flySpd end
        if u:IsKeyDown(Enum.KeyCode.D) then vel = vel + hrp.CFrame.RightVector * flySpd end
        if u:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, flySpd, 0) end
        if u:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0, flySpd, 0) end
        hrp.Velocity = vel
    end

    -- Kill Aura
    if killAura then
        local target, dist = nil, math.huge
        for _, plr in ipairs(g.Players:GetPlayers()) do
            if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local d = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    target, dist = plr, d
                end
            end
        end
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tPos = target.Character.HumanoidRootPart.Position
            local offset = CFrame.new(hrp.Position, tPos) * CFrame.new(0,0,-3)
            hrp.CFrame = CFrame.new(offset.Position, tPos)
        end
    end

    -- Safe Mode
    if safeMode and hum.Health < 20 then
        if not autoTp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 150, 0)
            safeMode = false
        else
            lastTp = lastTp + dt
            if lastTp >= 10 then
                lastTp = 0
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 150, 0)
            end
        end
    end
end)

-- ESP
r.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end

    if not esp then
        for _, obj in ipairs(cam:GetChildren()) do
            if obj.Name == "ESP_BOX" or obj.Name == "ESP_TEXT" then
                obj:Destroy()
            end
        end
        return
    end

    for _, plr in ipairs(g.Players:GetPlayers()) do
        if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local isKiller = false
            for _, child in ipairs(plr.Character:GetChildren()) do
                if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Fork" or child.Name == "Bottle" or child.Name == "Fists") then
                    isKiller = true
                    break
                end
            end

            -- Box
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_BOX"
            box.Adornee = hrp
            box.Size = Vector3.new(2, 5, 1)
            box.Color3 = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,100,255)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = cam

            -- Name tag
            local bill = Instance.new("BillboardGui")
            bill.Name = "ESP_TEXT"
            bill.Adornee = hrp
            bill.Size = UDim2.new(0, 120, 0, 40)
            bill.StudsOffset = Vector3.new(0, 3, 0)
            bill.AlwaysOnTop = true
            bill.Enabled = true  -- ✅ КРИТИЧНО ДЛЯ ОТОБРАЖЕНИЯ
            bill.Parent = cam

            local text = Instance.new("TextLabel")
            text.BackgroundTransparency = 1
            text.Size = UDim2.new(1, 0, 1, 0)
            text.Text = plr.Name
            text.TextColor3 = isKiller and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,200,255)
            text.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            text.TextStrokeTransparency = 0
            text.TextSize = 16
            text.Font = Enum.Font.GothamBold
            text.Parent = bill
        end
    end
end)

print("✅ Karatel Hub загружен. Нажмите G для открытия меню.")
