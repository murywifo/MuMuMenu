
--// MuMu Menu Script Finalizado (ESP, AIMBOT, Infinity Jump) //-- 

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurações
local Settings = {
    Aimbot = false,
    ESP = true,
    InfJump = false,
    FOV = 90,
    TeamCheck = true,
    AllyColors = {
        Green = Color3.fromRGB(0, 255, 0),
        Blue = Color3.fromRGB(0, 0, 255),
    },
    EnemyColors = {
        Red = Color3.fromRGB(255, 0, 0),
        Purple = Color3.fromRGB(128, 0, 128),
    }
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MuMuMenu"
local UICorner = Instance.new("UICorner")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 420)
Frame.Position = UDim2.new(0.5, -175, 0.5, -210)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
UICorner:Clone().Parent = Frame

-- Botão para abrir/fechar
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.Text = "+"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
UICorner:Clone().Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Elementos do menu
local function createRoundedButton(name, yPos)
    local button = Instance.new("TextButton", Frame)
    button.Size = UDim2.new(0, 300, 0, 40)
    button.Position = UDim2.new(0, 25, 0, yPos)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    UICorner:Clone().Parent = button
    return button
end

local function createSlider(yPos, min, max, default, callback)
    local label = Instance.new("TextLabel", Frame)
    label.Size = UDim2.new(0, 300, 0, 20)
    label.Position = UDim2.new(0, 25, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = "FOV: " .. tostring(default)
    label.TextColor3 = Color3.new(1, 1, 1)

    local slider = Instance.new("TextButton", Frame)
    slider.Size = UDim2.new(0, 300, 0, 20)
    slider.Position = UDim2.new(0, 25, 0, yPos + 25)
    slider.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    UICorner:Clone().Parent = slider
    slider.Text = ""

    local drag = Instance.new("Frame", slider)
    drag.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    drag.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    drag.Position = UDim2.new(0, 0, 0, 0)
    UICorner:Clone().Parent = drag

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mouse - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            drag.Size = UDim2.new(rel, 0, 1, 0)
            local value = math.floor(min + (max - min) * rel)
            label.Text = "FOV: " .. tostring(value)
            callback(value)
        end
    end)
end

-- Botões
local aimbotBtn = createRoundedButton("Toggle AIMBOT", 20)
aimbotBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    aimbotBtn.Text = "Toggle AIMBOT (" .. tostring(Settings.Aimbot) .. ")"
end)

local espBtn = createRoundedButton("Toggle ESP", 70)
espBtn.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    espBtn.Text = "Toggle ESP (" .. tostring(Settings.ESP) .. ")"
end)

local infBtn = createRoundedButton("Toggle Infinity Jump", 120)
infBtn.MouseButton1Click:Connect(function()
    Settings.InfJump = not Settings.InfJump
    infBtn.Text = "Toggle Infinity Jump (" .. tostring(Settings.InfJump) .. ")"
end)

createSlider(180, 10, 180, Settings.FOV, function(val)
    Settings.FOV = val
end)

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
