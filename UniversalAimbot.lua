--[[
    SupaSt4r Universal - Combat Hub
    Version: 3.3 (Branding Update)

    - Title changed as per user request.
    - Core ESP and Aimbot functionality remains unchanged from the last stable version.
]]

--//============================================================================================//
--//                                      [ CONFIGURATION ]                                     //
--//============================================================================================//

local CONFIG = {
    -- ESP Toggles
    Enabled = true,
    BoxESP = true,
    NameESP = true,
    TeamCheck = true,

    -- Aimbot Toggles & Settings
    Aimbot = true,
    SmoothingEnabled = false,
    AimPart = "Head",
    SmoothingValue = 0.2,

    -- Colors
    VisibleColor = Color3.fromRGB(255, 60, 60),
    OccludedColor = Color3.fromRGB(255, 180, 180),
    TargetColor = Color3.fromRGB(255, 255, 0)
}

--//============================================================================================//
--//                                        [ CORE SCRIPT ]                                     //
--//============================================================================================//

--// Services & Player
local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local UserInputService = game:GetService("UserInputService"); local CoreGui = game:GetService("CoreGui"); local Camera = workspace.CurrentCamera; local player = Players.LocalPlayer

--// Containers & Management Tables
local mainGui = Instance.new("ScreenGui", CoreGui); mainGui.Name = "SupaSt4r_Main"; mainGui.ResetOnSpawn = false; mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local espElements = {}
local isAiming = false
local currentTarget = nil

--// Control Panel GUI
local guiFrame = Instance.new("Frame", mainGui); guiFrame.Size = UDim2.new(0, 220, 0, 230);
guiFrame.Position = UDim2.new(0.01, 0, 0.5, -115); guiFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); guiFrame.BorderColor3 = Color3.fromRGB(150,150,150); guiFrame.Draggable = true

-- [MODIFIED] Title text updated
local title = Instance.new("TextLabel", guiFrame); title.Size = UDim2.new(1,0,0,25); title.BackgroundColor3 = Color3.fromRGB(40,40,40); title.Text = "SupaSt4r Universal"; title.Font = Enum.Font.SourceSansBold; title.TextColor3 = Color3.new(1,1,1)

local function createToggle(text, yPos, key, callback)
    local btn = Instance.new("TextButton", guiFrame); btn.Name = text; btn.Size = UDim2.new(1,-20,0,25); btn.Position = UDim2.new(0,10,0,yPos); btn.Font = Enum.Font.SourceSans; btn.TextSize = 14
    local function update() local on=CONFIG[key]; btn.Text=text..(on and " [ON]" or " [OFF]"); btn.TextColor3=on and Color3.fromRGB(0,255,127) or Color3.fromRGB(255,70,70); btn.BackgroundColor3=on and Color3.fromRGB(50,50,50) or Color3.fromRGB(30,30,30) end
    btn.MouseButton1Click:Connect(function() CONFIG[key] = not CONFIG[key]; update(); if callback then callback(CONFIG[key]) end end); update()
    return btn
end

createToggle("Master Toggle", 35, "Enabled")
createToggle("Box ESP", 70, "BoxESP")
createToggle("Name ESP", 105, "NameESP")

local smoothButton = createToggle("Smooth Aimbot", 175, "SmoothingEnabled")
local aimbotButton = createToggle("Aimbot", 140, "Aimbot", function(enabled)
    smoothButton.Visible = enabled
end)
smoothButton.Visible = CONFIG.Aimbot

--// ESP Element Creation
local function createESPElements(p) local c=Instance.new("Frame", mainGui);c.Name=p.Name;c.BackgroundTransparency=1;c.Size=UDim2.new(1,0,1,0);local b=Instance.new("Frame", c);b.Name="Box";b.BackgroundTransparency=1;b.ZIndex=2;Instance.new("UIStroke",b).Thickness=1;local n=Instance.new("TextLabel",c);n.Name="NameLabel";n.BackgroundTransparency=1;n.Font=Enum.Font.SourceSans;n.TextSize=13;n.ZIndex=2;return{Container=c,Box=b,Name=n}end

--// Main Render Loop
RunService.RenderStepped:Connect(function()
    local validPlayers = {}; local bestTarget, smallestDist = nil, math.huge; local mousePos = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        local character = p.Character; local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if CONFIG.Enabled and p ~= player and humanoid and humanoid.Health > 0 and (not CONFIG.TeamCheck or p.Team ~= player.Team) then
            validPlayers[p] = true; local elements = espElements[p]; if not elements then elements = createESPElements(p); espElements[p] = elements end
            local head = character:FindFirstChild("Head"); if not head then continue end
            local headPos, onScreen = Camera:WorldToScreenPoint(head.Position); if not onScreen then elements.Container.Visible = false; continue end
            elements.Container.Visible = true
            local isVisible = false; local rayParams = RaycastParams.new(); rayParams.FilterType = Enum.RaycastFilterType.Exclude; rayParams.FilterDescendantsInstances = {player.Character}; local result = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position), rayParams); if not result or result.Instance:IsDescendantOf(character) then isVisible = true end
            local drawColor = (p == currentTarget) and CONFIG.TargetColor or (isVisible and CONFIG.VisibleColor or CONFIG.OccludedColor)
            local footPos = Camera:WorldToScreenPoint(character.HumanoidRootPart.Position - Vector3.new(0,3,0)).Y; local boxHeight = math.abs(headPos.Y - footPos); local boxWidth = boxHeight/1.75; local boxPos = Vector2.new(headPos.X - boxWidth/2, headPos.Y)
            elements.Name.Visible = CONFIG.NameESP; if CONFIG.NameESP then local dist = (player.Character.HumanoidRootPart.Position-character.HumanoidRootPart.Position).Magnitude; elements.Name.Text = string.format("%s\n[%.fm|%dHP]", p.Name, dist, math.floor(humanoid.Health)); elements.Name.TextColor3 = drawColor; elements.Name.Position = UDim2.fromOffset(headPos.X - (elements.Name.TextBounds.X / 2), headPos.Y - 15) end
            elements.Box.Visible = CONFIG.BoxESP; if CONFIG.BoxESP then elements.Box.Position = UDim2.fromOffset(boxPos.X, boxPos.Y); elements.Box.Size = UDim2.fromOffset(boxWidth, boxHeight); elements.Box.UIStroke.Color = drawColor end
            if isVisible then local distFromMouse = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude; if distFromMouse < smallestDist then smallestDist = distFromMouse; bestTarget = p end end
        else if espElements[p] then espElements[p].Container.Visible = false end end
    end
    
    if CONFIG.Aimbot and isAiming and bestTarget then currentTarget = bestTarget else currentTarget = nil end
    if currentTarget then
        local aimPart = currentTarget.Character and currentTarget.Character:FindFirstChild(CONFIG.AimPart)
        if aimPart then
            if CONFIG.SmoothingEnabled then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, CONFIG.SmoothingValue)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
            end
        end
    end

    for p, elements in pairs(espElements) do if not validPlayers[p] then elements.Container:Destroy(); espElements[p] = nil end end
end)

--// Input Handlers
UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.RightControl then guiFrame.Visible = not guiFrame.Visible end; if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end end)
