-- Universal Cat Hub (UCH) v1.1
-- Автор: Ты и ChatGPT

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "UCH_GUI"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = "Universal Cat Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BorderSizePixel = 0

-- Кнопка "Закрыть"
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.BackgroundTransparency = 1

closeButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Кнопка "Свернуть"
local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 2)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 14
minimizeButton.BackgroundTransparency = 1

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(mainFrame:GetChildren()) do
		if child:IsA("TextButton") and child ~= closeButton and child ~= minimizeButton then
			child.Visible = not minimized
		end
	end
	mainFrame.Size = minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 300)
end)

-- Функция создания переключателя
local function createToggle(name, posY, callback)
	local toggle = Instance.new("TextButton", mainFrame)
	toggle.Size = UDim2.new(1, -20, 0, 30)
	toggle.Position = UDim2.new(0, 10, 0, posY)
	toggle.Text = name .. ": OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.SourceSans
	toggle.TextSize = 16
	toggle.BorderSizePixel = 0

	local isOn = false
	toggle.MouseButton1Click:Connect(function()
		isOn = not isOn
		toggle.Text = name .. ": " .. (isOn and "ON" or "OFF")
		callback(isOn)
	end)
end

-- Функции

-- Rainbow Skin (фиксированный)
createToggle("Rainbow Skin", 40, function(state)
	if state then
		local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		while wait(0.2) and char and char:FindFirstChild("Humanoid") and char.Parent and ScreenGui do
			for _, part in ipairs(char:GetChildren()) do
				if part:IsA("BasePart") then
					part.Color = Color3.fromHSV(math.random(), 1, 1)
				end
			end
			if not state then break end
		end
	end
end)

-- Jerk Off
createToggle("Jerk Off", 80, function(state)
	if state then
		game.ReplicatedStorage:FindFirstChild("JerkOffTool"):Clone().Parent = game.Players.LocalPlayer.Backpack
	end
end)

-- Bang
createToggle("Bang", 120, function(state)
	if state then
		game.ReplicatedStorage:FindFirstChild("Bang"):Clone().Parent = game.Players.LocalPlayer.Backpack
	end
end)

-- Gravity 0
createToggle("Gravity 0", 160, function(state)
	local player = game.Players.LocalPlayer
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if root then
		local gravity = workspace.Gravity
		workspace.Gravity = state and 0 or 196.2
	end
end)

-- Speed Hack (ползунок)
local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Position = UDim2.new(0, 10, 0, 200)
speedLabel.Size = UDim2.new(0, 230, 0, 20)
speedLabel.Text = "Speed Hack"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.SourceSansBold

local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Position = UDim2.new(0, 10, 0, 225)
speedBox.Size = UDim2.new(0, 230, 0, 30)
speedBox.PlaceholderText = "Введите скорость (напр. 100)"
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 16
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
speedBox.ClearTextOnFocus = false

speedBox.FocusLost:Connect(function()
	local speed = tonumber(speedBox.Text)
	if speed and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
	end
end)