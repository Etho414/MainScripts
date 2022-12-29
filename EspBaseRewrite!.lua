-- ESP BASE REWRITE
local player;

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

function ESPRenderer()
    for i,OptionTable in pairs(ESPListenTable) do
        if _G[OptionTable.GlobalVariableTable.Toggle] == false then
            VisibleText(false,OptionTable.ESPTextObjects)
        else
            local PositionCached = OptionTable.Data.ReturnPosFunc(OptionTable)
            if PositionCached ~= nil and _G[OptionTable.GlobalVariableTable.Toggle] == true  then
                local cam = game.Workspace.CurrentCamera
                local ScreenPos,OnS = cam:WorldToViewportPoint(PositionCached)
                if OnS then
                    local TextTable = OptionTable.ESPTextObjects
                    local StringCached = OptionTable.Data.CalcStringFunction(OptionTable)
                    local MagnitudeCached = ESPFunctionReturnTable:GetMagnitude(game.Players.LocalPlayer.Character.HumanoidRootPart.Position,PositionCached)
                    local TextOffset = MagnitudeCached / 500
                    --Settings texts for the lines!!!
                    StringCached.Line1 = StringCached.Line1 or ""
                    StringCached.Line2 = StringCached.Line2 or ""
                    StringCached.Line2 = StringCached.Line2 or ""

                    TextTable.Text1.Text = StringCached.Line1
                    TextTable.Text2.Text = StringCached.Line2
                    TextTable.Text3.Text = StringCached.Line3

                    -- Settings positions of text objects
                    
                    TextTable.Text1.Position = Vector2.new(ScreenPos.X - (TextTable.Text1.TextBounds.X / 2),(ScreenPos.Y - TextOffset) - OptionTable.Data.TextOffset)
                    TextTable.Text2.Position = Vector2.new(ScreenPos.X - (TextTable.Text2.TextBounds.X / 2),(1.5 + TextTable.Text1.Position.Y - TextTable.Text1.TextBounds.Y / 2))
                    TextTable.Text3.Position = Vector2.new(ScreenPos.X - (TextTable.Text3.TextBounds.X / 2),(1.5 + TextTable.Text2.Position.Y - TextTable.Text2.TextBounds.Y / 2) )
                    for i,v in pairs(TextTable) do
                        local HoldSize = _G[OptionTable.GlobalVariableTable.TextSize]
                        local ChangeTo = HoldSize - (TextOffset * 1.5)
                        if ChangeTo < (HoldSize / 2) then 
                            ChangeTo = (HoldSize / 2)
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
end

local DrawESP = false
function ESPFunctionReturnTable:Toggle()
    DrawESP = not DrawESP
    if DrawESP == true then
        print("d")
        ESPRunServ = game:GetService("RunService").RenderStepped:connect(ESPRenderer)
    else
        ESPRunServ:Disconnect()
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
for i,v in pairs(game.Players:GetChildren()) do
    if v ~= player then
        local OptionTable = {
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
                    local Line2Text = "222"
                    local Line3Text = "222"
                    if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                        local MagnitudeChached = ESPFunctionReturnTable:GetMagnitude(v.Character.HumanoidRootPart.Position,player.Character:FindFirstChild("HumanoidRootPart").Position)
                        if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                            Line1Text = "["..tostring(Round(MagnitudeChached)).."]"..Line1Text.." "
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
                TextOffset = 0
            },
            GlobalVariableTable = {
                Toggle = "PlayerESP",
                TextSize = "PlayerTextSize",
                TextColor = "PlayerTextColor",
                ShowDistance = "PlayerDist",
                MaxRenderDistance = "PlayerMaxDist",
                ShowHealth = "ShowPlayerHealth",
                ShowHealthPercent = "ShowPlayerHealthPercent"


            }


        }
        ESPFunctionReturnTable:AddESPObj(OptionTable)
    end
end












--[[
 Settings tables format
 _G.PlayerESP = true -- The toggle for player ESP
 _G.PlayerTextSize = 30
 _G.PlayerTextColor = Color3.fromRGB(255,255,255)
 _G.PlayerDist = true -- Shows Distance
 _G.ShowPlayerHealth = true -- Shows player Health
 _G.ShowPlayerHealthPercent = false -- Displays players health in %
 PlayerEspTable
 Table = {
    Data = {
        ReturnPosFunc = function(DataTable) return game.Players.LocalPlayer.Character.HumanoidRootPart.Position end -- Function to return the position of the desired player! (This is where all checks will be done)
        ModdedName = "" -- If "" then name will be playerpath name,
        CalcStringFunction = function(DataTable) return {String = player.Name,Line = 1} end -- String to be displayed  and what line to draw it to (3 lines max)
        TextOffset = 3 -- Offset for ESP to render to
    },
    GlobalVariableTable = {
        Toggle = "PlayerESP",
        TextSize = "PlayerTextSize",
        TextColor = "PlayerTextColor",
        ShowDistance = "PlayerDist",
        MaxRenderDistance = "PlayerMaxDist",
        ShowHealth = "ShowPlayerHealth"
        ShowHealthPercent = "ShowPlayerHealthPercent"
    }
}

DeepwokenMobESP / Model ESP Check
-- 2 Ways of getting the position for moddel, Have the loop run through all tghe children checking if there and checking the :isA thing or make ModelChildListener a function that returns the desired position


Table = {
    Date = {

        ModdedName = "", -- if left to blank default to model name
        ModelPath = "",
        ReturnPosFunction = function() end -- Function to return the position of the part!! -- Add magnitude check in this!,
        CalcStringFunction = function(optiontable) return {String = player.Name,Line = 1} end -- String to be displayed  and what line to draw it to (3 lines max) -- Option table will be passed into it
        HpType = "humanoid",
        HumanoidPath = workspace.live.etreanguard.humanoid
    }


}


-- Example for OWlSpaned ESP
Table = {
    Date = { -- GlobalVariableTable would be the same as player just different names !!

        ReturnPosFunction = function() end, -- funbction to return the position of owl feathers,
        CalcStringFunction = function() return {String = player.Name,Line = 1} end -- String to be displayed  and what line to draw it to (3 lines max)
        ModdedName = "",
        HpType = "none"
    }



}








]]

