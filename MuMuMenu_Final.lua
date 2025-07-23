local player = game.Players.LocalPlayer
if not player then
    warn("LocalPlayer não encontrado! Execute esse script em um LocalScript.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuMuMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criar menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 350, 0, 550) -- altura ajustada
menuFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false -- começa fechado
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

-- Botão fechar “X” no canto superior direito
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.Parent = menuFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
end)

-- Botão imagem para abrir/fechar menu
local menuButton = Instance.new("ImageButton")
menuButton.Name = "AbrirMenu"
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 10, 0, 10)
menuButton.BackgroundTransparency = 1
menuButton.Image = "rbxassetid://100959264885238"
menuButton.Parent = screenGui

menuButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Abrir/fechar menu com tecla Control
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        menuFrame.Visible = not menuFrame.Visible
    end
end)

-- Função para criar botões arredondados
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

-- ================== ESP ==================

local espOn = false
local selectedEnemyColor = Color3.fromRGB(255, 0, 0)
local selectedTeamColor = Color3.fromRGB(0, 255, 0)

local espBtn = criarBotao("ESPToggle", 50, "ESP: Desativado")
espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    if espOn then
        espBtn.Text = "ESP: Ativado"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        espBtn.Text = "ESP: Desativado"
        espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Botão para expandir configurações de cor ESP
local espConfigBtn = criarBotao("ESPConfigBtn", 100, "▼ Configurar cores ESP")
espConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local espConfigAberto = false

local function esconderConfigESP()
    for _, obj in pairs(menuFrame:GetChildren()) do
        if obj.Name:match("^ESPColorOption") or obj:IsA("TextLabel") and (obj.Text == "Cores do Time (Aliados)" or obj.Text == "Cores dos Inimigos") then
            obj:Destroy()
        end
    end
end

espConfigBtn.MouseButton1Click:Connect(function()
    if espConfigAberto then
        esconderConfigESP()
        espConfigBtn.Text = "▼ Configurar cores ESP"
        menuFrame.Size = UDim2.new(0, 350, 0, 550)
    else
        local yStart = 150
        -- Label aliados
        local labelAliados = Instance.new("TextLabel")
        labelAliados.Text = "Cores do Time (Aliados)"
        labelAliados.Size = UDim2.new(0, 300, 0, 30)
        labelAliados.Position = UDim2.new(0, 25, 0, yStart)
        labelAliados.TextColor3 = Color3.new(1,1,1)
        labelAliados.BackgroundTransparency = 1
        labelAliados.Font = Enum.Font.SourceSansBold
        labelAliados.TextSize = 18
        labelAliados.Parent = menuFrame

        local function criarOpcaoCor(nome, cor, posY, isEnemy)
            local btn = criarBotao("ESPColorOption_"..nome, posY, nome)
            btn.BackgroundColor3 = cor
            btn.MouseButton1Click:Connect(function()
                if isEnemy then
                    selectedEnemyColor = cor
                    print("Cor ESP inimigos setada para:", nome)
                else
                    selectedTeamColor = cor
                    print("Cor ESP aliados setada para:", nome)
                end
            end)
            btn.Parent = menuFrame
        end

        criarOpcaoCor("Verde", Color3.fromRGB(0,255,0), yStart + 35, false)
        criarOpcaoCor("Azul", Color3.fromRGB(0,150,255), yStart + 85, false)

        -- Label inimigos
        local labelInimigos = Instance.new("TextLabel")
        labelInimigos.Text = "Cores dos Inimigos"
        labelInimigos.Size = UDim2.new(0, 300, 0, 30)
        labelInimigos.Position = UDim2.new(0, 25, 0, yStart + 130)
        labelInimigos.TextColor3 = Color3.new(1,1,1)
        labelInimigos.BackgroundTransparency = 1
        labelInimigos.Font = Enum.Font.SourceSansBold
        labelInimigos.TextSize = 18
        labelInimigos.Parent = menuFrame

        criarOpcaoCor("Vermelho", Color3.fromRGB(255,0,0), yStart + 165, true)
        criarOpcaoCor("Roxo", Color3.fromRGB(170,0,255), yStart + 215, true)

        espConfigBtn.Text = "▲ Fechar cores ESP"
        menuFrame.Size = UDim2.new(0, 350, 0, 720)
    end
    espConfigAberto = not espConfigAberto
end)

-- ================== AIMBOT ==================

local aimbotOn = false
local aimbotBtn = criarBotao("AIMBOT", 350, "AIMBOT: Desativar")
aimbotBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

aimbotBtn.MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
    if aimbotOn then
        aimbotBtn.Text = "AIMBOT: Ativar"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        aimbotBtn.Text = "AIMBOT: Desativar"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
    print("AIMBOT ativo:", aimbotOn)
end)

-- FOV slider corrigido
local fov = 90
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 300, 0, 20)
fovLabel.Position = UDim2.new(0, 25, 0, 400)
fovLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.TextSize = 16
fovLabel.Font = Enum.Font.SourceSans
fovLabel.Text = "FOV: 90"
fovLabel.Parent = menuFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 8)
fovCorner.Parent = fovLabel

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 300, 0, 10)
sliderBar.Position = UDim2.new(0, 25, 0, 425)
sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
sliderBar.Parent = menuFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(fov/180, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fill.Parent = sliderBar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent = fill

local sliderActive = false
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderActive = true
    end
end)
sliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderActive = false
    end
end)

uis.InputChanged:Connect(function(input)
    if sliderActive and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        fov = math.floor(pos * 180)
        fovLabel.Text = "FOV: "..fov
    end
end)

-- ================== INFINITY JUMP ==================

local jumping = false

uis.JumpRequest:Connect(function()
    if not jumping then
        jumping = true
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        wait(0.1)
        jumping = false
    end
end)

-- ================== ESP & AIMBOT LOGIC ==================

local function getClosestEnemy()
    local closest = nil
    local shortest = math.huge
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Team ~= player.Team and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos = target.Character.HumanoidRootPart.Position
            local screenPos, visible = workspace.CurrentCamera:WorldToViewportPoint(pos)
            local mousePos = uis:GetMouseLocation()
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if visible and dist < shortest and dist <= fov then
                shortest = dist
                closest = target.Character
            end
        end
    end
    return closest
end

local function criarESP(obj, color)
    if obj:FindFirstChild("ESPBox") then return end
    local head = obj:FindFirstChild("Head")
    if not head then return end

    local box = Instance.new("BillboardGui", head)
    box.Name = "ESPBox"
    box.Size = UDim2.new(0, 100, 0, 40)
    box.AlwaysOnTop = true
    box.Adornee = head

    local frame = Instance.new("Frame", box)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.5

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
end

runService.RenderStepped:Connect(function()
    -- Limpar todas as ESP antes de recriar
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
            local espBox = v.Head and v.Head:FindFirstChild("ESPBox")
            if espBox then espBox:Destroy() end
        end
    end

    if espOn then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= player then
                local cor = (v.Team == player.Team) and selectedTeamColor or selectedEnemyColor
                criarESP(v.Character, cor)
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

print("MuMuMenu atualizado com Infinity Jump, AIMBOT, ESP, e controles funcionais!")
