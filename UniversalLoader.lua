--[[
    Genius Universal Script Hub Loader - The Engine
    Version: 3.0 (Definitive Rebuild)

    - CRITICAL FIX: The entire script has been rebuilt to be 100% self-contained.
      It no longer loads any external libraries before the GUI is created, which
      guarantees it will always execute and display the authentication window.
]]

--//============================================================================================//
--//                                      [ CONFIGURATION ]                                     //
--//============================================================================================//

local CONFIG = {
    GitHubBaseURL = "https://raw.githubusercontent.com/Blobmanner12/SupaSt4r-Scripts/main/",
    UniversalAimbotPath = "UniversalAimbot.lua",
    ScriptManifest = {
        [78041891124723] = { name = "Blood Debt", path = "BloodDebt.lua" },
    },
    HubKey = "GeniusHub-Stellar-4096X",
    AimbotKey = "SupaSt4r-Aim-777",
    DiscordLink = "https://discord.gg/pFG68V2wFj"
}

--//============================================================================================//
--//                             [ SCRIPT EXECUTION & GUI LOGIC ]                               //
--//============================================================================================//

--// --- Fail-Safe Initialization ---
local success, err = pcall(function()

    local CoreGui = game:GetService("CoreGui")
    local PlaceId = game.PlaceId
    local GameInfo = CONFIG.ScriptManifest[PlaceId]

    --// --- Authentication GUI (The Only GUI) ---
    local authGui = Instance.new("ScreenGui", CoreGui); authGui.Name = "GeniusAuth_V3"; authGui.ResetOnSpawn = false; authGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
    local authFrame = Instance.new("Frame", authGui); authFrame.Size = UDim2.new(0, 300, 0, 200); authFrame.AnchorPoint = Vector2.new(0.5, 0.5); authFrame.Position = UDim2.new(0.5, 0, 0.5, 0); authFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); authFrame.BorderColor3 = Color3.fromRGB(80, 80, 80); authFrame.Draggable = true;
    local authTitle = Instance.new("TextLabel", authFrame); authTitle.Size = UDim2.new(1, 0, 0, 30); authTitle.BackgroundColor3 = Color3.fromRGB(80, 80, 80); authTitle.Text = "SupaSt4r Universal"; authTitle.Font = Enum.Font.SourceSansBold; authTitle.TextColor3 = Color3.new(1, 1, 1); authTitle.TextSize = 16;
    local keyBox = Instance.new("TextBox", authFrame); keyBox.Size = UDim2.new(1, -20, 0, 30); keyBox.Position = UDim2.new(0, 10, 0, 40); keyBox.Font = Enum.Font.SourceSans; keyBox.PlaceholderText = "Enter Key..."; keyBox.TextColor3 = Color3.new(1, 1, 1); keyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45); keyBox.TextSize = 14;
    local authStatusLabel = Instance.new("TextLabel", authFrame); authStatusLabel.Size = UDim2.new(1, -20, 0, 20); authStatusLabel.Position = UDim2.new(0, 10, 0, 75); authStatusLabel.Font = Enum.Font.SourceSans; authStatusLabel.Text = ""; authStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80); authStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; authStatusLabel.BackgroundTransparency = 1; authStatusLabel.TextSize = 14;
    local submitButton = Instance.new("TextButton", authFrame); submitButton.Size = UDim2.new(1, -20, 0, 35); submitButton.Position = UDim2.new(0, 10, 0, 105); submitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80); submitButton.TextColor3 = Color3.new(1, 1, 1); submitButton.Font = Enum.Font.SourceSansBold; submitButton.Text = "Submit Key"; submitButton.TextSize = 16;
    local getKeyButton = Instance.new("TextButton", authFrame); getKeyButton.Size = UDim2.new(1, -20, 0, 35); getKeyButton.Position = UDim2.new(0, 10, 0, 150); getKeyButton.BackgroundColor3 = Color3.fromRGB(80, 100, 200); getKeyButton.TextColor3 = Color3.new(1, 1, 1); getKeyButton.Font = Enum.Font.SourceSansBold; getKeyButton.Text = "Get Key (Copy Discord)"; getKeyButton.TextSize = 16;

    local function executeLoadstring(path, name)
        local url = CONFIG.GitHubBaseURL .. path;
        authStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255);
        authStatusLabel.Text = "Fetching " .. name .. "...";

        -- The HttpGet call is now safely inside the button press
        local s, r = pcall(game.HttpGet, game, url);
        if s then
            local ls, le = pcall(loadstring(r));
            if ls then
                authStatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80);
                authStatusLabel.Text = "Success! Destroying auth...";
                wait(1);
                authGui:Destroy();
            else
                authStatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50); authStatusLabel.Text = "Execution Error.";
            end
        else
            authStatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50); authStatusLabel.Text = "Fetch Error.";
        end
    end

    submitButton.MouseButton1Click:Connect(function()
        local key = keyBox.Text;
        if key == CONFIG.AimbotKey then
            executeLoadstring(CONFIG.UniversalAimbotPath, "Universal Aimbot");
        elseif key == CONFIG.HubKey then
            if GameInfo then
                executeLoadstring(GameInfo.path, GameInfo.name);
            else
                authStatusLabel.Text = "Correct Hub Key, but game not supported.";
            end
        else
            authStatusLabel.Text = "Incorrect Key.";
        end
    end)

    getKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(CONFIG.DiscordLink);
            getKeyButton.Text = "Copied!";
        else
            authStatusLabel.Text = "Clipboard not supported.";
        end
    end)
end)

if not success then
    warn("--- LOADER FAILED TO INITIALIZE ---");
    warn("--- ERROR: " .. tostring(err));
end
