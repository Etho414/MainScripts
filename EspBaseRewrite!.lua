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
_G.EthoChamsDefaultESPBoxToggle = false
_G.EthoChamsDefaultESPHpBarToggle = false 

local ESPListenTable = {}
local ESPRunServ;
local ESPFunctionReturnTable = {}
_G.AllowChamsEtho = _G.AllowChamsEtho or false 
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
    
    if TextTable.Data.Highlight ~= nil and TextTable.Data.Highlight.HighlightObj ~= nil  then
        TextTable.Data.Highlight.HighlightObj.Enabled = Bool
    end
end

function ReturnColorOnHp(HP)
    if HP <= 0.1 then
        return Color3.fromRGB(255,0,0)
    elseif HP <= 0.2 then
        return Color3.fromRGB(255, 68, 68)
    elseif HP <= 0.3 then
        return Color3.fromRGB(247, 99, 99)
    elseif HP <= 0.4 then
        return Color3.fromRGB(255, 116, 62)
    elseif HP <= 0.5 then
        return Color3.fromRGB(255, 178, 36)
    elseif HP <= 0.6 then
        return Color3.fromRGB(253, 182, 74)
    elseif HP <= 0.7 then
        return Color3.fromRGB(255, 251, 0)
    elseif HP <= 0.8 then
        return Color3.fromRGB(173, 207, 19)
    else
        return Color3.fromRGB(139, 255, 30)
    end

end

function ESPFunctionReturnTable:RefreshHighlight(PassedTable,PartToAdornee)
    if PassedTable.Data.Highlight.Refreshing == false then
        PassedTable.Data.Highlight.Refreshing = true 
        local HighlightObj = PassedTable.Data.Highlight.HighlightObj
        local HighlightObj2 = PassedTable.Data.Highlight.HighlightObj2
        HighlightObj2.Adornee = PartToAdornee
        HighlightObj.Adornee = nil
        HighlightObj.Adornee = PartToAdornee
        HighlightObj2.Adornee = nil
    end
    PassedTable.Data.Highlight.Refreshing = false 
end
function CFtoVec(cf)
    return Vector3.new(cf.x,cf.y,cf.z)
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
        error("AddESPObj Function, GlobalVariableTable == nil, aa6")
        return
    end
    GlobalVariablePreset.TextToggle = GlobalVariablePreset.TextToggle or "EthoChamsDefaultESPToggle"
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
    GlobalVariablePreset.BoxToggle = GlobalVariablePreset.BoxToggle or "EthoChamsDefaultESPBoxToggle"
    GlobalVariablePreset.HpBarToggle = GlobalVariablePreset.HpBarToggle or "EthoChamsDefaultESPHpBarToggle"


    OptionTable.Data.BoxESP = OptionTable.Data.BoxESP or {UseBoxESP = false}
    OptionTable.Data.BoxESP.OffsetTable = OptionTable.Data.BoxESP.OffsetTable or {TopLeft = CFrame.new(-2,2,0), TopRight = CFrame.new(2,2,0), BottomLeft = CFrame.new(-2,-3.5,0), BottomRight = CFrame.new(2,-3.5,0)}
    OptionTable.Data.HpBar = OptionTable.Data.HpBar or {UseHpBar = false}
    OptionTable.Data.HpBar.BarOffsetTable = OptionTable.Data.HpBar.BarOffsetTable or {TopLeft = CFrame.new(3,2,0),TopRight = CFrame.new(2,2,0),BottomLeft = CFrame.new(3,-3.5,0),BottomRight = CFrame.new(2,-3.5,0)}
    if _G.AllowChamsEtho == true and ChamsFolder ~= nil  and OptionTable.Data.Highlight.UseChams == true then

        local Highlight = Instance.new("Highlight",ChamsFolder)
        local Highlight2 = Instance.new("Highlight"),ChamsFolder
        OptionTable.Data.Highlight.HighlightObj = Highlight
        OptionTable.Data.Highlight.HighlightObj2 = Highlight2
        OptionTable.Data.Highlight.LastKnownChildrenCache = -2
        OptionTable.Data.Highlight.Refreshing = false
        if OptionTable.Data.Highlight.ReturnPartFunction == nil then
           error("AddESPObj Function - Highlight Portion, Return Part Function == nil, aa7") 
        end
    end


    local ESPPresetText1 = Drawing.new("Text")
    local ESPPresetText2 = Drawing.new("Text")
    local ESPPresetText3 = Drawing.new("Text")
    local ESPPresetBox = Drawing.new("Quad")
    local HpBarOutlineBox = Drawing.new("Quad")
    local HpBarFilledBox = Drawing.new("Quad")
    HpBarOutlineBox.Thickness = 1
    HpBarFilledBox.Thickness = 0.1
    HpBarFilledBox.Filled = true 

    ESPPresetBox.Thickness = 1 
    OptionTable.ESPTextObjects = {Text1 =ESPPresetText1,Text2 = ESPPresetText2,Text3 = ESPPresetText3,BoxObj = ESPPresetBox, HpBarOutline = HpBarOutlineBox,HpBarFilled = HpBarFilledBox}

    ESPListenTable[#ESPListenTable + 1] = OptionTable
end
local PauseRender = false
function ESPRenderer()
    for i,OptionTable in pairs(ESPListenTable) do
        OptionTable.Data.DeterminToRemoveFunction(OptionTable)
        if OptionTable.ToBeRemoved == true  then
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
            if PositionCached ~= nil  and DrawESP == true  then
                if player and player.Character and player.Character.HumanoidRootPart and ESPFunctionReturnTable:GetMagnitude(player.Character.HumanoidRootPart.Position,CFtoVec(PositionCached)) < _G[OptionTable.GlobalVariableTable.MaxRenderDistance] then
                    local MagnitudeCached = ESPFunctionReturnTable:GetMagnitude(game.Players.LocalPlayer.Character.HumanoidRootPart.Position,CFtoVec(PositionCached))
                    local cam = game.Workspace.CurrentCamera
                    local ScreenPos,OnS = cam:WorldToViewportPoint(CFtoVec(PositionCached) + OptionTable.Data.Vector3Offset)
                    if OnS then
                        local TextTable = OptionTable.ESPTextObjects
                        local StringCached = OptionTable.Data.CalcStringFunction(OptionTable)
                        
                        local TextOffset = MagnitudeCached / 500
                        if TextOffset < 0 then TextOffset = 0 end
                        if _G[OptionTable.GlobalVariableTable.TextToggle] == true then
                            --Settings texts for the lines!!!

                            StringCached.Line1 = StringCached.Line1 or ""
                            StringCached.Line2 = StringCached.Line2 or ""
                            StringCached.Line2 = StringCached.Line2 or ""

                            TextTable.Text1.Text = StringCached.Line1
                            TextTable.Text2.Text = StringCached.Line2
                            TextTable.Text3.Text = StringCached.Line3

                            -- Settings positions of text objects 
                            if TextTable.Text1.Text == "" then
                                TextTable.Text1.Position = Vector2.new(ScreenPos.X - (TextTable.Text1.TextBounds.X / 2),((ScreenPos.Y - TextOffset) - OptionTable.Data.TextOffset) + (TextTable.Text1.TextBounds.Y / 2))
                            else
                                TextTable.Text1.Position = Vector2.new(ScreenPos.X - (TextTable.Text1.TextBounds.X / 2),(ScreenPos.Y - TextOffset) - OptionTable.Data.TextOffset)
                            end
                            if TextTable.Text2.Text == "" then
                                TextTable.Text2.Position = Vector2.new(ScreenPos.X - (TextTable.Text1.TextBounds.X / 2),((ScreenPos.Y - TextOffset) - OptionTable.Data.TextOffset) + (TextTable.Text1.TextBounds.Y / 2))
                            else
                                TextTable.Text2.Position = Vector2.new(ScreenPos.X - (TextTable.Text2.TextBounds.X / 2), (TextTable.Text1.Position.Y - 1 -( TextTable.Text1.TextBounds.Y / 2)))
                            end
                            
                            TextTable.Text3.Position = Vector2.new(ScreenPos.X - (TextTable.Text3.TextBounds.X / 2),(TextTable.Text2.Position.Y - 1 - (TextTable.Text2.TextBounds.Y / 2)) )

                            TextTable.Text1.Visible = true 
                            TextTable.Text2.Visible = true
                            TextTable.Text3.Visible = true 

                            -- Changes Text Options / Makes Offsets!
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
                                if v == "Text" then      
                                    v.Size = ChangeTo 
                                end  
                                if i ~= "HpBarFilled" then
                                    v.Color = _G[OptionTable.GlobalVariableTable.TextColor]
                                end
                            end
                        else
                            TextTable.Text1.Visible = false 
                            TextTable.Text2.Visible = false
                            TextTable.Text3.Visible = false 
                        end
                        

                        

                        -- Box ESP !!!

                        if OptionTable.Data.BoxESP.UseBoxESP == true then
                            local BoxESPPreset = OptionTable.Data.BoxESP
                            local BoxEspObj = OptionTable.ESPTextObjects.BoxObj
                            if BoxESPPreset ~= nil then
                                if _G[OptionTable.GlobalVariableTable.BoxToggle] == true then  
                                    local OffsetTable = BoxESPPreset.OffsetTable
                                    local TopLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * OffsetTable.TopLeft))
                                    local TopRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * OffsetTable.TopRight))
                                    local BottomLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * OffsetTable.BottomLeft))
                                    local BottomRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * OffsetTable.BottomRight))
                                    
                                    BoxEspObj.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                    BoxEspObj.PointA = Vector2.new(TopRight.X,TopRight.Y)
                                    BoxEspObj.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                    BoxEspObj.PointD = Vector2.new(BottomRight.X,BottomRight.Y)
    
                                    BoxEspObj.Visible = true 

                                    
                                else
                                    BoxEspObj.Visible = false
                                end
                            end
                        end

                        if OptionTable.Data.HpBar.UseHpBar == true and _G[OptionTable.GlobalVariableTable.HpBarToggle] == true then
                            local HpBarPreset = OptionTable.Data.HpBar
                            local BarOffsetTable = HpBarPreset.BarOffsetTable
                            local OutlineBoxPreset = OptionTable.ESPTextObjects.HpBarOutline
                            local FilledBoxPreset = OptionTable.ESPTextObjects.HpBarFilled
                            local HpCached = HpBarPreset.ReturnHPFunction(OptionTable)
                            
                            if HpCached ~= nil then
                                local HP = HpCached.Min / HpCached.Max
                                local Widthinset = 0.25
                                local Heightinset = 0.25
                                local BarFilledOffsets = {
                                    TopLeft = CFrame.new(BarOffsetTable.TopLeft.X - Widthinset,BarOffsetTable.TopLeft.Y - Heightinset,0),
                                    TopRight = CFrame.new(BarOffsetTable.TopRight.X + Widthinset,BarOffsetTable.TopRight.Y + Heightinset,0),
                                    BottomLeft = CFrame.new(BarOffsetTable.BottomLeft.X - Widthinset,BarOffsetTable.BottomLeft.Y + Heightinset,0),
                                    BottomRight = CFrame.new(BarOffsetTable.BottomRight.X + Widthinset,BarOffsetTable.BottomRight.Y + Heightinset,0)

                                }

                                -- Outline for HpBar
                                local TopLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * BarOffsetTable.TopLeft))
                                local TopRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * BarOffsetTable.TopRight))
                                local BottomLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * BarOffsetTable.BottomLeft))
                                local BottomRight =cam:WorldToViewportPoint(CFtoVec(PositionCached * BarOffsetTable.BottomRight))

                                OutlineBoxPreset.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                OutlineBoxPreset.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                OutlineBoxPreset.PointA = Vector2.new(TopRight.X,TopLeft.Y)
                                OutlineBoxPreset.PointD = Vector2.new(BottomRight.X,BottomLeft.Y)
                                -- HpBar Part

                                local BarSizeInVec = (BarFilledOffsets.TopLeft.Y - BarFilledOffsets.BottomLeft.Y) 
                                local BarHeight = BarSizeInVec * HP

                                local TopLeftBar = CFrame.new(BarFilledOffsets.TopLeft.X,BarFilledOffsets.BottomLeft.Y + BarHeight,BarFilledOffsets.TopLeft.Z)
                                local TopRightBar = CFrame.new(BarFilledOffsets.TopRight.X,BarFilledOffsets.BottomRight.Y + BarHeight,BarFilledOffsets.TopRight.Z)
                                local TopLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * TopLeftBar))
                                local TopRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * TopRightBar))
                                local BottomLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * BarFilledOffsets.BottomLeft))
                                local BottomRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * BarFilledOffsets.BottomRight))

                                FilledBoxPreset.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                FilledBoxPreset.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                FilledBoxPreset.PointA = Vector2.new(TopRight.X,TopLeft.Y)
                                FilledBoxPreset.PointD = Vector2.new(BottomRight.X,BottomLeft.Y)

                                FilledBoxPreset.Color = ReturnColorOnHp(HP)
                                OutlineBoxPreset.Visible = true
                                FilledBoxPreset.Visible = true
                            else
                                OutlineBoxPreset.Visible = false
                                FilledBoxPreset.Visible = false
                            end
                        else
                            OptionTable.ESPTextObjects.HpBarOutline.Visible = false
                            OptionTable.ESPTextObjects.HpBarFilled.Visible = false
                        end
                        



                        OptionTable.Data.RunAfterEverthing(OptionTable)
                        
                    else
                        VisibleText(false,OptionTable)
                    end
                    
                    -- Chams !!!!

                    if  OptionTable.Data.Highlight.UseChams == true and OptionTable.Data.Highlight.HighlightObj ~= nil and _G.AllowChamsEtho == true  then
                        
                        local HighlightObj = OptionTable.Data.Highlight.HighlightObj
                        local HighlightObj2 = OptionTable.Data.Highlight.HighlightObj2
                        local AdorneePart = OptionTable.Data.Highlight.ReturnPartFunction()
                        if HighlightObj ~= nil and AdorneePart ~= nil then
                            if ESPFunctionReturnTable:CheckBasePartValid(AdorneePart) == true and _G[OptionTable.GlobalVariableTable.ChamsToggle] == true then
                                local ChildrenCached = #AdorneePart:GetChildren()
                                if HighlightObj.Adornee ~= AdorneePart then
                                    OptionTable.Data.Highlight.LastKnownChildrenCache = ChildrenCached
                                    HighlightObj.Adornee = AdorneePart
                                end
                                if ChildrenCached ~= OptionTable.Data.Highlight.LastKnownChildrenCache and HighlightObj.Adornee == OptionTable.Data.Highlight.ReturnPartFunction() then
                                    OptionTable.Data.Highlight.LastKnownChildrenCache = ChildrenCached
                                    ESPFunctionReturnTable:RefreshHighlight(OptionTable,OptionTable.Data.Highlight.ReturnPartFunction())
                                end
                                HighlightObj.FillColor = _G[OptionTable.GlobalVariableTable.ChamsFillColor]
                                HighlightObj.OutlineColor = _G[OptionTable.GlobalVariableTable.ChamsOutlineColor]
                                HighlightObj.FillTransparency = _G[OptionTable.GlobalVariableTable.ChamsFillTrans]
                                HighlightObj.OutlineTransparency = _G[OptionTable.GlobalVariableTable.ChamsOutlineTrans]
                                HighlightObj.Enabled = true 

                                HighlightObj2.FillColor = _G[OptionTable.GlobalVariableTable.ChamsFillColor]
                                HighlightObj2.OutlineColor = _G[OptionTable.GlobalVariableTable.ChamsOutlineColor]
                                HighlightObj2.FillTransparency = _G[OptionTable.GlobalVariableTable.ChamsFillTrans]
                                HighlightObj2.OutlineTransparency = _G[OptionTable.GlobalVariableTable.ChamsOutlineTrans]
                                HighlightObj2.Enabled = false 
                            else
                                HighlightObj.Enabled = false
                                HighlightObj2.Enabled = false 
                            end
                        end
                    end
                    


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
            VisibleText(false,v)
        end
    end
end
ESPFunctionReturnTable:Toggle()



_G.PlayerESP = true
_G.PlayerTextSize = 30
_G.PlayerTextColor = Color3.fromRGB(255,255,255)
_G.PlayerDist = true
_G.ShowPlayerHealthPercent = false
_G.PlayerMaxDist = 200
_G.ShowPlayerHealth = true
_G.ScalePlayerText = true
_G.ShowChams = true
_G.ChamsFillColor = Color3.fromRGB(255,0,255)
_G.ChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.ChamsFill = 0
_G.ChamsOutlineTrans = 0
_G.ShowPlayerBox = true
_G.ShowHpBars = true

function AddPlayerESP(v)
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            ReturnPosFunc = function(PassedTable)
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    return v.Character.HumanoidRootPart.CFrame
                end 
                return nil
            end,
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
                        Line3Text = Line3Text..v.Name.." "
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
                return {Line1 = Line3Text,Line2 = Line2Text,Line3 = Line1Text}
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
                ReturnPartFunction = function(PassedTable)
                    return v.Character
                end
            },
            BoxESP = {
                UseBoxESP = true,
                OffsetTable = {
                    TopLeft = CFrame.new(-2,2,0),
                    TopRight = CFrame.new(2,2,0),
                    BottomLeft = CFrame.new(-2,-3.5,0),
                    BottomRight = CFrame.new(2,-3.5,0)
                }
            },
            HpBar = {
                UseHpBar = true,
                ReturnHPFunction = function(PassedTable)
                    if v and v.Character and v.Character.Humanoid then
                        return {Min = v.Character.Humanoid.Health,Max = v.Character.Humanoid.MaxHealth}
                    end
                end,
                BarOffsetTable = {
                    TopLeft = CFrame.new(3,2,0),
                    TopRight = CFrame.new(2,2,0),
                    BottomLeft = CFrame.new(3,-3.5,0),
                    BottomRight = CFrame.new(2,-3.5,0)

                }
            }
        },
        GlobalVariableTable = {
            TextToggle = "PlayerESP",
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
            ChamsOutlineTrans = "ChamsOutlineTrans",
            BoxToggle = "ShowPlayerBox",
            HpBarToggle = "ShowHpBars"


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