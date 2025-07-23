-- MuMu Menu Script Completo

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações iniciais
local ESPEnabled = false
local AimbotEnabled = false
local InfinityJumpEnabled = false
local FOV = 90
local TeamCheckESP = true
local AllyColor = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

-- Criar Menu UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MuMuMenu"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

local BgImage = Instance.new("ImageLabel", MainFrame)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.Image = "rbxassetid://87676365321602"
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.3

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Image = "rbxassetid://87676365321602"
OpenBtn.BackgroundTransparency = 1
OpenBtn.Visible = false
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Alternar menu com tecla Control
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
        OpenBtn.Visible = not MainFrame.Visible
    end
end)

-- Infinity Jump
local InfJumpBtn = Instance.new("TextButton", MainFrame)
InfJumpBtn.Size = UDim2.new(0, 150, 0, 30)
InfJumpBtn.Position = UDim2.new(0, 10, 0, 40)
InfJumpBtn.Text = "Infinity Jump: OFF"
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
local InfinityJumpEnabled = false
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

-- ESP toggle
local ESPBtn = Instance.new("TextButton", MainFrame)
ESPBtn.Size = UDim2.new(0, 150, 0, 30)
ESPBtn.Position = UDim2.new(0, 10, 0, 80)
ESPBtn.Text = "ESP: OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
local ESPEnabled = false
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
end)

-- AIMBOT toggle
local AimBtn = Instance.new("TextButton", MainFrame)
AimBtn.Size = UDim2.new(0, 150, 0, 30)
AimBtn.Position = UDim2.new(0, 10, 0, 120)
AimBtn.Text = "AIMBOT: OFF"
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
local AimbotEnabled = false
AimBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
end)

-- FOV slider textbox
local FOVBox = Instance.new("TextBox", MainFrame)
FOVBox.Size = UDim2.new(0, 150, 0, 30)
FOVBox.Position = UDim2.new(0, 10, 0, 160)
FOVBox.Text = tostring(FOV)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVBox.ClearTextOnFocus = false
FOVBox.FocusLost:Connect(function()
    local val = tonumber(FOVBox.Text)
    if val and val >= 1 and val <= 180 then
        FOV = val
    else
        FOVBox.Text = tostring(FOV)
    end
end)

-- ESP Box Drawing setup
local espBoxes = {}

local function createESPForPlayer(player)
    if espBoxes[player] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false
    local outline = Drawing.new("Square")
    outline.Thickness = 3
    outline.Filled = false
    outline.Color = Color3.new(0,0,0)
    outline.Visible = false
    espBoxes[player] = {Box=box, Outline=outline}
end

local function removeESPForPlayer(player)
    if espBoxes[player] then
        espBoxes[player].Box:Remove()
        espBoxes[player].Outline:Remove()
        espBoxes[player] = nil
    end
end

-- Atualiza ESP de todos os players
local function updateESP()
    for player, drawings in pairs(espBoxes) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player == LocalPlayer then
            drawings.Box.Visible = false
            drawings.Outline.Visible = false
            continue
        end
        
        if TeamCheckESP and player.Team == LocalPlayer.Team then
            drawings.Box.Visible = false
            drawings.Outline.Visible = false
            continue
        end

        local root = player.Character.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if onScreen then
            local scale = 1000 / (root.Position - Camera.CFrame.Position).Magnitude
            local size = Vector2.new(25, 45) * scale / 100

            drawings.Box.Size = size
            drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
            drawings.Box.Color = player.Team == LocalPlayer.Team and AllyColor or EnemyColor
            drawings.Box.Visible = ESPEnabled

            drawings.Outline.Size = drawings.Box.Size
            drawings.Outline.Position = drawings.Box.Position
            drawings.Outline.Visible = ESPEnabled
        else
            drawings.Box.Visible = false
            drawings.Outline.Visible = false
        end
    end
end

-- Criar ESP para todos jogadores existentes
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESPForPlayer(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    createESPForPlayer(p)
end)

Players.PlayerRemoving:Connect(function(p)
    removeESPForPlayer(p)
end)

-- Função para achar inimigo mais próximo no FOV para AIMBOT
local function getClosestEnemy()
    local closest = nil
    local shortestDist = FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if player.Team == LocalPlayer.Team then
                continue
            end
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

-- Update loop
RunService.RenderStepped:Connect(function()
    updateESP()
    
    if AimbotEnabled then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

print("[MuMuMenu] Script carregado com sucesso!")
