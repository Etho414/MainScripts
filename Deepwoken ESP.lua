--[[

--ESP Options


--Player ESP Settings
_G.DisplayHp = true -- Display players HP
_G.ShowTalentAmount = true -- Show how many talents the player has
_G.ShowPlayerDist = true -- Shows how far away the PLAYER is in units (In the [] Brackets)
_G.PlayerESPDist = 10000 -- How many units away until ESP Stops to render
_G.PlayerESPColor = Color3.fromRGB(0,0,0) -- Color of the PLAYER ESP (In RGB)
_G.TextSize = 30 -- Player ESP Text Size 


--Mob ESP Settings
_G.ShowMobDist = true -- Shows how far away the MOB is in units (In the [] Brackets)
_G.MobESPDist = 5000 -- How many units away until ESP Stops to render
_G.MobESPColor = Color3.fromRGB(255,255,255) -- Color of the MOB ESP (In RGB)
_G.MobTextSize = 20 -- Mob ESP Text Size


--KeyBinds (Make sure its Capital, Change to "" for no keybind!)
_G.ToggleKey = "T" -- Bind for Toggeling ESP
_G.InstantLogButton = "L" -- Bind for Instant logging (Will NOT bypass combat tag)

--Other ESP Settings (NPC, OWLS, ARTIFACTS)
_G.OtherESPDist = 100000
_G.ShowOtherDist = true

_G.ShowPosture = true -- Shows posture % of enemies (Works on mobs!!!!)
_G.ShowEther = true -- Shows ether % of enemies (Mobs dont have ether..)

_G.ShowPlayer = true -- Shows plays on ESP (Defaults to true)
_G.ShowMOB = true -- Shows mobs on ESP (defaults to true)
_G.ShowNPC = false -- Shows NPC's on ESP (Defaults to false)
_G.ShowOwlSpawns = true -- Shows Owl Event locations on ESP (Defaults to true)
_G.ShowUnloadedMobs = true -- Determines whether to show MOB's (Not Owls) which are not loaded in or not (Defaults to true) Recommended to leave set to true
_G.ShowOwlNotifications = true -- Shows a notification on the left side of the screen if a OWL has spawned
_G.NotificationTime = 5 -- How long a notification would stay up for (In seconds)



-- Debug mode!!!
_G.DebugMode = false

loadstring(game:HttpGet("https://raw.githubusercontent.com/Etho414/MainScripts/main/MainLoader", true))()

]]
_G.ShowOwlSpawns = true
_G.DisplayHp = _G.DisplayHp or true 
_G.ShowTalentAmount = _G.ShowTalentAmount or true 
_G.ShowPlayerDist = _G.ShowPlayerDist or true 
_G.PlayerESPDist = _G.PlayerESPDist or 60000
_G.PlayerESPColor = _G.PlayerESPColor or Color3.fromRGB(0,0,0) 
_G.TextSize  = _G.TextSize or 30
_G.ShowMobDist = _G.ShowMobDist or true
_G.MobESPDist = _G.MobESPDist or 2000
_G.MobESPColor = _G.MobESPColor or Color3.fromRGB(255,255,255)
_G.MobTextSize = _G.MobTextSize or 20
_G.ToggleKey = _G.ToggleKey or "T"
_G.InstantLogButton = _G.InstantLogButton or "L"
_G.OtherESPDist = _G.OtherESPDist or 20000
_G.ShowOtherDist = _G.ShowOtherDist or true
_G.ShowPosture = _G.ShowPosture or true
_G.ShowEther = _G.ShowEther or true
_G.ShowMOB = _G.ShowMOB or true
_G.ShowNPC = _G.ShowNPC or false
_G.ShowOwlSpawns = _G.ShowOwlSpawns or true
_G.ShowPlayer = _G.ShowPlayer or true
_G.ShowUnloadedMobs = _G.ShowUnloadedMobs  or true
_G.ShowOwlNotifications = _G.ShowOwlNotifications or true
_G.NotificationTime = _G.NotificationTime or 5


local player = game.Players.LocalPlayer
local EspListenTable = {}

local RunESP = false

if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat wait() until workspace:FindFirstChild("Live")
repeat wait(); player = game.Players.LocalPlayer until player.Name ~= nil
repeat wait() until workspace:WaitForChild("Live"):FindFirstChild(player.Name)

local cam = game.Workspace.CurrentCamera
function round(n)
    return math.floor(n)
end
local PossibleKickmsg = {"I fucking love etho","Holy fuck merh is ugly IRL","i love MEN","I wanna kill merhs dog","Why silver so hot IRL","i love pebbels..."}
function KickLocPlayer()
    game.Players.LocalPlayer:Kick(PossibleKickmsg[math.random(1,#PossibleKickmsg)])
end



function CheckMag(PositionToCheck)

    if player ~= nil  and player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") then
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
    return 0

end

 function GetDeepWokenMobDist(v)
    if v.PosType.Model:FindFirstChild("HumanoidRootPart") then
        return CheckMag(v.PosType.Model.HumanoidRootPart.Position)
    elseif v.PosType.Model:FindFirstChild("SpawnCF") then
        local cf = v.PosType.Model.SpawnCF.Value
        return CheckMag(Vector3.new(cf.X,cf.Y,cf.Z))     
    else return _G.MobESPDist + 1000
    end
 end
function debug(msg)
    if _G.DebugMode == true then
        print(msg)
    end    


end
_G.test = ""
local ESPZindexHoldval = 0
function AddESPObj(PosType,CharaName,HpValTable,IsPlayer,ModdedName,GlobalVarriable)
    if not PosType or type(PosType) ~= "table" then
        warn("PosType is not set")
        return
    end

    CharaName = CharaName or "Dumby forgot a name..."
    ModdedName = ModdedName or ""
    GlobalVarriable = GlobalVarriable or "test"

    HpValTable = HpValTable or {Type = "None",Min = 0,Max = 0}
    IsPlayer = IsPlayer or false
    local ESPText = Drawing.new("Text")
    local BackUpText = Drawing.new("Text")
    if IsPlayer == true then
        ESPText.ZIndex = ESPZindexHoldval + 10000
        BackUpText.ZIndex = ESPZindexHoldval + 10000
        debug("Player "..tostring(ESPText.ZIndex))
    else
        ESPText.ZIndex = ESPZindexHoldval + 1
        BackUpText.ZIndex = ESPZindexHoldval + 1
    end
    ESPZindexHoldval = ESPZindexHoldval + 1

    EspListenTable[#EspListenTable + 1 ] = {PosType = PosType,Text = ESPText, Name = CharaName, HpType = HpValTable,IsPlayer = IsPlayer, Enabled = GlobalVarriable, ModName = ModdedName,BackUpText = BackUpText}
    return EspListenTable[#EspListenTable]
end

function CalcString(OptTable)
    local basestring = ""
    if _G.DisplayHp == true then
        basestring = "["
        if string.upper(OptTable.HpType.Type) == "HUMANOID" and OptTable.HpType.HumanoidPath ~= false then
            local huma = OptTable.HpType.HumanoidPath

            basestring = basestring..tostring(round(huma.Health)).."/"..tostring(round(huma.MaxHealth)).."] "
        elseif string.upper(OptTable.HpType.Type) == "NONE" then
            basestring = ""
        elseif string.upper(OptTable.HpType.Type) == "CUSTOM" then
            basestring = basestring..tostring(round(OptTable.HpType.MinHP.Value)).."/"..tostring(round(OptTable.HpType.MaxHp.Value)).."] "

        end
    end
    if OptTable.ModName == "" then
        basestring = basestring..OptTable.Name
    else
        basestring = basestring..OptTable.ModName
    end
   
    if OptTable.IsPlayer == true then -- Talent ESP
        if _G.ShowTalentAmount == true then
            if game.Players:FindFirstChild(OptTable.Name)  then
                basestring = basestring.." Talents: "..tostring(CheckTalentAmount(game.Players:FindFirstChild(OptTable.Name)))
            elseif game.Players:FindFirstChild(OptTable.HpType.HumanoidPath.Parent.Name) then
                basestring = basestring.." Talents: "..tostring(CheckTalentAmount(game.Players:FindFirstChild(game.Players:FindFirstChild(OptTable.HpType.HumanoidPath.Parent.Name))))
            else

                basestring = basestring.. " Talents: Nil"
            end
        end
        if OptTable.IsPlayer == true and _G.ShowPlayerDist == true then
            basestring = basestring.." ["..tostring(round(CheckMag(OptTable.PosType.Part.Position))).."]"  
        end
    elseif OptTable.PosType.Type == "Part" then -- Show Distance for ESP
        if  OptTable.IsPlayer == false and _G.ShowOtherDist == true  then
            basestring = basestring.." ["..tostring(round(CheckMag(OptTable.PosType.Part.Position))).."]"  
        end
       
    elseif OptTable.PosType.Type == "DeepWoken" then -- Deepwoken Mobs ESP
        if _G.ShowMobDist == true then
            basestring = basestring.." ["..round(GetDeepWokenMobDist(OptTable)).."]"
        end
        
    end
    return basestring
end

function CheckPartValid(chara)
    if chara.Parent ~= nil then return true else return false end
end
function GetPercent(min,max)
    return round((min / max) * 100)

end
function CalcBackUpString(OptTable)
    local basestring = ""
    if OptTable.IsPlayer == true then
        local charactermodel = OptTable.PosType.Part.Parent
        if charactermodel == nil then return "" end
        if charactermodel:FindFirstChild("BreakMeter") and _G.ShowPosture == true then
            local val = charactermodel.BreakMeter
            basestring = basestring.."Posture: "..GetPercent(val.Value,val.MaxValue).."%"
        end
        if charactermodel:FindFirstChild("Ether") and _G.ShowEther == true then
            local val = charactermodel.Ether
            basestring = basestring.." Ether: "..GetPercent(val.Value,val.MaxValue).."%"
        end
        
    else
        local MobModel = OptTable.PosType.Model
        if MobModel == nil then return "" end
        if MobModel:FindFirstChild("BreakMeter") and _G.ShowPosture == true then
            local val = MobModel.BreakMeter
            basestring = basestring.."Posture: "..GetPercent(val.Value,val.MaxValue).."%"
        end
        if MobModel:FindFirstChild("Ether") and _G.ShowEther == true then
            local val = MobModel.Ether
            basestring = basestring.." Ether: "..GetPercent(val.Value,val.MaxValue).."%"
        end
    end

    return basestring
end




function EspListener()
    local RemoveESPVal = false
    for i,v in pairs(EspListenTable) do
        if RemoveESPVal == false then

            if v.PosType.Type == "Part" and CheckPartValid(v.PosType.Part) == false then

                v.Text:Remove()
                v.BackUpText:Remove()
                table.remove(EspListenTable,i)
                RemoveESPVal = true
            elseif v.PosType.Type == "DeepWoken" and v.PosType.Model == nil or v.PosType.Type == "DeepWoken" == nil and  v.PosType.Model.Parent then
                v.Text:Remove()
                v.BackUpText:Remove()
                table.remove(EspListenTable,i)
                RemoveESPVal = true
            elseif _G[v.Enabled] ~= true and _G[v.Enabled] ~= "" then 

                v.Text.Visible = false
                v.BackUpText.Visible = false
            elseif v.IsPlayer == true and v.Name ~= nil and game.Players:FindFirstChild(v.Name) == nil then

                v.Text:Remove()
                v.BackUpText:Remove()
                table.remove(EspListenTable,i)
                RemoveESPVal = true
            else
                if v.PosType.Type == "Part" then
                    
                    local distcache = CheckMag(v.PosType.Part.Position)
                    if distcache ~= nil and distcache < _G.PlayerESPDist and v.IsPlayer == true or v.IsPlayer == false and distcache ~= nil and  distcache < _G.OtherESPDist then
                        local offs = Vector3.new(0,0,0)
                        if v.IsPlayer == true then offs = Vector3.new(0,3,0) end 
                        local CharPos,OnS = cam:WorldToViewportPoint(v.PosType.Part.Position +offs)
                        local TextOBJ = v.Text
                        local BackUpText = v.BackUpText
                        TextOBJ.Visible = OnS
                        BackUpText.Visible = OnS
                        if OnS == true then
                            
                            local offset = CheckMag(v.PosType.Part.Position) / 500
                            if offset < 0 then offset = 0 end
                            TextOBJ.Position = Vector2.new(CharPos.X - (TextOBJ.TextBounds.X/2),CharPos.Y - offset)
                            
                            TextOBJ.Text = CalcString(v) 
                            BackUpText.Text = CalcBackUpString(v)
                            local textoffs = _G.TextSize - (offset * 1.5)
                            if textoffs < 15 then textoffs = 15 end
                            BackUpText.Size = textoffs
                            TextOBJ.Size = textoffs
                            BackUpText.Position = Vector2.new(CharPos.X - (BackUpText.TextBounds.X/2),(CharPos.Y - offset) + TextOBJ.TextBounds.Y)
                            if v.ModName == "OWL" then
                                TextOBJ.Color = Color3.fromRGB(255,255,255)
                                BackUpText.Color = Color3.fromRGB(255,255,255)
                            else
                                TextOBJ.Color = _G.PlayerESPColor
                                BackUpText.Color = _G.PlayerESPColor
                            end
                            
                            
                        end
                    else
                        v.Text.Visible = false
                        v.BackUpText.Visible = false
                    end
    
                   
                elseif v.PosType.Type == "DeepWoken" then
                    local CharPos,OnS;
                    local mobdist = GetDeepWokenMobDist(v)
                    if mobdist ~= nil and mobdist < _G.MobESPDist then
                        local holdpos;

                        if v.PosType.Model:FindFirstChild("HumanoidRootPart") then
                            CharPos,OnS = cam:WorldToViewportPoint(v.PosType.Model.HumanoidRootPart.Position)
                            holdpos = v.PosType.Model.HumanoidRootPart.Position
                        elseif v.PosType.Model:FindFirstChild("SpawnCF") and _G.ShowUnloadedMobs == true then
                            local cf = v.PosType.Model.SpawnCF.Value
                            CharPos,OnS = cam:WorldToViewportPoint(Vector3.new(cf.X,cf.Y,cf.Z))
                            holdpos = Vector3.new(cf.X,cf.Y,cf.Z)
                        end
                        if CharPos ~= nil and holdpos ~= nil  then
                            local BackUpText = v.BackUpText
                            local TextOBJ = v.Text
                            OnS = OnS or false
                            TextOBJ.Visible = OnS
                            BackUpText.Visible = OnS
                            local offset = CheckMag(holdpos) / 500
                            if offset < 0 then offset = 0 end

                            if OnS == true then
                                TextOBJ.Text = CalcString(v)
                                BackUpText.Text = CalcBackUpString(v)
                                TextOBJ.Position = Vector2.new(CharPos.X - (TextOBJ.TextBounds.X/2),CharPos.Y- offset) 

                                local textoffs = _G.MobTextSize - (offset * 1.5)
                                if textoffs < 15 then textoffs = 15 end
                                TextOBJ.Size = textoffs
                                BackUpText.Size = textoffs
                                BackUpText.Position = Vector2.new(CharPos.X - (BackUpText.TextBounds.X/2),(CharPos.Y - offset) + TextOBJ.TextBounds.Y)
                                TextOBJ.Color = _G.MobESPColor
                                BackUpText.Color = _G.MobESPColor
                            end
                        else
                            v.Text.Visible = false
                            v.BackUpText.Visible = false
                        end
                    else
                        v.Text.Visible = false
                        v.BackUpText.Visible = false
                    end
                
                end
              
               
                
            
            end
            
        end
        

    end
end

local LoopServ;
function EspToggle()
    if RunESP == true then
        RunESP = false
        LoopServ:Disconnect()
        for i,v in pairs(EspListenTable) do
            v.Text.Visible = false
            v.BackUpText.Visible = false
        end
       
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
    local CharaName = ""
    if v.Name == "Etho4141" then CharaName = "MASTER ETHO" end
    if v.Name == "GrenadeGrey"  then CharaName = "zZzMerh" end
    if v.Name == "MoriRobloxCringe" then CharaName = "zZzSilver" end
    if v.Name == "Saiahwastaken" then CharaName = "zZzSaiah" end
    AddESPObj(PosTypeTable,v.Name,HpValTable,true,CharaName,"ShowPlayer")
end

local PlayerConnectionsTable = {}

for i,v in pairs(game.Players:GetChildren()) do
    if v ~= game.Players.LocalPlayer or v.Name ~= game.Players.LocalPlayer.Name then
        AddPlayerToESP(v)
        PlayerConnectionsTable[v.Name] = v.CharacterAdded:connect(function(v)
            AddPlayerToESP(game.Players[v.Name])
        end)
    end
end

game.Players.PlayerAdded:connect(function(v)
    if v == game.Players.LocalPlayer then return end
    PlayerConnectionsTable[v.Name] = v.CharacterAdded:connect(function(v)
        AddPlayerToESP(game.Players[v.Name])
    end)
    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        AddPlayerToESP(v)
    end
end)

game.Players.PlayerRemoving:connect(function(v)
    if table.find(PlayerConnectionsTable,v.Name) then
        PlayerConnectionsTable[v.Name]:Disconnect()
    end
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







local MobsInESP = {}
local MobRetryTable = {}
function AddMobToESP(v)
    if not v:IsA("Model") then return end

    if v and v:FindFirstChild("Humanoid") and CheckMob(v) == true  and v:GetAttribute("MOB_rich_name") ~= nil then
        local HpValTable = {
            Type = "Humanoid",
            HumanoidPath = v.Humanoid
        }
        local PosTypeTable = {
            Type = "DeepWoken",
            Model = v
        }
        if table.find(MobsInESP,v) == nil then
            MobsInESP[#MobsInESP+1] = v
            AddESPObj(PosTypeTable,v:GetAttribute("MOB_rich_name"),HpValTable,false,"","ShowMOB")
        end
        
        
    else
        MobRetryTable[#MobRetryTable + 1] = v

    end
end

function MobRetryFunction()
    while wait() do
        local RemovedVal = false
        for i,v in pairs(MobRetryTable) do
            if v and v:FindFirstChild("Humanoid") and RemovedVal == false and v:GetAttribute("MOB_rich_name") ~= nil and CheckMob(v) == true  then
                AddMobToESP(v)
                table.remove(MobRetryTable,i)
                RemovedVal = true
            end
            if game.Players:FindFirstChild(v.Name) then
                table.remove(MobRetryTable,i)
                RemovedVal = true

            end
        end

    end
end

coroutine.wrap(MobRetryFunction)()


workspace:WaitForChild("Live")


for i,v in pairs(workspace.Live:GetChildren()) do
    AddMobToESP(v)
end
workspace.Live.ChildAdded:connect(function(v)
    AddMobToESP(v)
end)

workspace.ChildRemoved:Connect(function(child)
    if table.find(MobsInESP,child) ~= nil then
        table.remove(MobsInESP,table.find(MobsInESP,child))
    end
end)
local NPCRetry = {}
function AddToNPCEsp(v)
    if v and v:FindFirstChild("HumanoidRootPart") then
        local PosTypeTable = {
            Type = "Part",
            Part = v.HumanoidRootPart
    
        }
        local HealthThingTable = {
            Type = "None"

        }
        AddESPObj(PosTypeTable,v.Name,HealthThingTable,false,"","ShowNPC")
    else
        NPCRetry[#NPCRetry+1] = v
    end
    


end



for i,v in pairs(game.Workspace.NPCs:GetChildren()) do
    AddToNPCEsp(v)
end

game.Workspace.NPCs.ChildAdded:connect(function(v)
    AddToNPCEsp(v)
end)

function NpcRetryFunc()
    for i,v in pairs(NPCRetry) do
        if v and v.Name ~= "" and v.Name ~= nil and v:FindFirstChild("HumanoidRootPart") then
            AddToNPCEsp(v)
        end
    end   
end
coroutine.wrap(NpcRetryFunc)()

function AddBasePartToESP(v,ModdedName)
    local PosTypeTable = {
        Type = "Part",
        Part = v

    }
    local HealthThingTable = {
        Type = "None"
    }
    AddESPObj(PosTypeTable,v.Name,HealthThingTable,false,ModdedName,"ShowOwlSpawns")

end





local NotifTab = {}

local cam = game.Workspace.CurrentCamera



local BaseNotifPos = Vector2.new(cam.ViewportSize.X/ 19 ,cam.ViewportSize.Y / 2)
function CreateNotif(Contents, Duration)
    Contents = Contents or "retard"
    Duration = Duration or 3
    local NotifPos = #NotifTab
    local text = Drawing.new("Text")
    text.Visible = true
    text.Size = 35
    text.Color = Color3.fromRGB(255,255,255)
    NotifTab[#NotifTab+ 1] = {Message = Contents,Dura = Duration, Pos = NotifPos, NotifText = text}
    local function CreateText()
        
        text.Text = Contents
        text.Position = BaseNotifPos + Vector2.new(0 ,0 - #NotifTab * text.TextBounds.y)
       
        wait(Duration)
        text.Visible = false
        table.remove(NotifTab,NotifPos)
        local function ReDrawNotifs()
            for i,v in pairs(NotifTab) do
                v.NotifText.Position = BaseNotifPos + Vector2.new(0,0 - i* v.NotifText.TextBounds.Y)
            end
        end
        ReDrawNotifs()
    end
    CreateText()
end
function Inter(con,dura)
    if _G.ShowOwlNotifications == true then
        coroutine.wrap(CreateNotif)(con,dura)
    end
end











for i,v in pairs(game.Workspace.Thrown:GetChildren()) do
    if v.Name == "EventFeatherRef" and CheckPartValid(v) == true  then
        Inter("An Owl has spawned check ESP",_G.NotificationTime)
        AddBasePartToESP(v,"OWL")
    end   
end
game.Workspace.Thrown.ChildAdded:connect(function(v)
    if v.Name == "EventFeatherRef" and CheckPartValid(v) == true  then
        Inter("An Owl has spawned check ESP",_G.NotificationTime)
        AddBasePartToESP(v,"OWL")
    end   
end)









game:GetService("UserInputService").InputBegan:connect(function(key,gpe)
    if gpe then return end
    if _G.ToggleKey ~= "" and  key.KeyCode == Enum.KeyCode[_G.ToggleKey] then
        EspToggle()
    elseif _G.InstantLogButton ~= "" and  key.KeyCode == Enum.KeyCode[_G.InstantLogButton] then
        KickLocPlayer()
    end

end)




