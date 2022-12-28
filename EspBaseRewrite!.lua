-- The town ReWrite!
local player;

if not game:IsLoaded() then
    game:IsLoaded():Wait()
end

repeat wait(); player =  game.Players.LocalPlayer until player and player.Name and player.Parent

local ESPListenTable = {}
local ESPRunServ;
local ESPFunctionReturnTable = {}



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
function 



function ESPFunctionReturnTable:AddESPObj(OptionTable)
    if type(OptionTable) ~= "table"  then
        error("AddESPObj FUnction, Set Variable is not a OPTIONTABLE aa1")
        return
    elseif OptionTable.Date == nil then
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
            local PositionCached = OptionTable.ReturnPosFunc()
            if PositionCached ~= nil then
                

            else
                VisibleText(false, OptionTable.ESPTextObjects)
            end
        end


        

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
        ReturnPosFunc = function() return game.Players.LocalPlayer.Character.HumanoidRootPart.Position end -- Function to return the position of the desired player! (This is where all checks will be done)
        ModdedName = "" -- If "" then name will be playerpath name,
        CalcStringFunction = function() return {String = player.Name,Line = 1} end -- String to be displayed  and what line to draw it to (3 lines max)
        HpType = "player"
    },
    GlobalVariableTable = {
        Toggle = "PlayerESP",
        TextSize = "PlayerTextSize",
        TextColor = "PlayerTextColor",
        ShowDistance = "PlayerDist",
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
        ReturnPosFunction = function() end -- Function to return the position of the part!!,
        CalcStringFunction = function() return {String = player.Name,Line = 1} end -- String to be displayed  and what line to draw it to (3 lines max)
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

