local ReturnTabThing = {}
local player = game.Players.LocalPlayer
local HighlightFold = Instance.new("Folder",game.CoreGui)
local StopHighlight = false
local ButtonPressServ;
local PlayerAddServ;
print("Chams Script Etho v0.9!")

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
            HighLight.Adornee = v.Character
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
            Stop()
        end
    end)
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
            Cham(v,SettingsTab)
        end
    end
    PlayerAddServ = game.Players.PlayerAdded:connect(function(v)
        if v ~= player then
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
