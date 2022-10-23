local Window = RenderWindow.new("Project Menu")
--[[ V 1.3.5
    Aimbot Functionality
    - AimPart Choser
    - Trigger Bot Universal
    - Silent Aim for Certain games (must be made)
    - RayCast for Walls
    - Team Check (Make it automatic by checking how many teams there are)
    - FOV Check 
    - Differnt methods for mouse movement (Synaapse lib / CFrame of Current Camera)
    - Rebind Aimbot
    - Aimtbot toggle
    ESP Functionality
    - Target Hud / .. Add more then just flux,
    - Well the esp (Skeleton if possible, Box, Chams if possible, HeadDot (can be added on)) / .. Name, Hp, HpPercentage, Chams All compelted
    - Change Color of name for aimbot locked on / .. Compeleted (added chams to it)

    Code Insights
    - More Function Structered Code
        - Make each proto function a seperate function (Check Team, CheckRayResult, etc)
    - Use Synapse 3.0 Lib (just to try it, however dont make it to nessecary to the point where it would be trivial to swap to a V2.0 Lib)

    List of Options
        ESP
            Toggle On / Off /
            Skeleton
            Chams /
            Box
            Show Target Hud / 
            Show Name / 
            Show HP / 
            Hp Display Type (Pecentage / non percentage) / 
            Show HeadDot
        AimBot
            Rebind For Aimbot will say (Aimbot: R.Click)    / 
            Toggle On / off / 
            Aimpart DropDown for Head, Torso, Middled of Legs / 
            Visible Check On / off / 
            Trigger Bot On / off / 
            
            Dropdown For Method Type - With Silent AIm /
            TeamCheck (Hover should include how it is Hopefully automatic) -- May not be needed to be added depends on how good it works /
            Use FOV On / Off /
            FOV Size Slider /
            Show FOV On / off//
        Misc
            Tp to Aimbot Target (Use a tp function so i can add checks for Deathzone Tp Bypass)
            Panic Module
            Speed (Also use function so i can add checks)
            Chat Logger (Will be fun to make one i hope)
            Open Tp Player GUi
    AfterThoughts to add
        Aimbot
            Add a ray for each limb, Make a target feature in aimpart "All" /

]]
local ChamColor = {
    Ally = Color3.fromRGB(19, 232, 255),
    Enemy = Color3.fromRGB(255, 83, 86),
    Target = Color3.fromRGB(93, 228, 111),
    Fill = 0,
    Outline = 0

}
local TextColor = {
    AimbotTarget = Color3.fromRGB(93, 228, 111),
    AllyColor = Color3.fromRGB(139, 230, 255),
    EnemyColor = Color3.fromRGB(207, 96, 96)

}
local OutlineColors = {
    AimbotTarget = Color3.fromRGB(0,0,0),
    AllyColor = Color3.fromRGB(255,255,255),
    EnemyColor = Color3.fromRGB(255,255,255)

}

local MiscOp = {
    ShowTpTab = false
}
local EspTextOption = {
    Size = 24
}

local ChangingBind = false

local globtar = nil
local AimbotOp = {
    OverallEnabled = true,
    GlobalAimPart = nil,
    AimPart = "HumanoidRootPart", -- Head, HumanoidRootPart
    AimType = "Cframe", -- Cframe, MouseAbs, Silent Aim
    TriggerBot = true,
    AimBotToggle = false,
    UseFov = false,
    FovSize = 500,
    CheckTeam = true,
    debug = false,
    VisiblyCheck = "Raycast",
    BotBind = "MouseButton2",
    ShowFOV = false,
    TreatAimAsTog = false

}


local Circle = Circle.new()
Circle.Thickness = 4
Circle.Radius = AimbotOp.FovSize
Circle.NumSides = 1000
Circle.Color = Color3.fromRGB(255,255,255)


local player = game.Players.LocalPlayer
function Debugged(str,v)
    v = v or ""
    if AimbotOp.debug == true then
        print(str,v)
    end    
end

function Checks(v) -- Returning true == Passed all checks
    if v == player then return end
    if v.Parent == nil then Debugged("v.Parent, Checks",v); return end
    if v.Character == nil then Debugged("v.Character, Checks",v); return end
    if v.Character.Parent == nil then Debugged("v.Character.Parent, Checks",v); return end
    if v.Character:FindFirstChildOfClass("Humanoid") == nil then Debugged("Humanoid, Checks",v); return end
    if v.Character:FindFirstChild("HumanoidRootPart") == nil then Debugged("HumanoidRootPart, Checks",v); return end
    if v.Character:FindFirstChildOfClass("ForceField") then Debugged("Forcefield, Checks",v); return end
    if game.PlaceId == 286090429 then -- Checks for Arsenal Only
        if  v.Character:FindFirstChild("FakeHead") == nil then return end
        if  v.Character:FindFirstChild("Spawned") == nil then return end
        if  v.Character.Humanoid.Health < 0 then Debugged("Humanoid Health, Checks, Aresenal",v) return end 
    else
        if  v.Character.Humanoid.Health < 0 then Debugged("Humanoid Health, Checks, Global",v) return end 
    end

    return true
end
 local Teams = {}


game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    for i,v in pairs(game.Players:GetChildren()) do
        if v.Team and table.find(Teams,v.Team) == nil and Checks(v) == true then
            Teams[#Teams+1] = v.Team 
        end
    end
    for i,v in pairs(game.Players:GetChildren()) do
        if Checks(v) == true then
            if  table.find(Teams,v.Team) == nil  then
                Teams = {}  
            end
        end
    end
end)

function TeamCheck(v) -- Returning True == Passed the check

   
    if #Teams > 1 and player.Team ~= v.Team or #Teams < 1  then
        return true
    else
        return false
    end
end


local IgnoreRayTable = {player.Character}
local IgnoreObscureTable = {}
function ObscureAllWorkspace()
if  AimbotOp.VisiblyCheck ~= "ObscuringParts" then IgnoreObscureTable = {}; return end
     IgnoreObscureTable = {}
     for _,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Transparency == 1 or v.CanCollide == false) then
            IgnoreObscureTable[#IgnoreObscureTable+1] = v
        end
    end
end
function AddObscureTable()

    game.Workspace.DescendantAdded:connect(function(v)
        if v:IsA("BasePart") and (v.Transparency == 1 or v.CanCollide == false) and AimbotOp.VisiblyCheck == "ObscuringParts"  then
            IgnoreObscureTable[#IgnoreObscureTable+1] = v
        end
    end)
    game.Workspace.DescendantRemoving:connect(function(v)
        local k = table.find(IgnoreObscureTable,v)
        if k ~= nil then
            table.remove(IgnoreObscureTable,k)

        end
    end)
end
coroutine.wrap(AddObscureTable)()

function FindHumanoid(v)
	local Path = v
	while true do
		if Path:FindFirstChildOfClass("Humanoid") then
			return true
		elseif Path.Parent == game.Workspace then
			return false
		else
			Path = Path.Parent
		end
	end
end



function CheckVisiblity(v) -- Return true == Visible to part
    if AimbotOp.AimPart == "All" then
        if AimbotOp.VisiblyCheck == "ObscuringParts" then
            local R15Character = false
            if v.Character:FindFirstChild("LeftLowerArm") then R15Character = true end
            local cam = game.Workspace.CurrentCamera
            local HeadVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.Head.Position}, IgnoreObscureTable))
            if HeadVis == true then return true, v.Character.Head end
            local TorsoVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.HumanoidRootPart.Position}, IgnoreObscureTable))
            if TorsoVis == true then  return true, v.Character.HumanoidRootPart end
            if R15Character == true then
                local RightArmVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.RightLowerArm.Position}, IgnoreObscureTable))
                if RightArmVis == true then return true, v.Character.RightLowerArm end
                local LeftArmVis =  not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.LeftLowerArm.Position}, IgnoreObscureTable))
                if LeftArmVis == true then return true, v.Character.LeftLowerArm end
                local RightLegVis =  not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.RightLowerLeg.Position}, IgnoreObscureTable))
                if RightLegVis == true then return true, v.Character.RightLowerLeg end
                local LeftLegVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character.LeftLowerLeg.Position}, IgnoreObscureTable))
                if LeftLegVis == true then return true, v.Character.LeftLowerLeg end
            else
                local RightArmVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character["Right Arm"].Position}, IgnoreObscureTable))
                if RightArmVis == true then return true, v.Character["Right Arm"] end
                local LeftArmVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character["Left Arm"].Position}, IgnoreObscureTable))
                if LeftArmVis == true then return true, v.Character["Left Arm"] end
                local RightLegVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character["Right Leg"].Position}, IgnoreObscureTable))
                if RightLegVis == true then return true, v.Character["Right Leg"] end
                local LeftLegVis = not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character["Left Leg"].Position}, IgnoreObscureTable))
                if LeftLegVis == true then return true, v.Character["Left Leg"] end
            end
            
        end  
        return false
    end
     
    
    if AimbotOp.VisiblyCheck == "ObscuringParts" then
        local cam = game.Workspace.CurrentCamera
	    return not unpack(cam:GetPartsObscuringTarget({player.Character.Head.Position, v.Character[AimbotOp.AimPart].Position}, IgnoreObscureTable)), v.Character[AimbotOp.AimPart]
    else
        local ray = Ray.new(player.Character.Head.Position, (v.Character[AimbotOp.AimPart].Position - player.Character.Head.Position).unit * 30000)
        local part, position = workspace:FindPartOnRayWithIgnoreList(ray, IgnoreRayTable, false, true)
        if part then
            if FindHumanoid(part) == true then
                return true, v.Character[AimbotOp.AimPart]
            elseif part.Transparency == 1   or part.CanCollide == false then
                IgnoreRayTable[#IgnoreRayTable+1] = part   

                return false
            end
        end
        Debugged("Check Visibilty, Part: "..tostring(part))
    end
end

function InFOV(v)
    -- Returning true == INFOV
    local camera = game.Workspace.CurrentCamera
    local mouse = player:GetMouse()
    local chatpartpos, OnScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
	local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(chatpartpos.x, chatpartpos.Y)).Magnitude
	if mag < AimbotOp.FovSize then
		return true
	end
end

function CompareMag(ReturningPerson,NewPerson) -- TRUE = NEWPERSON IS CLOSER
    if ReturningPerson == nil then
        return true
    else
        local mag1 = (player.Character.HumanoidRootPart.Position - ReturningPerson.Character.HumanoidRootPart.Position).Magnitude
        local mag2 = (player.Character.HumanoidRootPart.Position - NewPerson.Character.HumanoidRootPart.Position).Magnitude
        if mag1 > mag2 then
            return true
        end
         
    end
end
function FindClosestPlayer()
    if AimbotOp.OverallEnabled == false then Debugged("Overall","Not Enabled"); return end 
    local CurrentTarget;

    for i,v in pairs(game.Players:GetChildren()) do 
        if Checks(v) == true then
            if AimbotOp.UseFov == false or AimbotOp.UseFov == true and InFOV(v) == true then
                if AimbotOp.CheckTeam == true and TeamCheck(v) == true or AimbotOp.CheckTeam == false then
                    local Visible, AimPart = CheckVisiblity(v)
                    if AimbotOp.VisiblyCheck ~= "None" and Visible == true  or AimbotOp.VisiblyCheck == "None" then
                        if CompareMag(CurrentTarget,v) == true then
                            CurrentTarget = v
                            if AimPart then
                                AimbotOp.GlobalAimPart = AimPart
                            end
                            
                        end
                    end
                end
               
            end
        end
    end
    return CurrentTarget
end

function SetCamera()
    local camera = game.Workspace.CurrentCamera
    if AimbotOp.AimType == "Cframe" then
        camera.CFrame = CFrame.new(camera.CFrame.Position, AimbotOp.GlobalAimPart.Position)
    end
    
end

print(FindClosestPlayer(),AimbotOp.GlobalAimPart)

local MousePressing = false
game:GetService("RunService").RenderStepped:connect(function()
    -- Aimbot
	globtar = FindClosestPlayer()
    if AimbotOp.AimBotToggle == true and globtar ~= nil then
        SetCamera()
		if AimbotOp.TriggerBot == true then
			mouse1press()
			MousePressing = true
		end
	elseif MousePressing == true then
		mouse1release()
		MousePressing = false
		wait()
		mouse1release()
	end
    -- Circle Position
    if Circle.Visible == true then
        local mouse = player:GetMouse()
        Circle.Position =  Vector2.new(mouse.X, mouse.Y + 36)

    end
-- Circle Colour
    if AimbotOp.AimBotToggle == true  then
        Circle.Color = Color3.fromRGB(0,255,0)    
    else
        Circle.Color = Color3.fromRGB(201, 167, 240)
    end

end)

local TabMenu = Window:TabMenu()
local AimbotTab = TabMenu:Add("Aimbot")

AimbotTab:Label("Aimbot Settings")
AimbotTab:Separator()

local ChangeAimBotBind = AimbotTab:Button()
ChangeAimBotBind.Label = "Aimbot Bind: MouseButton2"
ChangeAimBotBind.OnUpdated:Connect(function()
    ChangeAimBotBind.Label = "Changing Bind"
    ChangingBind = true
end)
local AimbotToggleUi = AimbotTab:CheckBox()
AimbotToggleUi.Label = "Toggle Aimbot"
AimbotToggleUi.Value = AimbotOp.OverallEnabled
AimbotToggleUi.OnUpdated:Connect(function(v)
    AimbotOp.OverallEnabled = v
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if  gameProcessedEvent then return end
    if  input.UserInputType == Enum.UserInputType.Focus then return end
    local e,r = pcall(function()
        if  ChangingBind == false  and (input.UserInputType == Enum.UserInputType[AimbotOp.BotBind] or input.KeyCode == Enum.KeyCode[AimbotOp.BotBind])   then
            if AimbotOp.TreatAimAsTog == true then
                AimbotOp.AimBotToggle = not AimbotOp.AimBotToggle
            else
                AimbotOp.AimBotToggle = true
            end
           
        elseif ChangingBind == true then
            local keyhold = input.KeyCode
            if keyhold  == Enum.KeyCode.Unknown then 
                AimbotOp.BotBind = input.UserInputType.Name
            else
                AimbotOp.BotBind = input.KeyCode.Name
            end
            ChangeAimBotBind.Label = "Aimbot Bind: "..AimbotOp.BotBind
            ChangingBind = false
            MousePressing = false
        end

    end)
    
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
    if  gameProcessedEvent then return end
    local e,r = pcall(function()
        if input.UserInputType == Enum.UserInputType[AimbotOp.BotBind] or input.KeyCode == Enum.KeyCode[AimbotOp.BotBind]  and ChangingBind == false then
            if AimbotOp.TreatAimAsTog == false then
                AimbotOp.AimBotToggle = false
            end
        end
    end)
 
end)




local UseAimbotASToggle = AimbotTab:CheckBox()
UseAimbotASToggle.Label = "Aimbot As Toggle"
UseAimbotASToggle.Value = AimbotOp.TreatAimAsTog
UseAimbotASToggle.OnUpdated:Connect(function(v)
    AimbotOp.TreatAimAsTog = v

end)




local Aimparts = {
    "Head",
    "HumanoidRootPart",
    "All"
}
local SelectedItem = table.find(Aimparts,AimbotOp.AimPart)
if SelectedItem == nil then
    error(AimbotOp.Aimpart,"Not part of Aim Parts Table")
end
local ComboAirPart = AimbotTab:Combo()
ComboAirPart.Label = "Select AimPart"
ComboAirPart.Items = Aimparts
ComboAirPart.SelectedItem = SelectedItem
ComboAirPart.OnUpdated:Connect(function(i)
    AimbotOp.AimPart = Aimparts[i]
end)



local AimTypes = {
    "Cframe"
}
local SelectedItem = table.find(AimTypes,AimbotOp.AimType)
if SelectedItem == nil then
    error(AimbotOp.AimType,"Not part of Aim Types Table")
end

AimbotTab:Label("Moving Camera Method")
AimbotTab:Separator()

local ComboAimType = AimbotTab:Combo()
ComboAimType.Label = "Select AimType"
ComboAimType.Items = AimTypes
ComboAimType.SelectedItem = SelectedItem
ComboAimType.OnUpdated:Connect(function(i)
    AimbotOp.AimType = AimTypes[i]
end)

AimbotTab:Label("Will detect if the gamemode is FFA, Turn it off to shoot teamates")
AimbotTab:Separator()
local TeamCheckBut = AimbotTab:CheckBox()
TeamCheckBut.Label = "Automatic TeamCheck"
TeamCheckBut.Value = AimbotOp.CheckTeam
TeamCheckBut.OnUpdated:Connect(function(v)
    AimbotOp.CheckTeam = v
end)



local RayTypes = {
    "Raycast",
    "ObscuringParts",
    "None"
}
local SelectedItem = table.find(RayTypes,AimbotOp.VisiblyCheck)
if SelectedItem == nil then
    error(AimbotOp.VisiblyCheck,"Not part of Visibly Table")
end




AimbotTab:Label("AimBot Check Options")
AimbotTab:Separator()
local VisibleCheckBut = AimbotTab:Combo()
VisibleCheckBut.Label = "Visibility Check"
VisibleCheckBut.SelectedItem = SelectedItem
VisibleCheckBut.Items = RayTypes
VisibleCheckBut.OnUpdated:Connect(function(i)
    AimbotOp.VisiblyCheck = RayTypes[i]
    ObscureAllWorkspace()
end)




local TriggerBotBut = AimbotTab:CheckBox()
TriggerBotBut.Label = "Trigger Bot"
TriggerBotBut.Value = AimbotOp.TriggerBot
TriggerBotBut.OnUpdated:Connect(function(v)
    AimbotOp.TriggerBot = v
end)


AimbotTab:Label("FOV Settings")
AimbotTab:Separator()
local UseFOVUI = AimbotTab:CheckBox()
UseFOVUI.Label = "Use FOV"
UseFOVUI.Value = AimbotOp.UseFov
UseFOVUI.OnUpdated:Connect(function(v)
    AimbotOp.UseFov = v
end)


local FOVSlider = AimbotTab:IntSlider()
FOVSlider.Clamped = true
FOVSlider.Min = 1
FOVSlider.Max = 1000
FOVSlider.Value = AimbotOp.FovSize


FOVSlider.OnUpdated:Connect(function(i)
    AimbotOp.FovSize = i
    Circle.Radius = AimbotOp.FovSize
end)


local ShowFOV = AimbotTab:CheckBox()
ShowFOV.Label = "Show FOV"
ShowFOV.Value = AimbotOp.ShowFOV
ShowFOV.OnUpdated:Connect(function(v)
    AimbotOp.ShowFOV = v
    Circle.Visible = v
end)

local ESPOp = {
    Chams = false,
    ESPEnabled = true,
    ShowName = true,
    ShowHP = true,
    UsePercentage = true,
    Skeleton = false,
    HeadDot = false,
    TargetHud = "Flux"

}



local ChamsFolder = Instance.new("Folder",game.CoreGui)



local ESPTab = TabMenu:Add("ESP")
ESPTab:Label("ESP Settings")
ESPTab:Separator()
local ToggleEspBut = ESPTab:CheckBox()
ToggleEspBut.Label = "Enable ESP"
ToggleEspBut.Value = ESPOp.ESPEnabled
ToggleEspBut.OnUpdated:Connect(function(v)
    ESPOp.ESPEnabled = v
end)
ESPTab:Label("Edit Text Esp Options")
ESPTab:Separator()
local ToggleShowName = ESPTab:CheckBox()
ToggleShowName.Label = "Show Name"
ToggleShowName.Value = ESPOp.ShowName
ToggleShowName.OnUpdated:Connect(function(v)
    ESPOp.ShowName = v
end)

local ToggleShowHp = ESPTab:CheckBox()
ToggleShowHp.Label = "Show HP"
ToggleShowHp.Value = ESPOp.ShowHP
ToggleShowHp.OnUpdated:Connect(function(v)
ESPOp.ShowHP = v
end)

local ToggleUsePercentage = ESPTab:CheckBox()
ToggleUsePercentage.Label = "Use Percentage"
ToggleUsePercentage.Value = ESPOp.UsePercentage
ToggleUsePercentage.OnUpdated:Connect(function(v)
    ESPOp.UsePercentage = v
end)
ESPTab:Label("Misc ESP Types")
ESPTab:Separator()
local Chams = ESPTab:CheckBox()
Chams.Label = "Chams"
Chams.Value = false


function Cham(v)
    local Highlight = Instance.new("Highlight",ChamsFolder)
    if v.Character then
        Highlight.Adornee = v.Character
        Highlight.Enabled = true
        Highlight.Name = v.Name
        Highlight.Enabled = ESPOp.Chams
        Highlight.FillTransparency = ChamColor.Fill
        Highlight.OutlineTransparency = ChamColor.Outline 
    end
    local serv;
    local serv2;
    local serv3;
    serv = game:GetService("RunService").RenderStepped:connect(function()
        if globtar == v then
            Highlight.FillColor = ChamColor.Target
            Highlight.OutlineColor  = OutlineColors.AimbotTarget
        elseif TeamCheck(v) == true then
            Highlight.FillColor = ChamColor.Enemy  
            Highlight.OutlineColor  = OutlineColors.EnemyColor
        else
            Highlight.FillColor = ChamColor.Ally
            Highlight.OutlineColor  = OutlineColors.AllyColor
        end
        Highlight.FillTransparency = ChamColor.Fill
        Highlight.OutlineTransparency = ChamColor.Outline
        Highlight.Enabled = ESPOp.Chams
        
    end)

    serv2 = game.Players.PlayerRemoving:connect(function(removed)
        if removed == v then
            serv:Disconnect()
            serv3:Disconnect()
            serv2:Disconnect()
        end  
    end)
    serv3 = v.CharacterAdded:connect(function(v)
       Highlight.Adornee = v
    end)
end

game.Players.PlayerAdded:connect(function(v)
    Cham(v)
end)
for i,v in pairs(game.Players:GetChildren()) do
   Cham(v)
end         



Chams.OnUpdated:Connect(function(v2)
   ESPOp.Chams = v2
end)
local p;
if ChamColor.Fill == 0 then
    p = true
else
    p = false
end
local ChamFilSlider = ESPTab:CheckBox()
ChamFilSlider.Label = "Fill Transparency"
ChamFilSlider.Value = p
ChamFilSlider.OnUpdated:Connect(function(i)
    if i == true then
        ChamColor.Fill = 0
    else
        ChamColor.Fill = 1
    end
    for i,v in pairs(ChamsFolder:GetChildren()) do
        v.FillTransparency = ChamColor.Fill
    end
end)

local p;
if ChamColor.Transparency == 0 then
    p = true
else
    p = false
end

local ChamOutlineSlider = ESPTab:CheckBox()
ChamOutlineSlider.Label = "Outline Transparency"
ChamOutlineSlider.Value = p
ChamOutlineSlider.OnUpdated:Connect(function(i)
    if i == true then
        ChamColor.Transparency = 0
    else
        ChamColor.Transparency = 1
    end
    for i,v in pairs(ChamsFolder:GetChildren()) do
        v.OutlineTransparency = ChamColor.Transparency
    end
end)
local function GetPercent(i,v)
    return (i/v) *100
end
local function Round(v)
    return math.floor(v + 0.5)
end
local function GetHp(v)
    if game.PlaceId == 286090429 then -- Aresenal HP 
        if v:FindFirstChild("NRPBS") == nil then return false end
        return {Health = v.NRPBS.Health.Value, MaxHealth = v.NRPBS.MaxHealth.Value}
    elseif game.PlaceId == 3785125742 then -- Xeno Online 2
        if (v.Character:FindFirstChild("Health") or v.Character.Health:FindFirstChild("Max")) == nil then return false end
        return {Health = v.Character.Health.Value, MaxHealth = v.Character.Health.Max.Value}
    else -- Universal
        if v.Character:FindFirstChild("Humanoid") == nil then return false end
        return {Health = v.Character.Humanoid.Health, MaxHealth = v.Character.Humanoid.MaxHealth}
    end

end
local function ModdedText(str,v) -- Add extra text like Bp: Money: blah blah
    if game.PlaceId == 184928419545353 then
        return str.." jhhfhfh"..v.Name
    end
    
end

local function floorpos(pos)
    return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
end


local function ESP(v)
    local RunService;
    local TextString = Text.new()
    TextString.Visible = true
    TextString.Text = ""
    TextString.Size = EspTextOption.Size

    RunService = game:GetService("RunService").RenderStepped:connect(function()
        if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and GetHp(v).Health > 0  then
            local StringRender = ""
            local camera = game.Workspace.CurrentCamera
            local RootPos, OnS = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local HeadPos, OnS = camera:WorldToViewportPoint(v.Character.Head.Position)
            
            local function DrawText()
                TextString.Text = StringRender
                TextString.Position = floorpos(Vector2.new(HeadPos.X - (TextString.TextBounds.X / 2),HeadPos.Y -  TextString.TextBounds.Y))
                if v == globtar then
                    TextString.Color = TextColor.AimbotTarget
                elseif v.Team == player.Team then
                    TextString.Color = TextColor.AllyColor
                else
                    TextString.Color = TextColor.EnemyColor
                end
            end
            if ESPOp.ESPEnabled == false or OnS == false then
                TextString.Visible = false
            else
                TextString.Visible = true
                if ESPOp.ShowName == true then
                    StringRender = v.Name
                end
                if ESPOp.ShowHP == true then
                    if ESPOp.UsePercentage == false then
                        local hp = GetHp(v)
                        if hp ~= false then
                            StringRender = StringRender.. " "..tostring(hp.Health).." / "..tostring(hp.MaxHealth)
                        else
                            StringRender = StringRender.." Cannot find HP"
                        end
                        
                    else
                        local hp = GetHp(v)
                        if hp ~= false then
                            StringRender = StringRender.." "..tostring(Round(GetPercent(hp.Health,hp.MaxHealth))).."%"
                        else
                            StringRender = StringRender.." Cannot find HP"
                        end
                    end
                end
                ModdedText(StringRender,v)
                DrawText()
            end
        else
            TextString.Visible = false
        end
    end)
    game.Players.PlayerRemoving:connect(function(removed)
        if removed == v then
            RunService:Disconnect()
        end
    end)
end
for i,v in pairs(game.Players:GetChildren()) do
    if v ~= player then
        ESP(v)
    end
end

game.Players.PlayerAdded:connect(function(v)
    ESP(v)
end)


function Dragify(MainFrame)
	local dragging
	local dragInput
	local dragStart
	local startPos
    local Delta
    local Position
	local function update(input)
		Delta = input.Position - dragStart
		Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(.15), {Position = Position}):Play()
	end

	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	MainFrame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end



local TargetHuds = Instance.new("ScreenGui")
local Flux = Instance.new("Frame")
local Avatar = Instance.new("ImageLabel")
local Name = Instance.new("TextLabel")
local HPBackDrop = Instance.new("Frame")
local HpBar = Instance.new("Frame")
local HpText = Instance.new("TextLabel")
local Dist = Instance.new("TextLabel")


TargetHuds.Name = "TargetHuds"
TargetHuds.Parent = game.CoreGui
TargetHuds.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Flux.Name = "Flux"
Flux.Parent = TargetHuds
Flux.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
Flux.BackgroundTransparency = 0.200
Flux.BorderSizePixel = 0
Flux.Position = UDim2.new(0.412204295, 0, 0.653481007, 0)
Flux.Size = UDim2.new(0, 250, 0, 100)

Avatar.Name = "Avatar"
Avatar.Parent = Flux
Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Avatar.BorderColor3 = Color3.fromRGB(27, 42, 53)
Avatar.BorderSizePixel = 0
Avatar.Position = UDim2.new(0.0399999991, 0, 0.100000307, 0)
Avatar.Size = UDim2.new(0, 80, 0, 80)
Avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

Name.Name = "Name"
Name.Parent = Flux
Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name.BackgroundTransparency = 1.000
Name.Position = UDim2.new(0.385192633, 0, 0.330000311, 0)
Name.Size = UDim2.new(0, 133, 0, 32)
Name.Font = Enum.Font.SourceSans
Name.Text = "RapidRobbieee"
Name.TextColor3 = Color3.fromRGB(0, 0, 0)
Name.TextSize = 27.000
Name.TextWrapped = true
Name.TextXAlignment = Enum.TextXAlignment.Left

HPBackDrop.Name = "HPBackDrop"
HPBackDrop.Parent = Flux
HPBackDrop.BackgroundColor3 = Color3.fromRGB(60, 63, 70)
HPBackDrop.BorderSizePixel = 0
HPBackDrop.ClipsDescendants = true
HPBackDrop.Position = UDim2.new(0.385192633, 0, 0.656923175, 0)
HPBackDrop.Size = UDim2.new(0, 133, 0, 24)

HpBar.Name = "HpBar"
HpBar.Parent = HPBackDrop
HpBar.BackgroundColor3 = Color3.fromRGB(66, 134, 245)
HpBar.BorderSizePixel = 0
HpBar.Size = UDim2.new(1, 0, 1, 0)

HpText.Name = "HpText"
HpText.Parent = HPBackDrop
HpText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HpText.BackgroundTransparency = 1.000
HpText.Size = UDim2.new(1, 0, 1, 0)
HpText.Font = Enum.Font.Cartoon
HpText.Text = "100%"
HpText.TextColor3 = Color3.fromRGB(255, 255, 255)
HpText.TextSize = 22.000
HpText.TextWrapped = true

Dist.Name = "Dist"
Dist.Parent = Flux
Dist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Dist.BackgroundTransparency = 1.000
Dist.Position = UDim2.new(0.385192573, 0, 0.100000307, 0)
Dist.Size = UDim2.new(0, 133, 0, 23)
Dist.Font = Enum.Font.SourceSans
Dist.Text = "Dist: 10000"
Dist.TextColor3 = Color3.fromRGB(0, 0, 0)
Dist.TextSize = 27.000
Dist.TextWrapped = true
Dist.TextXAlignment = Enum.TextXAlignment.Left





Dragify(Flux)
local Huds = {
    "Flux",
    "None"

}

function InvisHud()
    for i,v in pairs(TargetHuds:GetChildren()) do
        v.Visible = false
    end
end
local TargetHudCombo = ESPTab:Combo()
TargetHudCombo.Items = Huds
TargetHudCombo.Label = "Target Huds"
TargetHudCombo.SelectedItem = 1
TargetHudCombo.OnUpdated:Connect(function(i)
    ESPOp.TargetHud = Huds[i]
    InvisHud()
end)
Avatar.BackgroundTransparency = 1

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if ESPOp.TargetHud == "Flux" then
        if globtar ~= nil then
            Flux.Visible = true
            local hp = GetHp(globtar)
            Name.Text = globtar.Name
            if hp ~= false then
                local HpPercent = Round(GetPercent(hp.Health,hp.MaxHealth))
                HpBar.Size = UDim2.new(HpPercent / 100, 0,1,0)
                HpText.Text = tostring(HpPercent).."%"
            else
                HpText.Text = "Cannot find HP"
            end
            
            if globtar.Character:FindFirstChild("HumanoidRootPart") then
                local mag = Round((player.Character.HumanoidRootPart.Position - globtar.Character.HumanoidRootPart.Position).Magnitude)
                Dist.Text = "Dist: "..tostring(mag)
            end
         
            local con, isrea = game:GetService("Players"):GetUserThumbnailAsync(globtar.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Avatar.Image = con
        end
    end
end)






game:GetService("RunService").RenderStepped:connect(function()
    local e,r = pcall(function()
         Window:Emplace()
    end)
end)



function Teleport(v)
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then return end
    if game.GameId == 19274812341 then
        
    else   -- Universal TP
        print("Attempt TP")
        local succes, Error = pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position)
        end)
        print(succes)
        if succes then
            syn.toast_notification({Title = 'Success',Content = 'Sucessfully Teleported to '..v.Name,Type = ToastType.Success,Duration = 1.5,})
        else
            syn.toast_notification({Title = 'Error',Content = Error..v.Name,Type = ToastType.Error,Duration = 1.5,})
        end
    end

end

--[[local TabMenu = Window:TabMenu()
local AimbotTab = TabMenu:Add("Aimbot")

AimbotTab:Label("Aimbot Settings")
AimbotTab:Separator()

local ChangeAimBotBind = AimbotTab:Button()
ChangeAimBotBind.Label = "Aimbot Bind: MouseButton2"
ChangeAimBotBind.OnUpdated:Connect(function()
    ChangeAimBotBind.Label = "Changing Bind"
    ChangingBind = true
end)]]
local TpPlayerGuiUIObjs = {}
local TpPlayerGuiConnections = {}

local PlayerTpTab;
function TptoPlayer(bool)
    if bool == true then
        PlayerTpTab =  TabMenu:Add("TP To Player UI")
        TpPlayerGuiUIObjs[#TpPlayerGuiUIObjs+1] = PlayerTpTab    
        PlayerTpTab:Label("Click a name to TP to them")
        PlayerTpTab:Separator()
        local function CreateButton(v)
            local PlayerButton = PlayerTpTab:Button()
            PlayerButton.Label = v.Name
            PlayerButton.OnUpdated:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    Teleport(v)
                end

            end)
        end
        for i,v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer then
                CreateButton(v)
            end
        end
        TpPlayerGuiConnections[#TpPlayerGuiConnections+1] = game:GetService("Players").PlayerAdded:connect(function(v)
            if v ~= game.Players.LocalPlayer then
                CreateButton(v)
            end
        end)
    else
        for i,v in pairs(TpPlayerGuiConnections) do
            v:Disconnect()
        end
        PlayerTpTab:Clear()
    end    
end



local MiscTabMenu = TabMenu:Add("Misc")

local TpPlayerCheckBox = MiscTabMenu:CheckBox()
TpPlayerCheckBox.Label = "Open Player TP Menu"
TpPlayerCheckBox.OnUpdated:Connect(function(v)
    TptoPlayer(v)
end)







syn.toast_notification({Title = 'Project Hub',Content = 'Sucessfully loaded Project HUB',Type = ToastType.Success,Duration = 3,})