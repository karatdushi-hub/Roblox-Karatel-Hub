-- Karatel Hub | Ink Game | Ultimate Edition

local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local r = c:WaitForChild("HumanoidRootPart")

local g = Instance.new("ScreenGui")
g.Name = "KaratelHub_UI"
g.ResetOnSpawn = false
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local m = Instance.new("Frame")
m.Size = UDim2.new(0, 280, 0, 360)
m.Position = UDim2.new(0.5, -140, 0.5, -180)
m.BackgroundTransparency = 0.2
m.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
m.BorderSizePixel = 0
m.Draggable = true
m.Active = true

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 0, 40)
t.BackgroundTransparency = 1
t.Text = "⚡ Karatel Hub"
t.TextColor3 = Color3.fromRGB(255, 165, 0)
t.TextSize = 20
t.Font = Enum.Font.GothamBold

local x = Instance.new("TextButton")
x.Size = UDim2.new(0, 30, 0, 30)
x.Position = UDim2.new(1, -35, 0, 5)
x.BackgroundTransparency = 1
x.Text = "✕"
x.TextColor3 = Color3.fromRGB(255, 80, 80)
x.TextSize = 24
x.Font = Enum.Font.SourceSansBold

local tabBtns = {}
local tabs = {}
local currentTab = nil

local function createTab(name, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.33, 0, 0, 40)
    btn.Position = UDim2.new(0, (yPos-1)*93.3, 0, 0)
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = m

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = m

    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(tabBtns) do b.TextColor3 = Color3.fromRGB(200,200,200) end
        for _,c in pairs(tabs) do c.Visible = false end
        btn.TextColor3 = Color3.fromRGB(255,165,0)
        content.Visible = true
        currentTab = content
    end)

    table.insert(tabBtns, btn)
    table.insert(tabs, content)
    if #tabs == 1 then
        btn.TextColor3 = Color3.fromRGB(255,165,0)
        content.Visible = true
        currentTab = content
    end
    return content
end

local function B(tx, y, cb, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = tx
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSans
    b.TextSize = 14
    b.Parent = parent or currentTab
    b.MouseButton1Click:Connect(cb)
    return b
end

local function L(tx, y, parent)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 25)
    l.Position = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.Text = tx
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 14
    l.Parent = parent or currentTab
    return l
end

local function I(tx, y, def, cb, parent)
    local l = L(tx, y, parent)
    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(0.4, 0, 0, 25)
    inp.Position = UDim2.new(1, -90, 0, y)
    inp.Text = tostring(def)
    inp.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    inp.TextColor3 = Color3.fromRGB(255, 255, 255)
    inp.Font = Enum.Font.SourceSans
    inp.TextSize = 14
    inp.Parent = parent or currentTab
    inp.FocusLost:Connect(function() cb(tonumber(inp.Text) or def) end)
    return inp
end

local function C(tx, y, def, cb, parent)
    local chk = Instance.new("TextButton")
    chk.Size = UDim2.new(0.2, 0, 0, 25)
    chk.Position = UDim2.new(1, -70, 0, y)
    chk.Text = def and "ON" or "OFF"
    chk.TextColor3 = def and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    chk.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    chk.Font = Enum.Font.SourceSans
    chk.TextSize = 14
    chk.Parent = parent or currentTab
    chk.MouseButton1Click:Connect(function()
        def = not def
        chk.Text = def and "ON" or "OFF"
        chk.TextColor3 = def and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
        cb(def)
    end)
    L(tx, y, parent)
    return chk
end

t.Parent = m
x.Parent = m
m.Parent = g
g.Parent = p:WaitForChild("PlayerGui")

-- ТАБЫ

local tab1 = createTab("Movement", "🏃", 1)
local tab2 = createTab("Combat", "⚔️", 2)
local tab3 = createTab("Visuals", "👁️", 3)
local tab4 = createTab("Safety", "🛡️", 4)

-- MOVEMENT
B("Teleport +100", 10, function() r.CFrame = r.CFrame + Vector3.new(0,100,0) end, tab1)
B("Teleport -40", 50, function() r.CFrame = r.CFrame + Vector3.new(0,-40,0) end, tab1)

local nc = false
C("NoClip", 90, false, function(v) nc = v end, tab1)

local fl = false
local flySpeed = 50
C("Fly", 130, false, function(v) fl = v end, tab1)
I("Fly Speed", 170, 50, function(v) flySpeed = v end, tab1)

-- COMBAT
local killAura = false
C("Kill Aura", 10, false, function(v) killAura = v end, tab2)

-- VISUALS
local esp = false
C("ESP", 10, false, function(v) esp = v end, tab3)

-- SAFETY
local safeMode = false
local autoTeleport = false
C("Safe Mode (<20 HP)", 10, false, function(v) safeMode = v end, tab4)
C("Auto Teleport (10s)", 50, false, function(v) autoTeleport = v end, tab4)

-- ЛОГИКА

-- Fly
game:GetService("RunService").Heartbeat:Connect(function()
    if not fl then return end
    local mv = Vector3.new(0,0,0)
    if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + r.CFrame.LookVector * flySpeed end
    if game.UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - r.CFrame.LookVector * flySpeed end
    if game.UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - r.CFrame.RightVector * flySpeed end
    if game.UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + r.CFrame.RightVector * flySpeed end
    if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,flySpeed,0) end
    if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv = mv - Vector3.new(0,flySpeed,0) end
    r.Velocity = mv
end)

-- NoClip
game:GetService("RunService").Heartbeat:Connect(function()
    if not nc then return end
    for _,v in ipairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

-- Kill Aura
local lastTarget = nil
game:GetService("RunService").Heartbeat:Connect(function()
    if not killAura then return end
    local closest = nil
    local closestDist = math.huge
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (r.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closest = plr
                closestDist = dist
            end
        end
    end
    if closest then
        lastTarget = closest
        local targetPos = closest.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
        local offset = (CFrame.lookAt(r.Position, targetPos) * CFrame.new(0,0,-5)).Position
        r.CFrame = CFrame.lookAt(offset, targetPos)
        wait(0.05)
    end
end)

-- ESP + Hide'n Seek
game:GetService("RunService").RenderStepped:Connect(function()
    if not esp then
        for _, obj in ipairs(workspace.CurrentCamera:GetChildren()) do
            if obj.Name == "ESP_BOX" or obj.Name == "ESP_TEXT" then obj:Destroy() end
        end
        return
    end

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= p and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local isKiller = false
            for _, tool in ipairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name == "Knife" or tool.Name == "Fork" or tool.Name == "Bottle" or tool.Name == "Fists") then
                    isKiller = true
                    break
                end
            end

            -- Box
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_BOX"
            box.Adornee = hrp
            box.Size = Vector3.new(2,5,1)
            box.Color3 = isKiller and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,100,255)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = workspace.CurrentCamera

            -- Name
            local txt = Instance.new("BillboardGui")
            txt.Name = "ESP_TEXT"
            txt.Adornee = hrp
            txt.Size = UDim2.new(0, 100, 0, 30)
            txt.StudsOffset = Vector3.new(0, 3, 0)
            txt.AlwaysOnTop = true
            txt.Parent = workspace.CurrentCamera

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Text = plr.Name
            lbl.TextColor3 = isKiller and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,200,255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            lbl.TextStrokeTransparency = 0
            lbl.TextSize = 16
            lbl.Font = Enum.Font.GothamBold
            lbl.Parent = txt
        end
    end
end)

-- Safe Mode
local safeTimer = 0
game:GetService("RunService").Heartbeat:Connect(function(dt)
    if not safeMode or h.Health >= 20 then return end
    if h.Health < 20 then
        r.CFrame = r.CFrame + Vector3.new(0, 150, 0)
        if not autoTeleport then
            safeMode = false
        else
            safeTimer = safeTimer + dt
            if safeTimer >= 10 then
                safeTimer = 0
                r.CFrame = r.CFrame + Vector3.new(0, 150, 0)
            end
        end
    end
end)

x.MouseButton1Click:Connect(function() g:Destroy() end)
