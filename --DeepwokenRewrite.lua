--[[
    Left to add
    Chest ESP
    Inventory Viewer
    Somesort of GUI

]]

-- Chams Settings 
_G.AllowChamsEtho = true -- This is the only thinbg that could possibly be detected, However merh and me have been using it and no bans for around a week

_G.ChamsFillColor = Color3.fromRGB(255,0,255)
_G.ChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.ChamsFill = 1
_G.ChamsOutlineTrans = 0

-- Player ESP Settings
_G.PlayerESP = true
_G.PlayerTextSize = 30
_G.PlayerTextColor = Color3.fromRGB(43, 171, 245)
_G.PlayerDist = true
_G.ShowPlayerHealthPercent = false
_G.PlayerMaxDist = 20000
_G.ShowPlayerHealth = true

_G.ShowChams = true
_G.ShowPlayerBox = true
_G.ShowHpBars = true
_G.WhitelistNames = {"etho","mori","saiah","christopher","GrenadeGrey"} -- Caps DO NOT matter and it will Auto Fill Names
_G.WhitelistColor = Color3.fromRGB(255,0,0)
_G.ShowPlayerLevel = true 
_G.ShowPlayerPosture = true 

-- Mob ESP Settings
_G.MobEsp = true 
_G.MobTextSize = 20
_G.MobColor = Color3.fromRGB(255,255,255)
_G.ShowMobDistance = true 
_G.MobMaxDist = 5000
_G.ShowMobHp = true 
_G.ShowMobHpPercent = false
_G.ShowMobChams = true 
_G.ShowMobBox = true 
_G.ShowMobHpBars = true 
_G.ShowMobPosture = true 

-- OWL

_G.OwlEsp = true 
_G.OwlTextSize = 30
_G.OwlColor = Color3.fromRGB(255,255,255)
_G.ShowOwlDistance = true 
_G.OwlMaxDistance = 100000

-- Ingredient ESP
_G.IngredientESP = true 
_G.IngredientTextSize = 25
_G.IngredientColor = Color3.fromRGB(233, 255, 39)
_G.ShowIngredientDistance = true  
_G.IngredientMaxDistance = 1000
_G.WhitelistIngredients = {"GALEWAX"} -- Whitelist for ingredients HIGHLY RECOMMENED (As it will be laggy wihtout one..), Caps dont matter, Requries restart to Change Whitelist, Leave blank for no Whitelist

-- NPC ESP

_G.NPCEsp = true 
_G.NPCEspSize = 25
_G.NPCColor = Color3.fromRGB(255,255,255)
_G.ShowNpcDistance = true
_G.NpcRenderDistance = 3000
_G.NPCWhitelist = {} -- Whitelist for NPC's, Caps dont matter, Requries restart to Change Whitelist, Leave blank for no Whitelist

-- Misc Settings
_G.SillyNames = true -- Will require restart
_G.ScaleESPText = true
_G.OutlineText = true -- Outlines ESP Text 
_G.UseLookAt = true -- Makes 2D box esp always show on screen!
_G.UseTwoD = true -- true == 2D box's, false == 3D Box's

local Live;
repeat wait(); Live = game.Workspace.Live until Live ~= nil 
local player;
repeat wait(); player = game.Players.LocalPlayer until player and player.Name and player.Parent
local Ingre;
repeat wait(); Ingre = workspace.Ingredients until Ingre and Ingre.Parent and Ingre.Name 
local np;
repeat wait() np = workspace.NPCs until np and np.Name and np.Parent



local ESPBASE =  loadstring(game:HttpGet("https://raw.githubusercontent.com/Etho414/MainScripts/main/EspBaseRewrite!.lua", true))()


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
    coroutine.wrap(CreateNotif)(con,dura)
end

local RandomTextTable = {"Judge is ugly asf","I LOVE PEBBELS","ASMR Intense kisses for you to sleep  💖" ,"Saiah WAS NOT taken","Age of Empires","Morii is like dorii got emm","Extinct Species will NEVER get a girl","OMG do clan GAMES!","i love peanut","ON YOUR FEET SOLDIER WE ARE LEAVING","Soon.","I love big mike"}




local LocalPlayerFunctionVariable = function(PassedTable)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.HumanoidRootPart.Position
    end

end

function CFtoVec(c)
    return Vector3.new(c.x,c.y,c.z)
end

function CalcPercent(min,max)
    return math.floor(((min / max) * 100) + 0.5)
end
function Round(n)
    return math.floor(n + 0.5)
end

function ReturnPlayerTalents(v)
    if v and v.Backpack then
       local val = 0  
        for i,v in pairs(v.Backpack:GetChildren()) do
            if v.Name:match("Talent") then
                val = val + 1
            end
        end
        return val
    end
     return nil 
end

function ReturnPowerLevel(v)
    local function ReturnStatPoints()
        local StatPoints = 0 
        for i,v in pairs(v:GetAttributes()) do
            if string.match(i,"Stat") then
               StatPoints = StatPoints + v 
            end
    
        end
        return StatPoints
    end
    local Points = ReturnStatPoints(v) - 28
    local Level =  math.floor((Points / 15) + 1)
    return Level
end

local player = game.Players.LocalPlayer
local TotalPlayer = 10000
function AddPlayerESP(v)
    TotalPlayer = TotalPlayer + 1 
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            BaseZIndex = TotalPlayer, 
            TextOffset = 0,
            TextOutline = _G.OutlineText,
            Vector3Offset = Vector3.new(0,3,0),
            ReturnTeamCheck = function()
                return false 
            end,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    return v.Character.HumanoidRootPart.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = LocalPlayerFunctionVariable,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = (v.Character.HumanoidRootPart.Position - PassedTable.Data.ReturnLocalPlayerpos()).Magnitude
                    if _G[PassedTable.GlobalVariableTable.ShowHealth] == true then
                        local MinHp = v.Character.Humanoid.Health
                        local MaxHp = v.Character.Humanoid.MaxHealth
                        if _G[PassedTable.GlobalVariableTable.ShowHealthPercent] == true then
                            Line3Text = Line3Text.."["..tostring(Round(CalcPercent(MinHp,MaxHp))).."%] "
                        else
                            Line3Text = Line3Text.."["..tostring(Round(MinHp)).."/"..tostring(Round(MaxHp)).."] "
                        end
                    end
                    if PassedTable.Data.ModdedName ~= "" then
                        Line3Text = Line3Text..PassedTable.Data.ModdedName.." "
                    else
                        Line3Text = Line3Text..v.Name.." "
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                        Line3Text = Line3Text.."["..tostring(Round(MagnitudeChached)).."] "
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowPosture] == true then
                        if v.Character:FindFirstChild("BreakMeter") then
                            Line2Text = Line2Text.."P: "..tostring(CalcPercent(v.Character.BreakMeter.Value,v.Character.BreakMeter.MaxValue)).."% "
                        end
                    end
                    
                    if _G[PassedTable.GlobalVariableTable.ShowPowerLevel] == true then 
                        local Level = ReturnPowerLevel(v.Character)
                        if Level ~= nil then
                            Line2Text = Line2Text.."Level: "..tostring(Level).." "
                        end
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            DeterminToRemoveFunction = function(PassedTable) -- P MUCH keep the same
                if ESPBASE:CheckBasePartValid(v) == false then
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
                },
                ThreeDOffsetTable = {
                    ForwardLeft = CFrame.new(-2,2,-2),
                    ForwardRight = CFrame.new(2,2,-2),
                    BackwardLeft = CFrame.new(-2,2,2),
                    BackwardRight = CFrame.new(2,2,2),
                    Height = 5

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
            },
            UseWhitelist = {
                UseWhitelist = true,
                ReturnNameFunction = function(PassedTable)
                    return v.Name
                end
            }
        },
        GlobalVariableTable = {
            TextToggle = "PlayerESP",
            TextSize = "PlayerTextSize",
            TextColor = "PlayerTextColor",
            MaxRenderDistance = "PlayerMaxDist",
            ScaledText = "ScalePlayerText",
            ChamsToggle = "ShowChams",
            ChamsFillColor = "ChamsFillColor",
            ChamsOutlineColor = "ChamsOutlineColor",
            ChamsFillTrans = "ChamsFill",
            ChamsOutlineTrans = "ChamsOutlineTrans",
            BoxToggle = "ShowPlayerBox",
            HpBarToggle = "ShowHpBars",
            WhitelistTable = "WhitelistNames",
            WhitelistColor = "WhitelistColor",
            UseTwoD = "UseTwoD",
            UseLookAt = "UseLookAt",

            ShowPosture = "ShowPlayerPosture",
            ShowPowerLevel = "ShowPlayerLevel",
            ShowHealth = "ShowPlayerHealth",
            ShowHealthPercent = "ShowPlayerHealthPercent",
            ShowDistance = "PlayerDist"


        }


        
    }
    ESPBASE:AddESPObj(OptionTable)
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


local CustomOffsetTable = {
    RotSkipper = {
        CustomName = "PxieStix",
    },
    ["Bloated Mudskipper"] = {
        CustomName = "Silver",
    },
    Mudskipper = {
        CustomName = "Saiah",
    },
    Gigamed = {
        CustomName = "Extinct",
    },
    ["King Gigamed"] = {
        CustomName = "Bruther",
    
    }
    


}

local TotalMobs = 1 

function AddMobToESP(v)
    TotalMobs = TotalMobs + 1 
    local MobName = v:GetAttribute("MOB_rich_name")
    local BoxOffset = {
        TopLeft = CFrame.new(-2,2,0),
        TopRight = CFrame.new(2,2,0),
        BottomLeft = CFrame.new(-2,-3.5,0),
        BottomRight = CFrame.new(2,-3.5,0)
    }
    local ThreeDBoxOffset = {
        ForwardLeft = CFrame.new(-2,2,-2),
        ForwardRight = CFrame.new(2,2,-2),
        BackwardLeft = CFrame.new(-2,2,2),
        BackwardRight = CFrame.new(2,2,2),
        Height = 5

    }
    local BarOffset = {
        TopLeft = CFrame.new(3,2,0),
        TopRight = CFrame.new(2,2,0),
        BottomLeft = CFrame.new(3,-3.5,0),
        BottomRight = CFrame.new(2,-3.5,0)

    }
    if CustomOffsetTable[MobName] ~= nil and _G.SillyNames == true then
        local Indexed = CustomOffsetTable[MobName]
        if Indexed["CustomName"] ~= nil or Indexed["CustomName"] ~= "" then      
            MobName = Indexed["CustomName"]    
        end
        if Indexed["BoxOffset"] ~= nil then  
            BoxOffset = Indexed["BoxOffset"]
        end
        if Indexed["ThreeDBoxOffset"] ~= nil then  
            ThreeDBoxOffset = Indexed["ThreeDBoxOffset"]
        end
        if Indexed["BarOffset"] ~= nil then   
            BarOffset = Indexed["BarOffset"]
        end
    end
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = MobName,
            BaseZIndex = TotalMobs,
            TextOffset = 0,
            TextOutline = _G.OutlineText,
            Vector3Offset = Vector3.new(0,3,0),
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v  then
                    if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.CFrame then
                        return v.HumanoidRootPart.CFrame
                    elseif v:FindFirstChild("SpawnCF") then
                        return v.SpawnCF.Value
                    end
                end 
                return nil
            end,
            ReturnTeamCheck = function()
                return false 
            end,
            ReturnLocalPlayerpos = LocalPlayerFunctionVariable,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""

                local CFramePosition;
                if v  and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if v:FindFirstChild("HumanoidRootPart") then
                        CFramePosition = v.HumanoidRootPart.Position
                    elseif v:FindFirstChild("SpawnCF")  then
                        CFramePosition = v.SpawnCF.Value
                        CFramePosition = Vector3.new(CFramePosition.X,CFramePosition.Y,CFramePosition.Z)
                    end
                end
                if CFramePosition then  
                    local MagnitudeChached = (CFramePosition - PassedTable.Data.ReturnLocalPlayerpos()).Magnitude
                    if MagnitudeChached then 
                        if _G[PassedTable.GlobalVariableTable.ShowHealth] == true then
                            local MinHp = v.Humanoid.Health
                            local MaxHp = v.Humanoid.MaxHealth
                            if _G[PassedTable.GlobalVariableTable.ShowHealthPercent] == true then
                                Line3Text = Line3Text.."["..tostring(Round(CalcPercent(MinHp,MaxHp))).."%] "
                           else
                                Line3Text = Line3Text.."["..tostring(Round(MinHp)).."/"..tostring(Round(MaxHp)).."] "
                            end
                        end
                        if PassedTable.Data.ModdedName ~= "" then
                            Line3Text = Line3Text..PassedTable.Data.ModdedName.." "
                        else
                            Line3Text = Line3Text..v.Name.." "
                        end
                        if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                            Line3Text = Line3Text.."["..tostring(Round(MagnitudeChached)).."] "
                        end
                        if _G[PassedTable.GlobalVariableTable.ShowPosture] == true then
                            if v:FindFirstChild("BreakMeter") then
                                Line2Text = Line2Text.."P: "..tostring(CalcPercent(v.BreakMeter.Value,v.BreakMeter.MaxValue)).."% "
                            end 
                        end
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            
            DeterminToRemoveFunction = function(PassedTable) -- P MUCH keep the same
                if ESPBASE:CheckBasePartValid(v) == false then
                    PassedTable.ToBeRemoved = true
                end
            end,
            RunAfterEverthing = function(PassedTable)  
            end,
            Highlight = {
                UseChams = true,
                ReturnPartFunction = function(PassedTable)
                    return v
                end
            },
            BoxESP = {
                UseBoxESP = true,
                OffsetTable = BoxOffset,
                ThreeDOffsetTable = ThreeDBoxOffset
            },
            HpBar = {
                UseHpBar = true,
                ReturnHPFunction = function(PassedTable)
                    if v  and v.Humanoid then
                        return {Min = v.Humanoid.Health,Max = v.Humanoid.MaxHealth}
                    end
                end,
                BarOffsetTable = BarOffset
            },
            UseWhitelist = {
                UseWhitelist = false
            }
        },
        GlobalVariableTable = {
            TextToggle = "MobEsp",
            TextSize = "MobTextSize",
            TextColor = "MobColor",
            ShowDistance = "ShowMobDistance",
            MaxRenderDistance = "MobMaxDist",
            ShowHealth = "ShowMobHp",
            ShowHealthPercent = "ShowMobHpPercent",
            ScaledText = "ScalePlayerText",
            
            ChamsToggle = "ShowMobChams",
            ChamsFillColor = "ChamsFillColor",
            ChamsOutlineColor = "ChamsOutlineColor",
            ChamsFillTrans = "ChamsFill",
            ChamsOutlineTrans = "ChamsOutlineTrans",
            BoxToggle = "ShowMobBox",
            HpBarToggle = "ShowMobHpBars",
            UseTwoD = "UseTwoD",

            ShowPosture = "ShowMobPosture",
            UseLookAt = "UseLookAt"
        }


        
    }
    ESPBASE:AddESPObj(OptionTable)
end




for i,v in pairs(game.Workspace.Live:GetChildren()) do
    if game.Players:FindFirstChild(v.Name) == nil then
        AddMobToESP(v)
    end
end
game.Workspace.Live.ChildAdded:connect(function(v)
    if game.Players:FindFirstChild(v.Name) == nil then
        AddMobToESP(v)
    end
end)



function AddOwlToEsp(v)
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            TextOffset = 0,
            TextOutline = _G.OutlineText,
            Vector3Offset = Vector3.new(0,4,0),
            BaseZIndex = 100000,
            ReturnTeamCheck = function()
                return false 
            end,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v then
                    return v.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = LocalPlayerFunctionVariable,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v then
                    Line1Text = "OWL"
                    if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                        local MagnitudeChached = (v.Position - PassedTable.Data.ReturnLocalPlayerpos()).Magnitude
                        if MagnitudeChached then
                            Line1Text = Line1Text .." ["..tostring(Round(MagnitudeChached)).."]"
                        end
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            DeterminToRemoveFunction = function(PassedTable) -- P MUCH keep the same
                if ESPBASE:CheckBasePartValid(v) == false then
                    PassedTable.ToBeRemoved = true
                    end
                end,
            RunAfterEverthing = function(PassedTable)
                    

            end,
            Highlight = {
                 UseChams = false,

            },
            BoxESP = {
                UseBoxESP = false
            },
            HpBar = {
                UseHpBar = false,
            },
            UseWhitelist = {
                UseWhitelist = false
            }
        },
        GlobalVariableTable = {
            
            TextToggle = "OwlEsp",
            TextSize = "OwlTextSize",
            TextColor = "OwlColor",
            ShowDistance = "ShowOwlDistance",
            MaxRenderDistance = "OwlMaxDistance",
            ScaledText = "ScaleESPText",
        }


        
    }
    ESPBASE:AddESPObj(OptionTable)

end

for i,v in pairs(game.Workspace.Thrown:GetChildren()) do
    if v.Name == "EventFeatherRef"  then
        Inter("Owl spawned!",10)
        AddOwlToEsp(v)
    end 
end

game.Workspace.Thrown.ChildAdded:connect(function(v)
    if v.Name == "EventFeatherRef"  then
        Inter("Owl spawned!",10)
        AddOwlToEsp(v)
    end   
end)
 

function AddIngredient(v)
    if table.find(_G.WhitelistIngredients,string.upper(v.Name)) == nil then
        return
    end
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            TextOffset = 0,
            TextOutline = _G.OutlineText,
            Vector3Offset = Vector3.new(0,0,0),
            BaseZIndex = 1,
            ReturnTeamCheck = function()
                return false 
            end,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v then
                    return v.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = LocalPlayerFunctionVariable,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v then
                    local MagnitudeChached = (v.Position - PassedTable.Data.ReturnLocalPlayerpos()).Magnitude
                    if PassedTable.Data.ModdedName ~= nil and PassedTable.Data.ModdedName ~= "" then
                        Line1Text = PassedTable.Data.ModdedName
                    else
                        Line1Text = v.Name
                    end 
                    if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                        Line1Text = Line1Text.." ["..tostring(math.floor(MagnitudeChached)).."]"
                    end
                    
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            DeterminToRemoveFunction = function(PassedTable) -- P MUCH keep the same
                if ESPBASE:CheckBasePartValid(v) == false then
                    PassedTable.ToBeRemoved = true
                    end
                end,
            RunAfterEverthing = function(PassedTable)
                

            end,
            Highlight = {
                 UseChams = false,

            },
            BoxESP = {
                UseBoxESP = false
            },
            HpBar = {
                UseHpBar = false,
            },
            UseWhitelist = {
                UseWhitelist = false
            }
        },
        GlobalVariableTable = {
            
            TextToggle = "IngredientESP",
            TextSize = "IngredientTextSize",
            TextColor = "IngredientColor",
            ShowDistance = "ShowIngredientDistance",
            MaxRenderDistance = "IngredientMaxDistance",
            ScaledText = "ScaleESPText",
        }


        
    }
    ESPBASE:AddESPObj(OptionTable)

end
for i,v in pairs(workspace.Ingredients:GetChildren()) do
    
   AddIngredient(v)
end
workspace.Ingredients.ChildAdded:connect(function(v)
   AddIngredient(v)

end)


function AddNPCToEsp(v)
    if table.find(_G.NPCWhitelist,string.upper(v.Name)) == nil then
        return
    end
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            TextOffset = 0,
            TextOutline = _G.OutlineText,
            Vector3Offset = Vector3.new(0,4,0),
            BaseZIndex = 100000,
            ReturnTeamCheck = function()
                return false 
            end,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v and v:FindFirstChild("HumanoidRootPart") then
                    return v.HumanoidRootPart.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = LocalPlayerFunctionVariable,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v then
                    local MagnitudeChached = Round((CFtoVec(PassedTable.Data.ReturnPosFunc()) - PassedTable.Data.ReturnLocalPlayerpos()).Magnitude)
                    if PassedTable.Data.ModdedName ~= "" then
                        Line1Text = PassedTable.Data.ModdedName
                    else
                        Line1Text = v.Name
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowDistance] == true then
                        Line1Text = Line1Text.." ["..tostring(MagnitudeChached).."] "
                    end
                    
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            DeterminToRemoveFunction = function(PassedTable) -- P MUCH keep the same
                if ESPBASE:CheckBasePartValid(v) == false then
                    PassedTable.ToBeRemoved = true
                    end
                end,
            RunAfterEverthing = function(PassedTable)
                for i,v in pairs(_G.NPCWhitelist) do
                    _G.NPCWhitelist[i] = string.upper(v)
                end

            end,
            Highlight = {
                 UseChams = false,

            },
            BoxESP = {
                UseBoxESP = false
            },
            HpBar = {
                UseHpBar = false,
            },
            UseWhitelist = {
                UseWhitelist = false
            }
        },
        GlobalVariableTable = {

            TextToggle = "NPCEsp",
            TextSize = "NPCEspSize",
            TextColor = "NPCColor",
            ShowDistance = "ShowNpcDistance",
            MaxRenderDistance = "NpcRenderDistance",
            ScaledText = "ScaleESPText",
        }


        
    }
    ESPBASE:AddESPObj(OptionTable)

end


for i,v in pairs(workspace.NPCs:GetChildren()) do
    AddNPCToEsp(v)
end

workspace.NPCs.ChildAdded:connect(function(v)
    AddNPCToEsp(v)
end)


game:GetService("UserInputService").InputBegan:connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.T then
        ESPBASE:Toggle()

    end

end)


ESPBASE:Toggle()

Inter(RandomTextTable[math.random(1,#RandomTextTable)],10)
