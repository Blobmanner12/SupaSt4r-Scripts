--[[
    Genius Universal Script Hub Loader - The Engine
    Version: 2.9 (Deprecated Modules Removed)

    - REMOVED: All references to the outdated "Fisch Game" and "Player Fishserver"
      modules have been purged from the ScriptManifest.
]]

--//============================================================================================//
--//                                      [ CONFIGURATION ]                                     //
--//============================================================================================//

local CONFIG = {
    -- The base URL for your GitHub repository
    GitHubBaseURL = "https://raw.githubusercontent.com/Blobmanner12/SupaSt4r-Scripts/main/",
    
    -- The filename for the universal aimbot script
    UniversalAimbotPath = "UniversalAimbot.lua",

    -- The manifest for game-specific scripts
    ScriptManifest = {
        [78041891124723] = { name = "Blood Debt", path = "BloodDebt.lua" },
        -- Fisch Game and Player Fishserver have been removed.
    },

    -- Authentication Keys
    HubKey = "GeniusHub-Stellar-4096X",
    AimbotKey = "SupaSt4r-Aim-777",
    DiscordLink = "https://discord.gg/pFG68V2wFj",
    
    -- Link to the notification library
    NotificationLibURL = "https://raw.githubusercontent.com/newtoyotacamry/scripts/refs/heads/main/Toast"
}

--//============================================================================================//
--//                             [ SCRIPT EXECUTION & GUI LOGIC ]                               //
--//============================================================================================//

local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId
local GameInfo = CONFIG.ScriptManifest[PlaceId]

--// --- Load Notification Library First ---
local success, notifyLib = pcall(game.HttpGet, game, CONFIG.NotificationLibURL)
if success and notifyLib then
    _G.SupaSt4rNotify = loadstring(notifyLib)()
    if _G.SupaSt4rNotify then
        _G.SupaSt4rNotify.CreateToast(nil,"SupaSt4r Universal","Notification library loaded.",nil,5)
    end
else
    warn("SupaSt4r Loader: Failed to load notification library.")
    _G.SupaSt4rNotify = { CreateToast = function() end }
end

--// --- Authentication GUI ---
local authGui=Instance.new("ScreenGui",CoreGui);authGui.Name="GeniusAuth";authGui.ResetOnSpawn=false;local authFrame=Instance.new("Frame",authGui);authFrame.Size=UDim2.new(0,300,0,200);authFrame.AnchorPoint=Vector2.new(0.5,0.5);authFrame.Position=UDim2.new(0.5,0,0.5,0);authFrame.BackgroundColor3=Color3.fromRGB(30,30,30);authFrame.Draggable=true;local authTitle=Instance.new("TextLabel",authFrame);authTitle.Size=UDim2.new(1,0,0,30);authTitle.BackgroundColor3=Color3.fromRGB(80,80,80);authTitle.Text="SupaSt4r Universal";authTitle.Font=Enum.Font.SourceSansBold;authTitle.TextColor3=Color3.new(1,1,1);local keyBox=Instance.new("TextBox",authFrame);keyBox.Size=UDim2.new(1,-20,0,30);keyBox.Position=UDim2.new(0,10,0,40);keyBox.PlaceholderText="Enter Key...";local submitButton=Instance.new("TextButton",authFrame);submitButton.Size=UDim2.new(1,-20,0,35);submitButton.Position=UDim2.new(0,10,0,105);submitButton.Text="Submit Key";local getKeyButton=Instance.new("TextButton",authFrame);getKeyButton.Size=UDim2.new(1,-20,0,35);getKeyButton.Position=UDim2.new(0,10,0,150);getKeyButton.Text="Get Key (Copy Discord)";local authStatusLabel=Instance.new("TextLabel",authFrame);authStatusLabel.Size=UDim2.new(1,-20,0,20);authStatusLabel.Position=UDim2.new(0,10,0,75);authStatusLabel.Text="";authStatusLabel.BackgroundTransparency=1;
for _,v in pairs({keyBox,submitButton,getKeyButton,authStatusLabel,authTitle}) do v.Font=Enum.Font.SourceSans; v.TextColor3=Color3.new(1,1,1); v.TextSize=14; if v:is(TextBox)or v:is(TextButton)then v.BackgroundColor3=Color3.fromRGB(45,45,45)end end; submitButton.BackgroundColor3,getKeyButton.BackgroundColor3=Color3.fromRGB(80,120,80),Color3.fromRGB(80,100,200);

local function executeLoadstring(path, name)
    local url = CONFIG.GitHubBaseURL .. path; _G.SupaSt4rNotify.CreateToast(nil,"Loading...",name,nil,3)
    local s, r = pcall(game.HttpGet, game, url); if s then local ls,le=pcall(loadstring(r)); if ls then authGui:Destroy() else authStatusLabel.Text="Execution Error." end else authStatusLabel.Text="Fetch Error." end
end

submitButton.MouseButton1Click:Connect(function()
    local key=keyBox.Text; if key==CONFIG.AimbotKey then executeLoadstring(CONFIG.UniversalAimbotPath,"Universal Aimbot") elseif key==CONFIG.HubKey then if GameInfo then executeLoadstring(GameInfo.path,GameInfo.name) else authStatusLabel.Text="Game not supported." end else authStatusLabel.Text="Incorrect Key." end
end)
getKeyButton.MouseButton1Click:Connect(function() if setclipboard then setclipboard(CONFIG.DiscordLink); getKeyButton.Text="Copied!" end end)
