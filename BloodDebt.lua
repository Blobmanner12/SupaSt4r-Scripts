-- Blood Debt - Tactical Hub Script
-- Version 1.6 - Critical Execution Fix
--
-- This script is designed to be loaded by the Universal Hub.
-- FIXED: A typo (Enum.ZIndex -> Enum.ZIndexBehavior) that caused the script to fail on execution.
-- The previous ESP toggle fix remains in place. The script is now stable.

local CONFIG = {
    KillerWeaponName = "Knife",
    SheriffWeaponName = "Gun",
    RoleAttributeName = "Role",
    BlinkDistance = 15,
    InfiniteJumpPower = 50,
    DefaultSpeed = 16
}

local plr_s = game:GetService("Players")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local core_gui = game:GetService("CoreGui")
local plr = plr_s.LocalPlayer

-- Unified state management table
local toggles = {
    Players = true,
    Tools = true,
    Aimlock = true,
    InfJump = false
}

local is_aiming = false
local target = nil

-- ## THE FIX IS HERE: Corrected Enum.ZIndex.Global to Enum.ZIndexBehavior.Global ##
local main_gui = Instance.new("ScreenGui", core_gui); main_gui.Name = "BloodDebt"; main_gui.ResetOnSpawn = false; main_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local main_frame = Instance.new("Frame", main_gui); main_frame.Size = UDim2.new(0, 220, 0, 280); main_frame.Position = UDim2.new(0, 10, 0.5, -140); main_frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main_frame.BorderColor3 = Color3.fromRGB(200, 0, 0); main_frame.Draggable = true
local title = Instance.new("TextLabel", main_frame); title.Size = UDim2.new(1, 0, 0, 25); title.BackgroundColor3 = Color3.fromRGB(50, 0, 0); title.Text = "Blood Debt"; title.Font = Enum.Font.SourceSansBold; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.TextSize = 14

local speed_label = Instance.new("TextLabel", main_frame); speed_label.Size = UDim2.new(0, 80, 0, 30); speed_label.Position = UDim2.new(0, 10, 0, 35); speed_label.Font = Enum.Font.SourceSans; speed_label.TextColor3 = Color3.new(1,1,1); speed_label.Text = "WalkSpeed:"; speed_label.TextXAlignment = Enum.TextXAlignment.Left; speed_label.BackgroundTransparency = 1; speed_label.TextSize = 14
local speed_input = Instance.new("TextBox", main_frame); speed_input.Size = UDim2.new(1, -100, 0, 30); speed_input.Position = UDim2.new(0, 90, 0, 35); speed_input.Font = Enum.Font.SourceSans; speed_input.TextColor3 = Color3.new(1, 1, 1); speed_input.BackgroundColor3 = Color3.fromRGB(25, 25, 25); speed_input.Text = tostring(CONFIG.DefaultSpeed); speed_input.TextSize = 14; speed_input.ClearTextOnFocus = false

local function make_toggle(text, y, key)
    local btn = Instance.new("TextButton", main_frame); btn.Size = UDim2.new(1, -20, 0, 25); btn.Position = UDim2.new(0, 10, 0, y); btn.Font = Enum.Font.SourceSans; btn.TextSize = 14
    local function update() local on=toggles[key]; btn.Text=text..(on and " [ON]" or " [OFF]"); btn.TextColor3=on and Color3.fromRGB(0,255,127) or Color3.fromRGB(255,70,70); btn.BackgroundColor3=on and Color3.fromRGB(50,50,50) or Color3.fromRGB(30,30,30) end
    btn.MouseButton1Click:Connect(function() toggles[key]=not toggles[key]; update() end); update()
end

make_toggle("Player ESP", 70, "Players")
make_toggle("Tool ESP", 105, "Tools")
make_toggle("Infinite Jump", 140, "InfJump")
make_toggle("Aimlock", 175, "Aimlock")

local keybind_info = Instance.new("TextLabel", main_frame); keybind_info.Size = UDim2.new(1, -20, 0, 20); keybind_info.Position = UDim2.new(0, 10, 0, 210); keybind_info.Font = Enum.Font.SourceSans; keybind_info.TextColor3 = Color3.fromRGB(180, 180, 190); keybind_info.Text = "K: Blink | R_Ctrl: Toggle GUI"; keybind_info.TextXAlignment = Enum.TextXAlignment.Center; keybind_info.BackgroundTransparency = 1; keybind_info.TextSize = 12
local scan_btn = Instance.new("TextButton", main_frame); scan_btn.Size = UDim2.new(1, -20, 0, 25); scan_btn.Position = UDim2.new(0, 10, 0, 240); scan_btn.Font = Enum.Font.SourceSansBold; scan_btn.TextSize = 14; scan_btn.Text = "Scan Game State"; scan_btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0); scan_btn.TextColor3 = Color3.new(1,1,1)

local esp_folder = Instance.new("Folder", main_gui)

local function set_speed() local new_speed=tonumber(speed_input.Text); if new_speed and plr.Character and plr.Character:FindFirstChild("Humanoid") then plr.Character.Humanoid.WalkSpeed = new_speed end end
speed_input.FocusLost:Connect(function(enter) if enter then set_speed() end end)

local function find_role(p) if p.Character then if p.Character:FindFirstChild(CONFIG.KillerWeaponName) or p.Backpack:FindFirstChild(CONFIG.KillerWeaponName) then return "Killer" end; if p.Character:FindFirstChild(CONFIG.SheriffWeaponName) or p.Backpack:FindFirstChild(CONFIG.SheriffWeaponName) then return "Sheriff" end; local attr=p.Character:GetAttribute(CONFIG.RoleAttributeName); if attr then if tostring(attr):lower():find("killer")or tostring(attr):lower():find("murderer")then return"Killer"end;if tostring(attr):lower():find("sheriff")or tostring(attr):lower():find("detective")then return"Sheriff"end end end; return"Innocent" end
local function is_accessory(item) for _, p in pairs(plr_s:GetPlayers()) do if p.Character and item:IsDescendantOf(p.Character) then return true end end; return false end

rs.RenderStepped:Connect(function()
    for _, esp in pairs(esp_folder:GetChildren()) do
        if not esp.Adornee or not esp.Adornee.Parent then esp:Destroy() end
        if esp.Name:find("_PlayerESP") and not toggles.Players then esp:Destroy() end
        if esp.Name:find("_ToolESP") and not toggles.Tools then esp:Destroy() end
    end
    
    if toggles.Players then for _, p in pairs(plr_s:GetPlayers()) do if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then local hrp=p.Character.HumanoidRootPart; local esp=esp_folder:FindFirstChild(p.Name.."_PlayerESP"); if not esp then esp=Instance.new("BillboardGui",esp_folder);esp.Name=p.Name.."_PlayerESP";esp.AlwaysOnTop=true;esp.Size=UDim2.new(0,180,0,70);local name_l=Instance.new("TextLabel",esp);name_l.Name="NameLabel";name_l.Size=UDim2.new(1,0,0.5,0);name_l.Text=p.Name;name_l.BackgroundTransparency=1;name_l.Font=Enum.Font.SourceSansBold;name_l.TextSize=16;local role_l=Instance.new("TextLabel",esp);role_l.Name="RoleLabel";role_l.Size=UDim2.new(1,0,0.5,0);role_l.Position=UDim2.new(0,0,0.5,0);role_l.BackgroundTransparency=1;role_l.Font=Enum.Font.SourceSans;role_l.TextSize=14 end; esp.Adornee=hrp;local role=find_role(p);local color;if role=="Killer"then color=Color3.fromRGB(255,20,20)elseif role=="Sheriff"then color=Color3.fromRGB(20,120,255)else color=Color3.fromRGB(20,255,120)end;esp.NameLabel.TextColor3=(target==p)and Color3.fromRGB(255,255,0)or color;esp.RoleLabel.TextColor3=Color3.new(1,1,1);esp.RoleLabel.Text=string.format("HP: %d | Role: %s",math.floor(p.Character.Humanoid.Health),role) end end end
    if toggles.Tools then for _, item in pairs(ws:GetDescendants()) do if item:IsA("Tool") and item:FindFirstChild("Handle") and not is_accessory(item) then local h=item.Handle;local esp=esp_folder:FindFirstChild(item:GetDebugId().."_ToolESP");if not esp then esp=Instance.new("BillboardGui",esp_folder);esp.Name=item:GetDebugId().."_ToolESP";esp.AlwaysOnTop=true;esp.Size=UDim2.new(0,120,0,40);local txt=Instance.new("TextLabel",esp);txt.Name="TextLabel";txt.Size=UDim2.new(1,0,1,0);txt.BackgroundTransparency=1;txt.Font=Enum.Font.SourceSans;txt.TextSize=14;txt.TextColor3=Color3.fromRGB(200,200,255)end;esp.Adornee=h;esp.TextLabel.Text=item.Name end end end
    if toggles.Aimlock and is_aiming then local best_t,min_d=nil,math.huge;local mouse_p=uis:GetMouseLocation();for _,p in pairs(plr_s:GetPlayers())do if p~=plr and p.Character and p.Character:FindFirstChild("Head")and p.Character.Humanoid.Health>0 then local head_p,on_s=ws.CurrentCamera:WorldToScreenPoint(p.Character.Head.Position);if on_s then local dist=(Vector2.new(head_p.X,head_p.Y)-mouse_p).Magnitude;if dist<min_d then min_d=dist;best_t=p end end end end;target=best_t;if target then local target_cf=CFrame.new(ws.CurrentCamera.CFrame.Position,target.Character.Head.Position);ws.CurrentCamera.CFrame=ws.CurrentCamera.CFrame:Lerp(target_cf,0.15)end else target=nil end
    if toggles.InfJump and uis:IsKeyDown(Enum.KeyCode.Space) then if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.Velocity = Vector3.new(plr.Character.HumanoidRootPart.Velocity.X, CONFIG.InfiniteJumpPower, plr.Character.HumanoidRootPart.Velocity.Z) end end
end)

uis.InputBegan:Connect(function(inp,gp) if not gp and inp.KeyCode==Enum.KeyCode.RightControl then main_frame.Visible=not main_frame.Visible end;if inp.UserInputType==Enum.UserInputType.MouseButton2 then is_aiming=true end;if not gp and inp.KeyCode==Enum.KeyCode.K and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame*=CFrame.new(0,0,-CONFIG.BlinkDistance) end end)
uis.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton2 then is_aiming=false end end)

scan_btn.MouseButton1Click:Connect(function() print("--- SCANNING ---");for _,p in pairs(plr_s:GetPlayers())do print("- Player: "..p.Name);local found=false;if p.Character then for _,c in pairs(p.Character:GetChildren())do if c:IsA("Tool")then print("  [WPN]: "..c.Name.." (Char)");found=true end end end;if p.Backpack then for _,c in pairs(p.Backpack:GetChildren())do if c:IsA("Tool")then print("  [WPN]: "..c.Name.." (BP)");found=true end end end;if p.Team then print("  [TEAM]: "..p.Team.Name);found=true end;if p.Character then local attrs=p.Character:GetAttributes();for n,v in pairs(attrs)do print("  [ATTR]: "..n.." = "..tostring(v));found=true end end;if not found then print("  (No data found)")end end;print("--- SCAN COMPLETE ---")end)

local function on_character(character) character:WaitForChild("Humanoid"); wait(0.1); set_speed() end
if plr.Character then on_character(plr.Character) end; plr.CharacterAdded:Connect(on_character)
