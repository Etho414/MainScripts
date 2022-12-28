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
    local HighLight = Instance.new("Highlight")
    HighLight.Parent = HighlightFold
    local HoldChildrenNum = 0
    local function Stop()
        PlayerRemoveServ:Disconnect()
        RunServ:Disconnect() 
        HighLight.Enabled = false
        HighLight:Destroy()
        PlayerAddServ:Disconnect()
        if _G.StopGlobalEthoChams == true then
            ButtonPressServ:Disconnect()    

        end
    end
    local function RefreshHighlight(hl)
        hl.Adornee = nil
        hl.Adornee = v.Character
    
    end
    RunServ = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
            if v.Character and HighLight.Adornee ~= v.Character then
                HoldChildrenNum = #v.Character:GetChildren()
                HighLight.Adornee = v.Character
            end
            if v.Character and HighLight.Adornee == v.Character then
                if HoldChildrenNum ~= #v.Character:GetChildren() then
                    HoldChildrenNum = #v.Character:GetChildren()
                    RefreshHighlight(HighLight)
                end
            end
            HighLight.Enabled = not StopHighlight
            HighLight.FillTransparency = _G[SettingsTab.FillTransVal]
            HighLight.OutlineTransparency = _G[SettingsTab.OutlineGlobal]
            HighLight.FillColor = _G[SettingsTab.FillColor]
            HighLight.OutlineColor = _G[SettingsTab.OutlineColor]
        if _G.StopGlobalEthoChams == true then Stop() end
    end)
    
    PlayerRemoveServ = game:GetService("RunService").RenderStepped:connect(function(v2)
        if v2 == v then
            RunServ:Disconnect()
            PlayerRemoveServ:Disconnect()
            HighLight:Destroy()
        end
    end)
end
function ReturnTabThing:ToggleCham(TogVal)
    if TogVal == true then
        StopHighlight = false
    else
        StopHighlight = true
    end
end






function ReturnTabThing:InitChams(SettingsTab)
    local ChamsToggle = true
    ReturnTabThing:ToggleCham(ChamsToggle)
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
    if SettingsTab.ToggleKey and SettingsTab.ToggleKey ~= "" then
        ButtonPressServ = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            if input.KeyCode == Enum.KeyCode[string.upper(_G[SettingsTab.ToggleKey])] then
                ChamsToggle = not ChamsToggle
                ReturnTabThing:ToggleCham(ChamsToggle,SettingsTab)
            end
        end)
    end
end



return ReturnTabThing
