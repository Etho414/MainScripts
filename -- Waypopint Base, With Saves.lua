-- Waypopint Base, With Saves
local player;
repeat wait(); player = game.Players.LocalPlayer until player and player.Name and player.Parent
local ConnectionTable = {}
local WaypointTable = {}
local GameId = game.GameId
function Teleport(PositionValue)
    if player and player.Character and player.Character.HumanoidRootPart then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(PositionValue.x,PositionValue.y,PositionValue.z)
    end
end
if isfolder("Etho") == false then
    makefolder("Etho")
end
if isfolder("Etho/Waypoints") == false then
    makefolder("Etho/Waypoints")
end

function CreateSaveFile()
    local TableStringed = "{"
    for i,v in pairs(WaypointTable) do
        TableStringed = TableStringed.."\n{Position = Vector3.new("..tostring(v.Position).."),\nName = "..v.Name..",\nKeybind = "..v.Keybind.."}"
        if i ~= #WaypointTable then
            TableStringed = TableStringed..", "
        end
    end
    TableStringed = TableStringed.."\n}"
    writefile("Etho/Waypoints/"..tostring(GameId)..".txt",TableStringed)
end

function AddWayPoint(Settings)
    local Keybind = Settings.Keybind
    local WaypointName = Settings.Name
    local WaypointPosition = Settings.Position
    local KeybindPosition = #ConnectionTable + 1 
    local CLickPosition = #ConnectionTable + 2 
    local RemoveCheckPosition = #ConnectionTable + 3
    local SettingsTablePosition =   # WaypointTable + 1 
    WaypointTable[SettingsTablePosition] = Settings

    CreateSaveFile()


end
AddWayPoint({Name = "daddy",Position = Vector3.new(0,9,0),Keybind = "K"})

--[[

    local Settings = {
        Position = Vector3.new(),
        Name = "Yuri is hardstuck masters dogshit",
        Keybind = "d"
    }

]]
