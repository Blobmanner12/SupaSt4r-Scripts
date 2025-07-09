--[[
    SupaSt4r Universal - Aimbot Module
    Version: 3.5 (Notification Integration)

    - INTEGRATED: Now uses the globally loaded notification library to provide
                  feedback when toggling features.
]]

--//============================================================================================//
--//                                        [ CORE SCRIPT ]                                     //
--//============================================================================================//

local success, err = pcall(function()
    --// Services & Player
    local Players, RunService, UserInputService, CoreGui, Camera = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("CoreGui"), workspace.CurrentCamera;
    local player = Players.LocalPlayer;

    --// Configuration Table
    local CONFIG = { Enabled=true, BoxESP=true, NameESP=true, Aimbot=true, TeamCheck=true, SmoothingEnabled=false, AimPart="Head", SmoothingValue=0.2, TeammateColor=Color3.fromRGB(0,255,127), EnemyColor=Color3.fromRGB(255,60,60), TargetColor=Color3.fromRGB(255,255,0) };

    --// Script State & Helper
    local espElements, isAiming, currentTarget, bodyGyro = {}, false, nil, nil;
    local Notify = _G.SupaSt4rNotify or {CreateToast = function(a,b,c,d,e) print(b..": "..c) end } -- Fallback

    --// --- GUI Construction ---
    local mainGui = Instance.new("ScreenGui", CoreGui); mainGui.Name = "SupaSt4r_Aimbot"; mainGui.ResetOnSpawn = false;
    local guiFrame = Instance.new("Frame", mainGui); guiFrame.Size = UDim2.new(0,220,0,210); guiFrame.Position = UDim2.new(0.01,0,0.5,-105); guiFrame.BackgroundColor3=Color3.fromRGB(30,30,30); guiFrame.Draggable=true;
    local title = Instance.new("TextLabel", guiFrame); title.Size=UDim2.new(1,0,0,25); title.BackgroundColor3=Color3.fromRGB(40,40,40); title.Text="Universal Aimbot"; title.Font=Enum.Font.SourceSansBold; title.TextColor3=Color3.new(1,1,1);
    
    local function createToggle(t,y,k,c) local b=Instance.new("TextButton",guiFrame);b.Name=k;b.Size=UDim2.new(1,-20,0,25);b.Position=UDim2.new(0,10,0,y);b.Font=Enum.Font.SourceSans;b.TextSize=14;local function u()local o=CONFIG[k];b.Text=t..(o and" [ON]"or" [OFF]");b.TextColor3=o and Color3.fromRGB(0,255,127)or Color3.fromRGB(255,70,70);b.BackgroundColor3=o and Color3.fromRGB(50,50,50)or Color3.fromRGB(30,30,30)end;b.MouseButton1Click:Connect(function()CONFIG[k]=not CONFIG[k];u();if c then c(CONFIG[k])end;Notify.CreateToast(nil,t,CONFIG[k]and"Enabled"or"Disabled",nil,2)end);u();return b;end
    createToggle("Box ESP",35,"BoxESP"); createToggle("Name ESP",70,"NameESP");
    local smoothButton=createToggle("Smooth Aim",175,"SmoothingEnabled"); local aimbotButton=createToggle("Aimbot",140,"AimAssist",function(e)smoothButton.Visible=e end); smoothButton.Visible=CONFIG.AimAssist;

    --// --- Core Logic ---
    local function createESPElements(p) local c=Instance.new("Frame",mainGui);c.Name=p.Name;c.BackgroundTransparency=1;c.Size=UDim2.new(1,0,1,0);local b=Instance.new("Frame",c);b.Name="Box";b.BackgroundTransparency=1;b.ZIndex=2;Instance.new("UIStroke",b).Thickness=1;local n=Instance.new("TextLabel",c);n.Name="NameLabel";n.BackgroundTransparency=1;n.Font=Enum.Font.SourceSans;n.TextSize=13;n.ZIndex=2;return{Container=c,Box=b,Name=n}end
    RunService.RenderStepped:Connect(function()
        local validPlayers,bestTarget,smallestDist,mousePos={},nil,math.huge,UserInputService:GetMouseLocation();
        for _,p in pairs(Players:GetPlayers()) do
            local char,hum=p.Character,p.Character and p.Character:FindFirstChildOfClass("Humanoid");
            if CONFIG.Enabled and p~=player and hum and hum.Health>0 then
                local isEnemy=(not CONFIG.TeamCheck or p.Team~=player.Team);validPlayers[p]=true; local elements=espElements[p]; if not elements then elements=createESPElements(p);espElements[p]=elements;end;
                local head=char:FindFirstChild("Head");if not head then continue;end;
                local headPos,onScreen=Camera:WorldToScreenPoint(head.Position);if not onScreen then elements.Container.Visible=false;continue;end;elements.Container.Visible=true;
                local isVisible=false;local rayParams=RaycastParams.new();rayParams.FilterType=Enum.RaycastFilterType.Exclude;rayParams.FilterDescendantsInstances={player.Character};local result=workspace:Raycast(Camera.CFrame.Position,(head.Position-Camera.CFrame.Position),rayParams);if not result or result.Instance:IsDescendantOf(char)then isVisible=true;end;
                local drawColor=(p==currentTarget)and CONFIG.TargetColor or(isEnemy and(isVisible and CONFIG.EnemyColor or CONFIG.OccludedColor)or CONFIG.TeammateColor);
                local footPos=Camera:WorldToScreenPoint(char.HumanoidRootPart.Position-Vector3.new(0,3,0)).Y;local h=math.abs(headPos.Y-footPos);local w=h/1.75;local bP=Vector2.new(headPos.X-w/2,headPos.Y);
                elements.Name.Visible=CONFIG.NameESP;if CONFIG.NameESP then local d=(player.Character.PrimaryPart.Position-char.PrimaryPart.Position).Magnitude;elements.Name.Text=string.format("%s\n[%.fm|%dHP]",p.Name,d,math.floor(hum.Health));elements.Name.TextColor3=drawColor;elements.Name.Position=UDim2.fromOffset(headPos.X-(elements.Name.TextBounds.X/2),headPos.Y-15)end;
                elements.Box.Visible=CONFIG.BoxESP;if CONFIG.BoxESP then elements.Box.Position=UDim2.fromOffset(bP.X,bP.Y);elements.Box.Size=UDim2.fromOffset(w,h);elements.Box.UIStroke.Color=drawColor;end;
                if isEnemy and isVisible then local dM=(Vector2.new(headPos.X,headPos.Y)-mousePos).Magnitude;if dM<smallestDist then smallestDist=dM;bestTarget=p;end;end;
            else if espElements[p]then espElements[p].Container.Visible=false;end;end;
        end
        if CONFIG.Aimbot and isAiming and bestTarget and player.Character then currentTarget=bestTarget;local myHRP=player.Character:FindFirstChild("HumanoidRootPart");local targetHRP=bestTarget.Character and bestTarget.Character:FindFirstChild(CONFIG.AimPart);if myHRP and targetHRP then local l=CFrame.lookAt(myHRP.Position,targetHRP.Position);local _,y,_=l:ToOrientation();local nC=CFrame.new(myHRP.Position)*CFrame.Angles(0,y,0);if CONFIG.SmoothingEnabled then myHRP.CFrame=myHRP.CFrame:Lerp(nC,CONFIG.SmoothingValue)else myHRP.CFrame=nC;end;end;else currentTarget=nil;end;
        for p,elements in pairs(espElements)do if not validPlayers[p]then elements.Container:Destroy();espElements[p]=nil;end;end;
    end)
    UserInputService.InputBegan:Connect(function(i,g)if not g and i.KeyCode==Enum.KeyCode.RightControl then guiFrame.Visible=not guiFrame.Visible;end;if i.UserInputType==Enum.UserInputType.MouseButton2 then isAiming=true;end;end);
    UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton2 then isAiming=false;end;end);
end)
if not success then warn("AIMBOT SCRIPT FAILED: "..tostring(err)) end
