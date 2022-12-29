-- ESP BASE REWRITE
local player;
local DrawESP = false
if not game:IsLoaded() then
    game:IsLoaded():Wait()
end

repeat wait(); player =  game.Players.LocalPlayer until player and player.Name and player.Parent

local ESPListenTable = {}
local ESPRunServ;
local ESPFunctionReturnTable = {}
_G.AllowChamsToBeUsed = false -- might have a detection (i tryed to stop it tho..)

local ChamsFolder;
if _G.AllowChamsToBeUsed == true then
    ChamsFolder = Instance.new("Folder")
    syn.protect_gui(ChamsFolder)
    ChamsFolder.Parent = game.CoreGui
end

function CalcPercent(min,max)
    return math.floor(((min / max) * 100) + 0.5)
end
function Round(n)
    return math.floor(n + 0.5)
end

function ESPFunctionReturnTable:GetMagnitude(Pos1,Pos2)
    return (Pos1 - Pos2).Magnitude
end


function ESPFunctionReturnTable:CheckBasePartValid(Part)
    if Part == nil then return false end
    if Part.Parent == nil then return false end
    if Part.Name == nil then return false end
    return true
end
function VisibleText(Bool,TextTable)
    for i,v in pairs(TextTable) do
        v.Visible = Bool
    end
end



function ESPFunctionReturnTable:AddESPObj(OptionTable)
    if type(OptionTable) ~= "table"  then
        error("AddESPObj Function, Set Variable is not a OPTIONTABLE aa1")
        return
    elseif OptionTable.Data == nil then
        error("AddESPObj Function, Data is not a varaible in OptionTable aa2")
        return
    end
    local ESPPresetText1 = Drawing.new("Text")
    local ESPPresetText2 = Drawing.new("Text")
    local ESPPresetText3 = Drawing.new("Text")
    OptionTable.ESPTextObjects = {Text1 =ESPPresetText1,Text2 = ESPPresetText2,Text3 = ESPPresetText3}

    ESPListenTable[#ESPListenTable + 1] = OptionTable
end
local PauseRender = false
function ESPRenderer()
    for i,OptionTable in pairs(ESPListenTable) do
        OptionTable.Data.DeterminToRemoveFunction(OptionTable)
        if _G[OptionTable.GlobalVariableTable.Toggle] == false then
            VisibleText(false,OptionTable.ESPTextObjects)
        elseif OptionTable.ToBeRemoved == true  then
            PauseRender = true
            for i,v in pairs(OptionTable.ESPTextObjects) do 
                v.Visible = false
                v:Remove()
            end
            table.remove(ESPListenTable,i)
        elseif DrawESP == false then
            VisibleText(false, OptionTable.ESPTextObjects)
        elseif PauseRender == false then
            local PositionCached = OptionTable.Data.ReturnPosFunc(OptionTable)
            if PositionCached ~= nil and _G[OptionTable.GlobalVariableTable.Toggle] == true  then
                local cam = game.Workspace.CurrentCamera
                local ScreenPos,OnS = cam:WorldToViewportPoint(PositionCached + OptionTable.Data.Vector3Offset)
                if OnS then
                    local TextTable = OptionTable.ESPTextObjects
                    local StringCached = OptionTable.Data.CalcStringFunction(OptionTable)
                    local MagnitudeCached = ESPFunctionReturnTable:GetMagnitude(game.Players.LocalPlayer.Character.HumanoidRootPart.Position,PositionCached)
                    local TextOffset = MagnitudeCached / 500
                    if TextOffset < 0 then TextOffset = 0 end
                    --Settings texts for the lines!!!
                    StringCached.Line1 = StringCached.Line1 or ""
                    StringCached.Line2 = StringCached.Line2 or ""
                    StringCached.Line2 = StringCached.Line2 or ""

                    TextTable.Text1.Text = StringCached.Line1
                    TextTable.Text2.Text = StringCached.Line2
                    TextTable.Text3.Text = StringCached.Line3

                    -- Settings positions of text objects 
                    
                    TextTable.Text1.Position = Vector2.new(ScreenPos.X - (TextTable.Text1.TextBounds.X / 2),(ScreenPos.Y - TextOffset) - OptionTable.Data.TextOffset)
                    TextTable.Text2.Position = Vector2.new(ScreenPos.X - (TextTable.Text2.TextBounds.X / 2), (TextTable.Text1.Position.Y - 1 - TextTable.Text1.TextBounds.Y / 2))
                    TextTable.Text3.Position = Vector2.new(ScreenPos.X - (TextTable.Text3.TextBounds.X / 2),(TextTable.Text2.Position.Y - 1 - TextTable.Text2.TextBounds.Y / 2) )
                    for i,v in pairs(TextTable) do
                        local ChangeTo;
                        local HoldSize = _G[OptionTable.GlobalVariableTable.TextSize]
                        if _G[OptionTable.GlobalVariableTable.ScaledText] == true then
                            ChangeTo = HoldSize - (TextOffset * 8)
                            if ChangeTo < (HoldSize / 2) then 
                                ChangeTo = (HoldSize / 2)
                            end
                        else
                            ChangeTo = HoldSize
                        end   
                        v.Size = ChangeTo
                        v.Color = _G[OptionTable.GlobalVariableTable.TextColor]
                    end
                    VisibleText(true,OptionTable.ESPTextObjects)
                else
                    VisibleText(false,OptionTable.ESPTextObjects)
                end

            else
                VisibleText(false, OptionTable.ESPTextObjects)
            end
        end
    end
    PauseRender = false
end

function ESPFunctionReturnTable:Toggle()
    DrawESP = not DrawESP
    if DrawESP == true then
        ESPRunServ = game:GetService("RunService").RenderStepped:connect(ESPRenderer)
    else
        ESPRunServ:Disconnect()
        for i,v in pairs(ESPListenTable) do
            VisibleText(false,v.ESPTextObjects)
        end
    end
end
ESPFunctionReturnTable:Toggle()



_G.PlayerESP = true
_G.PlayerTextSize = 30
_G.PlayerTextColor = Color3.fromRGB(255,255,255)
_G.PlayerDist = true
_G.ShowPlayerHealthPercent = false
_G.PlayerMaxDist = 10000
_G.ShowPlayerHealth = true
_G.ScalePlayerText = true

function AddPlayerESP(v)
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ReturnPosFunc = function(PassedTable)
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = ESPFunctionReturnTable:GetMagnitude(v.Character.HumanoidRootPart.Position,player.Character:FindFirstChild("HumanoidRootPart").Position)
                    if MagnitudeChached < _G[PassedTable.GlobalVariableTable.MaxRenderDistance] then
                        return v.Character.HumanoidRootPart.Position
                    end
                end
                return nil
            end,
            ModdedName = "",
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = ESPFunctionReturnTable:GetMagnitude(v.Character.HumanoidRootPart.Position,player.Character:FindFirstChild("HumanoidRootPart").Position)
                    if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                        Line1Text = "["..tostring(Round(MagnitudeChached)).."] "..Line1Text
                    end
                    if PassedTable.Data.ModdedName ~= "" then
                        Line1Text = Line1Text..PassedTable.Data.ModdedName.." "
                    else
                        Line1Text = Line1Text..v.Name.." "
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowHealth] == true then
                        local MinHp = v.Character.Humanoid.Health
                        local MaxHp = v.Character.Humanoid.MaxHealth
                        if _G[PassedTable.GlobalVariableTable.ShowHealthPercent] == true then
                            Line1Text = Line1Text.."["..tostring(Round(CalcPercent(MinHp,MaxHp))).."%] "
                        else
                            Line1Text = Line1Text.."["..tostring(Round(MinHp)).."/"..tostring(Round(MaxHp)).."] "
                        end
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text}
            end,
            TextOffset = 0,
            Vector3Offset = Vector3.new(0,4,0),
            DeterminToRemoveFunction = function(PassedTable)
                if ESPFunctionReturnTable:CheckBasePartValid(v) == false then
                    PassedTable.ToBeRemoved = true
                end
            end
        },
        GlobalVariableTable = {
            Toggle = "PlayerESP",
            TextSize = "PlayerTextSize",
            TextColor = "PlayerTextColor",
            ShowDistance = "PlayerDist",
            MaxRenderDistance = "PlayerMaxDist",
            ShowHealth = "ShowPlayerHealth",
            ShowHealthPercent = "ShowPlayerHealthPercent",
            ScaledText = "ScalePlayerText"


        }


    }
    ESPFunctionReturnTable:AddESPObj(OptionTable)
end






for i,v in pairs(game.Players:GetChildren()) do
    if v ~= player then
        AddPlayerESP(v)
    end
end
game.Players.PlayerAdded:connect(function(v)
    if v ~= player then
        AddPlayerESP(v)
    end

end)

game:GetService("UserInputService").InputBegan:connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.T then
        ESPFunctionReturnTable:Toggle()

    end

end)