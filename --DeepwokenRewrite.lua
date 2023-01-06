--DeepwokenRewrite

local Live;
repeat wait(); Live = game.Workspace.Live until Live ~= nil 


local ESPBASE =  loadstring(game:HttpGet("https://raw.githubusercontent.com/Etho414/MainScripts/main/EspBaseRewrite!.lua", true))()

_G.SillyNames = true 



_G.PlayerESP = true
_G.PlayerTextSize = 30
_G.PlayerTextColor = Color3.fromRGB(255,255,255)
_G.PlayerDist = true
_G.ShowPlayerHealthPercent = false
_G.PlayerMaxDist = 20000
_G.ShowPlayerHealth = true
_G.ScalePlayerText = true
_G.ShowChams = true
_G.ChamsFillColor = Color3.fromRGB(255,0,255)
_G.ChamsOutlineColor = Color3.fromRGB(0,0,0)
_G.ChamsFill = 0
_G.ChamsOutlineTrans = 0
_G.ShowPlayerBox = true
_G.ShowHpBars = true
_G.WhitelistNames = {"etho","mori","saiah","christopher"}
_G.WhitelistColor = Color3.fromRGB(255,0,0)
_G.ShowPlayerEther = true
_G.ShowPlayerTalents = true 
_G.ShowPlayerPosture = true 


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

ESPBASE:Toggle()

local player = game.Players.LocalPlayer
function AddPlayerESP(v)
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    return v.Character.HumanoidRootPart.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = function()
                if player and player.Character and player.Character.HumanoidRootPart then
                    return player.Character.HumanoidRootPart.Position
                end
            end,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = PassedTable.Data.ReturnMagnitude(v.Character.HumanoidRootPart.CFrame)
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
                        Line3Text = "["..tostring(Round(MagnitudeChached)).."] "..Line3Text
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowPosture] == true then
                        if v.Character:FindFirstChild("BreakMeter") then
                            Line2Text = Line2Text.."P: "..tostring(CalcPercent(v.Character.BreakMeter.Value,v.Character.BreakMeter.MaxValue)).."% "
                        end
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowEther] == true then
                        if v.Character:FindFirstChild("Ether") then
                            Line2Text = Line2Text.."E: "..tostring(CalcPercent(v.Character.Ether.Value,v.Character.Ether.MaxValue)).."% "
                        end
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowTalents] == true then 
                        local Talents = ReturnPlayerTalents(v)
                        if Talents ~= nil then
                            Line1Text = Line1Text.."Talents: "..tostring(Talents).." "
                        end
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            TextOffset = 0,
            Vector3Offset = Vector3.new(0,4,0),
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
                    TopRight = CFrame.new(2,2,0),
                    Height = 5,
                    Width = 5

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
            HpBarToggle = "ShowHpBars",
            WhitelistTable = "WhitelistNames",
            WhitelistColor = "WhitelistColor",
            UseTwoD = "UseTwoD",
            ShowEther = "ShowPlayerEther",
            ShowPosture = "ShowPlayerPosture",
            ShowTalents = "ShowPlayerTalents"


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

_G.MobEsp = true 
_G.MobTextSize = 20
_G.MobColor = Color3.fromRGB(255,255,255)
_G.ShowMobDistance = true 
_G.MobMaxDist = 3000
_G.ShowMobHp = true 
_G.ShowMobHpPercent = false
_G.ShowMobChams = true 
_G.ShowMobBox = true 
_G.ShowMobHpBars = true 
_G.ShowMobPosture = true 

local CustomOffsetTable = {
    RotSkipper = {
        CustomName = "PxieStix",
        BoxOffset = {
            TopLeft = CFrame.new(-2,2,0),
            TopRight = CFrame.new(2,2,0),
            BottomLeft = CFrame.new(-2,-3.5,0),
            BottomRight = CFrame.new(2,-3.5,0)
        },
        ThreeDBoxOffset = {
            ForwardLeft = CFrame.new(-2,2,-2),
            ForwardRight = CFrame.new(2,2,-2),
            BackwardLeft = CFrame.new(-2,2,2),
            BackwardRight = CFrame.new(2,2,2),
            Height = 5
    
        },
        BarOffset = {
            TopRight = CFrame.new(2,2,0),
            Height = 5 
    
        }
    },
    ["Bloated Mudskipper"] = {
        CustomName = "Silver",
        BoxOffset = {
            TopLeft = CFrame.new(-2,2,0),
            TopRight = CFrame.new(2,2,0),
            BottomLeft = CFrame.new(-2,-3.5,0),
            BottomRight = CFrame.new(2,-3.5,0)
        },
        ThreeDBoxOffset = {
            ForwardLeft = CFrame.new(-2,2,-2),
            ForwardRight = CFrame.new(2,2,-2),
            BackwardLeft = CFrame.new(-2,2,2),
            BackwardRight = CFrame.new(2,2,2),
            Height = 5
    
        },
        BarOffset = {
            TopRight = CFrame.new(2,2,0),
            Height = 5
    
        }
    },
    Mudskipper = {
        CustomName = "Saiah",
        BoxOffset = {
            TopLeft = CFrame.new(-2,2,0),
            TopRight = CFrame.new(2,2,0),
            BottomLeft = CFrame.new(-2,-3.5,0),
            BottomRight = CFrame.new(2,-3.5,0)
        },
        ThreeDBoxOffset = {
            ForwardLeft = CFrame.new(-2,2,-2),
            ForwardRight = CFrame.new(2,2,-2),
            BackwardLeft = CFrame.new(-2,2,2),
            BackwardRight = CFrame.new(2,2,2),
            Height = 5
    
        },
        BarOffset = {
            TopRight = CFrame.new(2,2,0),
            Height = 5
    
        }
    },
    Gigamed = {
        CustomName = "Extinct",
        BoxOffset = {
            TopLeft = CFrame.new(-2,2,0),
            TopRight = CFrame.new(2,2,0),
            BottomLeft = CFrame.new(-2,-3.5,0),
            BottomRight = CFrame.new(2,-3.5,0)
        },
        ThreeDBoxOffset = {
            ForwardLeft = CFrame.new(-2,2,-2),
            ForwardRight = CFrame.new(2,2,-2),
            BackwardLeft = CFrame.new(-2,2,2),
            BackwardRight = CFrame.new(2,2,2),
            Height = 5
    
        },
        BarOffset = {
        TopRight = CFrame.new(2,2,0),
        Height = 5
    
        }
    },
    ["King Gigamed"] = {
        CustomName = "Bruther",
        BoxOffset = {
            TopLeft = CFrame.new(-2,2,0),
            TopRight = CFrame.new(2,2,0),
            BottomLeft = CFrame.new(-2,-3.5,0),
            BottomRight = CFrame.new(2,-3.5,0)
        },
        ThreeDBoxOffset = {
            ForwardLeft = CFrame.new(-2,2,-2),
            ForwardRight = CFrame.new(2,2,-2),
            BackwardLeft = CFrame.new(-2,2,2),
            BackwardRight = CFrame.new(2,2,2),
            Height = 5
    
        },
        BarOffset = {
            TopRight = CFrame.new(2,2,0),
            Height = 5
    
        }
    }
    


}



function AddMobToESP(v)
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
        TopRight = CFrame.new(2,2,0),
        Height = 5

    }
    if CustomOffsetTable[MobName] ~= nil and _G.SillyNames == true then
        local Indexed = CustomOffsetTable[MobName]
        MobName = Indexed["CustomName"]
        BoxOffset = Indexed["BoxOffset"]
        ThreeDBoxOffset = Indexed["ThreeDBoxOffset"]
        BarOffset = Indexed["BarOffset"]
    end
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = MobName,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v  then
                    if v:FindFirstChild("HumanoidRootPart") then
                        return v.HumanoidRootPart.CFrame
                    elseif v:FindFirstChild("SpawnCF") then
                        return v.SpawnCF.Value
                    end
                end 
                return nil
            end,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v  and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = PassedTable.Data.ReturnMagnitude(v.HumanoidRootPart.CFrame)
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
                        Line3Text = "["..tostring(Round(MagnitudeChached)).."] "..Line3Text
                    end
                    if _G[PassedTable.GlobalVariableTable.ShowPosture] == true then
                        if v:FindFirstChild("BreakMeter") then
                            Line2Text = Line2Text.."P: "..tostring(CalcPercent(v.BreakMeter.Value,v.BreakMeter.MaxValue)).."% "
                        end 
                    end
                end
                return {Line1 = Line1Text,Line2 = Line2Text,Line3 = Line3Text} -- Dont change return!
            end,
            TextOffset = 0,
            Vector3Offset = Vector3.new(0,4,0),
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
        }


        
    }
    ESPBASE:AddESPObj(OptionTable)
end




for i,v in pairs(game.Workspace.Live:GetChildren()) do
    if game.Players:FindFirstChild(v.Name) == nil then
        print("d")
        AddMobToESP(v)
    end
end
game.Workspace.Live.ChildAdded:connect(function(v)
    if game.Players:FindFirstChild(v.Name) == nil then
        AddMobToESP(v)
    end
end)


game:GetService("UserInputService").InputBegan:connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.T then
        ESPBASE:Toggle()

    end

end)