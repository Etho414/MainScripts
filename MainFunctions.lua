local tab = {
	UIFunctions = {},
	MathOperation = {},
	StringManip = {},
	Misc = {}
	
	
}

local HoldInstance = {}
local CollideAll = false
function tab.Misc:CollideAllTog()
	if CollideAll == false then
		CollideAll = true
		for i,v in pairs(game.Workspace:GetDescendants()) do
			if v.CanCollide == true and v:IsA("BasePart") then
				HoldInstance[#HoldInstance+1] = v
				v.CanCollide = false

			end

		end
	else
		CollideAll = false
		wait(0.1)
		for i,v in pairs(HoldInstance) do
			v.CanCollide = true
			
		end
		HoldInstance = {}
	end


end
game.Workspace.DescendantAdded:Connect(function(descendant)
	if CollideAll == true then
		if descendant.CanCollide == true and descendant:IsA("BasePart") then
			HoldInstance[#HoldInstance+1] = descendant
			descendant.CanCollide = false
		end
	end
end)
function tab.Misc:SendChat(str)
		wait(0.1)
		local vim = game:GetService("VirtualInputManager")
		local plrs = game:GetService("Players")
		local bar = plrs.LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
	   
		bar.Text = ""
		bar:CaptureFocus()
		for i = 1, #str do
			vim:SendTextInputCharacterEvent(string.sub(str, i, i), nil)
		end
		task.wait(0.06)
		keypress(0x0D)
	

end


function tab.Misc:Check(v,...)
	if v and v.Character and v.Character:FindFirstChild("Humanoid") == true then
		local args = {...}
		if #args == 0 then
			return true
		end
		local val = true 
		for i,v in pairs(args) do
			if not v then
				val = false
			end
		end		
		return val
	else
		return false
	end
end



function tab.UIFunctions:Ripple(UIInstance,Duration,Color,Zin)
	Color = Color or Color3.fromRGB(0,0,0)
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local function Tween(Obj,Goal)
		game:GetService("TweenService"):Create(Obj,TweenInfo.new(Duration),Goal):Play()
	end
	UIInstance.ClipsDescendants = true
	local ASX,ASY = UIInstance.AbsoluteSize.X, UIInstance.AbsoluteSize.Y
	local APX,APY = UIInstance.AbsolutePosition.X, UIInstance.AbsolutePosition.Y
	local MX,MY = Mouse.X,Mouse.Y
	local Pos = UDim2.new(0,MX-APX,0,MY-APY)
	local UBC3 = UIInstance.BackgroundColor3
	local UR,UG,UB = UBC3.R, UBC3.G, UBC3.B

	local UI = Instance.new("Frame",UIInstance)
	UI.BackgroundColor3 = Color
	UI.Name = "Ripple"
	Zin = Zin or 2
	UI.ZIndex = Zin

	local Corner = Instance.new("UICorner",UI)
	Corner.CornerRadius = UDim.new(1,0)

	UI.AnchorPoint = Vector2.new(0.5,0.5)
	UI.Position = Pos

	local MS = UDim2.fromOffset(math.max(ASX,ASY),math.max(ASX,ASY))

	UI:TweenSize(MS,"Out","Sine",Duration)
	Tween(UI,{BackgroundTransparency = 1})

	wait(Duration)
	UI:Destroy()
end

function tab.UIFunctions:Dragify(MainFrame)
	local dragging
	local dragInput
	local dragStart
	local startPos
    local Delta
    local Position
	local function update(input)
		Delta = input.Position - dragStart
		Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(.15), {Position = Position}):Play()
	end

	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	MainFrame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end
	
function tab.StringManip:FindPlayer(name)
	for i,v in pairs(game.Players:GetPlayers()) do 
		if v.Name:lower():sub(1,#name) == name:lower() then	
			return v 
		end
	end
end
function tab.StringManip:SortLength(tab)
	table.sort(tab, function(a,b) return #a>#b end)
end

return tab

