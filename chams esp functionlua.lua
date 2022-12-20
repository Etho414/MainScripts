
local ChamFolder = Instance.new("Folder",game.CoreGui)
local enabled = true
function Cham(v)
    local Highlight = Instance.new("Highlight",ChamFolder)
    local ConnectTab = {}
    Highlight.Enabled = enabled
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 0
    
    ConnectTab[#ConnectTab + 1] = game:GetService("RunService").RenderStepped:connect(function()
        pcall(function()
            
            Highlight.Adornee = v.Character
        end)
    end) 
    ConnectTab[#ConnectTab + 1 ] = game.Players.PlayerRemoving:connect(function(chara)
        if chara == v then
            Highlight:Destroy()
            for i,v in pairs(ConnectTab) do
                v:Disconnect()
            end
        end
    
    end)
end 

for i,v in pairs(game.Players:GetChildren()) do
    if v ~= game.Players.LocalPlayer then
        Cham(v)
    end
end
game.Players.PlayerAdded:connect(function(v)
    print(v.Name.." Joined the GAME!!!")

    Cham(V)
end)
local function togglething()
    enabled = not enabled
    for i,v in pairs(ChamFolder:GetChildren()) do
        v.Enabled = enabled
    end
end

game:GetService("UserInputService").InputBegan:connect(function(key,gpe)
    if gpe then return end
    if key.KeyCode == Enum.KeyCode.P then
        
        togglething()
    end

end)