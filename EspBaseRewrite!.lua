local GuiService = game:GetService("GuiService")
-- ESP BASE REWRITE
local player;
local DrawESP = false

local ChamsFolder;
if not game:IsLoaded() then
    game:IsLoaded():Wait()
end

repeat wait(); player =  game.Players.LocalPlayer until player and player.Name and player.Parent


-- Backup Global Variables incase they are not set

_G.EthoChamsDefaultESPToggle = true
_G.EthoChamsDefaultESPTextSize = 30
_G.EthoChamsDefaultESPTextColor = Color3.fromRGB(255,255,255)
_G.EthoChamsDefaultESPShowDistance = true
_G.EthoChamsDefaultESPMaxRenderDistance = 10000
_G.EthoChamsDefaultESPShowHealth =  true
_G.EthoChamsDefaultESPShowHealthPercent = false
_G.EthoChamsDefaultESPScaledText = true
_G.EthoChamsDefaultESPChamsToggle = false
_G.EthoChamsDefaultESPChamsFillColor = Color3.fromRGB(255,0,0)
_G.EthoChamsDefaultESPChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.EthoChamsDefaultESPChamsFillTrans = 1
_G.EthoChamsDefaultESPChamsOutlineTrans = 0


local ESPListenTable = {}
local ESPRunServ;
local ESPFunctionReturnTable = {}
_G.AllowChamsEtho = true
if _G.AllowChamsEtho == true then
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
    for i,v in pairs(TextTable.ESPTextObjects) do
        v.Visible = Bool
    end
    if TextTable.Highlight ~= nil then
        TextTable.Highlight.HightlightObj.Enabled = Bool
    end
end

function ESPFunctionReturnTable:RefreshHighlight(HighlightObj,PartToAdornee)
    HighlightObj.Adornee = nil
    HighlightObj.Adornee = PartToAdornee

end

function ESPFunctionReturnTable:AddESPObj(OptionTable)
    if type(OptionTable) ~= "table"  then
        error("AddESPObj Function, Set Variable is not a OPTIONTABLE aa1")
        return
    elseif OptionTable.Data == nil then
        error("AddESPObj Function, Data is not a varaible in OptionTable aa2")
        return
    elseif OptionTable.Data.ReturnPosFunc == nil then
        error("AddESPObj Function, Return pos function == nil aa3")
        return
    elseif OptionTable.Data.CalcStringFunction == nil then
        error("AddESPObj Function, Calc String function == nil aa4")
        return   
    elseif OptionTable.Data.DeterminToRemoveFunction == nil then
        error("AddESPObj Function, DeterminToBeRemovedFunction == nil, aa5")    
    end
    OptionTable.Data.ModdedName = OptionTable.Data.ModdedName or ""
    OptionTable.Data.TextOffset = OptionTable.Data.TextOffset or 0
    OptionTable.Data.Vector3Offset = OptionTable.Data.Vector3Offset or Vector3.new(0,0,0)
    OptionTable.ToBeRemoved = OptionTable.ToBeRemoved or false
    
    local GlobalVariablePreset = OptionTable.GlobalVariableTable
    if GlobalVariablePreset == nil then
        error("AddESPObj Function, GlobalVariableTable == nil")
        return
    end
    GlobalVariablePreset.Toggle = GlobalVariablePreset.Toggle or "EthoChamsDefaultESPToggle"
    GlobalVariablePreset.TextSize = GlobalVariablePreset.TextSize or "EthoChamsDefaultESPTextSize"
    GlobalVariablePreset.TextColor = GlobalVariablePreset.TextColor or "EthoChamsDefaultESPTextColor"
    GlobalVariablePreset.ShowDistance = GlobalVariablePreset.ShowDistance or "EthoChamsDefaultESPShowDistance"
    GlobalVariablePreset.MaxRenderDistance = GlobalVariablePreset.MaxRenderDistance or "EthoChamsDefaultESPMaxRenderDistance"
    GlobalVariablePreset.ShowHealth = GlobalVariablePreset.ShowHealth or "EthoChamsDefaultESPShowHealth"
    GlobalVariablePreset.ShowHealthPercent = GlobalVariablePreset.ShowHealthPercent or "EthoChamsDefaultESPShowHealthPercent"
    GlobalVariablePreset.ScaledText = GlobalVariablePreset.ScaledText or "EthoChamsDefaultESPScaledText"
    GlobalVariablePreset.ChamsToggle = GlobalVariablePreset.ChamsToggle or "EthoChamsDefaultESPChamsToggle"
    GlobalVariablePreset.ChamsFillColor = GlobalVariablePreset.ChamsFillColor or "EthoChamsDefaultESPChamsFillColor"
    GlobalVariablePreset.ChamsOutlineColor = GlobalVariablePreset.ChamsOutlineColor or "EthoChamsDefaultESPChamsOutlineColor"
    GlobalVariablePreset.ChamsFillTrans = GlobalVariablePreset.ChamsFillTrans or "EthoChamsDefaultESPChamsFillTrans"
    GlobalVariablePreset.ChamsOutlineTrans = GlobalVariablePreset.ChamsFillTrans or "EthoChamsDefaultESPChamsOutlineTrans"


    if _G.AllowChamsEtho == true and ChamsFolder ~= nil  and OptionTable.Data.Highlight.UseChams == true then

        local Highlight = Instance.new("Highlight",ChamsFolder)
        OptionTable.Data.Highlight.HighlightObj = Highlight
        OptionTable.Data.Highlight.LastKnownChildrenCache = -2
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
            VisibleText(false,OptionTable)
        elseif OptionTable.ToBeRemoved == true  then
            PauseRender = true
            for i,v in pairs(OptionTable.ESPTextObjects) do 
                v.Visible = false
                v:Remove()
            end
            table.remove(ESPListenTable,i)
        elseif DrawESP == false then
            VisibleText(false, OptionTable)
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
                    if  OptionTable.Data.Highlight.UseChams == true and OptionTable.Data.Highlight.HighlightObj ~= nil then
                       
                        local HighlightObj = OptionTable.Data.Highlight.HighlightObj
                        local AdorneePart = OptionTable.Data.Highlight.ReturnPartFunction()
                       
                        if ESPFunctionReturnTable:CheckBasePartValid(AdorneePart) == true and _G[OptionTable.GlobalVariableTable.ChamsToggle] == true then
                            local ChildrenCached = #AdorneePart:GetChildren()
                            if HighlightObj.Adornee ~= AdorneePart then
                                OptionTable.Data.Highlight.LastKnownChildrenCache = ChildrenCached
                                HighlightObj.Adornee = AdorneePart
                            end
                            if ChildrenCached ~= OptionTable.Data.Highlight.LastKnownChildrenCache then
                                OptionTable.Data.Highlight.LastKnownChildrenCache = ChildrenCached
                                ESPFunctionReturnTable:RefreshHighlight(HighlightObj,AdorneePart)
                            end
                            HighlightObj.FillColor = _G[OptionTable.GlobalVariableTable.ChamsFillColor]
                            HighlightObj.OutlineColor = _G[OptionTable.GlobalVariableTable.ChamsOutlineColor]
                            HighlightObj.FillTransparency = _G[OptionTable.GlobalVariableTable.ChamsFillTrans]
                            HighlightObj.OutlineTransparency = _G[OptionTable.GlobalVariableTable.ChamsOutlineTrans]
                            HighlightObj.Enabled = true 
                        else
                            HighlightObj.Enabled = false
                        end

                    end


                    VisibleText(true,OptionTable)
                else
                    VisibleText(false,OptionTable)
                end

            else
                VisibleText(false, OptionTable)
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
            VisibleText(false,v.Highlight.HightlightObj)
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
_G.ShowChams = true
_G.ChamsFillColor = Color3.fromRGB(255,0,255)
_G.ChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.ChamsFill = 0
_G.ChamsOutlineTrans = 0


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
                        Line3Text = "["..tostring(Round(MagnitudeChached)).."] "..Line3Text
                    end
                    if PassedTable.Data.ModdedName ~= "" then
                        Line3Text = Line3Text..PassedTable.Data.ModdedName.." "
                    else
                        Line1Text = Line1Text..v.Name.." "
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowHealth] == true then
                        local MinHp = v.Character.Humanoid.Health
                        local MaxHp = v.Character.Humanoid.MaxHealth
                        if _G[PassedTable.GlobalVariableTable.ShowHealthPercent] == true then
                            Line3Text = Line3Text.."["..tostring(Round(CalcPercent(MinHp,MaxHp))).."%] "
                        else
                            Line3Text = Line3Text.."["..tostring(Round(MinHp)).."/"..tostring(Round(MaxHp)).."] "
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
            end,
            RunAfterEverthing = function(PassedTable)
                

            end,
            Highlight = {
                UseChams = true,
                ReturnPartFunction = function()
                    return v.Character
                end,
                LastKnownChildrenCache = 0
            }
        },
        GlobalVariableTable = {
            Toggle = "PlayerESP",
            TextSize = "PlayerTextSize",
            TextColor = "PlayerTextColor",
            ShowDistance = "PlayerDist",
            MaxRenderDistance = "PlayerMaxDist",
            ShowHealth = "ShowPlayerHealth",
            ShowHealthPercent = "ShowPlayerHealthPercent",
            ScaledText = "ScalePlayerText",
            ChamsToggle = "ShowChams",
            ChamsFillColor = "ChamsFillColor",
            ChamsOutlineColor = "ChamsOutlineColor",
            ChamsFillTrans = "ChamsFill",
            ChamsOutlineTrans = "ChamsOutlineTrans"


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