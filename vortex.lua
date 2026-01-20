--// TITAN EDITION V5.2 (ULTIMATE)
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Global Settings
local ESP_Config = {
    Enabled = false,
    Chams = true,
    Names = true,
    Distance = true,
    Color = Color3.fromRGB(255, 80, 80)
}

--// Internal Utils
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function Tween(obj, info, props)
    TweenService:Create(obj, TweenInfo.new(unpack(info)), props):Play()
end

--// ESP Logic
local function CreateESP(target)
    if target == Player then return end
    
    local function Setup(char)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Chams (Highlights)
        local highlight = Create("Highlight", {
            Name = "TitanHighlight",
            Parent = char,
            FillColor = ESP_Config.Color,
            OutlineTransparency = 0,
            FillTransparency = 0.5
        })

        -- Billboard (Names/Dist)
        local billboard = Create("BillboardGui", {
            Name = "TitanTag",
            Parent = head,
            Size = UDim2.new(0, 100, 0, 50),
            StudsOffset = Vector3.new(0, 2, 0),
            AlwaysOnTop = true
        })
        
        local label = Create("TextLabel", {
            Parent = billboard,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 12,
            TextStrokeTransparency = 0
        })

        RunService.RenderStepped:Connect(function()
            if char.Parent and ESP_Config.Enabled then
                highlight.Enabled = ESP_Config.Chams
                highlight.FillColor = ESP_Config.Color
                label.Visible = ESP_Config.Names
                local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                label.Text = string.format("%s\n[%d studs]", target.Name, dist)
            else
                highlight.Enabled = false
                label.Visible = false
            end
        end)
    end
    Setup(target.Character)
    target.CharacterAdded:Connect(Setup)
end

--// Start ESP for everyone
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

--// Window Setup
function Library:Window(title)
    local GUI = Create("ScreenGui", {Name = "TitanV5", Parent = CoreGui})
    
    local Main = Create("Frame", {
        Name = "Main", Parent = GUI,
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    Create("UIStroke", {Color = Color3.fromRGB(45, 45, 50), Thickness = 2, Parent = Main})

    -- Topbar (Feature 2: Minimize/Close integrated)
    local Topbar = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Topbar})

    local Title = Create("TextLabel", {
        Parent = Topbar, Text = "  " .. title,
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Navigation
    local Nav = Create("Frame", {
        Parent = Main, Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 150, 1, -60), BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    })
    Create("UICorner", {Parent = Nav})
    local NavList = Create("UIListLayout", {Parent = Nav, Padding = UDim.new(0, 5)})

    local PageContainer = Create("Frame", {
        Parent = Main, Position = UDim2.new(0, 170, 0, 50),
        Size = UDim2.new(1, -180, 1, -60), BackgroundTransparency = 1
    })

    local Window = {}

    function Window:Tab(name)
        local TabBtn = Create("TextButton", {
            Parent = Nav, Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            Text = name, TextColor3 = Color3.new(0.7, 0.7, 0.7),
            Font = Enum.Font.Gotham, BackgroundTransparency = 1
        })

        local Page = Create("ScrollingFrame", {
            Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = false,
            ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,2,0)
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 10)})

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)

        local Tab = {}

        -- Feature: Multi-functional Toggle
        function Tab:Toggle(text, callback)
            local Enabled = false
            local TFrame = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            })
            Create("UICorner", {Parent = TFrame})
            
            local TBtn = Create("TextButton", {
                Parent = TFrame, Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, Text = "  " .. text,
                TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Indicator = Create("Frame", {
                Parent = TFrame, Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 35, 0, 20), BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

            TBtn.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Tween(Indicator, {0.2}, {BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(50, 50, 55)})
                callback(Enabled)
            end)
        end

        -- Feature: Color Picker
        function Tab:ColorPicker(text, default, callback)
            local Frame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
            Create("UICorner", {Parent = Frame})
            local Lbl = Create("TextLabel", {Parent = Frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "  "..text, TextColor3 = Color3.new(1,1,1), TextXAlignment = Enum.TextXAlignment.Left})
            local Pick = Create("TextButton", {Parent = Frame, Position = UDim2.new(1, -30, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = default, Text = ""})
            
            Pick.MouseButton1Click:Connect(function()
                local newCol = Color3.fromHSV(tick()%5/5, 1, 1)
                Pick.BackgroundColor3 = newCol
                callback(newCol)
            end)
        end

        return Tab
    end
    
    -- Feature: Notifications
    function Window:Notify(msg)
        local N = Create("Frame", {Parent = GUI, Position = UDim2.new(1, 10, 1, -60), Size = UDim2.new(0, 200, 0, 40), BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
        Create("UICorner", {Parent = N})
        Create("TextLabel", {Parent = N, Size = UDim2.new(1, 0, 1, 0), Text = msg, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1})
        Tween(N, {0.5}, {Position = UDim2.new(1, -210, 1, -60)})
        task.delay(3, function() Tween(N, {0.5}, {Position = UDim2.new(1, 10, 1, -60)}) end)
    end

    PageContainer.ChildAdded:Connect(function(c) if #PageContainer:GetChildren() == 1 then c.Visible = true end end)
    return Window
end

--// EXECUTION
local Win = Library:Window("TITAN V5.2 | PRO")
local ESPTab = Win:Tab("ESP / Visuals")
local Settings = Win:Tab("Settings")

ESPTab:Toggle("Master ESP", function(v) ESP_Config.Enabled = v end)
ESPTab:Toggle("Highlight Chams", function(v) ESP_Config.Chams = v end)
ESPTab:Toggle("Show Names", function(v) ESP_Config.Names = v end)
ESPTab:ColorPicker("ESP Color", ESP_Config.Color, function(c) ESP_Config.Color = c end)

Settings:Toggle("Rainbow UI", function(v) 
    Win:Notify("Rainbow UI " .. (v and "Enabled" or "Disabled"))
end)

Win:Notify("Welcome, " .. Player.Name)
