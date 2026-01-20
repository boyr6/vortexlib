--// ADVANCED GUI LIBRARY V5 (TITAN EDITION)
--// Made for highest flexibility and aesthetics
local Library = {}
Library.__index = Library

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

--// Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Viewport = workspace.CurrentCamera.ViewportSize

--// File System (Exploit check)
local FS = {
	Enabled = (writefile and readfile and isfile and makefolder and listfiles and delfile),
	Folder = "TitanConfig"
}

--// Utils
local function GetType(obj)
	return obj.ClassName
end

local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		obj[k] = v
	end
	return obj
end

local function Tween(obj, info, props)
	TweenService:Create(obj, TweenInfo.new(unpack(info)), props):Play()
end

local function Ripple(obj)
	spawn(function()
		local Mouse = Players.LocalPlayer:GetMouse()
		local Circle = Instance.new("ImageLabel")
		Circle.Name = "Ripple"
		Circle.Parent = obj
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1.000
		Circle.BorderSizePixel = 0
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Circle.ImageTransparency = 0.8
		Circle.Position = UDim2.new(0, (Mouse.X - obj.AbsolutePosition.X), 0, (Mouse.Y - obj.AbsolutePosition.Y))
		Circle.Size = UDim2.new(0, 0, 0, 0)
		Circle.ZIndex = obj.ZIndex + 1

		local Size = obj.AbsoluteSize.X
		TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.new(0, (Mouse.X - obj.AbsolutePosition.X) - Size/2, 0, (Mouse.Y - obj.AbsolutePosition.Y) - Size/2), Size = UDim2.new(0, Size, 0, Size), ImageTransparency = 1}):Play()
		
		task.wait(0.6)
		Circle:Destroy()
	end)
end

--// Dragging & Resizing Logic
local function MakeDraggable(topbar, object)
	local Dragging, DragInput, DragStart, StartPos

	local function Update(input)
		local Delta = input.Position - DragStart
		local Goal = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		TweenService:Create(object, TweenInfo.new(0.05), {Position = Goal}):Play()
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function MakeResizable(handle, frame, minSize)
	local Resizing, ResizeStart, StartSize
	minSize = minSize or Vector2.new(300, 200)

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Resizing = true
			ResizeStart = input.Position
			StartSize = frame.AbsoluteSize
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Resizing = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = input.Position - ResizeStart
			local NewX = math.max(StartSize.X + Delta.X, minSize.X)
			local NewY = math.max(StartSize.Y + Delta.Y, minSize.Y)
			
			-- Smooth resize
			TweenService:Create(frame, TweenInfo.new(0.05), {Size = UDim2.new(0, NewX, 0, NewY)}):Play()
		end
	end)
end

--// Themes
Library.Themes = {
	Dark = {
		Main = Color3.fromRGB(20, 20, 25),
		Sidebar = Color3.fromRGB(25, 25, 30),
		Content = Color3.fromRGB(30, 30, 35),
		Text = Color3.fromRGB(240, 240, 240),
		TextDark = Color3.fromRGB(150, 150, 150),
		Accent = Color3.fromRGB(65, 120, 255),
		Outline = Color3.fromRGB(40, 40, 50),
		Risk = Color3.fromRGB(255, 80, 80)
	}
}
Library.CurrentTheme = Library.Themes.Dark

--// Main Window Function
function Library:Window(options)
	local TitleName = options.Title or "Titan Library"
	local ConfigName = options.Config or "Default"
	
	-- Main ScreenGui
	local GUI = Create("ScreenGui", {
		Name = "TitanGUI",
		Parent = RunService:IsStudio() and Player.PlayerGui or CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})
	
	-- Main Frame
	local Main = Create("Frame", {
		Name = "Main",
		Parent = GUI,
		BackgroundColor3 = Library.CurrentTheme.Main,
		Position = UDim2.new(0.5, -275, 0.5, -175),
		Size = UDim2.new(0, 550, 0, 350), -- Default Size
		BorderSizePixel = 0,
		ClipsDescendants = true
	})

	Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
	Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = Main})
	
	-- Header / Topbar
	local Topbar = Create("Frame", {
		Name = "Topbar",
		Parent = Main,
		BackgroundColor3 = Library.CurrentTheme.Sidebar,
		Size = UDim2.new(1, 0, 0, 40),
		BorderSizePixel = 0
	})
	Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Topbar})
	
	-- Fix bottom corners of topbar
	local TopbarFix = Create("Frame", {
		Parent = Topbar,
		BackgroundColor3 = Library.CurrentTheme.Sidebar,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,1,-5),
		Size = UDim2.new(1,0,0,5)
	})

	local Title = Create("TextLabel", {
		Parent = Topbar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(1, -30, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = TitleName,
		TextColor3 = Library.CurrentTheme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	-- Tab Container
	local TabContainer = Create("Frame", {
		Name = "TabContainer",
		Parent = Main,
		BackgroundColor3 = Library.CurrentTheme.Sidebar,
		Position = UDim2.new(0, 10, 0, 50),
		Size = UDim2.new(0, 140, 1, -60),
		BorderSizePixel = 0
	})
	Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabContainer})
	Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = TabContainer})

	local TabList = Create("UIListLayout", {
		Parent = TabContainer,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})
	Create("UIPadding", {Parent = TabContainer, PaddingTop = UDim.new(0,10)})

	-- Page Container
	local PageContainer = Create("Frame", {
		Name = "PageContainer",
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 160, 0, 50),
		Size = UDim2.new(1, -170, 1, -60),
	})

	-- Resize Handle
	local ResizeHandle = Create("ImageButton", {
		Name = "ResizeHandle",
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -15, 1, -15),
		Size = UDim2.new(0, 15, 0, 15),
		Image = "rbxassetid://9784732626", -- Diagonal arrow icon
		ImageColor3 = Library.CurrentTheme.TextDark,
		ZIndex = 10
	})

	-- Initialize Drag and Resize
	MakeDraggable(Topbar, Main)
	MakeResizable(ResizeHandle, Main)

	-- Window Logic
	local Window = {}
	local Tabs = {}
	local FirstTab = true

	function Window:Tab(name)
		local Tab = {}
		
		-- Tab Button
		local TabBtn = Create("TextButton", {
			Name = name,
			Parent = TabContainer,
			BackgroundColor3 = Library.CurrentTheme.Main,
			BackgroundTransparency = 1, -- Start transparent
			Size = UDim2.new(1, -20, 0, 32),
			Font = Enum.Font.GothamMedium,
			Text = name,
			TextColor3 = Library.CurrentTheme.TextDark,
			TextSize = 13,
			AutoButtonColor = false
		})
		Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

		-- Page Frame (Scrolling)
		local Page = Create("ScrollingFrame", {
			Name = name.."Page",
			Parent = PageContainer,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Library.CurrentTheme.Accent,
			Visible = false,
			CanvasSize = UDim2.new(0,0,0,0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		})
		
		local PageLayout = Create("UIListLayout", {
			Parent = Page,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		Create("UIPadding", {Parent = Page, PaddingRight = UDim.new(0,5), PaddingLeft = UDim.new(0,2)})

		-- Activation Logic
		local function Activate()
			-- Reset all tabs
			for _, t in pairs(TabContainer:GetChildren()) do
				if t:IsA("TextButton") then
					Tween(t, {0.2}, {BackgroundTransparency = 1, TextColor3 = Library.CurrentTheme.TextDark})
				end
			end
			for _, p in pairs(PageContainer:GetChildren()) do
				if p:IsA("ScrollingFrame") then p.Visible = false end
			end
			
			-- Activate current
			Tween(TabBtn, {0.2}, {BackgroundTransparency = 0, TextColor3 = Library.CurrentTheme.Accent})
			Page.Visible = true
		end

		TabBtn.MouseButton1Click:Connect(Activate)

		if FirstTab then
			Activate()
			FirstTab = false
		end

		--// Elements
		
		function Tab:Section(text)
			local SectionFrame = Create("Frame", {
				Parent = Page,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25)
			})
			Create("TextLabel", {
				Parent = SectionFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.GothamBold,
				Text = text,
				TextColor3 = Library.CurrentTheme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end

		function Tab:Button(text, callback)
			callback = callback or function() end
			local BtnFrame = Create("Frame", {
				Parent = Page,
				BackgroundColor3 = Library.CurrentTheme.Content,
				Size = UDim2.new(1, 0, 0, 38)
			})
			Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BtnFrame})
			Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = BtnFrame})

			local Btn = Create("TextButton", {
				Parent = BtnFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Library.CurrentTheme.Text,
				TextSize = 13
			})

			Btn.MouseButton1Click:Connect(function()
				Ripple(BtnFrame)
				callback()
			end)
		end

		function Tab:Toggle(text, default, callback)
			callback = callback or function() end
			local Toggled = default or false

			local ToggleFrame = Create("Frame", {
				Parent = Page,
				BackgroundColor3 = Library.CurrentTheme.Content,
				Size = UDim2.new(1, 0, 0, 38)
			})
			Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ToggleFrame})
			Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = ToggleFrame})

			local Label = Create("TextLabel", {
				Parent = ToggleFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(0, 200, 1, 0),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Library.CurrentTheme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Switch = Create("Frame", {
				Parent = ToggleFrame,
				BackgroundColor3 = Toggled and Library.CurrentTheme.Accent or Library.CurrentTheme.Sidebar,
				Position = UDim2.new(1, -45, 0.5, -10),
				Size = UDim2.new(0, 35, 0, 20)
			})
			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Switch})
			
			local Dot = Create("Frame", {
				Parent = Switch,
				BackgroundColor3 = Library.CurrentTheme.Text,
				Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				Size = UDim2.new(0, 16, 0, 16)
			})
			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})
			
			local Button = Create("TextButton", {
				Parent = ToggleFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			})

			Button.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				Ripple(ToggleFrame)
				
				Tween(Switch, {0.15}, {BackgroundColor3 = Toggled and Library.CurrentTheme.Accent or Library.CurrentTheme.Sidebar})
				Tween(Dot, {0.15}, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
				
				callback(Toggled)
			end)
		end

		function Tab:Slider(text, min, max, default, callback)
			callback = callback or function() end
			local Value = default or min
			
			local SliderFrame = Create("Frame", {
				Parent = Page,
				BackgroundColor3 = Library.CurrentTheme.Content,
				Size = UDim2.new(1, 0, 0, 50)
			})
			Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderFrame})
			Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = SliderFrame})

			Create("TextLabel", {
				Parent = SliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(1, -20, 0, 20),
				Font = Enum.Font.Gotham,
				Text = text,
				TextColor3 = Library.CurrentTheme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ValueLabel = Create("TextLabel", {
				Parent = SliderFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 5),
				Size = UDim2.new(1, -20, 0, 20),
				Font = Enum.Font.Gotham,
				Text = tostring(Value),
				TextColor3 = Library.CurrentTheme.TextDark,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right
			})

			local Bar = Create("Frame", {
				Parent = SliderFrame,
				BackgroundColor3 = Library.CurrentTheme.Sidebar,
				Position = UDim2.new(0, 10, 0, 30),
				Size = UDim2.new(1, -20, 0, 6)
			})
			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

			local Fill = Create("Frame", {
				Parent = Bar,
				BackgroundColor3 = Library.CurrentTheme.Accent,
				Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
			})
			Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
			
			local Clickpad = Create("TextButton", {
				Parent = Bar,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,1,0),
				Text = ""
			})
			
			local function Update(input)
				local SizeX = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				Tween(Fill, {0.05}, {Size = UDim2.new(SizeX, 0, 1, 0)})
				local Result = math.floor(min + ((max - min) * SizeX))
				ValueLabel.Text = tostring(Result)
				callback(Result)
			end
			
			local Dragging = false
			Clickpad.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = true
					Update(input)
				end
			end)
			
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
			end)
			
			UIS.InputChanged:Connect(function(input)
				if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					Update(input)
				end
			end)
		end
		
		function Tab:Dropdown(text, options, callback)
			callback = callback or function() end
			local Dropped = false
			local Selected = "None"
			local DropHeight = 38
			local ContentHeight = #options * 30
			
			local DropFrame = Create("Frame", {
				Parent = Page,
				BackgroundColor3 = Library.CurrentTheme.Content,
				Size = UDim2.new(1, 0, 0, DropHeight),
				ClipsDescendants = true
			})
			Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropFrame})
			Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = DropFrame})
			
			local Header = Create("TextButton", {
				Parent = DropFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
				Font = Enum.Font.Gotham,
				Text = text .. " : " .. Selected,
				TextColor3 = Library.CurrentTheme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			Create("UIPadding", {Parent = Header, PaddingLeft = UDim.new(0,10)})
			
			local Icon = Create("ImageLabel", {
				Parent = Header,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -30, 0.5, -8),
				Size = UDim2.new(0,16,0,16),
				Image = "rbxassetid://6034818372", -- Arrow Down
				ImageColor3 = Library.CurrentTheme.TextDark
			})
			
			local Container = Create("Frame", {
				Parent = DropFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 38),
				Size = UDim2.new(1, 0, 0, ContentHeight)
			})
			Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder})
			
			for _, opt in ipairs(options) do
				local OptBtn = Create("TextButton", {
					Parent = Container,
					BackgroundColor3 = Library.CurrentTheme.Content,
					Size = UDim2.new(1, 0, 0, 30),
					Font = Enum.Font.Gotham,
					Text = opt,
					TextColor3 = Library.CurrentTheme.TextDark,
					TextSize = 12,
					AutoButtonColor = false
				})
				
				OptBtn.MouseEnter:Connect(function() 
					Tween(OptBtn, {0.1}, {BackgroundColor3 = Library.CurrentTheme.Sidebar, TextColor3 = Library.CurrentTheme.Accent}) 
				end)
				OptBtn.MouseLeave:Connect(function() 
					Tween(OptBtn, {0.1}, {BackgroundColor3 = Library.CurrentTheme.Content, TextColor3 = Library.CurrentTheme.TextDark}) 
				end)
				
				OptBtn.MouseButton1Click:Connect(function()
					Selected = opt
					Header.Text = text .. " : " .. Selected
					callback(opt)
					-- Close
					Dropped = false
					Tween(DropFrame, {0.2}, {Size = UDim2.new(1, 0, 0, DropHeight)})
					Tween(Icon, {0.2}, {Rotation = 0})
				end)
			end
			
			Header.MouseButton1Click:Connect(function()
				Dropped = not Dropped
				Tween(DropFrame, {0.2}, {Size = Dropped and UDim2.new(1, 0, 0, DropHeight + ContentHeight) or UDim2.new(1, 0, 0, DropHeight)})
				Tween(Icon, {0.2}, {Rotation = Dropped and 180 or 0})
			end)
		end

		return Tab
	end
	
	--// Notification
	function Window:Notify(text, duration)
		duration = duration or 3
		local NotifyFrame = Create("Frame", {
			Parent = GUI,
			BackgroundColor3 = Library.CurrentTheme.Sidebar,
			Position = UDim2.new(1, 20, 1, -50), -- Start off screen
			Size = UDim2.new(0, 250, 0, 50),
			BorderSizePixel = 0
		})
		Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NotifyFrame})
		Create("UIStroke", {Color = Library.CurrentTheme.Outline, Thickness = 1, Parent = NotifyFrame})
		
		local Bar = Create("Frame", {
			Parent = NotifyFrame,
			BackgroundColor3 = Library.CurrentTheme.Accent,
			Position = UDim2.new(0,0,1,-2),
			Size = UDim2.new(1,0,0,2)
		})

		Create("TextLabel", {
			Parent = NotifyFrame,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,-2),
			Position = UDim2.new(0,10,0,0),
			Font = Enum.Font.GothamMedium,
			Text = text,
			TextColor3 = Library.CurrentTheme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		
		Tween(NotifyFrame, {0.3}, {Position = UDim2.new(1, -260, 1, -60)})
		
		task.delay(duration, function()
			Tween(NotifyFrame, {0.3}, {Position = UDim2.new(1, 20, 1, -60)})
			task.wait(0.3)
			NotifyFrame:Destroy()
		end)
	end

	return Window
end

--// EXAMPLE USAGE
--// Paste this below the library in your script

-- local Win = Library:Window({Title = "Titan Hub | Max Tier", Config = "MainCfg"})
-- local MainTab = Win:Tab("Main")
-- local VisualsTab = Win:Tab("Visuals")

-- MainTab:Section("Character")

-- MainTab:Toggle("WalkSpeed", false, function(v)
--     print("Speed Toggle:", v)
-- end)

-- MainTab:Slider("Speed Value", 16, 200, 16, function(v)
--     print("Speed Set:", v)
-- end)

-- MainTab:Dropdown("Weapons", {"M4A1", "AK-47", "Desert Eagle"}, function(v)
--     print("Selected:", v)
-- end)

-- VisualsTab:Button("Refresh ESP", function()
--     Win:Notify("Refreshed ESP!", 2)
-- end)

return Library
