local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Создаём меню
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UniversalCatHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "UNIVERSAL CAT HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.BackgroundTransparency = 1

-- Переключатели
local toggles = {
    ESP = false,
    Noclip = false,
    Fly = false
}

local flySpeed = 3
local flying = false
local noclipConnection

local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18

    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. ": " .. (toggles[name] and "ON" or "OFF")
        callback(toggles[name])
    end)
end

-- ESP
local function toggleESP(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if state then
                local esp = Instance.new("BillboardGui", player.Character:FindFirstChild("Head"))
                esp.Name = "ESP"
                esp.Size = UDim2.new(0,100,0,40)
                esp.AlwaysOnTop = true
                local label = Instance.new("TextLabel", esp)
                label.Text = player.Name
                label.Size = UDim2.new(1,0,1,0)
                label.TextColor3 = Color3.new(1,0,0)
                label.BackgroundTransparency = 1
            else
                local head = player.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("ESP") then
                    head.ESP:Destroy()
                end
            end
        end
    end
end

-- Noclip
local function toggleNoclip(state)
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- Fly
local function toggleFly(state)
    flying = state
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")

    if flying then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        bodyGyro.Parent = hrp
        bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bodyGyro.P = 10000
        bodyGyro.CFrame = hrp.CFrame

        bodyVelocity.Parent = hrp
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)

        RunService.RenderStepped:Connect(function()
            if not flying then return end
            local moveVec = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += workspace.CurrentCamera.CFrame.lookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= workspace.CurrentCamera.CFrame.lookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= workspace.CurrentCamera.CFrame.rightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += workspace.CurrentCamera.CFrame.rightVector end
            bodyVelocity.Velocity = moveVec * flySpeed
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
    end
end

-- Teleport к игроку
local function teleportToPlayer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
            break -- Телепорт к первому найденному игроку
        end
    end
end

-- Создаём кнопки
createButton("ESP", 50, toggleESP)
createButton("Noclip", 90, toggleNoclip)
createButton("Fly", 130, toggleFly)

-- Кнопка TP
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.8, 0, 0, 30)
tpBtn.Position = UDim2.new(0.1, 0, 0, 170)
tpBtn.Text = "TP к игроку"
tpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.SourceSans
tpBtn.TextSize = 18
tpBtn.MouseButton1Click:Connect(teleportToPlayer)
