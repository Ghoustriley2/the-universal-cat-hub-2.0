-- Universal Cat Hub v1.0.4
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "UniversalCatHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Text = "UNIVERSAL CAT HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Function to make toggle buttons
local function createToggle(name, parent, callback, y)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 280, 0, 40)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextScaled = true
    local state = false

    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- ESP Function
local function enableESP(on)
    if not on then
        for _,v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("ESP") then
                v.ESP:Destroy()
            end
        end
        return
    end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local box = Instance.new("BoxHandleAdornment", plr.Character)
            box.Name = "ESP"
            box.Adornee = plr.Character
            box.Size = Vector3.new(4, 6, 2)
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
        end
    end
end

-- Noclip
local noclipConn
local function setNoclip(on)
    if on then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConn then
        noclipConn:Disconnect()
    end
end

-- Fly
local flying = false
local function setFly(on)
    if on then
        flying = true
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
        BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

        game:GetService("RunService").RenderStepped:Connect(function()
            if flying then
                BodyGyro.CFrame = workspace.CurrentCamera.CFrame
                local moveVec = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVec = moveVec + workspace.CurrentCamera.CFrame.lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVec = moveVec - workspace.CurrentCamera.CFrame.lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVec = moveVec - workspace.CurrentCamera.CFrame.rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVec = moveVec + workspace.CurrentCamera.CFrame.rightVector
                end
                BodyVelocity.Velocity = moveVec * 50
            end
        end)
    else
        flying = false
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end

-- TP к игроку
local dropdown = Instance.new("TextButton", Frame)
dropdown.Size = UDim2.new(0, 280, 0, 40)
dropdown.Position = UDim2.new(0, 10, 0, 260)
dropdown.Text = "TP к игроку"
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextScaled = true

local playerList = Instance.new("ScrollingFrame", Frame)
playerList.Size = UDim2.new(0, 280, 0, 100)
playerList.Position = UDim2.new(0, 10, 0, 310)
playerList.Visible = false
playerList.CanvasSize = UDim2.new(0, 0, 0, 500)
playerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

dropdown.MouseButton1Click:Connect(function()
    playerList.Visible = not playerList.Visible
    playerList:ClearAllChildren()
    for i, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, (i - 1) * 35)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                end
            end)
        end
    end
end)

-- Toggle Buttons
createToggle("ESP", Frame, enableESP, 60)
createToggle("Noclip", Frame, setNoclip, 110)
createToggle("Fly", Frame, setFly, 160)