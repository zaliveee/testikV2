local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local spawnButton = Instance.new("TextButton")
local petNameBox = Instance.new("TextBox")
local label = Instance.new("TextLabel")
local uiCorner = Instance.new("UICorner")
local uiCornerFrame = Instance.new("UICorner")
local uiCornerButton = Instance.new("UICorner")

-- Настройка GUI
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Настройка основной рамки (Frame)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 80) -- Темный фиолетово-синий фон
frame.BackgroundTransparency = 0.1
frame.Active = true -- Включаем активность для взаимодействий
frame.Parent = screenGui

uiCornerFrame.CornerRadius = UDim.new(0, 20) -- Скругление углов рамки
uiCornerFrame.Parent = frame

-- Настройка текста
label.Text = "Enter Pet Name:"
label.Size = UDim2.new(1, 0, 0.2, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.BackgroundTransparency = 1
label.Parent = frame

-- Текстовое поле (TextBox)
petNameBox.Size = UDim2.new(1, -40, 0.3, 0)
petNameBox.Position = UDim2.new(0, 20, 0.25, 0)
petNameBox.PlaceholderText = "Type pet name here"
petNameBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
petNameBox.TextColor3 = Color3.fromRGB(50, 50, 50)
petNameBox.Font = Enum.Font.Gotham
petNameBox.TextScaled = true
petNameBox.Parent = frame

uiCorner.CornerRadius = UDim.new(0, 10) -- Скругленные углы текстового поля
uiCorner.Parent = petNameBox

-- Кнопка (TextButton)
spawnButton.Text = "Spawn Pet"
spawnButton.Size = UDim2.new(1, -40, 0.3, 0)
spawnButton.Position = UDim2.new(0, 20, 0.6, 0)
spawnButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- Голубой фон кнопки
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.GothamBold
spawnButton.TextScaled = true
spawnButton.Parent = frame

uiCornerButton.CornerRadius = UDim.new(0, 10) -- Скругленные углы кнопки
uiCornerButton.Parent = spawnButton

-- Тень для рамки
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5587865193" -- Текстура мягкой тени
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = frame

-- Функция перемещения окна
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Скрипт для замены питомца
local Pets = require(game:GetService("ReplicatedStorage").Library.Directory.Pets)
local defaultPet = "Merry Manatee"

local function spawnPet()
    local targetPet = petNameBox.Text
    if targetPet == "" then
        warn("Please enter a pet name!")
        return
    end

    if Pets[defaultPet] and Pets[targetPet] then
        for i, v in pairs(Pets[defaultPet]) do
            Pets[defaultPet][i] = nil
        end

        for i, v in pairs(Pets[targetPet]) do
            Pets[defaultPet][i] = v
        end

        print("Pet modification completed!")
    else
        warn("Invalid pet name or pets not found!")
    end
end

-- Привязка функции к кнопке
spawnButton.MouseButton1Click:Connect(spawnPet)

