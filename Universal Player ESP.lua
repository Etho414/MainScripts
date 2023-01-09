-- Universal Player ESP
--[[
    How to use ESPBASe to make universal player ESP



]]
-- ESP BASE REWRITE

print("gf")



--[[

    Shit to add

    REVERT TO OLD WAY OF DOING HP BARS, However use the new system of CFrame.Lookat, 
    Make Position Cached always Faced Upwards

]]



local ESPBASE = loadstring(game:HttpGet("https://raw.githubusercontent.com/Etho414/MainScripts/main/EspBaseRewrite!.lua", true))()


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
_G.WhitelistNames = {"GrenadeGrey"}
_G.WhitelistColor = Color3.fromRGB(255,0,0)
_G.UseTwoD = false -- true == 2d false == 3d
_G.ShowTeam  = true 
_G.UseLookAt = true 




function CalcPercent(min,max)
    return math.floor(((min / max) * 100) + 0.5)
end
function Round(n)
    return math.floor(n + 0.5)
end


ESPBASE:Toggle()

local player = game.Players.LocalPlayer
function AddPlayerESP(v)
    local OptionTable = {
        ToBeRemoved = false,
        Data = {
            ModdedName = "",
            ReturnTeamCheck = function()
                return (v.Team == player.Team)
            end,
            ReturnPosFunc = function(PassedTable) -- Make sure to return CFRAME
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    return v.Character.HumanoidRootPart.CFrame
                end 
                return nil
            end,
            ReturnLocalPlayerpos = function(PassedTable)
                if player and player.Character and player.Character.HumanoidRootPart then
                    return player.Character.HumanoidRootPart.Position
                end
            end,
            CalcStringFunction = function(PassedTable)
                local Line1Text = ""
                local Line2Text = ""
                local Line3Text = ""
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                    local MagnitudeChached = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
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
                return {Line1 = Line3Text,Line2 = Line2Text,Line3 = Line1Text} -- Dont change return!
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
            ShowTeam = "ShowTeam",
            UseLookAt = "UseLookAt"


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

game:GetService("UserInputService").InputBegan:connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.T then
        ESPBASE:Toggle()

    end

end)