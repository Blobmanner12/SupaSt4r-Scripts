--[[
    Genius Universal Script Hub Loader - The Engine
    Version: 2.3 (Final Configuration)

    This version is fully configured with your key and Discord invite link.
]]

--//============================================================================================//
--//                                [ AUTHENTICATION CONFIG ]                                    //
--//                               This section is now complete.                                //
--//============================================================================================//

local AUTH_CONFIG = {
    -- The key for your script hub.
    SecretKey = "GeniusHub-Stellar-4096X",

    -- The "Get Key" button now points to your server.
    DiscordLink = "https://discord.gg/pFG68V2wFj"
}

--//============================================================================================//
--//                                      [ LOADER LOGIC ]                                      //
--//       This function contains the game loader and will only run after successful auth.      //
--//============================================================================================//

local function initialize_loader()
    --// --- MASTER CONFIGURATION --- //
    local GITHUB_BASE_URL = "https://raw.githubusercontent.com/Blobmanner12/SupaSt4r-Scripts/main/"
    local ScriptManifest = {
        [78041891124723] = { name = "Blood Debt", path = "BloodDebt.lua" },
    }

    --// --- LOADER CORE --- //
    local HttpService = game:GetService("HttpService")
    local CoreGui = game:GetService("CoreGui")
    local PlaceId = game.PlaceId
    local GameInfo = ScriptManifest[PlaceId]

    local loaderGui = Instance.new("ScreenGui", CoreGui); loaderGui.Name = "GeniusLoader"; loaderGui.ResetOnSpawn = false; loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    local mainFrame = Instance.new("Frame", loaderGui); mainFrame.Size = UDim2.new(0, 350, 0, 180); mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); mainFrame.BorderColor3 = Color3.fromRGB(150, 150, 150); mainFrame.Draggable = true
    local title = Instance.new("TextLabel", mainFrame); title.Size = UDim2.new(1, 0, 0, 30); title.BackgroundColor3 = Color3.fromRGB(40, 40, 40); title.Text = "Universal Script Hub"; title.Font = Enum.Font.SourceSansBold; title.TextColor3 = Color3.new(1, 1, 1); title.TextSize = 16
    local gameNameLabel = Instance.new("TextLabel", mainFrame); gameNameLabel.Size = UDim2.new(1, -20, 0, 20); gameNameLabel.Position = UDim2.new(0, 10, 0, 40); gameNameLabel.Font = Enum.Font.SourceSans; gameNameLabel.TextColor3 = Color3.new(1, 1, 1); gameNameLabel.Text = "Game: " .. (GameInfo and GameInfo.name or "Unknown"); gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left; gameNameLabel.TextSize = 14
    local placeIdLabel = Instance.new("TextLabel", mainFrame); placeIdLabel.Size = UDim2.new(1, -20, 0, 20); placeIdLabel.Position = UDim2.new(0, 10, 0, 60); placeIdLabel.Font = Enum.Font.SourceSans; placeIdLabel.TextColor3 = Color3.new(1, 1, 1); placeIdLabel.Text = "PlaceId: " .. PlaceId; placeIdLabel.TextXAlignment = Enum.TextXAlignment.Left; placeIdLabel.TextSize = 14
    local statusLabel = Instance.new("TextLabel", mainFrame); statusLabel.Size = UDim2.new(1, -20, 0, 20); statusLabel.Position = UDim2.new(0, 10, 0, 85); statusLabel.Font = Enum.Font.SourceSans; statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0); statusLabel.Text = GameInfo and "Ready to load script." or "Game not supported."; statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.TextSize = 14
    local loadButton = Instance.new("TextButton", mainFrame); loadButton.Size = UDim2.new(1, -20, 0, 40); loadButton.Position = UDim2.new(0, 10, 0, 120); loadButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80); loadButton.TextColor3 = Color3.new(1, 1, 1); loadButton.Font = Enum.Font.SourceSansBold; loadButton.Text = "Load Script"; loadButton.TextSize = 16; loadButton.Visible = (GameInfo ~= nil)

    loadButton.MouseButton1Click:Connect(function()
        if not GameInfo then return end
        local scriptUrl = GITHUB_BASE_URL .. GameInfo.path
        statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255); statusLabel.Text = "Fetching script..."
        local success, response = pcall(game.HttpGet, game, scriptUrl)
        if success then
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100); statusLabel.Text = "Script fetched. Executing..."
            local loadSuccess, loadError = pcall(loadstring(response))
            if loadSuccess then
                statusLabel.Text = "Script loaded successfully. Destroying loader..."; wait(2); loaderGui:Destroy()
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50); statusLabel.Text = "Error executing script: " .. tostring(loadError)
            end
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50); statusLabel.Text = "Failed to fetch script. Check URL/Connection."
        end
    end)
end

--//============================================================================================//
--//                                     [ AUTHENTICATION GUI ]                                 //
--//                                This is what the user sees first.                           //
--//============================================================================================//

local CoreGui = game:GetService("CoreGui")
local authGui = Instance.new("ScreenGui", CoreGui); authGui.Name = "GeniusAuth"; authGui.ResetOnSpawn = false; authGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local authFrame = Instance.new("Frame", authGui); authFrame.Size = UDim2.new(0, 300, 0, 200); authFrame.AnchorPoint = Vector2.new(0.5, 0.5); authFrame.Position = UDim2.new(0.5, 0, 0.5, 0); authFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); authFrame.BorderColor3 = Color3.fromRGB(80, 80, 80); authFrame.Draggable = true
local authTitle = Instance.new("TextLabel", authFrame); authTitle.Size = UDim2.new(1, 0, 0, 30); authTitle.BackgroundColor3 = Color3.fromRGB(80, 80, 80); authTitle.Text = "Authentication Required"; authTitle.Font = Enum.Font.SourceSansBold; authTitle.TextColor3 = Color3.new(1, 1, 1); authTitle.TextSize = 16
local keyBox = Instance.new("TextBox", authFrame); keyBox.Size = UDim2.new(1, -20, 0, 30); keyBox.Position = UDim2.new(0, 10, 0, 40); keyBox.Font = Enum.Font.SourceSans; keyBox.PlaceholderText = "Enter Key..."; keyBox.TextColor3 = Color3.new(1, 1, 1); keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45); keyBox.TextSize = 14; keyBox.ClearTextOnFocus = false
local authStatusLabel = Instance.new("TextLabel", authFrame); authStatusLabel.Size = UDim2.new(1, -20, 0, 20); authStatusLabel.Position = UDim2.new(0, 10, 0, 75); authStatusLabel.Font = Enum.Font.SourceSans; authStatusLabel.Text = ""; authStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); authStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; authStatusLabel.BackgroundTransparency = 1; authStatusLabel.TextSize = 14
local submitButton = Instance.new("TextButton", authFrame); submitButton.Size = UDim2.new(1, -20, 0, 35); submitButton.Position = UDim2.new(0, 10, 0, 105); submitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80); submitButton.TextColor3 = Color3.new(1, 1, 1); submitButton.Font = Enum.Font.SourceSansBold; submitButton.Text = "Submit Key"; submitButton.TextSize = 16
local getKeyButton = Instance.new("TextButton", authFrame); getKeyButton.Size = UDim2.new(1, -20, 0, 35); getKeyButton.Position = UDim2.new(0, 10, 0, 150); getKeyButton.BackgroundColor3 = Color3.fromRGB(80, 100, 200); getKeyButton.TextColor3 = Color3.new(1, 1, 1); getKeyButton.Font = Enum.Font.SourceSansBold; getKeyButton.Text = "Get Key (Copy Discord)"; getKeyButton.TextSize = 16

-- Event Handlers for Authentication
submitButton.MouseButton1Click:Connect(function()
    if keyBox.Text == AUTH_CONFIG.SecretKey then
        authStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        authStatusLabel.Text = "Success! Loading..."
        wait(1)
        authGui:Destroy()
        initialize_loader() -- Run the main loader logic
    else
        authStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        authStatusLabel.Text = "Incorrect Key."
        keyBox.Text = ""
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(AUTH_CONFIG.DiscordLink)
        local originalText = getKeyButton.Text
        getKeyButton.Text = "Copied!"
        spawn(function()
            wait(2)
            if getKeyButton and getKeyButton.Parent then
                getKeyButton.Text = originalText
            end
        end)
    else
        authStatusLabel.Text = "Clipboard not supported."
    end
end)
