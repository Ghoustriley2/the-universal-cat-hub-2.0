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

-- === Fly ===
local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 30)
FlyBtn.Position = UDim2.new(0.05, 0, 0, 140)
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.Text = "Fly"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = Enum.Font.SourceSans
FlyBtn.TextSize = 16

local flying = false
local flyConn

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        local bodyGyro = Instance.new("BodyGyro")
        local bodyVel = Instance.new("BodyVelocity")
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        bodyGyro.Parent = hrp
        bodyVel.Parent = hrp
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.CFrame = hrp.CFrame

        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Velocity = Vector3.new(0, 0, 0)

        flyConn = RunService.RenderStepped:Connect(function()
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
            bodyVel.Velocity = move * 60
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in pairs(hrp:GetChildren()) do
                if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- === Teleport to Player ===
local TPBtn = Instance.new("TextButton", Frame)
TPBtn.Size = UDim2.new(0.9, 0, 0, 30)
TPBtn.Position = UDim2.new(0.05, 0, 0, 180)
TPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TPBtn.Text = "TP к игроку"
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBtn.Font = Enum.Font.SourceSans
TPBtn.TextSize = 16

local TPFrame = Instance.new("Frame", ScreenGui)
TPFrame.Size = UDim2.new(0, 200, 0, 200)
TPFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
TPFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPFrame.Visible = false

local UIList = Instance.new("UIListLayout", TPFrame)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Padding = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", TPFrame)
CloseBtn.Size = UDim2.new(1, 0, 0, 30)
CloseBtn.Text = "Закрыть"
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.MouseButton1Click:Connect(function() TPFrame.Visible = false end)

TPBtn.MouseButton1Click:Connect(function()
    TPFrame.Visible = true
    for _, child in pairs(TPFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= CloseBtn then child:Destroy() end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", TPFrame)
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Text = player.Name
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.MouseButton1Click:Connect(function()
                local char = player.Character
                local myChar = LocalPlayer.Character
                if char and myChar and char:FindFirstChild("HumanoidRootPart") then
                    myChar:MoveTo(char.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                end
            end)
        end
    end
end)

-- Кнопка открытия GUI
local dragging = false
local dragInput, mousePos, framePos

DragButton.MouseButton1Down:Connect(function(input)
    dragging = true
    mousePos = input.Position
    framePos = DragButton.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mousePos
        DragButton.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

DragButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)