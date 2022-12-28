-- Notification Handler


local NotifTab = {}

local cam = game.Workspace.CurrentCamera



local BaseNotifPos = Vector2.new(cam.ViewportSize.X/ 19 ,cam.ViewportSize.Y / 2)
function CreateNotif(Contents, Duration)
    Contents = Contents or "retard"
    Duration = Duration or 3
    local NotifPos = #NotifTab
    local text = Drawing.new("Text")
    text.Visible = true
    text.Size = 50
    NotifTab[#NotifTab+ 1] = {Message = Contents,Dura = Duration, Pos = NotifPos, NotifText = text}
    print(#NotifTab)
    local function CreateText()
        
        text.Text = Contents
        text.Position = BaseNotifPos + Vector2.new(0 ,0 - (#NotifTab - 1) * text.TextBounds.y)
       
        wait(Duration)
        text.Visible = false
        table.remove(NotifTab,NotifPos)
        local function ReDrawNotifs()
            for i,v in pairs(NotifTab) do
                v.NotifText.Position = BaseNotifPos + Vector2.new(0,0 - i* v.NotifText.TextBounds.Y)
                print(i* v.NotifText.TextBounds.Y)
            end
        end
        ReDrawNotifs()
    end
    CreateText()
end
function Inter(con,dura)
    coroutine.wrap(CreateNotif)(con,dura)
end

local d = 0
while wait() do

    d = d + 1
    if d == 15 then break end
    wait(1)
    Inter("Owl spanwed check ESP",15)
end