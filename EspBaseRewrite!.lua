-- ESP BASE REWRITE

print("gf")



--[[

    Shit to add

    REVERT TO OLD WAY OF DOING HP BARS, However use the new system of CFrame.Lookat, 
    Make Position Cached always Faced Upwards

]]
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
_G.EthoChamsDefaultESPMaxRenderDistance = 10000
_G.EthoChamsDefaultESPScaledText = true
_G.EthoChamsDefaultESPChamsToggle = false
_G.EthoChamsDefaultESPChamsFillColor = Color3.fromRGB(255,0,0)
_G.EthoChamsDefaultESPChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.EthoChamsDefaultESPChamsFillTrans = 1
_G.EthoChamsDefaultESPChamsOutlineTrans = 0
_G.EthoChamsDefaultESPBoxToggle = false
_G.EthoChamsDefaultESPHpBarToggle = false 
_G.EthoChamsDefaultESPWhitelistTable = {}
_G.EthoChamsDefaultESPWhitelistColor = Color3.fromRGB(255,0,0)
_G.EthoChamsDefaultESPLookAt = false 
_G.EthoChamsDefaultESPShowTeam = true

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
        return Color3.fromRGB(226, 228, 98)
    elseif HP <= 0.8 then
        return Color3.fromRGB(155, 173, 71)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end


function FindPlayer(name,OptionTable)
	for i,v in pairs(_G[OptionTable.GlobalVariableTable.WhitelistTable]) do 
		if name:lower():sub(1,#v) == v:lower() then	
			return true
		end
	end
    return false 
end

function SetTextOptions(OptionTable,TextTable,TextOffset)
    for i,v in pairs(TextTable) do
        local ChangeTo;
        local HoldSize = _G[OptionTable.GlobalVariableTable.TextSize]
        if _G[OptionTable.GlobalVariableTable.ScaledText] == true then
            ChangeTo = HoldSize - (TextOffset * 2)
            if ChangeTo < (HoldSize / 2) then 
                ChangeTo = (HoldSize / 2)
            end
        else
            ChangeTo = HoldSize
        end 
        if i == "Text1" or i == "Text2" or i == "Text3" then     
            v.Size = ChangeTo 
        end  

        if OptionTable.Data.UseWhitelist.UseWhitelist == true and i ~= "HoBarFilled" then
            local name = OptionTable.Data.UseWhitelist.ReturnNameFunction(OptionTable)  
            if name and FindPlayer(name,OptionTable) == true  then
                v.Color = _G[OptionTable.GlobalVariableTable.WhitelistColor] 
            else
                
                v.Color = _G[OptionTable.GlobalVariableTable.TextColor]

            end
        else
           
            v.Color = _G[OptionTable.GlobalVariableTable.TextColor]

        end
    end   
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
    
    if TextTable.Data.Highlight ~= nil and TextTable.Data.Highlight.HighlightObj ~= nil and _G.AllowChamsEtho == true  then
        TextTable.Data.Highlight.HighlightObj.Enabled = Bool
    end
end

function ESPFunctionReturnTable:RefreshHighlight(PassedTable,PartToAdornee)
    if PassedTable.Data.Highlight.Refreshing == false then
        local function RefreshThingy()
            PassedTable.Data.Highlight.Refreshing = true 
            local HighlightObj = PassedTable.Data.Highlight.HighlightObj
            local HighlightObj2 = PassedTable.Data.Highlight.HighlightObj2
            HighlightObj2.Adornee = PartToAdornee
            wait()
            HighlightObj.Adornee = nil
            wait()
            HighlightObj.Adornee = PartToAdornee
            wait()
            HighlightObj2.Adornee = nil
            wait()
            PassedTable.Data.Highlight.Refreshing = false 
        end
        
        
        coroutine.wrap(RefreshThingy)()
        
    end
end
function CFtoVec(cf)
    if cf and cf.x and cf.y and cf.z then
            return Vector3.new(cf.x,cf.y,cf.z)
    end

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
        error("AddESPObj Function, OptionTable.Data.CalcStringFunction, Make sure it returns {Line1 = '', Line2 = '', Line3 = ''}")
        return   
    elseif OptionTable.Data.DeterminToRemoveFunction == nil then
        error("AddESPObj Function, OptionTable.Data.DeterminToRemoveFunction, Make sure it returns true if part is == nil! ")    
    elseif OptionTable.Data.ReturnLocalPlayerpos == nil then
        error("AddESPObj Function, OptionTable.Data.ReturnLocalPlayerpos, aa6")   
    elseif OptionTable.Data.ReturnTeamCheck == nil then
        error("AddESPObj Function, ReturnTeamCheck == nil, aa7") 
    end
    OptionTable.Data.ModdedName = OptionTable.Data.ModdedName or ""
    OptionTable.Data.TextOffset = OptionTable.Data.TextOffset or 0
    OptionTable.Data.Vector3Offset = OptionTable.Data.Vector3Offset or Vector3.new(0,0,0)
    OptionTable.ToBeRemoved = OptionTable.ToBeRemoved or false
    
    local GlobalVariablePreset = OptionTable.GlobalVariableTable
    if GlobalVariablePreset == nil then
        error("AddESPObj Function, GlobalVariableTable == nil, ab1")
        return
    end
    GlobalVariablePreset.TextToggle = GlobalVariablePreset.TextToggle or "EthoChamsDefaultESPToggle"
    GlobalVariablePreset.TextSize = GlobalVariablePreset.TextSize or "EthoChamsDefaultESPTextSize"
    GlobalVariablePreset.TextColor = GlobalVariablePreset.TextColor or "EthoChamsDefaultESPTextColor"
    GlobalVariablePreset.MaxRenderDistance = GlobalVariablePreset.MaxRenderDistance or "EthoChamsDefaultESPMaxRenderDistance"
    GlobalVariablePreset.ScaledText = GlobalVariablePreset.ScaledText or "EthoChamsDefaultESPScaledText"
    GlobalVariablePreset.ChamsToggle = GlobalVariablePreset.ChamsToggle or "EthoChamsDefaultESPChamsToggle"
    GlobalVariablePreset.ChamsFillColor = GlobalVariablePreset.ChamsFillColor or "EthoChamsDefaultESPChamsFillColor"
    GlobalVariablePreset.ChamsOutlineColor = GlobalVariablePreset.ChamsOutlineColor or "EthoChamsDefaultESPChamsOutlineColor"
    GlobalVariablePreset.ChamsFillTrans = GlobalVariablePreset.ChamsFillTrans or "EthoChamsDefaultESPChamsFillTrans"
    GlobalVariablePreset.ChamsOutlineTrans = GlobalVariablePreset.ChamsFillTrans or "EthoChamsDefaultESPChamsOutlineTrans"
    GlobalVariablePreset.BoxToggle = GlobalVariablePreset.BoxToggle or "EthoChamsDefaultESPBoxToggle"
    GlobalVariablePreset.HpBarToggle = GlobalVariablePreset.HpBarToggle or "EthoChamsDefaultESPHpBarToggle"
    GlobalVariablePreset.WhitelistTable = GlobalVariablePreset.WhitelistTable or "EthoChamsDefaultESPWhitelistTable"
    GlobalVariablePreset.WhitelistColor = GlobalVariablePreset.WhitelistColor or "EthoChamsDefaultESPWhitelistColor"
    GlobalVariablePreset.UseTwoD = GlobalVariablePreset.UseTwoD or "EthoChamsDefaultESPUseTwoD"
    GlobalVariablePreset.UseLookAt = GlobalVariablePreset.UseLookAt or "EthoChamsDefaultESPLookAt"
    GlobalVariablePreset.ShowTeam = GlobalVariablePreset.ShowTeam or "EthoChamsDefaultESPShowTeam"
    
    OptionTable.Data.BaseZIndex = OptionTable.Data.BaseZIndex or 1 
    OptionTable.Data.BoxESP = OptionTable.Data.BoxESP or {UseBoxESP = false}
    if OptionTable.Data.BoxESP.UseBoxESP == true then
        if OptionTable.Data.BoxESP.OffsetTable == nil then
            error("Add ESp OBj function, OptionTable.Data.BoxESP.OffsetTable == nil Example : TopLeft = CFrame.new(-2,2,0),TopRight = CFrame.new(2,2,0),BottomLeft = CFrame.new(-2,-3.5,0),BottomRight = CFrame.new(2,-3.5,0)")
        elseif OptionTable.Data.BoxESP.ThreeDOffsetTable == nil then
            error("Add ESp OBj function, OptionTable.Data.BoxESP.ThreeDOffsetTable == nil Example: ForwardLeft = CFrame.new(-2,2,-2),ForwardRight = CFrame.new(2,2,-2),BackwardLeft = CFrame.new(-2,2,2),BackwardRight = CFrame.new(2,2,2),Height = 5")
        end
    end
    
    OptionTable.Data.HpBar = OptionTable.Data.HpBar or {UseHpBar = false}
    if OptionTable.Data.HpBar.BarOffsetTable == nil and OptionTable.Data.HpBar.UseHpBar == true  then
        error("Add ESP OBj Function, OptionTable.Data.HpBar.BarOffsetTable == nil")
    end
    OptionTable.Data.UseWhitelist = OptionTable.Data.UseWhitelist or {UseWhitelist = false, ReturnNameFunction = function() return nil end}
    if OptionTable.Data.UseWhitelist.ReturnNameFunction == nil and OptionTable.Data.UseWhitelist.UseWhitelist == true  then
        error ("Add ESP OBj function, Optiontable.Data.UseWhitelist.ReturnNameFunction == nil, Make sure it returns a string!")

    end

    OptionTable.Data.ReturnTeamCheck = OptionTable.Data.ReturnTeamCheck or function() return false end 
    OptionTable.Data.TextOffset = OptionTable.Data.TextOffset or 0
    OptionTable.Data.Vector3Offset = OptionTable.Data.Vector3Offset or Vector3.new(0,0,0)

    if _G.AllowChamsEtho == true and ChamsFolder ~= nil  and OptionTable.Data.Highlight.UseChams == true then

        local Highlight = Instance.new("Highlight",ChamsFolder)
        local Highlight2 = Instance.new("Highlight",ChamsFolder)
        OptionTable.Data.Highlight.HighlightObj = Highlight
        OptionTable.Data.Highlight.HighlightObj2 = Highlight2
        OptionTable.Data.Highlight.LastKnownChildrenCache = -2
        OptionTable.Data.Highlight.Refreshing = false
        if OptionTable.Data.Highlight.ReturnPartFunction == nil then
           error("AddESPObj Function - Highlight Portion, Return Part Function == nil, ac1") 
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

    local ForwardQuadPreset = Drawing.new("Quad")
    local LeftQuadPreset = Drawing.new("Quad")
    local BackwardQuadPreset = Drawing.new("Quad")
    local RightQuadPreset = Drawing.new("Quad")
    ForwardQuadPreset.Thickness = 2
    LeftQuadPreset.Thickness = 2 
    BackwardQuadPreset.Thickness = 2
    RightQuadPreset.Thickness = 2 

    ESPPresetBox.Thickness = 1 
    OptionTable.ESPTextObjects = {Text1 =ESPPresetText1,Text2 = ESPPresetText2,Text3 = ESPPresetText3,BoxObj = ESPPresetBox, HpBarOutline = HpBarOutlineBox,HpBarFilled = HpBarFilledBox,ForwardQuad = ForwardQuadPreset,LeftQuad = LeftQuadPreset, BackwardQuad = BackwardQuadPreset,RightQuad = RightQuadPreset}

    for i,v in pairs(OptionTable.ESPTextObjects) do
         if OptionTable.Data.UseWhitelist.UseWhitelist == true and i ~= "HoBarFilled" then
            local name = OptionTable.Data.UseWhitelist.ReturnNameFunction(OptionTable)  
            if name and FindPlayer(name,OptionTable) == true  then
                v.ZIndex =  OptionTable.Data.BaseZIndex + 100000
            end
        else
            v.ZIndex =  OptionTable.Data.BaseZIndex
        end
    end
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
   
            local LocalPlayerPositionCached = OptionTable.Data.ReturnLocalPlayerpos(OptionTable)
            local TeamChecked = OptionTable.Data.ReturnTeamCheck(OptionTable)
            if _G[OptionTable.GlobalVariableTable.ShowTeam] == true  or _G[OptionTable.GlobalVariableTable.ShowTeam] == false and TeamChecked == false  then
                if PositionCached ~= nil  and DrawESP == true and LocalPlayerPositionCached ~= nil and game.Workspace.CurrentCamera ~= nil   then
                    
                    local MagnitudeCached = ESPFunctionReturnTable:GetMagnitude(LocalPlayerPositionCached,CFtoVec(PositionCached))
                    if MagnitudeCached ~= nil and MagnitudeCached < _G[OptionTable.GlobalVariableTable.MaxRenderDistance]  then
                        local cam = game.Workspace.CurrentCamera
                        local ScreenPos,OnS = cam:WorldToViewportPoint(CFtoVec(PositionCached) + OptionTable.Data.Vector3Offset)
                        if OnS then
                            local TextTable = OptionTable.ESPTextObjects
                            local StringCached = OptionTable.Data.CalcStringFunction(OptionTable)
                            
                            local TextOffset = MagnitudeCached / 500
                            local TextSizeOffset = math.floor(MagnitudeCached / 150)
                            TextOffset = TextOffset
                            if TextOffset < 0 then TextOffset = 0 end
                            SetTextOptions(OptionTable,TextTable,TextSizeOffset)
                            
                            if _G[OptionTable.GlobalVariableTable.TextToggle] == true then
                                --Settings texts for the lines!!!
    
                                StringCached.Line1 = StringCached.Line1 or ""
                                StringCached.Line2 = StringCached.Line2 or ""
                                StringCached.Line2 = StringCached.Line2 or ""
    
                                TextTable.Text1.Text = StringCached.Line1
                                TextTable.Text2.Text = StringCached.Line2
                                TextTable.Text3.Text = StringCached.Line3
    
                                -- Settings positions of text objects 
                              
                                local Text1OffsetX = (TextTable.Text1.TextBounds.X / 2)
                                local Text2OffsetX = (TextTable.Text2.TextBounds.X / 2)
                                local PositionX = math.floor(ScreenPos.X) - Text1OffsetX
                                
                                local Text1OffsetY = (TextTable.Text1.TextBounds.Y / 2)
                                local Text2OffsetY = (TextTable.Text2.TextBounds.Y / 2 )
                                local LineOffset = 2
    local PositionY = math.floor(ScreenPos.Y) - TextOffset
    
                                if TextTable.Text1.Text == "" then
                                    TextTable.Text1.Position = Vector2.new(PositionX,((PositionY) - OptionTable.Data.TextOffset) + Text1OffsetY)
                                else
                                    TextTable.Text1.Position = Vector2.new(PositionX,(PositionY) - OptionTable.Data.TextOffset)
                                end
                                if TextTable.Text2.Text == "" then
                                    TextTable.Text2.Position = Vector2.new(PositionX ,((PositionY) - OptionTable.Data.TextOffset) + Text1OffsetY)
                                else
                                    TextTable.Text2.Position = Vector2.new(PositionX - Text2OffsetX,(TextTable.Text1.Position.Y - LineOffset -( Text1OffsetY)))
                                end
                                
                                TextTable.Text3.Position = Vector2.new(PositionX - (TextTable.Text3.TextBounds.X / 2),(TextTable.Text2.Position.Y - LineOffset - Text2OffsetY) )
    
                                TextTable.Text1.Visible = true 
                                TextTable.Text2.Visible = true
                                TextTable.Text3.Visible = true 
    
                                -- Changes Text Options / Makes Offsets!
                                
                            else
                                TextTable.Text1.Visible = false 
                                TextTable.Text2.Visible = false
                                TextTable.Text3.Visible = false 
                            end
                            
    
                            
    
                            -- Box ESP !!!
    
                            if OptionTable.Data.BoxESP.UseBoxESP == true then
                                local LookedAtPosition = CFrame.lookAt(CFtoVec(PositionCached),CFtoVec(game.Workspace.CurrentCamera.CFrame))
                                local BoxESPPreset = OptionTable.Data.BoxESP
                                local BoxEspObj = OptionTable.ESPTextObjects.BoxObj
                                local ForwardQuad = OptionTable.ESPTextObjects.ForwardQuad
                                local LeftsideQuad = OptionTable.ESPTextObjects.LeftQuad
                                local BackwardQuad = OptionTable.ESPTextObjects.BackwardQuad
                                local RightsideQuad = OptionTable.ESPTextObjects.RightQuad
    
                                if BoxESPPreset ~= nil then
                                    if _G[OptionTable.GlobalVariableTable.UseTwoD] == true then
                                        if _G[OptionTable.GlobalVariableTable.BoxToggle] == true then  
                                            ForwardQuad.Visible = false
                                            LeftsideQuad.Visible = false
                                            BackwardQuad.Visible = false
                                            RightsideQuad.Visible = false 
                                            local TwoDBoxCachedPos = PositionCached
                                            if _G[OptionTable.GlobalVariableTable.UseLookAt] == true and LookedAtPosition ~= nil then
                                                TwoDBoxCachedPos = LookedAtPosition
                                            end
    
                                            local OffsetTable = BoxESPPreset.OffsetTable
                                            local TopLeft = cam:WorldToViewportPoint(CFtoVec(TwoDBoxCachedPos * OffsetTable.TopLeft))
                                            local TopRight = cam:WorldToViewportPoint(CFtoVec(TwoDBoxCachedPos * OffsetTable.TopRight))
                                            local BottomLeft = cam:WorldToViewportPoint(CFtoVec(TwoDBoxCachedPos * OffsetTable.BottomLeft))
                                            local BottomRight = cam:WorldToViewportPoint(CFtoVec(TwoDBoxCachedPos * OffsetTable.BottomRight))
                                            
                                            BoxEspObj.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                            BoxEspObj.PointA = Vector2.new(TopRight.X,TopRight.Y)
                                            BoxEspObj.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                            BoxEspObj.PointD = Vector2.new(BottomRight.X,BottomRight.Y)
            
                                            BoxEspObj.Visible = true 
        
                                        else
                                            BoxEspObj.Visible = false
                                            ForwardQuad.Visible = false
                                            LeftsideQuad.Visible = false
                                            BackwardQuad.Visible = false
                                            RightsideQuad.Visible = false 
                                        end
                                    elseif _G[OptionTable.GlobalVariableTable.UseTwoD] == false then
                                        if _G[OptionTable.GlobalVariableTable.BoxToggle] == true then
                                            BoxEspObj.Visible = false 
                                            local Corneroffsets = BoxESPPreset.ThreeDOffsetTable
                                            local ForwardLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.ForwardLeft))
                                            local ForwardRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.ForwardRight))
                                            local BackwardLeft = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.BackwardLeft))
                                            local BackwardRight = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.BackwardRight))
                                    
                                            local ForwardLeftBottom = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.ForwardLeft) - Vector3.new(0,Corneroffsets.Height,0))
                                            local ForwardRightBottom = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.ForwardRight) - Vector3.new(0,Corneroffsets.Height,0))
                                            local BackwardLeftBottom = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.BackwardLeft) - Vector3.new(0,Corneroffsets.Height,0))
                                            local BackwardRightBottom = cam:WorldToViewportPoint(CFtoVec(PositionCached * Corneroffsets.BackwardRight) - Vector3.new(0,Corneroffsets.Height,0))
                                    
                                            ForwardQuad.PointA = Vector2.new(ForwardRight.X,ForwardRight.Y)
                                            ForwardQuad.PointB = Vector2.new(ForwardLeft.X,ForwardLeft.Y)
                                            ForwardQuad.PointD = Vector2.new(ForwardRightBottom.X,ForwardRightBottom.Y)
                                            ForwardQuad.PointC = Vector2.new(ForwardLeftBottom.X,ForwardLeftBottom.Y)
                                    
                                            LeftsideQuad.PointA = Vector2.new(ForwardLeft.X,ForwardLeft.Y)
                                            LeftsideQuad.PointB = Vector2.new(ForwardLeftBottom.X,ForwardLeftBottom.Y)
                                            LeftsideQuad.PointD = Vector2.new(BackwardLeft.X,BackwardLeft.Y)
                                            LeftsideQuad.PointC = Vector2.new(BackwardLeftBottom.X,BackwardLeftBottom.Y)
                                    
                                            BackwardQuad.PointA = Vector2.new(BackwardRight.X,BackwardRight.Y)
                                            BackwardQuad.PointB = Vector2.new(BackwardRightBottom.X,BackwardRightBottom.Y)
                                            BackwardQuad.PointD = Vector2.new(BackwardLeft.X,BackwardLeft.Y)
                                            BackwardQuad.PointC = Vector2.new(BackwardLeftBottom.X,BackwardLeftBottom.Y)
                                    
                                            RightsideQuad.PointA = Vector2.new(ForwardRight.X,ForwardRight.Y)
                                            RightsideQuad.PointB = Vector2.new(ForwardRightBottom.X,ForwardRightBottom.Y)
                                            RightsideQuad.PointD = Vector2.new(BackwardRight.X,BackwardRight.Y)
                                            RightsideQuad.PointC = Vector2.new(BackwardRightBottom.X,BackwardRightBottom.Y) 
                                            ForwardQuad.Visible = true
                                            LeftsideQuad.Visible = true
                                            BackwardQuad.Visible = true
                                            RightsideQuad.Visible = true 
                                        else
                                            BoxEspObj.Visible = false 
                                            ForwardQuad.Visible = false
                                            LeftsideQuad.Visible = false
                                            BackwardQuad.Visible = false
                                            RightsideQuad.Visible = false 
                                        end
    
                                    end
                                    
                                end
                            end
    
                            if OptionTable.Data.HpBar.UseHpBar == true and _G[OptionTable.GlobalVariableTable.HpBarToggle] == true then
                                local LookedAtPosition = CFrame.lookAt(CFtoVec(PositionCached),CFtoVec(game.Workspace.CurrentCamera.CFrame))
                                local HpBarPreset = OptionTable.Data.HpBar
                                local BarOffsetTable = HpBarPreset.BarOffsetTable
                                local OutlineBoxPreset = OptionTable.ESPTextObjects.HpBarOutline
                                local FilledBoxPreset = OptionTable.ESPTextObjects.HpBarFilled
                                local HpCached = HpBarPreset.ReturnHPFunction(OptionTable)
                                if HpCached ~= nil and LookedAtPosition ~= nil then
                                    local HP = HpCached.Min / HpCached.Max
                                    local scale_factor = 1 / (ScreenPos.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
                                    local Widthinset = 0.25
                                    local Heightinset = 0.25
                                    local BarFilledOffsets = {
                                        TopLeft = CFrame.new(BarOffsetTable.TopLeft.X - Widthinset,BarOffsetTable.TopLeft.Y - Heightinset,0),
                                        TopRight = CFrame.new(BarOffsetTable.TopRight.X + Widthinset,BarOffsetTable.TopRight.Y + Heightinset,0),
                                        BottomLeft = CFrame.new(BarOffsetTable.BottomLeft.X - Widthinset,BarOffsetTable.BottomLeft.Y + Heightinset,0),
                                        BottomRight = CFrame.new(BarOffsetTable.BottomRight.X + Widthinset,BarOffsetTable.BottomRight.Y + Heightinset,0)
                                    }
                                    -- Outline for HpBar
                                    local TopLeft = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarOffsetTable.TopLeft))
                                    local TopRight = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarOffsetTable.TopRight))
                                    local BottomLeft = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarOffsetTable.BottomLeft))
                                    local BottomRight =cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarOffsetTable.BottomRight))

                                    OutlineBoxPreset.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                    OutlineBoxPreset.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                    OutlineBoxPreset.PointA = Vector2.new(TopRight.X,TopLeft.Y)
                                    OutlineBoxPreset.PointD = Vector2.new(BottomRight.X,BottomLeft.Y)
                                    -- HpBar Part

                                    local BarSizeInVec = (BarFilledOffsets.TopLeft.Y - BarFilledOffsets.BottomLeft.Y) 
                                    local BarHeight = BarSizeInVec * HP

                                    local TopLeftBar = CFrame.new(BarFilledOffsets.TopLeft.X,BarFilledOffsets.BottomLeft.Y + BarHeight,BarFilledOffsets.TopLeft.Z)
                                    local TopRightBar = CFrame.new(BarFilledOffsets.TopRight.X,BarFilledOffsets.BottomRight.Y + BarHeight,BarFilledOffsets.TopRight.Z)
                                    local TopLeft = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * TopLeftBar))
                                    local TopRight = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * TopRightBar))
                                    local BottomLeft = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarFilledOffsets.BottomLeft))
                                    local BottomRight = cam:WorldToViewportPoint(CFtoVec(LookedAtPosition * BarFilledOffsets.BottomRight))

                                    FilledBoxPreset.PointB = Vector2.new(TopLeft.X,TopLeft.Y)
                                    FilledBoxPreset.PointC = Vector2.new(BottomLeft.X,BottomLeft.Y)
                                    FilledBoxPreset.PointA = Vector2.new(TopRight.X,TopLeft.Y)
                                    FilledBoxPreset.PointD = Vector2.new(BottomRight.X,BottomLeft.Y)

                                    
                                    OutlineBoxPreset.Visible = true
                                    FilledBoxPreset.Visible = true
    
    
                                    FilledBoxPreset.Color = ReturnColorOnHp(HP)
    
                                    FilledBoxPreset.ZIndex = FilledBoxPreset.ZIndex  + 1 
                                    OutlineBoxPreset.ZIndex = OutlineBoxPreset.ZIndex + 2
                                    FilledBoxPreset.Visible = true 
                                    OutlineBoxPreset.Visible = true 
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

return ESPFunctionReturnTable