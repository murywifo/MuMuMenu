-- MuMu Menu Completo com Melhorias Visuais e ConfiguraÃ§Ãµes ESP

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ConfiguraÃ§Ãµes iniciais
local ESPEnabled = false
local AimbotEnabled = false
local InfinityJumpEnabled = false
local FOV = 90
local TeamCheckESP = true
local AllyColor = Color3.fromRGB(0, 255, 0)
local AllyAltColor = Color3.fromRGB(0, 0, 255)
local EnemyColor = Color3.fromRGB(255, 0, 0)
local EnemyAltColor = Color3.fromRGB(128, 0, 128)

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuMuMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Criar Frame Principal (arredondado)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- BotÃ£o fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

-- BotÃ£o abrir menu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Text = "â˜°"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 20
OpenBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false

local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0, 10)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Tecla Control para abrir/fechar menu
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
        OpenBtn.Visible = not MainFrame.Visible
    end
end)

-- Criador de botÃµes arredondados
local function createButton(name, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.Position = position
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = parent
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

-- Infinity Jump botÃ£o
local InfJumpBtn = createButton("Infinity Jump", UDim2.new(0, 10, 0, 40), MainFrame)
InfJumpBtn.MouseButton1Click:Connect(function()
    InfinityJumpEnabled = not InfinityJumpEnabled
    InfJumpBtn.Text = "Infinity Jump: " .. (InfinityJumpEnabled and "ON" or "OFF")
end)
UserInputService.JumpRequest:Connect(function()
    if InfinityJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ESP botÃ£o
local ESPBtn = createButton("ESP", UDim2.new(0, 10, 0, 80), MainFrame)
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
end)

-- AIMBOT botÃ£o
local AimBtn = createButton("AIMBOT", UDim2.new(0, 10, 0, 120), MainFrame)
AimBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
end)

-- FOV slider (simples)
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Text = "FOV: " .. FOV
FOVLabel.Size = UDim2.new(0, 150, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 160)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = MainFrame

local FOVSlider = Instance.new("TextButton")
FOVSlider.Size = UDim2.new(0, 150, 0, 10)
FOVSlider.Position = UDim2.new(0, 10, 0, 185)
FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVSlider.Text = ""
FOVSlider.Parent = MainFrame
local sliderCorner = Instance.new("UICorner", FOVSlider)
sliderCorner.CornerRadius = UDim.new(0, 6)

local dragging = false
FOVSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderX = FOVSlider.AbsolutePosition.X
        local percent = math.clamp((mouseX - sliderX) / FOVSlider.AbsoluteSize.X, 0, 1)
        FOV = math.floor(30 + percent * 150)
        FOVLabel.Text = "FOV: " .. FOV
    end
end)

-- ESP Drawing
local espBoxes = {}

local function createESPForPlayer(player)
    if espBoxes[player] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false
    box.ZIndex = 2
    local outline = Drawing.new("Square")
    outline.Thickness = 2
    outline.Filled = false
    outline.Color = Color3.new(0, 0, 0)
    outline.Visible = false
    outline.ZIndex = 1
    espBoxes[player] = {Box = box, Outline = outline}
end

local function removeESPForPlayer(player)
    if espBoxes[player] then
        espBoxes[player].Box:Remove()
        espBoxes[player].Outline:Remove()
        espBoxes[player] = nil
    end
end

local function updateESP()
    for player, drawings in pairs(espBoxes) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player == LocalPlayer then
            drawings.Box.Visible = false
            drawings.Outline.Visible = false
            continue
        end

        if TeamCheckESP and player.Team == LocalPlayer.Team then
            drawings.Box.Color = AllyAltColor
        else
            drawings.Box.Color = EnemyAltColor
        end

        local root = player.Character.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if onScreen then
            local distance = (root.Position - Camera.CFrame.Position).Magnitude
            local scale = 150 / distance
            local size = Vector2.new(20, 40) * scale

            drawings.Box.Size = size
            drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
            drawings.Box.Visible = ESPEnabled

            drawings.Outline.Size = size
            drawings.Outline.Position = drawings.Box.Position
            drawings.Outline.Visible = ESPEnabled
        else
            drawings.Box.Visible = false
            drawings.Outline.Visible = false
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESPForPlayer(p) end
end
Players.PlayerAdded:Connect(createESPForPlayer)
Players.PlayerRemoving:Connect(removeESPForPlayer)

local function getClosestEnemy()
    local closest = nil
    local shortestDist = FOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if player.Team == LocalPlayer.Team then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    updateESP()
    if AimbotEnabled then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

print("[MuMuMenu] Script melhorado carregado com sucesso!")
