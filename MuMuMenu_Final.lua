-- MuMu Menu Completo Corrigido e CompatÃ­vel com Roblox Executor

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ConfiguraÃ§Ãµes
local ESPEnabled = false
local AimbotEnabled = false
local InfinityJumpEnabled = false
local FOV = 90
local TeamCheckESP = true
local AllyColor = Color3.fromRGB(0, 255, 0)
local AllyAltColor = Color3.fromRGB(0, 0, 255)
local EnemyColor = Color3.fromRGB(255, 0, 0)
local EnemyAltColor = Color3.fromRGB(128, 0, 128)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuMuMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.Text = "â˜°"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local OpenUICorner = Instance.new("UICorner", OpenBtn)
OpenUICorner.CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame

local CloseUICorner = Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
        OpenBtn.Visible = not MainFrame.Visible
    end
end)

-- FunÃ§Ã£o rÃ¡pida para criar botÃµes
local function CreateButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yOffset)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
    end)
end

CreateButton("Infinity Jump", 50, function()
    InfinityJumpEnabled = not InfinityJumpEnabled
    return InfinityJumpEnabled
end)

CreateButton("ESP", 90, function()
    ESPEnabled = not ESPEnabled
    return ESPEnabled
end)

CreateButton("AIMBOT", 130, function()
    AimbotEnabled = not AimbotEnabled
    return AimbotEnabled
end)

-- Slider de FOV
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0, 150, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 170)
FOVLabel.Text = "FOV: " .. FOV
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = MainFrame

local FOVSlider = Instance.new("Frame")
FOVSlider.Size = UDim2.new(0, 150, 0, 8)
FOVSlider.Position = UDim2.new(0, 10, 0, 195)
FOVSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FOVSlider.Parent = MainFrame

local SliderUICorner = Instance.new("UICorner", FOVSlider)
SliderUICorner.CornerRadius = UDim.new(0, 4)

local FOVHandle = Instance.new("Frame")
FOVHandle.Size = UDim2.new(0, 8, 0, 16)
FOVHandle.Position = UDim2.new((FOV - 30) / 150, 0, -0.5, 0)
FOVHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FOVHandle.Parent = FOVSlider

local HandleCorner = Instance.new("UICorner", FOVHandle)

local dragging = false

FOVHandle.InputBegan:Connect(function(input)
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
        FOVHandle.Position = UDim2.new(percent, -4, -0.5, 0)
        FOVLabel.Text = "FOV: " .. FOV
    end
end)

-- Infinity Jump funcional
UserInputService.JumpRequest:Connect(function()
    if InfinityJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

print("[MuMuMenu] Script corrigido carregado com sucesso.")
