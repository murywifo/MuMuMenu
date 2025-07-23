
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuMuMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 350, 0, 420)
menuFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)

local menuButton = Instance.new("ImageButton")
menuButton.Name = "AbrirMenu"
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 10, 0, 10)
menuButton.BackgroundTransparency = 1
menuButton.Image = "rbxassetid://100959264885238"
menuButton.Parent = screenGui

local menuAberto = false
menuButton.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    menuFrame.Visible = menuAberto
end)

local function criarBotao(nome, posY, texto)
    local botao = Instance.new("TextButton")
    botao.Name = nome
    botao.Size = UDim2.new(0, 300, 0, 40)
    botao.Position = UDim2.new(0, 25, 0, posY)
    botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.SourceSansBold
    botao.TextSize = 20
    botao.Text = texto
    botao.Parent = menuFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = botao

    return botao
end

local selectedColor = Color3.fromRGB(0, 255, 0)
local showESP = false

local espDropdown = Instance.new("TextButton")
espDropdown.Name = "ESPDropdown"
espDropdown.Size = UDim2.new(0, 300, 0, 40)
espDropdown.Position = UDim2.new(0, 25, 0, 20)
espDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espDropdown.Text = "ESP: Selecione a Cor"
espDropdown.TextColor3 = Color3.new(1,1,1)
espDropdown.Font = Enum.Font.SourceSansBold
espDropdown.TextSize = 18
espDropdown.Parent = menuFrame

Instance.new("UICorner", espDropdown).CornerRadius = UDim.new(0, 10)

local dropdownAberto = false
local cores = {
    ["Verde"] = Color3.fromRGB(0, 255, 0),
    ["Azul"] = Color3.fromRGB(0, 150, 255),
    ["Vermelho"] = Color3.fromRGB(255, 0, 0),
    ["Roxo"] = Color3.fromRGB(170, 0, 255)
}

espDropdown.MouseButton1Click:Connect(function()
    if dropdownAberto then
        for _, item in pairs(menuFrame:GetChildren()) do
            if item:IsA("TextButton") and item.Name:match("^ESPOption") then
                item:Destroy()
            end
        end
    else
        local yOffset = 70
        for nome, cor in pairs(cores) do
            local option = criarBotao("ESPOption_"..nome, yOffset, "ESP: "..nome)
            option.BackgroundColor3 = cor
            option.MouseButton1Click:Connect(function()
                selectedColor = cor
                showESP = true
            end)
            yOffset = yOffset + 50
        end
    end
    dropdownAberto = not dropdownAberto
end)

local aimbotOn = false
local fov = 90

local aimbotBtn = criarBotao("AIMBOT", 280, "AIMBOT: Ativar")
aimbotBtn.MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
end)

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 300, 0, 20)
fovLabel.Position = UDim2.new(0, 25, 0, 330)
fovLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.TextSize = 16
fovLabel.Font = Enum.Font.SourceSans
fovLabel.Text = "FOV: 90"
fovLabel.Parent = menuFrame
Instance.new("UICorner", fovLabel).CornerRadius = UDim.new(0, 8)

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 300, 0, 10)
sliderBar.Position = UDim2.new(0, 25, 0, 355)
sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBar.Parent = menuFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.5, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fill.Parent = sliderBar
Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local conn
        conn = uis.InputChanged:Connect(function(move)
            if move.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((move.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                fov = math.floor(pos * 180)
                fovLabel.Text = "FOV: "..fov
            end
        end)
        input.Changed:Connect(function(state)
            if state == Enum.UserInputState.End then
                conn:Disconnect()
            end
        end)
    end
end)

-- ESP e AIMBOT funcional com Team Check e FOV
local function getClosestEnemy()
    local closest = nil
    local shortest = math.huge
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Team ~= player.Team and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos = target.Character.HumanoidRootPart.Position
            local screenPos, visible = workspace.CurrentCamera:WorldToViewportPoint(pos)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - uis:GetMouseLocation()).Magnitude
            if visible and dist < shortest and dist <= fov then
                shortest = dist
                closest = target.Character
            end
        end
    end
    return closest
end

runService.RenderStepped:Connect(function()
    if showESP then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                if v:FindFirstChild("Head") and not v.Head:FindFirstChild("ESPBox") then
                    local box = Instance.new("BillboardGui", v.Head)
                    box.Name = "ESPBox"
                    box.Size = UDim2.new(0, 100, 0, 40)
                    box.AlwaysOnTop = true
                    local frame = Instance.new("Frame", box)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = selectedColor
                    frame.BackgroundTransparency = 0.5
                end
            end
        end
    end

    if aimbotOn then
        local target = getClosestEnemy()
        if target and target:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Head.Position)
        end
    end
end)
