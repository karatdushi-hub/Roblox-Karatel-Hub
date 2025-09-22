
-- Karatel Hub | Ink Game

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 240)
main.Position = UDim2.new(0.5, -110, 0.5, -120)
main.BackgroundTransparency = 0.3
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Draggable = true
main.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "⚡ Karatel Hub"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextSize = 18
title.Font = Enum.Font.GothamBold

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextSize = 20

local function newBtn(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = main
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function newSlider(name, y, min, max, def, onChange)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. def
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Parent = main

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 8)
    slider.Position = UDim2.new(0, 10, 0, y + 22)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.BorderSizePixel = 0
    slider.Parent = main

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(def / max, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local drag = Instance.new("Frame")
    drag.Size = UDim2.new(0, 10, 0, 16)
    drag.Position = UDim2.new(def / max, -5, 0.5, -8)
    drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    drag.BorderSizePixel = 0
    drag.Parent = slider

    local dragging = false
    drag.MouseButton1Down:Connect(function()
        dragging = true
    end)
    game.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game.UserInputService.InputChanged:Connect(function(input)
        if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local pos = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        drag.Position = UDim2.new(pos, -5, 0.5, -8)
        label.Text = name .. ": " .. val
        onChange(val)
    end)

    onChange(def)
end

title.Parent = main
close.Parent = main
main.Parent = gui
gui.Parent = player:WaitForChild("PlayerGui")

-- Функции

newBtn("↑ Телепорт +100", 40, function()
    root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
end)

newBtn("↓ Телепорт -40", 75, function()
    root.CFrame = root.CFrame + Vector3.new(0, -40, 0)
end)

local noClip = false
newBtn("NoClip: OFF", 110, function(btn)
    noClip = not noClip
    btn.Text = "NoClip: " .. (noClip and "ON" or "OFF")
    btn.TextColor3 = noClip and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not noClip
        end
    end
end)

local flying = false
local flySpeed = 50
local function toggleFly(state)
    flying = state
    if flying then
        game:GetService("RunService").Heartbeat:Connect(function()
            if not flying then return end
            local move = Vector3.new(0, 0, 0)
            if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + root.CFrame.LookVector * flySpeed end
            if game.UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - root.CFrame.LookVector * flySpeed end
            if game.UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - root.CFrame.RightVector * flySpeed end
            if game.UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + root.CFrame.RightVector * flySpeed end
            if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, flySpeed, 0) end
            if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, flySpeed, 0) end
            root.Velocity = move
        end)
    end
end

newBtn("Fly: OFF", 145, function(btn)
    flying = not flying
    toggleFly(flying)
    btn.Text = "Fly: " .. (flying and "ON" or "OFF")
    btn.TextColor3 = flying and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

newSlider("WalkSpeed", 180, 16, 200, 50, function(v)
    hum.WalkSpeed = v
end)

newSlider("JumpPower", 210, 0, 100, 50, function(v)
    hum.JumpPower = v
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
