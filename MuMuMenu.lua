
-- MuMu Menu - Script Completo
-- Criado para Roblox Lua
-- Funções: ESP com team check, AIMBOT com FOV, Infinity Jump
-- Interface vermelha e preta, abre/fecha com Control ou botão

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

-- ======= INTERFACE =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuMuMenuGui"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.BackgroundTransparency = 0

-- Função helper para botões arredondados
local function makeButton(text, parent, pos, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0, 120, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = parent
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 0
    btn.ClipsDescendants = true
    btn.AnchorPoint = Vector2.new(0, 0)
    btn.Name = text:gsub(" ", "") .. "Btn"
    btn.Style = Enum.ButtonStyle.RobloxRound
    return btn
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "MuMu Menu"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 24
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local toggleBtn = makeButton("X", titleBar, UDim2.new(1, -40, 0, 5), UDim2.new(0, 35, 0, 30))

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Abrir/fechar com Control
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ======= ESP =======
local espSection = Instance.new("Frame")
espSection.Size = UDim2.new(1, -20, 0, 140)
espSection.Position = UDim2.new(0, 10, 0, 50)
espSection.BackgroundTransparency = 1
espSection.Parent = mainFrame

local espTitle = Instance.new("TextLabel")
espTitle.Text = "ESP Settings"
espTitle.Size = UDim2.new(1, 0, 0, 25)
espTitle.BackgroundTransparency = 1
espTitle.TextColor3 = Color3.fromRGB(220, 50, 50)
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 20
espTitle.Parent = espSection

local function createDropdown(title, options, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = espSection

    local label = Instance.new("TextLabel")
    label.Text = title
    label.Size = UDim2.new(0, 100, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local selected = Instance.new("TextButton")
    selected.Text = options[1]
    selected.Size = UDim2.new(0, 150, 1, 0)
    selected.Position = UDim2.new(0, 110, 0, 0)
    selected.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    selected.TextColor3 = Color3.new(1,1,1)
    selected.Font = Enum.Font.Gotham
    selected.TextSize = 18
    selected.Parent = frame
    selected.AutoButtonColor = true
    selected.BorderSizePixel = 0
    selected.ClipsDescendants = true
    selected.AnchorPoint = Vector2.new(0, 0)

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0, 150, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0, 110, 1, 0)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame

    local function hideDropdown()
        dropdownFrame.Visible = false
    end

    selected.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        optionBtn.Text = option
        optionBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
        optionBtn.TextColor3 = Color3.new(1,1,1)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 16
        optionBtn.Parent = dropdownFrame
        optionBtn.AutoButtonColor = true
        optionBtn.BorderSizePixel = 0
        optionBtn.ClipsDescendants = true

        optionBtn.MouseButton1Click:Connect(function()
            selected.Text = option
            hideDropdown()
            if frame.ChangedCallback then
                frame.ChangedCallback(option)
            end
        end)
    end

    return frame
end

local teamColorsOptions = {"Verde", "Azul"}
local enemyColorsOptions = {"Vermelho", "Roxo"}

local colorMap = {
    Verde = Color3.fromRGB(0, 255, 0),
    Azul = Color3.fromRGB(0, 0, 255),
    Vermelho = Color3.fromRGB(255, 0, 0),
    Roxo = Color3.fromRGB(128, 0, 128),
}

local selectedTeamColor = colorMap[teamColorsOptions[1]]
local selectedEnemyColor = colorMap[enemyColorsOptions[1]]

local teamColorDropdown = createDropdown("Team Color:", teamColorsOptions, UDim2.new(0, 0, 0, 40))
local enemyColorDropdown = createDropdown("Enemy Color:", enemyColorsOptions, UDim2.new(0, 0, 0, 90))

teamColorDropdown.ChangedCallback = function(choice)
    selectedTeamColor = colorMap[choice]
end

enemyColorDropdown.ChangedCallback = function(choice)
    selectedEnemyColor = colorMap[choice]
end

-- ESP Logic
local espBoxes = {}

local function createEspBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.5
    box.Color3 = Color3.new(1, 0, 0)
    box.Parent = workspace
    return box
end

local function updateEsp()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not espBoxes[player] then
                espBoxes[player] = createEspBox(player)
            end

            local box = espBoxes[player]
            box.Adornee = player.Character.HumanoidRootPart

            if player.Team == LocalPlayer.Team then
                box.Color3 = selectedTeamColor
            else
                box.Color3 = selectedEnemyColor
            end
            box.Transparency = 0.5
            box.Visible = true
        end
    end

    for player, box in pairs(espBoxes) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player == LocalPlayer then
            box.Visible = false
            espBoxes[player] = nil
            box:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if mainFrame.Visible then
        updateEsp()
    else
        for _, box in pairs(espBoxes) do
            box.Visible = false
        end
    end
end)

-- ======= AIMBOT =======
local aimSection = Instance.new("Frame")
aimSection.Size = UDim2.new(1, -20, 0, 100)
aimSection.Position = UDim2.new(0, 10, 0, 200)
aimSection.BackgroundTransparency = 1
aimSection.Parent = mainFrame

local aimTitle = Instance.new("TextLabel")
aimTitle.Text = "AIMBOT Settings"
aimTitle.Size = UDim2.new(1, 0, 0, 25)
aimTitle.BackgroundTransparency = 1
aimTitle.TextColor3 = Color3.fromRGB(220, 50, 50)
aimTitle.Font = Enum.Font.GothamBold
aimTitle.TextSize = 20
aimTitle.Parent = aimSection

local fovLabel = Instance.new("TextLabel")
fovLabel.Text = "FOV: 90°"
fovLabel.Size = UDim2.new(0, 70, 0, 25)
fovLabel.Position = UDim2.new(0, 10, 0, 40)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 16
fovLabel.Parent = aimSection

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 200, 0, 20)
sliderFrame.Position = UDim2.new(0, 90, 0, 45)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
sliderFrame.Parent = aimSection
sliderFrame.ClipsDescendants = true
sliderFrame.BorderSizePixel = 0
sliderFrame.AnchorPoint = Vector2.new(0,0)
sliderFrame.BackgroundTransparency = 0

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
sliderBar.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 15, 1, 0)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
sliderButton.Text = ""
sliderButton.Parent = sliderFrame
sliderButton.AutoButtonColor = false
sliderButton.BorderSizePixel = 0
sliderButton.ClipsDescendants = true

local aimFov = 90

local dragging = false

local function updateSlider(input)
    local mousePos = input.Position.X
    local sliderPos = sliderFrame.AbsolutePosition.X
    local sliderWidth = sliderFrame.AbsoluteSize.X
    local relativePos = math.clamp(mousePos - sliderPos, 0, sliderWidth)
    local percent = relativePos / sliderWidth
    aimFov = math.floor( percent * 180 )
    fovLabel.Text = "FOV: "..aimFov.."°"
    sliderBar.Size = UDim2.new(percent, 0, 1, 0)
    sliderButton.Position = UDim2.new(percent, -7, 0, 0)
end

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

sliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input)
    end
end)

local function inFov(targetPos)
    local screenPos, onScreen = camera:WorldToScreenPoint(targetPos)
    if not onScreen then return false end

    local mousePos = UIS:GetMouseLocation()
    local dx = mousePos.X - screenPos.X
    local dy = mousePos.Y - screenPos.Y
    local dist = math.sqrt(dx*dx + dy*dy)

    local fovPixels = (aimFov / 180) * (camera.ViewportSize.X / 2)

    return dist <= fovPixels
end

local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Team ~= LocalPlayer.Team then
            local pos = player.Character.HumanoidRootPart.Position
            if inFov(pos) then
                local screenPos = camera:WorldToScreenPoint(pos)
                local mousePos = UIS:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local aimbotEnabled = true

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and mainFrame.Visible then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
        end
    end
end)

-- ======= INFINITY JUMP =======
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local infJumpSection = Instance.new("Frame")
infJumpSection.Size = UDim2.new(1, -20, 0, 60)
infJumpSection.Position = UDim2.new(0, 10, 0, 310)
infJumpSection.BackgroundTransparency = 1
infJumpSection.Parent = mainFrame

local infJumpTitle = Instance.new("TextLabel")
infJumpTitle.Text = "Infinity Jump"
infJumpTitle.Size = UDim2.new(1, 0, 0, 25)
infJumpTitle.BackgroundTransparency = 1
infJumpTitle.TextColor3 = Color3.fromRGB(220, 50, 50)
infJumpTitle.Font = Enum.Font.GothamBold
infJumpTitle.TextSize = 20
infJumpTitle.Parent = infJumpSection

local infJumpToggle = Instance.new("TextButton")
infJumpToggle.Text = "OFF"
infJumpToggle.Size = UDim2.new(0, 70, 0, 30)
infJumpToggle.Position = UDim2.new(0, 10, 0, 30)
infJumpToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
infJumpToggle.TextColor3 = Color3.new(1,1,1)
infJumpToggle.Font = Enum.Font.GothamBold
infJumpToggle.TextSize = 18
infJumpToggle.Parent = infJumpSection
infJumpToggle.BorderSizePixel = 0
infJumpToggle.AutoButtonColor = true
infJumpToggle.ClipsDescendants = true

local infinityJumpEnabled = false

infJumpToggle.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    infJumpToggle.Text = infinityJumpEnabled and "ON" or "OFF"
    infJumpToggle.BackgroundColor3 = infinityJumpEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 30, 30)
end)

UIS.JumpRequest:Connect(function()
    if infinityJumpEnabled then
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        else
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
