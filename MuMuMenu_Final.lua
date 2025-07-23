local player = game.Players.LocalPlayer
if not player then return end

local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuMuMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Menu frame (menor e estilizado)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 280, 0, 420)
menuFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

-- Botão fechar X
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -33, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 22
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
menuButton.Size = UDim2.new(0, 50, 0, 50)
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
    botao.Size = UDim2.new(0, 240, 0, 36)
    botao.Position = UDim2.new(0, 20, 0, posY)
    botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Font = Enum.Font.SourceSansBold
    botao.TextSize = 18
    botao.Text = texto
    botao.Parent = menuFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = botao

    return botao
end

-- =========== ESP ============

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

local espConfigBtn = criarBotao("ESPConfigBtn", 95, "▼ Configurar cores ESP")
espConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local espConfigAberto = false

local function esconderConfigESP()
    for _, obj in pairs(menuFrame:GetChildren()) do
        if obj.Name:match("^ESPColorOption") or (obj:IsA("TextLabel") and (obj.Text == "Cores do Time (Aliados)" or obj.Text == "Cores dos Inimigos")) then
            obj:Destroy()
        end
    end
end

espConfigBtn.MouseButton1Click:Connect(function()
    if espConfigAberto then
        esconderConfigESP()
        espConfigBtn.Text = "▼ Configurar cores ESP"
        menuFrame.Size = UDim2.new(0, 280, 0, 420)
    else
        local yStart = 140
        local labelAliados = Instance.new("TextLabel")
        labelAliados.Text = "Cores do Time (Aliados)"
        labelAliados.Size = UDim2.new(0, 240, 0, 25)
        labelAliados.Position = UDim2.new(0, 20, 0, yStart)
        labelAliados.TextColor3 = Color3.new(1, 1, 1)
        labelAliados.BackgroundTransparency = 1
        labelAliados.Font = Enum.Font.SourceSansBold
        labelAliados.TextSize = 16
        labelAliados.Parent = menuFrame

        local function criarOpcaoCor(nome, cor, posY, isEnemy)
            local btn = criarBotao("ESPColorOption_"..nome, posY, nome)
            btn.BackgroundColor3 = cor
            btn.MouseButton1Click:Connect(function()
                if isEnemy then
                    selectedEnemyColor = cor
                else
                    selectedTeamColor = cor
                end
            end)
            btn.Parent = menuFrame
        end

        criarOpcaoCor("Verde", Color3.fromRGB(0,255,0), yStart + 30, false)
        criarOpcaoCor("Azul", Color3.fromRGB(0,150,255), yStart + 65, false)

        local labelInimigos = Instance.new("TextLabel")
        labelInimigos.Text = "Cores dos Inimigos"
        labelInimigos.Size = UDim2.new(0, 240, 0, 25)
        labelInimigos.Position = UDim2.new(0, 20, 0, yStart + 105)
        labelInimigos.TextColor3 = Color3.new(1, 1, 1)
        labelInimigos.BackgroundTransparency = 1
        labelInimigos.Font = Enum.Font.SourceSansBold
        labelInimigos.TextSize = 16
        labelInimigos.Parent = menuFrame

        criarOpcaoCor("Vermelho", Color3.fromRGB(255,0,0), yStart + 140, true)
        criarOpcaoCor("Roxo", Color3.fromRGB(170,0,255), yStart + 175, true)

        espConfigBtn.Text = "▲ Fechar cores ESP"
        menuFrame.Size = UDim2.new(0, 280, 0, 530)
    end
    espConfigAberto = not espConfigAberto
end)

-- ============ AIMBOT ===========

local aimbotOn = false
local aimbotBtn = criarBotao("AIMBOT", 290, "AIMBOT: Desativado")
aimbotBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

aimbotBtn.MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
    if aimbotOn then
        aimbotBtn.Text = "AIMBOT: Ativado"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        aimbotBtn.Text = "AIMBOT: Desativado"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

local fov = 90
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 240, 0, 18)
fovLabel.Position = UDim2.new(0, 20, 0, 335)
fovLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.SourceSans
fovLabel.Text = "FOV: 90"
fovLabel.Parent = menuFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovLabel

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 240, 0, 10)
sliderBar.Position = UDim2.new(0, 20, 0, 355)
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

-- =========== INFINITY JUMP ===========

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

-- =========== ESP & AIMBOT OTIMIZADO ===========

local espObjects = {}
local lerpSpeed = 0.15

local function getClosestEnemy()
    local closest = nil
    local shortest = math.huge
    local mousePos = uis:GetMouseLocation()
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos = target.Character.HumanoidRootPart.Position
            local screenPos, visible = camera:WorldToViewportPoint(pos)
            if visible then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortest and dist <= fov then
                    shortest = dist
                    closest = target.Character
                end
            end
        end
    end
    return closest
end

local function criarESP(character, color)
    if espObjects[character] then
        local box = espObjects[character]
        box.Frame.BackgroundColor3 = color
        box.Enabled = true
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local box = Instance.new("BillboardGui")
    box.Name = "ESPBox"
    box.Adornee = hrp
    box.Size = UDim2.new(0, 80, 0, 40)
    box.AlwaysOnTop = true

    local frame = Instance.new("Frame", box)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.4

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    box.Frame = frame
    box.Parent = hrp

    espObjects[character] = box
end

local function desativarTodosESPs()
    for character, box in pairs(espObjects) do
        if box and box.Parent then
            box.Enabled = false
        end
    end
end

local function limparESPsInativos()
    for character, box in pairs(espObjects) do
        if not character.Parent then
            if box and box.Parent then
                box:Destroy()
            end
            espObjects[character] = nil
        end
    end
end

runService.RenderStepped:Connect(function()
    limparESPsInativos()

    if espOn then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= player then
                local cor = (plr.Team == player.Team) and selectedTeamColor or selectedEnemyColor
                criarESP(plr.Character, cor)
            end
        end
    else
        desativarTodosESPs()
    end

    if aimbotOn then
        local target = getClosestEnemy()
        if target and target:FindFirstChild("Head") then
            local targetPos = target.Head.Position
            local camPos = camera.CFrame.Position
            local newLook = CFrame.new(camPos, targetPos)
            camera.CFrame = camera.CFrame:Lerp(newLook, lerpSpeed)
        end
    end
end)

print("MuMuMenu atualizado e funcionando!")
