-- MuMu Menu Script vFinal

--// SETTINGS
local settings = {
    fov = 100,
    aimbot_enabled = false,
    esp_enabled = false,
    infinity_jump_enabled = false,
    team_check = true,
    team_color = {
        friend = Color3.fromRGB(0, 255, 0),
        enemy = Color3.fromRGB(255, 0, 0)
    },
    esp_colors = {
        friend = Color3.fromRGB(0, 255, 0),
        enemy = Color3.fromRGB(255, 0, 0)
    }
}

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// UI LIB
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/murywifo/MuMuMenu/main/ui-lib.lua"))()
local win = lib:Window("MuMu Menu", Color3.fromRGB(255,0,0), Enum.KeyCode.LeftControl)

--// TABS
local mainTab = win:Tab("Main")
local espTab = win:Tab("ESP Settings")

--// INFINITY JUMP
local function toggleInfinityJump(state)
    settings.infinity_jump_enabled = state
end

UserInputService.JumpRequest:Connect(function()
    if settings.infinity_jump_enabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

mainTab:Toggle("Infinity Jump", false, function(t)
    toggleInfinityJump(t)
end)

--// FOV SLIDER
mainTab:Slider("Aimbot FOV", 1, 180, settings.fov, function(value)
    settings.fov = value
end)

--// ESP + AIMBOT
mainTab:Toggle("Enable ESP", false, function(t)
    settings.esp_enabled = t
end)

mainTab:Toggle("Enable Aimbot", false, function(t)
    settings.aimbot_enabled = t
end)

--// ESP COLOR SETTINGS
espTab:Dropdown("Friend Color", {"Green", "Blue"}, function(val)
    if val == "Green" then
        settings.esp_colors.friend = Color3.fromRGB(0, 255, 0)
    elseif val == "Blue" then
        settings.esp_colors.friend = Color3.fromRGB(0, 0, 255)
    end
end)

espTab:Dropdown("Enemy Color", {"Red", "Purple"}, function(val)
    if val == "Red" then
        settings.esp_colors.enemy = Color3.fromRGB(255, 0, 0)
    elseif val == "Purple" then
        settings.esp_colors.enemy = Color3.fromRGB(128, 0, 128)
    end
end)

--// ESP FUNCTION
local function createBox()
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false
    return box
end

local espBoxes = {}

local function updateEsp()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if not espBoxes[player] then
                espBoxes[player] = createBox()
            end

            local box = espBoxes[player]
            if onScreen and settings.esp_enabled then
                box.Size = Vector2.new(50, 65)
                box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                local isFriend = player.Team == LocalPlayer.Team
                if settings.team_check and isFriend then
                    box.Color = settings.esp_colors.friend
                else
                    box.Color = settings.esp_colors.enemy
                end
                box.Visible = true
            else
                box.Visible = false
            end
        elseif espBoxes[player] then
            espBoxes[player].Visible = false
        end
    end
end

--// AIMBOT FUNCTION
local function getClosest()
    local closest = nil
    local shortest = settings.fov

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if settings.team_check and player.Team == LocalPlayer.Team then
                continue
            end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if settings.aimbot_enabled then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    if settings.esp_enabled then
        updateEsp()
    end
end)
