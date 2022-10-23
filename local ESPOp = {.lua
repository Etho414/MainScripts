local ESPOp = {
    Use2dBox = true

}
local 2DColorTable = {
    Ally = Color3.fromRGB(1,1,1)


}
local 2DBoxConnections = {}
local 2DBoxTable = {}


function Add2DBoxToChar(v,bool)
    if bool == false then
        for i,v in pairs(2DBoxConnections) do
            v:Disconnect()
        end
        for i,v in pairs(2DBoxTable) do
            v:Destroy()
        end
        return
    end
    
    local 2DBoxObj = Quad.new()
    2DBoxObj.Thickness = 1.5
    2DBoxTable[#2DBoxTable + 1] = 2DBoxObj
    2DBoxObj.Color = 2DColorTable.Ally
    local function Vec3toVec2(pos)
        local cam = game.Workspace.CurrentCamera
        local posy = cam:WorldToViewportPoint(pos)
        return Vector2.new(posy.x,posy.Y )
    end
    2DBoxConnections[#2DBoxConnections + 1] = game:GetService("RunService").RenderStepped:connect(function()
        if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild('Head') then
            local _,Ons = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart)
            if Ons and ESPOp.Use2dBox == true then
                local TopLeft =  (v.Character.Head.Position + Vector3.new(0,(v.Character.Head.Size.Y / 2),0)) + (Vector3.new(v.Character.HumanoidRootPart.Size.X,0,0))
                local TopRight =  (v.Character.Head.Position - Vector3.new(0,(v.Character.Head.Size.Y / 2),0)) - (Vector3.new(v.Character.HumanoidRootPart.Size.X,0,0))
                local BottomLeft = TopLeft - Vector3.new(0,v.Character.Head.Size.Y + (v.Character.HumanoidRootPart.Size.Y * 2),0)
                local BottomRight = TopRight - Vector3.new(0,v.Character.Head.Size.Y + (v.Character.HumanoidRootPart.Size.Y * 2),0)

                Quad.PointA = Vec3toVec2(TopLeft)
                Quad.PointB = Vec3toVec2(TopRight)
                Quad.PointC = Vec3toVec2(BottomLeft)
                Quad.PointD = Vec3toVec2(BottomRight)

            end


        else
            2DBoxObj.Visible = false

            
        end

    end)


end