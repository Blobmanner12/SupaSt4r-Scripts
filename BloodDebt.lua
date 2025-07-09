--[[
    SupaSt4r Universal - "Blood Debt" Module
    Version: 1.5 (Notification Integration)

    - INTEGRATED: Now uses the globally loaded notification library.
]]

--//============================================================================================//
--//                                        [ CORE SCRIPT ]                                     //
--//============================================================================================//

local success, err = pcall(function()
    --// Services & Player
    local player = game:GetService("Players").LocalPlayer
    local CoreGui = game:GetService("CoreGui")

    --// Script State
    local toggles = { Players = true, Tools = true, Aimlock = true, InfJump = false }

    --// Notification Helper
    local Notify = _G.SupaSt4rNotify or {CreateToast = function(a,b,c,d,e) print(b..": "..c) end }

    --// --- GUI Construction
    local main_gui = Instance.new("ScreenGui", CoreGui); main_gui.Name = "BloodDebt"; main_gui.ResetOnSpawn = false;
    local main_frame = Instance.new("Frame", main_gui); main_frame.Size = UDim2.new(0, 220, 0, 280); main_frame.Position = UDim2.new(0, 10, 0.5, -140); main_frame.Draggable=true;
    local title = Instance.new("TextLabel", main_frame); title.Size = UDim2.new(1, 0, 0, 25); title.Text = "Blood Debt";
    
    local function make_toggle(text, y, key)
        local btn = Instance.new("TextButton", main_frame); btn.Size = UDim2.new(1,-20,0,25); btn.Position = UDim2.new(0,10,0,y);
        local function update() local on=toggles[key]; btn.Text=text..(on and " [ON]" or " [OFF]"); end
        btn.MouseButton1Click:Connect(function() toggles[key]=not toggles[key]; update(); Notify.CreateToast(nil,text,toggles[key] and "Enabled" or "Disabled",nil,2) end); update()
    end
    
    make_toggle("Player ESP", 70, "Players");
    make_toggle("Tool ESP", 105, "Tools");
    make_toggle("Infinite Jump", 140, "InfJump");
    make_toggle("Aimlock", 175, "Aimlock");
    
    -- Other GUI elements can be added here...
end)

if not success then warn("BLOOD DEBT SCRIPT FAILED: "..tostring(err)) end
