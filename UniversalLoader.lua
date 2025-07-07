--[[
    Genius Universal Script Hub Loader - The Engine
    Version: 2.0

    This is the main loader file, fetched by the one-line loadstring.
    It identifies the game and loads the appropriate script.
]]

--//============================================================================================//
--//                                  [ MASTER CONFIGURATION ]                                  //
--//             This is where you will add new games and scripts in the future.                //
--//============================================================================================//

-- The base URL is now defined relative to this file's location.
local GITHUB_BASE_URL = "https://raw.githubusercontent.com/Blobmanner12/SupaSt4r-Scripts/main/"

-- The manifest maps PlaceIds to script files.
local ScriptManifest = {
    -- [PlaceId] = { name = "Display Name", path = "FileName.lua" },
    [78041891124723] = { name = "Blood Debt", path = "BloodDebt.lua" },
    -- Example for a future game:
    -- [987654321] = { name = "Another Game", path = "AnotherGameScript.lua" },
}

--//============================================================================================//
--//                                        [ LOADER CORE ]                                     //
--//============================================================================================//

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId
local GameInfo = ScriptManifest[PlaceId]

-- GUI Creation
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
