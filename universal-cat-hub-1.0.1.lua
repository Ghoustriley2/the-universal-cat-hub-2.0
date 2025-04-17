-- // GUI Setup
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
Frame.Size = UDim2.new(0, 250, 0, 200)
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

-- // === ESP Section ===
local DescESP = Instance.new("TextLabel", Frame)
DescESP.Size = UDim2.new(0.7, 0, 0, 30)
DescESP.Position = UDim2.new(0.05, 0, 0, 40)
DescESP.Text = "ESP players"
DescESP.TextColor3 = Color3.fromRGB(255, 255, 255)
DescESP.BackgroundTransparency = 1
DescESP.Font = Enum.Font.SourceSans
DescESP.TextSize = 16
DescESP.TextXAlignment = Enum.TextXAlignment.Left

local ToggleESP = Instance.new("TextButton", Frame)
ToggleESP.Size = UDim2.new(0, 40, 0, 20)
ToggleESP.Position = UDim2.new(0.8, 0, 0, 45)
ToggleESP.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleESP.Text = ""
ToggleESP.BorderSizePixel = 0

local ToggleDotESP = Instance.new("Frame", ToggleESP)
ToggleDotESP.Size = UDim2.new(0.5, 0, 1, 0)
ToggleDotESP.Position = UDim2.new(0, 0, 0, 0)
ToggleDotESP.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local espEnabled = false

ToggleESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ToggleDotESP:TweenPosition(UDim2.new(espEnabled and 0.5 or 0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)

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

-- // === Noclip Section ===
local DescNoclip = Instance.new("TextLabel", Frame)
DescNoclip.Size = UDim2.new(0.7, 0, 0, 30)
DescNoclip.Position = UDim2.new(0.05, 0, 0, 90)
DescNoclip.Text = "Noclip"
DescNoclip.TextColor3 = Color3.fromRGB(255, 255, 255)
DescNoclip.BackgroundTransparency = 1
DescNoclip.Font = Enum.Font.SourceSans
DescNoclip.TextSize = 16
DescNoclip.TextXAlignment = Enum.TextXAlignment.Left

local ToggleNoclip = Instance.new("TextButton", Frame)
ToggleNoclip.Size = UDim2.new(0, 40, 0, 20)
ToggleNoclip.Position = UDim2.new(0.8, 0, 0, 95)
ToggleNoclip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleNoclip.Text = ""
ToggleNoclip.BorderSizePixel = 0

local ToggleDotNoclip = Instance.new("Frame", ToggleNoclip)
ToggleDotNoclip.Size = UDim2.new(0.5, 0, 1, 0)
ToggleDotNoclip.Position = UDim2.new(0, 0, 0, 0)
ToggleDotNoclip.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local noclipEnabled = false
local connection

ToggleNoclip.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	ToggleDotNoclip:TweenPosition(UDim2.new(noclipEnabled and 0.5 or 0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)

	if noclipEnabled then
		connection = RunService.Stepped:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if connection then connection:Disconnect() end
		if LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

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

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		DragButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- // Открытие/закрытие меню
DragButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)