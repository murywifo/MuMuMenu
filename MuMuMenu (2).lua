
-- MuMu Menu - ESP, Aimbot (com FOV), Infinity Jump
-- Desenvolvido para fins de teste e detecção

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Interface
local MuMuUI = Instance.new("ScreenGui", game.CoreGui)
MuMuUI.Name = "MuMuMenu"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleButton.Text = "MuMu Menu"
toggleButton.Parent = MuMuUI

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 10, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
mainFrame.Visible = true
mainFrame.Parent = MuMuUI

-- Dropdown para ESP
local espEnabled = false
local function createDropdown(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
end

createDropdown("Ativar ESP (Time/Inimigo)", mainFrame, function()
    espEnabled = not espEnabled
end)

-- Slider de FOV
local fov = 90
local slider = Instance.new("TextBox")
slider.Size = UDim2.new(1, -20, 0, 30)
slider.Position = UDim2.new(0, 10, 0, 100)
slider.Text = tostring(fov)
slider.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
slider.TextColor3 = Color3.new(1, 1, 1)
slider.Parent = mainFrame

slider.FocusLost:Connect(function()
    local val = tonumber(slider.Text)
    if val and val >= 1 and val <= 180 then
        fov = val
    else
        slider.Text = tostring(fov)
    end
end)

-- AIMBOT básico
local function getClosestTarget()
    local closest = nil
    local shortest = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(player.Character.Head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
            if onScreen and dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local tag = head:FindFirstChild("MuMuESP") or Instance.new("BillboardGui", head)
                    tag.Name = "MuMuESP"
                    tag.Size = UDim2.new(0, 100, 0, 20)
                    tag.StudsOffset = Vector3.new(0, 2, 0)
                    tag.AlwaysOnTop = true
                    local label = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = player.Name
                    label.TextScaled = true
                    label.BackgroundTransparency = 1
                    label.TextColor3 = player.Team == localPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                end
            end
        end
    end
end)

-- Infinity Jump
local jumping = false
UserInputService.JumpRequest:Connect(function()
    if jumping then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

createDropdown("Infinity Jump", mainFrame, function()
    jumping = not jumping
end)

-- Toggle com Control
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
