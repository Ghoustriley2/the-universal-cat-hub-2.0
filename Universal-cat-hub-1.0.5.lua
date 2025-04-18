local Players = game:GetService("Players")
local player = Players.LocalPlayer
local plrGui = player:WaitForChild("PlayerGui")
local coreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Main GUI
local gui = Instance.new("ScreenGui", coreGui)
gui.Name = "UniversalCatHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 330, 0, 450)
frame.Position = UDim2.new(0, 30, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Title (squishable)
local title = Instance.new("TextButton", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Universal Cat Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BorderSizePixel = 0

-- Container for toggles and extras
local container = Instance.new("ScrollingFrame", frame)
container.Position = UDim2.new(0, 10, 0, 45)
container.Size = UDim2.new(1, -20, 1, -55)
container.CanvasSize = UDim2.new(0, 0, 4, 0)
container.ScrollBarThickness = 6
container.BackgroundTransparency = 1
container.BorderSizePixel = 0

-- Menu toggle logic
local toggleMenu = true
title.MouseButton1Click:Connect(function()
    toggleMenu = not toggleMenu
    container.Visible = toggleMenu
    frame.Size = toggleMenu and UDim2.new(0, 330, 0, 450) or UDim2.new(0, 330, 0, 40)
end)

-- Helper: Create toggle
local function createToggle(name, callback)
    local toggleFrame = Instance.new("Frame", container)
    toggleFrame.Size = UDim2.new(1, -10, 0, 30)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Position = UDim2.new(0, 0, 0, #container:GetChildren() * 35)

    local label = Instance.new("TextLabel", toggleFrame)
    label.Text = name
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", toggleFrame)
    button.Text = "OFF"
    button.Size = UDim2.new(0.3, -10, 0.8, 0)
    button.Position = UDim2.new(0.7, 10, 0.1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    button.TextColor3 = Color3.new(1, 1, 1)

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 0, 0)
        callback(state)
    end)
end

-- Helper: Create speed slider
local function createSpeedSlider()
    local sliderFrame = Instance.new("Frame", container)
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Text = "Speed Hack"
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1

    local slider = Instance.new("TextBox", sliderFrame)
    slider.PlaceholderText = "Enter speed (default: 16)"
    slider.Text = ""
    slider.Position = UDim2.new(0, 5, 0.5, 0)
    slider.Size = UDim2.new(1, -10, 0.5, -5)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    slider.ClearTextOnFocus = false

    slider.FocusLost:Connect(function()
        local num = tonumber(slider.Text)
        if num then
            local hum = player.Character and player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = num
            end
        end
    end)
end

-- Helper: Create teleport menu
local function createTeleportToPlayer()
    createToggle("Teleport to Random Player", function(on)
        if on then
            local targets = Players:GetPlayers()
            local target = targets[math.random(1, #targets)]
            if target and target.Character and player.Character then
                player.Character:MoveTo(target.Character:GetPivot().Position + Vector3.new(2, 0, 2))
            end
        end
    end)
end

-- Helper: Simple ESP
local function createESP()
    createToggle("Enable ESP", function(on)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head and not head:FindFirstChild("ESP") then
                    local box = Instance.new("BillboardGui", head)
                    box.Name = "ESP"
                    box.Size = UDim2.new(0, 100, 0, 40)
                    box.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", box)
                    label.Text = plr.Name
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.BackgroundTransparency = 1
                end
            end
        end
        if not on then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head and head:FindFirstChild("ESP") then
                        head.ESP:Destroy()
                    end
                end
            end
        end
    end)
end

-------------------------
-- Скрипт-функции ниже --
-------------------------

createToggle("Rainbow Skin", function(on)
    while on do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end
        task.wait(0.1)
        if not on then break end
    end
end)

createToggle("Gravity 0", function(on)
    workspace.Gravity = on and 0 or 196.2
end)

createToggle("Car Fly", function(on)
    while on do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") and v.Occupant == player.Character:FindFirstChild("Humanoid") then
                v:FindFirstAncestorOfClass("Model"):TranslateBy(Vector3.new(0, 1, 0))
            end
        end
        wait(0.1)
        if not on then break end
    end
end)

createToggle("Server VIP (visual)", function(on)
    print("VIP:", on)
end)

createToggle("Server Admin (visual)", function(on)
    print("Admin:", on)
end)

createSpeedSlider()
createESP()
createTeleportToPlayer()