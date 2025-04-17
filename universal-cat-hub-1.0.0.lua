-- // GUI Setup
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Удалим старую версию если есть
if CoreGui:FindFirstChild("UniversalCatHub") then
    CoreGui:FindFirstChild("UniversalCatHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UniversalCatHub"
ScreenGui.ResetOnSpawn = false

-- // Плавающая кнопка
local DragButton = Instance.new("TextButton", ScreenGui)
DragButton.Size = UDim2.new(0, 50, 0, 50)
DragButton.Position = UDim2.new(0, 100, 0, 100)
DragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DragButton.Text = "≡"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DragButton.AutoButtonColor = false

-- // Окно меню
local Frame = Instance.new("Frame", DragButton)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(1, 10, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Visible = false
Frame.BorderSizePixel = 0

-- // Заголовок
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "universal cat hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- // ESP Description
local Desc = Instance.new("TextLabel", Frame)
Desc.Size = UDim2.new(0.7, 0, 0, 30)
Desc.Position = UDim2.new(0.05, 0, 0, 40)
Desc.Text = "ESP players"
Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
Desc.BackgroundTransparency = 1
Desc.Font = Enum.Font.SourceSans
Desc.TextSize = 16
Desc.TextXAlignment = Enum.TextXAlignment.Left

-- // Переключатель ESP
local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0, 40, 0, 20)
Toggle.Position = UDim2.new(0.8, 0, 0, 45)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Text = ""
Toggle.BorderSizePixel = 0

local ToggleDot = Instance.new("Frame", Toggle)
ToggleDot.Size = UDim2.new(0.5, 0, 1, 0)
ToggleDot.Position = UDim2.new(0, 0, 0, 0)
ToggleDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- // Переменные
local espEnabled = false

-- // Перетаскивание кнопки
local dragging, dragInput, dragStart, startPos

DragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = DragButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

DragButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		DragButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- // Открытие/закрытие меню
DragButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- // Включение ESP
Toggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ToggleDot:TweenPosition(
		UDim2.new(espEnabled and 0.5 or 0, 0, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true
	)

	if espEnabled then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPBox") then
				local highlight = Instance.new("Highlight", player.Character)
				highlight.Name = "ESPBox"
				highlight.FillColor = Color3.new(1, 1, 1)
				highlight.FillTransparency = 0.8
				highlight.OutlineColor = Color3.new(1, 1, 1)
			end
		end

		-- Следить за новыми игроками
		Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(char)
				if espEnabled then
					local highlight = Instance.new("Highlight", char)
					highlight.Name = "ESPBox"
					highlight.FillColor = Color3.new(1, 1, 1)
					highlight.FillTransparency = 0.8
					highlight.OutlineColor = Color3.new(1, 1, 1)
				end
			end)
		end)
	else
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("ESPBox") then
				player.Character.ESPBox:Destroy()
			end
		end
	end
end)