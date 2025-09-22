-- 🚨 XENO ROBLOX SCRIPT — UNIVERSAL FLIGHT WITH DRAGGABLE GUI
-- ВСТАВЬ В EXECUTOR (XENO, KRNL, SYNAPSE и т.д.)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XenoFlightGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.5, -75, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(0, 170, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "✈️ FLIGHT [F]"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.BackgroundTransparency = 0.3
button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
button.Parent = frame

-- Переменные
local flying = false
local flightSpeed = 50
local humanoid = nil

-- Функция переключения полёта
local function toggleFlight()
    flying = not flying
    button.Text = flying and "✈️ FLYING..." or "✈️ FLIGHT [F]"
    button.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 120, 255)

    local character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")

    if flying then
        -- Отключаем стандартную физику
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
    end
end

-- Привязка кнопки
button.MouseButton1Click:Connect(toggleFlight)

-- Горячая клавиша F
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFlight()
    end
end)

-- Основной цикл полёта (работает для всех игроков)
game:GetService("RunService").Heartbeat:Connect(function()
    if not flying then return end

    local character = player.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local moveVector = Vector3.new(0, 0, 0)
    local delta = game:GetService("RunService").Heartbeat:Wait()
    local speed = flightSpeed * delta

    -- Управление
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + root.CFrame.LookVector * speed
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector - root.CFrame.LookVector * speed
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector - root.CFrame.RightVector * speed
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + root.CFrame.RightVector * speed
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        moveVector = moveVector + Vector3.new(0, speed * 2, 0)
    end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        moveVector = moveVector - Vector3.new(0, speed * 2, 0)
    end

    -- Устанавливаем скорость — сервер синхронизирует всем
    root.Velocity = moveVector * 60 -- компенсация за delta
end)

-- Защита от удаления GUI
coroutine.wrap(function()
    while wait(2) do
        if not screenGui.Parent then
            screenGui.Parent = player:FindFirstChild("PlayerGui") or player.PlayerGui
        end
        if screenGui.Parent ~= player.PlayerGui then
            screenGui.Parent = player.PlayerGui
        end
    end
end)()

print("✅ Xeno Flight Script Loaded — Press F or click button to toggle flight!")
