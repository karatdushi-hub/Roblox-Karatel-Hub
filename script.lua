-- 🚀 Karate1 Local HUB by karatdushi-hub
-- Локальное меню: скорость, прыжок, ноклип — только для вас!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Создаём UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 220)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Draggable = true
MainFrame.Active = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Karate1 HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.SourceSansBold

-- WalkSpeed
local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Size = UDim2.new(1, -20, 0, 20)
WalkSpeedLabel.Position = UDim2.new(0, 10, 0, 50)
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.Text = "WalkSpeed: 16"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedLabel.TextSize = 16

local WalkSpeedSlider = Instance.new("Frame")
WalkSpeedSlider.Size = UDim2.new(1, -20, 0, 12)
WalkSpeedSlider.Position = UDim2.new(0, 10, 0, 75)
WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkSpeedSlider.BorderSizePixel = 0

local WalkSpeedFill = Instance.new("Frame")
WalkSpeedFill.Size = UDim2.new(0.5, 0, 1, 0) -- 16/50 = 0.32, но для удобства 0.5
WalkSpeedFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
WalkSpeedFill.BorderSizePixel = 0

local WalkSpeedDrag = Instance.new("TextButton")
WalkSpeedDrag.Size = UDim2.new(0, 12, 0, 12)
WalkSpeedDrag.Position = UDim2.new(0.5, -6, 0.5, -6)
WalkSpeedDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedDrag.BorderSizePixel = 0
WalkSpeedDrag.Text = ""

-- JumpPower
local JumpPowerLabel = Instance.new("TextLabel")
JumpPowerLabel.Size = UDim2.new(1, -20, 0, 20)
JumpPowerLabel.Position = UDim2.new(0, 10, 0, 100)
JumpPowerLabel.BackgroundTransparency = 1
JumpPowerLabel.Text = "JumpPower: 50"
JumpPowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedLabel.TextSize = 16

local JumpPowerSlider = Instance.new("Frame")
JumpPowerSlider.Size = UDim2.new(1, -20, 0, 12)
JumpPowerSlider.Position = UDim2.new(0, 10, 0, 125)
JumpPowerSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpPowerSlider.BorderSizePixel = 0

local JumpPowerFill = Instance.new("Frame")
JumpPowerFill.Size = UDim2.new(1, 0, 1, 0) -- 50/50 = 1.0
JumpPowerFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
JumpPowerFill.BorderSizePixel = 0

local JumpPowerDrag = Instance.new("TextButton")
JumpPowerDrag.Size = UDim2.new(0, 12, 0, 12)
JumpPowerDrag.Position = UDim2.new(1, -6, 0.5, -6)
JumpPowerDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerDrag.BorderSizePixel = 0
JumpPowerDrag.Text = ""

-- NoClip Toggle
local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(1, -20, 0, 30)
NoClipButton.Position = UDim2.new(0, 10, 0, 155)
NoClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 100, 100)
NoClipButton.TextSize = 16

-- Собираем UI
Title.Parent = MainFrame
CloseButton.Parent = MainFrame
WalkSpeedLabel.Parent = MainFrame
WalkSpeedSlider.Parent = MainFrame
WalkSpeedFill.Parent = WalkSpeedSlider
WalkSpeedDrag.Parent = WalkSpeedSlider
JumpPowerLabel.Parent = MainFrame
JumpPowerSlider.Parent = MainFrame
JumpPowerFill.Parent = JumpPowerSlider
JumpPowerDrag.Parent = JumpPowerSlider
NoClipButton.Parent = MainFrame
MainFrame.Parent = ScreenGui
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Функции управления

-- WalkSpeed
local function updateWalkSpeed(x)
    local percent = math.clamp(x / WalkSpeedSlider.AbsoluteSize.X, 0, 1)
    local speed = math.floor(percent * 100) -- от 0 до 100
    humanoid.WalkSpeed = speed
    WalkSpeedLabel.Text = "WalkSpeed: " .. speed
    WalkSpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    WalkSpeedDrag.Position = UDim2.new(percent, -6, 0.5, -6)
end

WalkSpeedDrag.MouseButton1Down:Connect(function()
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = input.Position.X - WalkSpeedSlider.AbsolutePosition.X
            updateWalkSpeed(x)
        end
    end)
end)

-- JumpPower
local function updateJumpPower(x)
    local percent = math.clamp(x / JumpPowerSlider.AbsoluteSize.X, 0, 1)
    local power = math.floor(percent * 100) -- от 0 до 100
    humanoid.JumpPower = power
    JumpPowerLabel.Text = "JumpPower: " .. power
    JumpPowerFill.Size = UDim2.new(percent, 0, 1, 0)
    JumpPowerDrag.Position = UDim2.new(percent, -6, 0.5, -6)
end

JumpPowerDrag.MouseButton1Down:Connect(function()
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = input.Position.X - JumpPowerSlider.AbsolutePosition.X
            updateJumpPower(x)
        end
    end)
end)

-- NoClip
local noClipEnabled = false
local noClipParts = {}

local function toggleNoClip()
    noClipEnabled = not noClipEnabled
    NoClipButton.Text = "NoClip: " .. (noClipEnabled and "ON" or "OFF")
    NoClipButton.TextColor3 = noClipEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

    if noClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(noClipParts, {part, part.CanCollide})
                part.CanCollide = false
            end
        end
    else
        for _, data in ipairs(noClipParts) do
            local part, original = data[1], data[2]
            if part and part.Parent then
                part.CanCollide = original
            end
        end
        noClipParts = {}
    end
end

NoClipButton.MouseButton1Click:Connect(toggleNoClip)

-- Закрытие
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("✅ Karate1 HUB успешно загружен! Управляйте персонажем локально.")
