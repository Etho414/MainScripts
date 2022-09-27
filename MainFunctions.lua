local tab = {
	UIFunctions = {},
	MathOperation = {},
	StringManip = {}
	
	
}


function tab.UIFunctions:Ripple(UIInstance,Duration,Zin)
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
	UI.BackgroundColor3 = Color3.fromRGB(0,0,0)
	UI.Name = "Ripple"
	Zin = Zin or 1
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