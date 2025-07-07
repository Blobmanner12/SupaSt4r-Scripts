--[[
    Genius Universal Script Hub Loader - The Engine
    Version: 2.4 (Dual Load System)

    - RE-ARCHITECTED: Loader now supports two distinct loading paths.
    - ADDED: "LOAD UNIVERSAL AIMBOT" button with a secondary key authentication system.
]]

--//============================================================================================//
--//                                [ AUTHENTICATION CONFIG ]                                    //
--//                                 Both keys are now configured.                              //
--//============================================================================================//

local AUTH_CONFIG = {
    -- Key to access the game-specific hub loader
    HubKey = "GeniusHub-Stellar-4096X",

    -- A new, separate key specifically for the Universal Aimbot
    AimbotKey = "SupaSt4r-Aim-777",

    -- Your Discord invite link
    DiscordLink = "https://discord.gg/pFG68V2wFj"
}

--//============================================================================================//
--//                                  [ LOADER CONFIGURATION ]                                  //
--//============================================================================================//

local LOADER_CONFIG = {
    -- The base URL for your GitHub repository
    GitHubBaseURL = "https://raw.githubusercontent.com/Blobmanner12/SupaSt4r-Scripts/main/",
    
    -- The filename for the universal aimbot script
    UniversalAimbotPath = "UniversalAimbot.lua",

    -- The manifest for game-specific scripts
    ScriptManifest = {
        [78041891124723] = { name = "Blood Debt", path = "BloodDebt.lua" },
    }
}

--//============================================================================================//
--//                                [ LOADER INITIALIZATION LOGIC ]                             //
--//============================================================================================//

local function initialize_loader()
    local CoreGui = game:GetService("CoreGui")
    local PlaceId = game.PlaceId
    local GameInfo = LOADER_CONFIG.ScriptManifest[PlaceId]

    local loaderGui = Instance.new("ScreenGui", CoreGui); loaderGui.Name = "GeniusLoader"; loaderGui.ResetOnSpawn = false; loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Main frame is now wider to accommodate two buttons
    local mainFrame = Instance.new("Frame", loaderGui); mainFrame.Size = UDim2.new(0, 480, 0, 220); mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); mainFrame.BorderColor3 = Color3.fromRGB(150, 150, 150); mainFrame.Draggable = true
    local title = Instance.new("TextLabel", mainFrame); title.Size = UDim2.new(1, 0, 0, 30); title.BackgroundColor3 = Color3.fromRGB(40, 40, 40); title.Text = "SupaSt4r Universal Hub"; title.Font = Enum.Font.SourceSansBold; title.TextColor3 = Color3.new(1, 1, 1); title.TextSize = 16
    local statusLabel = Instance.new("TextLabel", mainFrame); statusLabel.Size = UDim2.new(1, -20, 0, 20); statusLabel.Position = UDim2.new(0, 10, 0, 185); statusLabel.Font = Enum.Font.SourceSans; statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0); statusLabel.Text = GameInfo and "Game detected. Ready to load." or "Game not supported by hub."; statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.TextSize = 14

    -- Left side: Game-Specific Hub Loader
    local gameHubFrame = Instance.new("Frame", mainFrame); gameHubFrame.Size = UDim2.new(0.5, -15, 1, -40); gameHubFrame.Position = UDim2.new(0, 10, 0, 35); gameHubFrame.BackgroundColor3 = Color3.fromRGB(45,45,45);
    local ghTitle = Instance.new("TextLabel", gameHubFrame); ghTitle.Size = UDim2.new(1,0,0,25); ghTitle.BackgroundColor3=Color3.fromRGB(60,60,60); ghTitle.Text = "Game Hub"; ghTitle.Font=Enum.Font.SourceSansBold; ghTitle.TextColor3=Color3.new(1,1,1)
    local ghInfo = Instance.new("TextLabel", gameHubFrame); ghInfo.Size=UDim2.new(1,-10,0,50); ghInfo.Position=UDim2.new(0,5,0,30); ghInfo.Text= "Game: " .. (GameInfo and GameInfo.name or "N/A"); ghInfo.Font=Enum.Font.SourceSans; ghInfo.TextColor3=Color3.new(1,1,1); ghInfo.TextWrapped=true; ghInfo.TextXAlignment=Enum.TextXAlignment.Left;
    local loadGameHubBtn = Instance.new("TextButton", gameHubFrame); loadGameHubBtn.Size = UDim2.new(1, -20, 0, 40); loadGameHubBtn.Position = UDim2.new(0, 10, 1, -50); loadGameHubBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80); loadGameHubBtn.TextColor3 = Color3.new(1, 1, 1); loadGameHubBtn.Font = Enum.Font.SourceSansBold; loadGameHubBtn.Text = "Load Game Script"; loadGameHubBtn.Visible = (GameInfo ~= nil)
    
    -- Right side: Universal Aimbot Loader
    local aimbotFrame = Instance.new("Frame", mainFrame); aimbotFrame.Size = UDim2.new(0.5, -15, 1, -40); aimbotFrame.Position = UDim2.new(0.5, 5, 0, 35); aimbotFrame.BackgroundColor3 = Color3.fromRGB(45,45,45);
    local abTitle = Instance.new("TextLabel", aimbotFrame); abTitle.Size=UDim2.new(1,0,0,25);abTitle.BackgroundColor3=Color3.fromRGB(80,20,20);abTitle.Text="Universal Combat";abTitle.Font=Enum.Font.SourceSansBold;abTitle.TextColor3=Color3.new(1,1,1)
    local aimbotKeyBox = Instance.new("TextBox", aimbotFrame); aimbotKeyBox.Size=UDim2.new(1,-20,0,30);aimbotKeyBox.Position=UDim2.new(0,10,0,35);aimbotKeyBox.Font=Enum.Font.SourceSans;aimbotKeyBox.PlaceholderText="Enter Aimbot Key...";aimbotKeyBox.TextColor3=Color3.new(1,1,1);aimbotKeyBox.BackgroundColor3=Color3.fromRGB(30,30,30);aimbotKeyBox.TextSize=14
    local loadAimbotBtn = Instance.new("TextButton", aimbotFrame); loadAimbotBtn.Size = UDim2.new(1, -20, 0, 40); loadAimbotBtn.Position = UDim2.new(0, 10, 1, -50); loadAimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); loadAimbotBtn.TextColor3 = Color3.new(1, 1, 1); loadAimbotBtn.Font = Enum.Font.SourceSansBold; loadAimbotBtn.Text = "LOAD UNIVERSAL AIMBOT"

    -- Generic script loading function
    local function executeLoadstring(path)
        local url = LOADER_CONFIG.GitHubBaseURL .. path
        statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255); statusLabel.Text = "Fetching: " .. path
        local success, response = pcall(game.HttpGet, game, url)
        if success then
            local loadSuccess, loadError = pcall(loadstring(response))
            if loadSuccess then
                statusLabel.Text = "Script loaded successfully. Destroying loader..."; wait(2); loaderGui:Destroy()
            else
                statusLabel.TextColor3 = Color3.fromRGB(255,50,50); statusLabel.Text = "Execution Error: " .. tostring(loadError)
            end
        else
            statusLabel.TextColor3 = Color3.fromRGB(255,50,50); statusLabel.Text = "Fetch Error. Check URL/Connection."
        end
    end

    -- Button Connections
    loadGameHubBtn.MouseButton1Click:Connect(function() executeLoadstring(GameInfo.path) end)
    loadAimbotBtn.MouseButton1Click:Connect(function()
        if aimbotKeyBox.Text == AUTH_CONFIG.AimbotKey then
            executeLoadstring(LOADER_CONFIG.UniversalAimbotPath)
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50); statusLabel.Text = "Incorrect Aimbot Key."
        end
    end)
end

--//============================================================================================//
--//                                 [ INITIAL AUTHENTICATION ]                                 //
--//============================================================================================//

local CoreGui = game:GetService("CoreGui")
local authGui = Instance.new("ScreenGui", CoreGui); authGui.Name = "GeniusAuth"; authGui.ResetOnSpawn = false; authGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local authFrame = Instance.new("Frame", authGui); authFrame.Size = UDim2.new(0, 300, 0, 200); authFrame.AnchorPoint = Vector2.new(0.5, 0.5); authFrame.Position = UDim2.new(0.5, 0, 0.5, 0); authFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); authFrame.BorderColor3 = Color3.fromRGB(80, 80, 80); authFrame.Draggable = true
local authTitle = Instance.new("TextLabel", authFrame); authTitle.Size = UDim2.new(1, 0, 0, 30); authTitle.BackgroundColor3 = Color3.fromRGB(80, 80, 80); authTitle.Text = "Authentication Required"; authTitle.Font = Enum.Font.SourceSansBold; authTitle.TextColor3 = Color3.new(1, 1, 1); authTitle.TextSize = 16
local keyBox = Instance.new("TextBox", authFrame); keyBox.Size = UDim2.new(1, -20, 0, 30); keyBox.Position = UDim2.new(0, 10, 0, 40); keyBox.Font = Enum.Font.SourceSans; keyBox.PlaceholderText = "Enter Hub Key..."; keyBox.TextColor3 = Color3.new(1, 1, 1); keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45); keyBox.TextSize = 14
local authStatusLabel = Instance.new("TextLabel", authFrame); authStatusLabel.Size = UDim2.new(1, -20, 0, 20); authStatusLabel.Position = UDim2.new(0, 10, 0, 75); authStatusLabel.Font = Enum.Font.SourceSans; authStatusLabel.Text = ""; authStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); authStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; authStatusLabel.BackgroundTransparency = 1; authStatusLabel.TextSize = 14
local submitButton = Instance.new("TextButton", authFrame); submitButton.Size = UDim2.new(1, -20, 0, 35); submitButton.Position = UDim2.new(0, 10, 0, 105); submitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80); submitButton.TextColor3 = Color3.new(1, 1, 1); submitButton.Font = Enum.Font.SourceSansBold; submitButton.Text = "Submit Key"; submitButton.TextSize = 16
local getKeyButton = Instance.new("TextButton", authFrame); getKeyButton.Size = UDim2.new(1, -20, 0, 35); getKeyButton.Position = UDim2.new(0, 10, 0, 150); getKeyButton.BackgroundColor3 = Color3.fromRGB(80, 100, 200); getKeyButton.TextColor3 = Color3.new(1, 1, 1); getKeyButton.Font = Enum.Font.SourceSansBold; getKeyButton.Text = "Get Key (Copy Discord)"; getKeyButton.TextSize = 16

submitButton.MouseButton1Click:Connect(function()
    if keyBox.Text == AUTH_CONFIG.HubKey then
        authStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80); authStatusLabel.Text = "Success! Loading Hub..."; wait(1); authGui:Destroy(); initialize_loader()
    else
        authStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); authStatusLabel.Text = "Incorrect Hub Key."; keyBox.Text = ""
    end
end)
getKeyButton.MouseButton1Click:Connect(function() if setclipboard then setclipboard(AUTH_CONFIG.DiscordLink); local originalText = getKeyButton.Text; getKeyButton.Text = "Copied!"; spawn(function() wait(2); if getKeyButton and getKeyButton.Parent then getKeyButton.Text = originalText end end) else authStatusLabel.Text = "Clipboard not supported." end end)
