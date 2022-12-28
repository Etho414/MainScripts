local ReturnTabThing = {}
local player;
local HighlightFold = Instance.new("Folder")
syn.protect_gui(HighlightFold)
HighlightFold.Parent = game.CoreGui
local StopHighlight = false
local ButtonPressServ;
local PlayerAddServ;

repeat wait(); player = game.Players.LocalPlayer until player and player.Name and player.Parent
repeat wait() until game.Players
repeat wait() until #game.Players:GetChildren() ~= 0



_G.StopGlobalEthoChams = false

if _G.RanEthoChams == true then
    _G.StopGlobalEthoChams = true
    wait(1)
    _G.StopGlobalEthoChams = false
end

_G.RanEthoChams = true 

function Cham(v,SettingsTab)
    local RunServ;
    local PlayerRemoveServ;
    local HighLight = Instance.new("Highlight",HighlightFold)

    local function Stop()
        PlayerRemoveServ:Disconnect()
        RunServ:Disconnect() 
        HighLight:Destroy()
        PlayerAddServ:Disconnect()
        if _G.StopGlobalEthoChams == true then
            ButtonPressServ:Disconnect()

        end
    end
    RunServ = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        pcall(function()
            if v.Character and HighLight.Adornee ~= v.Character then
                print("Adorneed",v)
                HighLight.Adornee = v.Character
            end
            
            HighLight.Enabled = not StopHighlight
            HighLight.FillTransparency = _G[SettingsTab.FillGlobal]
            HighLight.OutlineTransparency = _G[SettingsTab.OutlineGlobal]
            HighLight.FillColor = _G[SettingsTab.FillColor]
            HighLight.OutlineColor = _G{SettingsTab.OutlineColor}
        end)
        if _G.StopGlobalEthoChams == true then Stop() end
    end)
    
    PlayerRemoveServ = game:GetService("RunService").RenderStepped:connect(function(v2)
        if v2 == v then
            print(v2 == v, "Remove Serv",v2,v)
            RunServ:Disconnect()
            PlayerRemoveServ:Disconnect()
            HighLight:Destroy()
        end
    end)
    print("Added "..v.Name.." To Cham Thing")
end
function ToggleCham(TogVal)
    if TogVal == true then
        StopHighlight = false
    else
        StopHighlight = true
    end
end






function ReturnTabThing:InitChams(SettingsTab)
    local ChamsToggle = true
    ToggleCham(ChamsToggle)
    for i,v in pairs(game.Players:GetChildren()) do 
        if v ~= player then   
            print(v)
            Cham(v,SettingsTab)
        end
    end
    PlayerAddServ = game.Players.PlayerAdded:connect(function(v)
        if v ~= player then
            print("Adding "..v.Name.." To CHAM!")
            Cham(v,SettingsTab)
        end
    end)
    ButtonPressServ = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode[string.upper(_G[SettingsTab.ToggleKey])] then
            ChamsToggle = not ChamsToggle
            ToggleCham(ChamsToggle,SettingsTab)
        end
    end)
end



return ReturnTabThing
