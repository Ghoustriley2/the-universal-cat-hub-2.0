-- Universal Cat Hub - v1.2 (GUI Fixes & Fly Update)

-- Создаём GUI local UCHGui = Instance.new("ScreenGui") UCHGui.Name = "UCHGui" UCHGui.ResetOnSpawn = false UCHGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 300, 0, 350) mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) mainFrame.BorderSizePixel = 0 mainFrame.Active = true mainFrame.Draggable = true mainFrame.Parent = UCHGui

local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundColor3 = Color3.fromRGB(30, 30, 30) title.Text = "Universal Cat Hub" title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.SourceSansBold title.TextSize = 18 title.Parent = mainFrame

-- Кнопки управления GUI local closeButton = Instance.new("TextButton") closeButton.Size = UDim2.new(0, 30, 0, 30) closeButton.Position = UDim2.new(1, -60, 0, 0) closeButton.Text = "X" closeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0) closeButton.TextColor3 = Color3.new(1,1,1) closeButton.Parent = mainFrame closeButton.MouseButton1Click:Connect(function() UCHGui:Destroy() end)

local minimizeButton = Instance.new("TextButton") minimizeButton.Size = UDim2.new(0, 30, 0, 30) minimizeButton.Position = UDim2.new(1, -30, 0, 0) minimizeButton.Text = "-" minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) minimizeButton.TextColor3 = Color3.new(1,1,1) minimizeButton.Parent = mainFrame

local minimized = false minimizeButton.MouseButton1Click:Connect(function() for _, child in pairs(mainFrame:GetChildren()) do if child ~= title and child ~= closeButton and child ~= minimizeButton then child.Visible = not minimized end end minimized = not minimized end)

-- Rainbow Skin local rainbowToggle = Instance.new("TextButton") rainbowToggle.Size = UDim2.new(1, -20, 0, 40) rainbowToggle.Position = UDim2.new(0, 10, 0, 50) rainbowToggle.Text = "Toggle Rainbow Skin" rainbowToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40) rainbowToggle.TextColor3 = Color3.new(1,1,1) rainbowToggle.Parent = mainFrame

local rainbowActive = false local rainbowConnection = nil

rainbowToggle.MouseButton1Click:Connect(function() rainbowActive = not rainbowActive if rainbowActive then rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function() local player = game.Players.LocalPlayer local character = player.Character if character then local h = tick() % 1 for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.Color = Color3.fromHSV(h, 1, 1) end end end end) else if rainbowConnection then rainbowConnection:Disconnect() end local character = game.Players.LocalPlayer.Character if character then for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.Color = Color3.fromRGB(255, 255, 255) end end end end end)

-- Fly функция local flyButton = Instance.new("TextButton") flyButton.Size = UDim2.new(1, -20, 0, 40) flyButton.Position = UDim2.new(0, 10, 0, 100) flyButton.Text = "Toggle Fly" flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) flyButton.TextColor3 = Color3.new(1,1,1) flyButton.Parent = mainFrame

local flying = false local bodyGyro, bodyVelocity

flyButton.MouseButton1Click:Connect(function() local player = game.Players.LocalPlayer local char = player.Character or player.CharacterAdded:Wait() local humanoidRootPart = char:WaitForChild("HumanoidRootPart")

flying = not flying
if flying then
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.Parent = humanoidRootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0,0.1,0)
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Parent = humanoidRootPart

	game:GetService("RunService").RenderStepped:Connect(function()
		if flying and humanoidRootPart and bodyGyro and bodyVelocity then
			local camera = workspace.CurrentCamera
			local moveDir = Vector3.new()
			if player.Character:FindFirstChildOfClass("Humanoid") then
				moveDir = player.Character:FindFirstChildOfClass("Humanoid").MoveDirection
			end
			bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveDir * 50)
			bodyGyro.CFrame = camera.CFrame
		end
	end)
else
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

end)

-- Конец скрипта

