-- Для загрузки интерфейса
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "ESP_GUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Visible = true

-- Кнопка для сворачивания и закрытия меню
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -75, 0, 10)
ToggleButton.Text = "Свернуть / Открыть"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

-- Функции ESP
local espPlayer = Instance.new("TextButton")
local espObjects = Instance.new("TextButton")
local espNickname = Instance.new("TextButton")
local espNPCs = Instance.new("TextButton")
local espEvent = Instance.new("TextButton")

-- Функции для ESP
espPlayer.Name = "ESP_Player"
espPlayer.Parent = MainFrame
espPlayer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espPlayer.Size = UDim2.new(0, 150, 0, 50)
espPlayer.Position = UDim2.new(0.5, -75, 0, 70)
espPlayer.Text = "ESP Игроки"
espPlayer.TextColor3 = Color3.fromRGB(255, 255, 255)
espPlayer.TextSize = 20

espObjects.Name = "ESP_Objects"
espObjects.Parent = MainFrame
espObjects.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espObjects.Size = UDim2.new(0, 150, 0, 50)
espObjects.Position = UDim2.new(0.5, -75, 0, 130)
espObjects.Text = "ESP Объекты"
espObjects.TextColor3 = Color3.fromRGB(255, 255, 255)
espObjects.TextSize = 20

espNickname.Name = "ESP_Nickname"
espNickname.Parent = MainFrame
espNickname.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espNickname.Size = UDim2.new(0, 150, 0, 50)
espNickname.Position = UDim2.new(0.5, -75, 0, 190)
espNickname.Text = "ESP Никнеймы"
espNickname.TextColor3 = Color3.fromRGB(255, 255, 255)
espNickname.TextSize = 20

espNPCs.Name = "ESP_NPCs"
espNPCs.Parent = MainFrame
espNPCs.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espNPCs.Size = UDim2.new(0, 150, 0, 50)
espNPCs.Position = UDim2.new(0.5, -75, 0, 250)
espNPCs.Text = "ESP NPCs"
espNPCs.TextColor3 = Color3.fromRGB(255, 255, 255)
espNPCs.TextSize = 20

espEvent.Name = "ESP_Event"
espEvent.Parent = MainFrame
espEvent.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espEvent.Size = UDim2.new(0, 150, 0, 50)
espEvent.Position = UDim2.new(0.5, -75, 0, 310)
espEvent.Text = "ESP Ивенты"
espEvent.TextColor3 = Color3.fromRGB(255, 255, 255)
espEvent.TextSize = 20

-- Функции для активации ESP
local function activateESPPlayer()
    -- Тут код для активации ESP для игроков
end

local function activateESPObjects()
    -- Тут код для активации ESP для объектов
end

local function activateESPNickname()
    -- Тут код для активации ESP для никнеймов
end

local function activateESPNPCs()
    -- Тут код для активации ESP для NPC
end

local function activateESPEvent()
    -- Тут код для активации ESP для текущего ивента в Brookhaven RP
end

-- Привязка кнопок к функциям
espPlayer.MouseButton1Click:Connect(activateESPPlayer)
espObjects.MouseButton1Click:Connect(activateESPObjects)
espNickname.MouseButton1Click:Connect(activateESPNickname)
espNPCs.MouseButton1Click:Connect(activateESPNPCs)
espEvent.MouseButton1Click:Connect(activateESPEvent)

-- Скрытие / показ меню при нажатии кнопки
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)