--// MuMu Menu Script - ESP, Aimbot, Infinity Jump, UI com fundo //

--// Services e variáveis principais local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera local Mouse = LocalPlayer:GetMouse()

--// Configurações local Settings = { TeamCheck = true, AllyColor = Color3.fromRGB(0, 255, 0), EnemyColor = Color3.fromRGB(255, 0, 0), AimbotEnabled = false, FOV = 90, InfinityJump = false }

--// ESP Box local ESP = {} function ESP:Create(player) local box = Drawing.new("Square") box.Thickness = 1 box.Filled = false box.Color = Settings.EnemyColor box.Visible = false

local outline = Drawing.new("Square")
outline.Thickness = 3
outline.Filled = false
outline.Color = Color3.new(0, 0, 0)
outline.Visible = false

ESP[player] = {Box = box, Outline = outline}

end

function ESP:Remove(player) if ESP[player] then ESP[player].Box:Remove() ESP[player].Outline:Remove() ESP[player] = nil end end

function ESP:Update() for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then if Settings.TeamCheck and player.Team == LocalPlayer.Team then ESP[player].Box.Visible = false ESP[player].Outline.Visible = false else local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position) if onScreen then local scale = 1 / (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude * 1000 local size = Vector2.new(60, 100) * scale local position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)

ESP[player].Box.Size = size
                ESP[player].Box.Position = position
                ESP[player].Box.Color = Settings.TeamCheck and (player.Team == LocalPlayer.Team and Settings.AllyColor or Settings.EnemyColor) or Settings.EnemyColor
                ESP[player].Box.Visible = true

                ESP[player].Outline.Size = size
                ESP[player].Outline.Position = position
                ESP[player].Outline.Visible = true
            else
                ESP[player].Box.Visible = false
                ESP[player].Outline.Visible = false
            end
        end
    end
end

end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then ESP:Create(p) end end Players.PlayerAdded:Connect(function(p) ESP:Create(p) end) Players.PlayerRemoving:Connect(function(p) ESP:Remove(p) end)

--// AIMBOT local function GetClosestPlayer() local closest, dist = nil, Settings.FOV for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position) if onScreen then local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude if mag < dist then dist = mag closest = player end end end end return closest end

RunService.RenderStepped:Connect(function() if Settings.AimbotEnabled then local target = GetClosestPlayer() if target and target.Character and target.Character:FindFirstChild("Head") then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end end ESP:Update() end)

--// Infinity Jump UserInputService.JumpRequest:Connect(function() if Settings.InfinityJump then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

--// UI local ScreenGui = Instance.new("ScreenGui", game.CoreGui) local Menu = Instance.new("Frame", ScreenGui) Menu.Size = UDim2.new(0, 300, 0, 240) Menu.Position = UDim2.new(0.02, 0, 0.2, 0) Menu.BackgroundColor3 = Color3.new(0, 0, 0) Menu.BorderSizePixel = 0 Menu.Visible = true Menu.Active = true Menu.Draggable = true

-- Fundo com imagem local Fundo = Instance.new("ImageLabel", Menu) Fundo.Size = UDim2.new(1, 0, 1, 0) Fundo.Position = UDim2.new(0, 0, 0, 0) Fundo.Image = "rbxassetid://87676365321602" Fundo.BackgroundTransparency = 1 Fundo.ImageTransparency = 0.2

-- Botões local function createButton(name, pos, callback) local btn = Instance.new("TextButton", Menu) btn.Size = UDim2.new(0, 120, 0, 30) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) btn.Text = name btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.GothamBold btn.TextSize = 14 btn.MouseButton1Click:Connect(callback) return btn end

createButton("Toggle Aimbot", UDim2.new(0, 10, 0, 10), function() Settings.AimbotEnabled = not Settings.AimbotEnabled end)

createButton("Toggle ESP TeamCheck", UDim2.new(0, 10, 0, 50), function() Settings.TeamCheck = not Settings.TeamCheck end)

createButton("Toggle InfinityJump", UDim2.new(0, 10, 0, 90), function() Settings.InfinityJump = not Settings.InfinityJump end)

-- Slider FOV local FOVSlider = Instance.new("TextBox", Menu) FOVSlider.Size = UDim2.new(0, 120, 0, 30) FOVSlider.Position = UDim2.new(0, 10, 0, 130) FOVSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30) FOVSlider.Text = "FOV: " .. Settings.FOV FOVSlider.TextColor3 = Color3.new(1,1,1) FOVSlider.Font = Enum.Font.Gotham FOVSlider.TextSize = 14 FOVSlider.FocusLost:Connect(function() local val = tonumber(FOVSlider.Text:match("%d+")) if val and val <= 180 then Settings.FOV = val FOVSlider.Text = "FOV: " .. val end end)

-- Botão X para fechar local CloseBtn = Instance.new("TextButton", Menu) CloseBtn.Size = UDim2.new(0, 20, 0, 20) CloseBtn.Position = UDim2.new(1, -25, 0, 5) CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) CloseBtn.Text = "X" CloseBtn.TextColor3 = Color3.new(1, 1, 1) CloseBtn.Font = Enum.Font.GothamBold CloseBtn.TextSize = 14 CloseBtn.MouseButton1Click:Connect(function() Menu.Visible = false end)

-- Ícone para abrir local OpenBtn = Instance.new("ImageButton", ScreenGui) OpenBtn.Size = UDim2.new(0, 50, 0, 50) OpenBtn.Position = UDim2.new(0, 10, 0, 10) OpenBtn.Image = "rbxassetid://87676365321602" OpenBtn.BackgroundTransparency = 1 OpenBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- Tecla Control para abrir/fechar UserInputService.InputBegan:Connect(function(input, gpe) if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then Menu.Visible = not Menu.Visible end end)

print("[MuMu Menu] Carregado com sucesso.")

