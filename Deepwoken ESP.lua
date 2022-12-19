local player = game.Players.LocalPlayer
local EspListenTable = {}
local cam = game.Workspace.CurrentCamera
local RunESP = false

--[[

_G.TextSize = 30
_G.MobTextSize = 20
_G.DisplayHp = true
_G.MobESPDist = 5000
_G.PlayerESPDist = 10000
_G.ShowTalentAmount = true
_G.ShowDistance = true
_G.ToggleKey = "T" -- Make sure its capital!!!!

_G.PlayerESPColor = Color3.fromRGB(0,0,0)
_G.MobESPColor = Color3.fromRGB(255,255,255)




]]

function round(n)
    return math.floor(n)
end

function CheckMag(PositionToCheck)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return (player.Character.HumanoidRootPart.Position - PositionToCheck).Magnitude

    end
end

function CheckTalentAmount(ToCheckPlayer)
    if ToCheckPlayer:FindFirstChild("Backpack") then
        local talentamount = 0
        for i,v in pairs(ToCheckPlayer.Backpack:GetChildren()) do
            if v.Name:match("Talent") then
                talentamount = talentamount + 1
            end
        end
        return talentamount
    end
    return false

end






function AddESPObj(PosType,CharaName,HpValTable,IsPlayer)
    if not PosType or type(PosType) ~= "table" then
        warn("PosType is not set")
        return
    end

    CharaName = CharaName or "Dumby forgot a name..."
    HpValTable = HpValTable or {Type = "None",Min = 0,Max = 0}
    IsPlayer = IsPlayer or false
    local ESPText = Drawing.new("Text")
    EspListenTable[#EspListenTable + 1 ] = {PosType = PosType,Text = ESPText, Name = CharaName, HpType = HpValTable,IsPlayer = IsPlayer}
end

function CalcString(OptTable)
    local basestring = ""
    if _G.DisplayHp == true then
        basestring = "["
        if string.upper(OptTable.HpType.Type) == "HUMANOID" and OptTable.HpType.HumanoidPath ~= false then
            local huma = OptTable.HpType.HumanoidPath

            basestring = basestring..tostring(round(huma.Health)).."/"..tostring(huma.MaxHealth).."] "
        elseif string.upper(OptTable.HpType.Type) == "NONE" then
            basestring = ""
        elseif string.upper(OptTable.HpType.Type) == "CUSTOM" then
            basestring = basestring..tostring(round(OptTable.HpType.MinHP.Value)).."/"..tostring(OptTable.HpType.MaxHp.Value).."] "

        end
    end
    basestring = basestring..OptTable.Name
    if OptTable.IsPlayer == true then
        if _G.ShowTalentAmount == true then
            if game.Players:FindFirstChild(OptTable.Name) then
                basestring = basestring.." Talents: "..tostring(CheckTalentAmount(game.Players:FindFirstChild(OptTable.Name)))
            else
                basestring = basestring.. " Nil Talent"
            end
           
        end
        if _G.ShowDistance == true then
            basestring = basestring.." ["..tostring(round(CheckMag(OptTable.PosType.Part.Position))).."]"
        end
    end
    return basestring
end

function CheckPartValid(chara)
    if chara.Parent ~= nil then return true else return false end
end

function EspListener()
    for i,v in pairs(EspListenTable) do
        if v.PosType.Type == "Part" and CheckPartValid(v.PosType.Part) == false then
            v.Text:Remove()
            table.remove(EspListenTable,i)
        elseif v.PosType.Type == "DeepWoken" and v.PosType.Model == nil or v.PosType.Type == "DeepWoken" == nil and  v.PosType.Model.Parent then
            v.Text:Remove()
            table.remove(EspListenTable,i)

        else
            if v.PosType.Type == "Part" then
                if CheckMag(v.PosType.Part.Position) < _G.PlayerESPDist then
                    local CharPos,OnS = cam:WorldToViewportPoint(v.PosType.Part.Position)
                    local TextOBJ = v.Text
                    TextOBJ.Visible = OnS
                    if OnS == true then
                        TextOBJ.Text = CalcString(v)
                        local offset = CheckMag(v.PosType.Part.Position) / 500
                        if offset < 0 then offset = 0 end
                        TextOBJ.Position = Vector2.new(CharPos.X - (TextOBJ.TextBounds.X/2),CharPos.Y - offset)
                        TextOBJ.Size = _G.TextSize
                        TextOBJ.ZIndex = 1
                        TextOBJ.Color = _G.PlayerESPColor
                    end
                end

               
            elseif v.PosType.Type == "DeepWoken" then
                
                local CharPos,OnS;
                if v.PosType.Model:FindFirstChild("HumanoidRootPart") then
                    if CheckMag(v.PosType.Model.HumanoidRootPart.Position) < _G.MobESPDist then
                        CharPos,OnS = cam:WorldToViewportPoint(v.PosType.Model.HumanoidRootPart.Position)
                    else
                        OnS = false
                    end
                elseif v.PosType.Model:FindFirstChild("SpawnCF") then
                    local cf = v.PosType.Model.SpawnCF.Value
                    if CheckMag(Vector3.new(cf.X,cf.Y,cf.Z)) < _G.MobESPDist then
                        CharPos,OnS = cam:WorldToViewportPoint(Vector3.new(cf.X,cf.Y,cf.Z))
                    else
                        OnS = false
                    end
                end
                local TextOBJ = v.Text
                OnS = OnS or false
                TextOBJ.Visible = OnS
                if OnS == true then
                    TextOBJ.Text = CalcString(v)
                    TextOBJ.Position = Vector2.new(CharPos.X - (TextOBJ.TextBounds.X/2),CharPos.Y)
                    TextOBJ.Size = _G.MobTextSize
                    TextOBJ.Color = _G.MobESPColor
                    TextOBJ.ZIndex = 20
                end

            
            
            end
          
           
            
        
        end

    end
end

local LoopServ;
function EspToggle()
    if RunESP == true then
        RunESP = false
        for i,v in pairs(EspListenTable) do
            v.Text.Visible = false
        end
        LoopServ:Disconnect()
    else
        RunESP = true
        LoopServ = game:GetService("RunService").RenderStepped:connect(EspListener)
    end
end
EspToggle()


local RetryTable = {}
function AddPlayerToESP(v)
    if not v.Character or not v.Character:FindFirstChild("Humanoid") or not v.Character:FindFirstChild("HumanoidRootPart") then
        RetryTable[#RetryTable + 1] = v
        return
    end
    local HpValTable = {
        Type = "Humanoid",
        HumanoidPath = v.Character.Humanoid
    }
    local PosTypeTable = {
        Type = "Part",
        Part = v.Character.HumanoidRootPart

    }
    AddESPObj(PosTypeTable,v.Name,HpValTable,true)
end

local PlayerConnectionsTable = {}

for i,v in pairs(game.Players:GetChildren()) do
    AddPlayerToESP(v)
    PlayerConnectionsTable[v.Name] = v.CharacterAdded:connect(function(v)
        AddPlayerToESP(game.Players[v.Name])
    end)

end

game.Players.PlayerAdded:connect(function(v)
    PlayerConnectionsTable[v.Name] = v.CharacterAdded:connect(function(v)
        AddPlayerToESP(game.Players[v.Name])
    end)
    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        AddPlayerToESP(v)
    end
end)

game.Players.PlayerRemoving:connect(function(v)
    PlayerConnectionsTable[v.Name]:Disconnect()
end)




function CheckRetryTable()
    while wait() do
        for i,v in pairs(RetryTable) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                if CheckPartValid(v.Character.HumanoidRootPart) == false then
                    table.remove(RetryTable,i)
                    return
                end
    
                if v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    AddPlayerToESP(v)
                    table.remove(RetryTable,i)
                end
            end
        end
    end
end
coroutine.wrap(CheckRetryTable)()





-- Deepwoken MOB ESP!!! :)))) :DDDD :))))))


function CheckMob(v)
    if not game.Players:FindFirstChild(v.Name) then
        return true
    end
end








local MobRetryTable = {}
function AddMobToESP(v)
    if not v:IsA("Model") then return end

    if v and v:FindFirstChild("Humanoid") and CheckMob(v) == true  then
        local HpValTable = {
            Type = "Humanoid",
            HumanoidPath = v.Humanoid
        }
        local PosTypeTable = {
            Type = "DeepWoken",
            Model = v
        }
        AddESPObj(PosTypeTable,v:GetAttribute("MOB_rich_name"),HpValTable)
    else
        MobRetryTable[#MobRetryTable + 1] = v

    end
end

function MobRetryFunction()
    while wait() do
        local RemovedVal = false
        for i,v in pairs(MobRetryTable) do
            if v and v:FindFirstChild("Humanoid") and RemovedVal == false then
                AddMobToESP(v)
                table.remove(MobRetryTable,i)
                RemovedVal = true
            end
        end

    end
end

coroutine.wrap(MobRetryFunction)()





for i,v in pairs(workspace.Live:GetChildren()) do
    AddMobToESP(v)
end
workspace.Live.ChildAdded:connect(function(v)
    AddMobToESP(v)
end)










game:GetService("UserInputService").InputBegan:connect(function(key,gpe)
    if gpe then return end
    if key.KeyCode == Enum.KeyCode[_G.ToggleKey] then
        EspToggle()
    end

end)
