-- MuMu Menu Completo Corrigido

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

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuMuMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Criar Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true

-- Imagem de fundo
local BgImage = Instance.new("ImageLabel", MainFrame)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.Image = "rbxassetid://87676365321602"
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.3

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
OpenBtn.Visible = true
end)

-- Botão abrir menu
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.Image = "rbxassetid://87676365321602"
OpenBtn.BackgroundTransparency = 1
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false

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

-- Infinity Jump botão
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Size = UDim2.new(0, 150, 0, 30)
InfJumpBtn.Position = UDim2.new(0, 10, 0, 40)
InfJumpBtn.Text = "Infinity Jump: OFF"
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
InfJumpBtn.TextColor3 = Color3.new(1, 1, 1)
InfJumpBtn.Parent = MainFrame

InfinityJumpEnabled = false

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

-- ESP botão
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0, 150, 0, 30)
ESPBtn.Position = UDim2.new(0, 10, 0, 80)
ESPBtn.Text = "ESP: OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Parent = MainFrame

ESPEnabled = false

ESPBtn.MouseButton1Click:Connect(function()
ESPEnabled = not ESPEnabled
ESPBtn.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
end)

-- AIMBOT botão
local AimBtn = Instance.new("TextButton")
AimBtn.Size = UDim2.new(0, 150, 0, 30)
AimBtn.Position = UDim2.new(0, 10, 0, 120)
AimBtn.Text = "AIMBOT: OFF"
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimBtn.TextColor3 = Color3.new(1, 1, 1)
AimBtn.Parent = MainFrame

AimbotEnabled = false

AimBtn.MouseButton1Click:Connect(function()
AimbotEnabled = not AimbotEnabled
AimBtn.Text = "AIMBOT: " .. (AimbotEnabled and "ON" or "OFF")
end)

-- FOV textbox
local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(0, 150, 0, 30)
FOVBox.Position = UDim2.new(0, 10, 0, 160)
FOVBox.Text = tostring(FOV)
FOVBox.TextColor3 = Color3.new(1, 1, 1)
FOVBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVBox.ClearTextOnFocus = false
FOVBox.Parent = MainFrame

FOVBox.FocusLost:Connect(function()
local val = tonumber(FOVBox.Text)
if val and val >= 1 and val <= 180 then
FOV = val
else
FOVBox.Text = tostring(FOV)
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
outline.Thickness = 3
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
drawings.Box.Visible = false
drawings.Outline.Visible = false
continue
end

local root = player.Character.HumanoidRootPart
local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
if onScreen then
local distance = (root.Position - Camera.CFrame.Position).Magnitude
local scale = 200 / distance
local size = Vector2.new(30, 60) * scale

drawings.Box.Size = size    
    drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)    
    drawings.Box.Color = player.Team == LocalPlayer.Team and AllyColor or EnemyColor    
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

-- Criar ESP para jogadores já presentes
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

-- Encontrar inimigo mais próximo dentro do FOV para AIMBOT
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

-- Loop de atualização
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

