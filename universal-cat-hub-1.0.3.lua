-- // Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Удалим старую версию
if CoreGui:FindFirstChild("UniversalCatHub") then
    CoreGui.UniversalCatHub:Destroy()
end

-- // GUI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UniversalCatHub"
ScreenGui.ResetOnSpawn = false

-- // Плавающая кнопка
local DragButton = Instance.new("TextButton", ScreenGui)
DragButton.Size = UDim2.new(0, 50, 0, 50)
DragButton.Position = UDim2.new(0, 100, 0, 100)
DragButton.BackgroundColor3 = Color3.new(0, 0, 0)
DragButton.Text = "≡"
DragButton.TextColor3 = Color3.new(1, 1, 1)

-- // Меню
local MainFrame = Instance.new("Frame", DragButton)
MainFrame.Size = UDim2.new(0, 300, 0, 260)
MainFrame.Position = UDim2.new(1, 10, 0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0

-- // Заголовок
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Universal Cat Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- // Меню функций
local function createToggle(name, positionY, callback)
	local label = Instance.new("TextLabel", MainFrame)
	label.Size = UDim2.new(0.7, 0, 0, 30)
	label.Position = UDim2.new(0.05, 0, 0, positionY)
	label.Text = name
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left

	local button = Instance.new("TextButton", MainFrame)
	button.Size = UDim2.new(0, 40, 0, 20)
	button.Position = UDim2.new(0.8, 0, 0, positionY + 5)
	button.BackgroundColor3 = Color3.new(1, 1, 1)
	button.Text = ""
	button.BorderSizePixel = 0

	local dot = Instance.new("Frame", button)
	dot.Size = UDim2.new(0.5, 0, 1, 0)
	dot.Position = UDim2.new(0, 0, 0, 0)
	dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

	local enabled = false
	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		dot:TweenPosition(UDim2.new(enabled and 0.5 or 0, 0, 0, 0), "Out", "Quad", 0.2, true)
		callback(enabled)
	end)
end

-- === ESP ===
createToggle("ESP", 40, function(state)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			if state then
				if not char:FindFirstChild("ESPBox") then
					local highlight = Instance.new("Highlight", char)
					highlight.Name = "ESPBox"
					highlight.FillTransparency = 0.8
					highlight.FillColor = Color3.new(1, 1, 1)
				end
			else
				if char:FindFirstChild("ESPBox") then
					char.ESPBox:Destroy()
				end
			end
		end
	end
end)

-- === Noclip ===
local noclipConn
createToggle("Noclip", 90, function(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

-- === Fly ===
local flyConn
createToggle("Fly", 140, function(state)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if state then
		local gyro = Instance.new("BodyGyro", hrp)
		gyro.P = 9e4
		gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		gyro.CFrame = hrp.CFrame

		local vel = Instance.new("BodyVelocity", hrp)
		vel.Velocity = Vector3.new(0, 0, 0)
		vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		flyConn = RunService.RenderStepped:Connect(function()
			local dir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
			vel.Velocity = dir.Unit * 100
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if hrp then
			if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
			if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
		end
	end
end)

-- === TP ===
local TpLabel = Instance.new("TextLabel", MainFrame)
TpLabel.Position = UDim2.new(0.05, 0, 0, 190)
TpLabel.Size = UDim2.new(0.9, 0, 0, 20)
TpLabel.Text = "Выбери игрока для ТП"
TpLabel.TextColor3 = Color3.new(1, 1, 1)
TpLabel.BackgroundTransparency = 1
TpLabel.TextXAlignment = Enum.TextXAlignment.Left

local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Position = UDim2.new(0.05, 0, 0, 210)
PlayerList.Size = UDim2.new(0.9, 0, 0, 80)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerList.BorderSizePixel = 0
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.Padding = UDim.new(0, 5)

local selectedPlayer = nil

local function refreshPlayerList()
	PlayerList:ClearAllChildren()
	UIListLayout.Parent = PlayerList
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton", PlayerList)
			btn.Size = UDim2.new(1, 0, 0, 25)
			btn.Text = player.Name
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = player
			end)
		end
	end
end

refreshPlayerList()

local TpBtn = Instance.new("TextButton", MainFrame)
TpBtn.Size = UDim2.new(0.9, 0, 0, 30)
TpBtn.Position = UDim2.new(0.05, 0, 1, -40)
TpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
TpBtn.Text = "Телепорт"
TpBtn.TextColor3 = Color3.new(1, 1, 1)

TpBtn.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)

-- // Перетаскивание
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

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		DragButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- // Открытие/закрытие меню
DragButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	refreshPlayerList()
end)