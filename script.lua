-- ██╗  ██╗ █████╗ ██████╗ ██████╗  █████╗ ██████╗ ██████╗ 
-- ██║ ██╔╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗
-- █████╔╝ ███████║██████╔╝██████╔╝███████║██████╔╝██████╔╝
-- ██╔═██╗ ██╔══██║██╔══██╗██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ 
-- ██║  ██╗██║  ██║██║  ██║██║  ██║██║  ██║██║     ██║     
-- ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     
-- Ultimate Edition for Ink Game

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ps = game:GetService("PhysicsService")

-- Создаем новую группу столкновений для NoClip
if not pcall(function() ps:CreateCollisionGroup("NoClipGroup") end) then
    ps:RemoveCollisionGroup("NoClipGroup")
    ps:CreateCollisionGroup("NoClipGroup")
end
ps:CollisionGroupSetCollidable("NoClipGroup", "Default", false)

-- UI Elements
local ui = Instance.new("ScreenGui")
ui.Name = "KaratelHub_UI"
ui.ResetOnSpawn = false
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = ui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 0.3
titleBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Karatel Hub | Ink Game"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundTransparency = 0.3
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

-- Контент
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Создаем вкладки
local tabs = {}
local tabButtons = {}

local function createTab(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0, 40)
    btn.Position = UDim2.new(0, yPos*105, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = contentFrame

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 400)
    content.ScrollBarThickness = 4
    content.Parent = contentFrame

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        for _, c in pairs(tabs) do
            c.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
    end)

    table.insert(tabButtons, btn)
    table.insert(tabs, content)
    
    if #tabs == 1 then
        btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
    end
    
    return content
end

-- Функции для создания элементов UI
local function createButton(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, y, default, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 16
    lbl.Parent = parent

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.3, 0, 0, 30)
    toggle.Position = UDim2.new(0.7, 0, 0, y)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 16
    toggle.Parent = parent

    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(default)
    end)

    return toggle
end

local function createInput(parent, text, y, default, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 16
    lbl.Parent = parent

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.3, 0, 0, 30)
    input.Position = UDim2.new(0.7, 0, 0, y)
    input.Text = tostring(default)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 16
    input.Parent = parent

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.2, 0, 0, 30)
    applyBtn.Position = UDim2.new(1, -70, 0, y)
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    applyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    applyBtn.BorderSizePixel = 0
    applyBtn.Font = Enum.Font.SourceSans
    applyBtn.TextSize = 14
    applyBtn.Parent = parent

    applyBtn.MouseButton1Click:Connect(function()
        callback(tonumber(input.Text) or default)
    end)

    return input
end

-- Создаем вкладки
local movementTab = createTab("Movement", 0)
local combatTab = createTab("Combat", 1)
local visualsTab = createTab("Visuals", 2)
local safetyTab = createTab("Safety", 3)

-- Переменные состояния
local noClipEnabled = false
local flyEnabled = false
local espEnabled = false
local killAuraEnabled = false
local safeModeEnabled = false
local autoTeleportEnabled = false
local walkSpeedValue = 16
local jumpPowerValue = 50
local flySpeedValue = 50

-- Movement Tab
createButton(movementTab, "↑ Teleport +100", 10, function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
    end
end)

createButton(movementTab, "↓ Teleport -40", 60, function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, -40, 0)
    end
end)

createToggle(movementTab, "NoClip", 110, false, function(state)
    noClipEnabled = state
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if state then
                    ps:SetPartCollisionGroup(part, "NoClipGroup")
                else
                    ps:SetPartCollisionGroup(part, "Default")
                end
            end
        end
    end
end)

createToggle(movementTab, "Fly", 160, false, function(state)
    flyEnabled = state
end)

createInput(movementTab, "WalkSpeed", 210, 16, function(value)
    walkSpeedValue = value
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

createInput(movementTab, "JumpPower", 260, 50, function(value)
    jumpPowerValue = value
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

createInput(movementTab, "Fly Speed", 310, 50, function(value)
    flySpeedValue = value
end)

-- Combat Tab
createToggle(combatTab, "Kill Aura", 10, false, function(state)
    killAuraEnabled = state
end)

-- Visuals Tab
createToggle(visualsTab, "ESP (Hide'n Seek)", 10, false, function(state)
    espEnabled = state
end)

-- Safety Tab
createToggle(safetyTab, "Safe Mode (<20 HP)", 10, false, function(state)
    safeModeEnabled = state
end)

createToggle(safetyTab, "Auto Teleport (10s)", 60, false, function(state)
    autoTeleportEnabled = state
end)

-- Закрытие по кнопке G и по крестику
closeButton.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

uis.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        ui.Enabled = not ui.Enabled
    end
end)

-- Основная логика
local lastTeleportTime = 0
local lastTarget = nil

rs.Heartbeat:Connect(function(deltaTime)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    
    if not root or not humanoid then return end

    -- Обновляем скорость и прыжок
    humanoid.WalkSpeed = walkSpeedValue
    humanoid.JumpPower = jumpPowerValue

    -- Fly Logic
    if flyEnabled then
        local moveVector = Vector3.new(0, 0, 0)
        if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + root.CFrame.LookVector * flySpeedValue end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - root.CFrame.LookVector * flySpeedValue end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - root.CFrame.RightVector * flySpeedValue end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + root.CFrame.RightVector * flySpeedValue end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, flySpeedValue, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0, flySpeedValue, 0) end
        root.Velocity = moveVector
    end

    -- Kill Aura Logic
    if killAuraEnabled then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (root.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestPlayer = otherPlayer
                    closestDistance = distance
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            lastTarget = closestPlayer
            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
            local offset = CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -3)
            root.CFrame = CFrame.lookAt(offset.Position, targetPos) * CFrame.Angles(0, math.rad(os.clock() * 360), 0)
        end
    end

    -- Safe Mode Logic
    if safeModeEnabled and humanoid.Health < 20 then
        if not autoTeleportEnabled then
            root.CFrame = root.CFrame + Vector3.new(0, 150, 0)
            safeModeEnabled = false -- Отключаем после одного срабатывания
        else
            lastTeleportTime = lastTeleportTime + deltaTime
            if lastTeleportTime >= 10 then
                lastTeleportTime = 0
                root.CFrame = root.CFrame + Vector3.new(0, 150, 0)
            end
        end
    end
end)

-- ESP Logic
rs.RenderStepped:Connect(function()
    if not espEnabled then
        for _, obj in ipairs(workspace.CurrentCamera:GetChildren()) do
            if obj.Name == "ESP_BOX" or obj.Name == "ESP_TEXT" then
                obj:Destroy()
            end
        end
        return
    end

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local isKiller = false
            
            -- Проверяем, есть ли у игрока оружие
            for _, child in ipairs(plr.Character:GetChildren()) do
                if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Fork" or child.Name == "Bottle" or child.Name == "Fists") then
                    isKiller = true
                    break
                end
            end

            -- Создаем Box
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_BOX"
            box.Adornee = hrp
            box.Size = Vector3.new(2, 5, 1)
            box.Color3 = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 100, 255)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = workspace.CurrentCamera

            -- Создаем текст с именем
            local txt = Instance.new("BillboardGui")
            txt.Name = "ESP_TEXT"
            txt.Adornee = hrp
            txt.Size = UDim2.new(0, 120, 0, 40)
            txt.StudsOffset = Vector3.new(0, 3, 0)
            txt.AlwaysOnTop = true
            txt.Parent = workspace.CurrentCamera

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Text = plr.Name
            lbl.TextColor3 = isKiller and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 200, 255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.TextStrokeTransparency = 0
            lbl.TextSize = 16
            lbl.Font = Enum.Font.GothamBold
            lbl.Parent = txt
        end
    end
end)

print("✅ Karatel Hub успешно загружен! Нажмите G для скрытия/показа меню.")
