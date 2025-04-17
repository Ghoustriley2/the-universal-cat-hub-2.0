-- Весь функционал переработан, включая: -- - Плавающее перетаскиваемое меню -- - ESP, Noclip, Fly -- - Телепорт с выбором игрока через всплывающее подменю

local CoreGui = game:GetService("CoreGui") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild("UniversalCatHub") then CoreGui:FindFirstChild("UniversalCatHub"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui) ScreenGui.Name = "UniversalCatHub" ScreenGui.ResetOnSpawn = false

-- Перетаскиваемая кнопка local DragButton = Instance.new("TextButton", ScreenGui) DragButton.Size = UDim2.new(0, 50, 0, 50) DragButton.Position = UDim2.new(0, 100, 0, 100) DragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) DragButton.Text = "≡" DragButton.TextColor3 = Color3.fromRGB(255, 255, 255) DragButton.AutoButtonColor = false

-- Меню (основное окно) local Frame = Instance.new("Frame", DragButton) Frame.Size = UDim2.new(0, 250, 0, 300) Frame.Position = UDim2.new(1, 10, 0, 0) Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) Frame.Visible = false Frame.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", Frame) UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createLabel(text) local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, -10, 0, 30) lbl.Text = text lbl.TextColor3 = Color3.new(1,1,1) lbl.BackgroundTransparency = 1 lbl.Font = Enum.Font.SourceSansBold lbl.TextSize = 16 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.LayoutOrder = 0 return lbl end

local function createToggle(name, callback) local container = Instance.new("Frame") container.Size = UDim2.new(1, -10, 0, 30) container.BackgroundTransparency = 1

local label = Instance.new("TextLabel", container)
label.Size = UDim2.new(0.7, 0, 1, 0)
label.Text = name
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSans
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("TextButton", container)
toggle.Size = UDim2.new(0.25, 0, 0.7, 0)
toggle.Position = UDim2.new(0.75, 0, 0.15, 0)
toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle.BorderSizePixel = 0
toggle.Text = ""

local dot = Instance.new("Frame", toggle)
dot.Size = UDim2.new(0.5, 0, 1, 0)
dot.Position = UDim2.new(0, 0, 0, 0)
dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local state = false

toggle.MouseButton1Click:Connect(function()
    state = not state
    dot:TweenPosition(UDim2.new(state and 0.5 or 0, 0, 0, 0), "Out", "Quad", 0.2, true)
    callback(state)
end)

return container

end

local function createButton(text, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -10, 0, 30) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.SourceSans btn.TextSize = 16 btn.MouseButton1Click:Connect(callback) return btn end

-- ESP Toggle Frame:AddChild(createLabel("ESP Players")) Frame:AddChild(createToggle("ESP", function(on) if on then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ESPBox") then local h = Instance.new("Highlight", p.Character) h.Name = "ESPBox" h.FillTransparency = 0.8 end end else for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("ESPBox") then p.Character.ESPBox:Destroy() end end end end))

-- Noclip Toggle Frame:AddChild(createLabel("Noclip")) local noclipConn Frame:AddChild(createToggle("Noclip", function(on) if on then noclipConn = RunService.Stepped:Connect(function() if LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) elseif noclipConn then noclipConn:Disconnect() end end))

-- Fly Frame:AddChild(createLabel("Fly")) local flying, flyConn Frame:AddChild(createButton("Fly", function() flying = not flying local char = LocalPlayer.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") if not hrp then return end if flying then local bg = Instance.new("BodyGyro", hrp) local bv = Instance.new("BodyVelocity", hrp) bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.P = 9e4 bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) bv.Velocity = Vector3.zero flyConn = RunService.RenderStepped:Connect(function() local cam = workspace.CurrentCamera local dir = Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end bv.Velocity = dir * 50 bg.CFrame = cam.CFrame end) else if flyConn then flyConn:Disconnect() end hrp:FindFirstChildOfClass("BodyGyro"):Destroy() hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end end))

-- TP меню local tpFrame = Instance.new("Frame", Frame) tpFrame.Size = UDim2.new(1, -10, 0, 100) tpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) tpFrame.Visible = false

local playerList = Instance.new("ScrollingFrame", tpFrame) playerList.Size = UDim2.new(1, 0, 1, 0) playerList.CanvasSize = UDim2.new(0, 0, 5, 0) playerList.ScrollBarThickness = 4

local selectedPlayer for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then local pBtn = Instance.new("TextButton", playerList) pBtn.Size = UDim2.new(1, -4, 0, 25) pBtn.Text = p.Name pBtn.TextColor3 = Color3.new(1,1,1) pBtn.BackgroundColor3 = Color3.fromRGB(30,30,30) pBtn.MouseButton1Click:Connect(function() selectedPlayer = p tpFrame.Visible = false end) end end

Frame:AddChild(createButton("TP", function() tpFrame.Visible = not tpFrame.Visible end))

Frame:AddChild(createButton("Teleport!", function() if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(selectedPlayer.Character.HumanoidRootPart.Position) end end))

-- Открытие меню по клику на значок DragButton.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

-- Перетаскивание меню local dragging, dragInput, dragStart, startPos

DragButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = DragButton.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end if dragging and input == dragInput then local delta = input.Position - dragStart DragButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

