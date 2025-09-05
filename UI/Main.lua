local API = {
    Categories = {},
    MainBKG = {
        Hue = 0.70,
        Sat = 1,
        Value = 0.27,
    },
    UIColor = {
        Hue = 0.58,
        Sat = 1,
        Value = 1,
    },
    UIColor2 = {
		Hue = 0.65,
		Sat = 1,
		Value = 1
	},
    Modules = {},
    Keybind = { 'RightShift' },
    Loaded = false,
    ColorUpdate = Instance.new('BindableEvent'),
    Libraries = {},
    Place = game.PlaceId,
    Profile = 'Galaxy',
    Profiles = {},
    RainbowSpeed = { Value = 1 },
    RainbowUpdateSpeed = { Value = 60 },
    RainbowTable = {},
    Scale = { Value = 1 },
    --ThreadFix = setthreadidentity and true or false,
    ToggleNotifications = {},
    BlatantMode = {},
    Version = '1.0',
}

local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local textservice = game:GetService('TextService')
local HttpService = game:GetService('HttpService')

local lplr = Players.LocalPlayer
local playerGui = lplr:WaitForChild('PlayerGui')

if
    UserInputService.TouchEnabled
    and not UserInputService.KeyboardEnabled
    and not UserInputService.MouseEnabled
then
    lplr:Kick(
        "Mobile not supported, maybe in the future i'll add mobile support. 🤷‍♂"
    )
end

local Config = {}
local ConfigSystem = {}

ConfigSystem.CanSave = true
local FilePath = 'Galaxy/Configs/' .. game.PlaceId .. '.json'
function ConfigSystem:Save_Config()
    if not ConfigSystem.CanSave then
        return
    end
    if isfile(FilePath) then
        delfile(FilePath)
    end
    writefile(FilePath, HttpService:JSONEncode(Config))
end
function ConfigSystem:Load_Config()
    if isfile(FilePath) then
        Config = HttpService:JSONDecode(readfile(FilePath))
    end
end

local function HSVToColor3(h, s, v)
    return Color3.fromHSV(h, s, v)
end

local color = {}
local uipal = {
	Main = Color3.fromRGB(10,10,10),
	warn = Color3.fromRGB(255, 150, 2),
	alert = Color3.fromRGB(255, 72, 0),
	headerBg = Color3.fromHSV(API.MainBKG.Hue, API.MainBKG.Sat, API.MainBKG.Value),
	ModuleOn = Color3.fromHSV(API.UIColor.Hue, API.UIColor.Sat, API.UIColor.Value),
    ModuleOn2 = Color3.fromHSV(API.UIColor2.Hue, API.UIColor2.Sat, API.UIColor2.Value),
	text = Color3.fromRGB(200,200,200),
	tipBg = Color3.fromRGB(15, 15, 15),
	Font = Font.fromEnum(Enum.Font.GothamBold),
	TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local Gradient = ColorSequence.new{
	ColorSequenceKeypoint.new(0, uipal.ModuleOn),
	ColorSequenceKeypoint.new(0.5, uipal.ModuleOn),
	ColorSequenceKeypoint.new(1, uipal.ModuleOn2)
}

local function roundify(gui, r)
    local c = Instance.new('UICorner')
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = gui
end

local Root = Instance.new('ScreenGui')
Root.Name = 'Root'
Root.ResetOnSpawn = false
Root.IgnoreGuiInset = true
Root.Parent = playerGui

local ClickGUI = Instance.new('Frame')
ClickGUI.Name = 'ClickGUI'
ClickGUI.Size = UDim2.new(1, 0, 1, 0)
ClickGUI.BackgroundTransparency = 1
ClickGUI.Visible = false
ClickGUI.Parent = Root

local blur = Instance.new('BlurEffect')
blur.Parent = game.Lighting
blur.Enabled = false

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
fontsize.Font = uipal.Font

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos = false

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            frame.Position.X.Scale,
            startPos.X.Offset + delta.X,
            frame.Position.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseMovement
            and dragging
        then
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseMovement
            and dragging
        then
            update(input)
        end
    end)
end

local function TextSize(text, size)
    return textservice:GetTextSize(text, size, Enum.Font.Arial, Vector2.zero).X
end

function color.Dark(col, num)
    local h, s, v = col:ToHSV()
    return Color3.fromHSV(
        h,
        s,
        math.clamp(
            select(3, uipal.Main:ToHSV()) > 0.5 and v + num or v - num,
            0,
            1
        )
    )
end

function color.Light(col, num)
    local h, s, v = col:ToHSV()
    return Color3.fromHSV(
        h,
        s,
        math.clamp(
            select(3, uipal.Main:ToHSV()) > 0.5 and v - num or v + num,
            0,
            1
        )
    )
end

local GalaxyWatermark = Instance.new("TextLabel")
GalaxyWatermark.Name = "GalaxyWaterMark"
GalaxyWatermark.Size = UDim2.new(0, 60, 0, 65)
GalaxyWatermark.Position = UDim2.new(0, 75, 0, 40)
GalaxyWatermark.BackgroundColor3 = uipal.headerBg
GalaxyWatermark.TextColor3 = uipal.text
GalaxyWatermark.FontFace = uipal.Font
GalaxyWatermark.BackgroundTransparency = 1
GalaxyWatermark.TextSize = 35
GalaxyWatermark.Text = "Galaxy"
GalaxyWatermark.TextXAlignment = Enum.TextXAlignment.Center
GalaxyWatermark.BorderSizePixel = 0
GalaxyWatermark.Parent = Root

local GalaxyWatermarkGradient = Instance.new("UIGradient")
GalaxyWatermarkGradient.Enabled = true
GalaxyWatermarkGradient.Parent = GalaxyWatermark
GalaxyWatermarkGradient.Name = "GalaxyWatermarkGradient"
GalaxyWatermarkGradient.Color = Gradient

local ArrayItems = {}

local ArrayListFrame = Instance.new("Frame", Root)
ArrayListFrame.Size = UDim2.fromScale(0.2, 0.7)
ArrayListFrame.Name = "ArrayListFrame"
ArrayListFrame.Position = UDim2.fromScale(0.79, 0.05)
ArrayListFrame.BackgroundTransparency = 1
ArrayListFrame.Visible = true

local ArrayListFrameSorter = Instance.new("UIListLayout")
ArrayListFrameSorter.Parent = ArrayListFrame
ArrayListFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
ArrayListFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
ArrayListFrameSorter.Padding = UDim.new(0, 0.9)

local Arraylistmover = Instance.new("TextLabel")
Arraylistmover.Name = "Arraylistmover"
Arraylistmover.Size = UDim2.new(0, 250, 0, 40)
Arraylistmover.BackgroundColor3 = uipal.headerBg
Arraylistmover.TextColor3 = color.Dark(uipal.text, 0.3)
Arraylistmover.FontFace = uipal.Font
Arraylistmover.TextSize = 14
Arraylistmover.Text = "Module List"
Arraylistmover.TextXAlignment = Enum.TextXAlignment.Center
Arraylistmover.Visible = false
Arraylistmover.BorderSizePixel = 0
Arraylistmover.Parent = ArrayListFrame

local arraylistlabel = Instance.new("TextLabel")
arraylistlabel.Name = "Arraylistlabel"
arraylistlabel.Size = UDim2.new(0, 75, 0, 40)
arraylistlabel.BackgroundColor3 = uipal.headerBg
arraylistlabel.TextColor3 = uipal.text
arraylistlabel.FontFace = uipal.Font
arraylistlabel.BackgroundTransparency = 1
arraylistlabel.TextSize = 50
arraylistlabel.Text = "Galaxy"
arraylistlabel.TextXAlignment = Enum.TextXAlignment.Right
--arraylistlabel.Visible = false
arraylistlabel.BorderSizePixel = 0
arraylistlabel.Parent = ArrayListFrame

local ArrayGradient = Instance.new("UIGradient")
ArrayGradient.Enabled = true
ArrayGradient.Parent = arraylistlabel
ArrayGradient.Name = "ArrayGradient"
ArrayGradient.Color = Gradient
roundify(Arraylistmover, 6)
makeDraggable(ArrayListFrame, Arraylistmover)

local ArrayList = {
	Create = function(Name)
		local Item = Instance.new("TextLabel")
		Item.Parent = ArrayListFrame
		Item.Name = Name.."_Array"
		Item.Text = Name
		Item.BorderSizePixel = 0
		Item.TextSize = 20
		Item.TextColor3 = Color3.new(1, 1, 1) -- text stays normal, gradient goes on Line
		Item.BackgroundTransparency = 1
		Item.FontFace = uipal.Font

		-- The line with gradient
		local Line = Instance.new("Frame")
		Line.Name = "Line"
		Line.Size = UDim2.new(0, 5, 0.7, 0)
		Line.Parent = Item
		Line.BorderSizePixel = 0
		Line.Visible = true
		Line.BackgroundColor3 = uipal.text
		Line.Position = UDim2.fromScale(1,0.2)
		roundify(Line, 25)

		local uiGradient = Instance.new("UIGradient")
		uiGradient.Color = Gradient
		uiGradient.Rotation = 90 -- vertical movement
		uiGradient.Parent = Item
		
		local ui2Gradient = Instance.new("UIGradient")
		ui2Gradient.Color = Gradient
		ui2Gradient.Rotation = 90 -- vertical movement
		ui2Gradient.Parent = Line

		local size = TextSize(Name, 23)
		Item.Size = UDim2.new(0.03, size, 0.048, 0)

		ArrayItems[Name] = Item

		-- Sort array
		local SortedArray = {}
		for _, v in pairs(ArrayItems) do
			table.insert(SortedArray, v)
		end
		table.sort(SortedArray, function(a, b)
			return TextSize(a.Text, a.TextSize) > TextSize(b.Text, b.TextSize)
		end)
		for i, v in ipairs(SortedArray) do
			v.LayoutOrder = i
		end
	end,

	Remove = function(Name)
		if ArrayItems[Name] then
			ArrayItems[Name]:Destroy()
			ArrayItems[Name] = nil
		end
	end,
}

local settingsholderframe = Instance.new('Frame')
settingsholderframe.Size = UDim2.new(1, -10, 0, 425)
settingsholderframe.Position = UDim2.new(0, 0, 0, 575)
settingsholderframe.BackgroundColor3 = uipal.Main
settingsholderframe.BorderSizePixel = 0
settingsholderframe.BackgroundTransparency = 1
settingsholderframe.Name = 'SettingsHolder'
settingsholderframe.Parent = ClickGUI

local settingholderframesorter = Instance.new('UIListLayout')
settingholderframesorter.Padding = UDim.new(0, 10)
settingholderframesorter.Parent = settingsholderframe
--settingholderframesorter.SortOrder = Enum.SortOrder.LayoutOrder
settingholderframesorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
settingholderframesorter.FillDirection = Enum.FillDirection.Horizontal

-- MAIN PANEL (LEFT SIDE)
local mainPanel = Instance.new('Frame')
mainPanel.Size = UDim2.new(0, 225, 0, 450)
mainPanel.Position = UDim2.new(0, 20, 0, 100)
mainPanel.BackgroundColor3 = uipal.Main
mainPanel.BorderSizePixel = 0
mainPanel.Name = 'MainPanel'
mainPanel.Parent = ClickGUI
roundify(mainPanel, 13)

local mpheader = Instance.new('TextLabel')
mpheader.Text = '     Galaxy'
mpheader.Size = UDim2.new(1, 0, 0, 50)
mpheader.BackgroundTransparency = 0
mpheader.BackgroundColor3 = uipal.headerBg
mpheader.Name = 'MPHeader'
mpheader.TextXAlignment = Enum.TextXAlignment.Left
mpheader.TextColor3 = uipal.text
mpheader.FontFace = uipal.Font
mpheader.Position = UDim2.new(0, 0, 0, 0)
mpheader.TextSize = 18
mpheader.LayoutOrder = 1
mpheader.Parent = mainPanel
roundify(mpheader, 13)
makeDraggable(mainPanel, mpheader)

local mpheader2 = Instance.new('Frame')
mpheader2.Name = 'MPHeader2'
mpheader2.Size = UDim2.new(1, 0, 0, 10)
mpheader2.Position = UDim2.new(0, 0, 0, 40)
mpheader2.BackgroundColor3 = uipal.headerBg
mpheader2.BorderSizePixel = 0
mpheader2.Parent = mainPanel

-- Inner container for category buttons
local categoryContainer = Instance.new('Frame')
categoryContainer.Size = UDim2.new(1, -20, 0, 200)
categoryContainer.Position = UDim2.new(0, 10, 0, 75)
categoryContainer.BackgroundColor3 = uipal.headerBg
categoryContainer.BorderSizePixel = 0
categoryContainer.Name = 'CategoryContainer'
categoryContainer.Parent = mainPanel
roundify(categoryContainer, 13)

local categoryLayout = Instance.new('UIListLayout')
categoryLayout.Padding = UDim.new(0, 0)
categoryLayout.FillDirection = Enum.FillDirection.Vertical
categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
categoryLayout.Parent = categoryContainer

-- Footer for Configs & Settings
local footer = Instance.new('Frame')
footer.Size = UDim2.new(1, -20, 0, 80)
footer.Position = UDim2.new(0, 10, 1, -110)
footer.BackgroundColor3 = uipal.headerBg
footer.Name = 'Footer'
footer.BackgroundTransparency = 0
footer.Parent = mainPanel
roundify(footer, 13)

local footerLayout = Instance.new('UIListLayout')
footerLayout.Padding = UDim.new(0, 0)
footerLayout.FillDirection = Enum.FillDirection.Vertical
footerLayout.SortOrder = Enum.SortOrder.LayoutOrder
footerLayout.Parent = footer

local seperator = Instance.new('Frame')
seperator.Parent = mainPanel
seperator.Size = UDim2.new(1, -65, 0, 1)
seperator.Position = UDim2.new(0, 35, 0, 379.5)
seperator.BorderSizePixel = 0
seperator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
seperator.BackgroundTransparency = 0.5
roundify(seperator, 10)

local seperator2 = Instance.new('Frame')
seperator2.Parent = mainPanel
seperator2.Size = UDim2.new(1, -65, 0, 1)
seperator2.Position = UDim2.new(0, 35, 0, 380.5)
seperator2.BorderSizePixel = 0
seperator2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
seperator2.BackgroundTransparency = 0.5
roundify(seperator2, 10)

-- CATEGORY BUTTON CREATION
local function createCategoryButton(category)
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = uipal.headerBg
    btn.Name = category.Name .. '_PanelOpener'
    btn.TextColor3 = uipal.text
    btn.FontFace = uipal.Font
    btn.Visible = true --category.V
    btn.TextSize = 14
    btn.Text = '            ' .. category.Name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = category.Parent
    btn.BorderSizePixel = 0
    roundify(btn, 13)

    local Icon = Instance.new('ImageLabel')
    Icon.Name = 'Icon'
    Icon.Size = UDim2.new(0, 23, 0, 23)
    Icon.Position = UDim2.new(0, 10, 0, 9)
    Icon.Image = category.Icon
    Icon.BackgroundColor3 = uipal.text
    Icon.BackgroundTransparency = 1
    Icon.BorderSizePixel = 0
    Icon.Parent = btn

    local visible = false
    btn.MouseButton1Click:Connect(function()
        visible = not visible
        TweenService:Create(
            btn,
            uipal.TWEEN,
            { TextColor3 = visible and uipal.ModuleOn or uipal.text }
        ):Play()
        TweenService:Create(
            Icon,
            uipal.TWEEN,
            { ImageColor3 = visible and uipal.ModuleOn or uipal.text }
        ):Play()
        category._panel.Visible = visible
    end)
end

ConfigSystem:Load_Config()

-- ========== CATEGORY CREATION ==========
function API:CreateCategory(categorysettings)
    local category = {}
    category.Name = categorysettings.name
    category.Icon = categorysettings.Icon
    category.open = false
    category.Parent = categorysettings.Parent

    -- Panel
    local panel = Instance.new('Frame')
    panel.Name = categorysettings.name .. '_Panel'
    panel.Size = UDim2.new(0, 225, 0, 450)
    panel.Position = UDim2.new(
        0,
        categorysettings.posX or 200,
        0,
        categorysettings.posY or 140
    )
    panel.BackgroundColor3 = uipal.Main
    panel.BorderSizePixel = 0
    panel.AutomaticSize = Enum.AutomaticSize.Y
    panel.Visible = false -- hidden by default
    panel.Parent = ClickGUI
    panel.ClipsDescendants = false
    roundify(panel, 13)

    local header = Instance.new('TextLabel')
    header.Name = 'Header'
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = uipal.headerBg
    header.TextColor3 = uipal.text
    header.FontFace = uipal.Font
    header.TextSize = 18
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = '          ' .. categorysettings.name
    header.BorderSizePixel = 0
    header.Parent = panel
    roundify(header, 13)
    makeDraggable(panel, header)

    local header2 = Instance.new('Frame')
    header2.Name = 'Header'
    header2.Size = UDim2.new(1, 0, 0, 5)
    header2.BackgroundColor3 = uipal.headerBg
    header2.BorderSizePixel = 0
    header2.Position = UDim2.new(0, 0, 0, 45)
    header2.Parent = panel
    roundify(header2, 13)
    makeDraggable(panel, header)

    local Icon = Instance.new('ImageLabel')
    Icon.Name = 'Icon'
    Icon.Size = UDim2.new(0, 22, 0, 22)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.Image = categorysettings.Icon
    Icon.BackgroundColor3 = uipal.text
    Icon.BackgroundTransparency = 1
    Icon.BorderSizePixel = 0
    Icon.Parent = header

    -- Module container
    local listHolder = Instance.new('ScrollingFrame')
    listHolder.Name = 'ListHolder'
    listHolder.ScrollBarThickness = 0
    listHolder.ScrollingEnabled = true
    listHolder.Size = UDim2.new(1, 0, 0, 0)
    listHolder.Position = UDim2.new(0, 0, 0, 70)
    listHolder.BackgroundTransparency = 1
    listHolder.AutomaticSize = Enum.AutomaticSize.Y
    listHolder.Parent = panel
    listHolder.BorderSizePixel = 0

    local listLayout = Instance.new('UIListLayout')
    listLayout.Padding = UDim.new(0, 20)
    listLayout.Parent = listHolder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    category._panel = panel
    category._holder = listHolder
    category.Modules = {}

    -- Add category button to main panel
    createCategoryButton(category)

    -- ========== MODULE CREATION ==========
    function category:CreateModule(def)
		local module = {
			Name = def.Name or "Module",
            Legit = def.Legit,
			Icon = def.Icon,
			Enabled = def.Enabled,
			ModulesTable = {
                Toggles = {},
                Sliders = {},
                Dropdowns = {}
            }
		}
		if Config[module.Name] == nil then
			Config[module.Name] = {Enabled = false, Keybind = "none", Legit = module.Legit, Toggles = {}, Dropdowns = {}, Sliders = {}}
		end

		local Module = Instance.new("TextButton")
		Module.Name = module.Name .. "_Module"
		Module.Size = UDim2.new(1, -20, 0, 40)
		Module.BackgroundColor3 = uipal.headerBg
		Module.Text = ""
		Module.AutoButtonColor = false
		Module.BorderSizePixel = 0
		Module.Parent = listHolder
		roundify(Module, 13)
		
		local ModuleLabel = Instance.new("TextLabel")
		ModuleLabel.Name = module.Name .. "_ModuleLabel"
		ModuleLabel.Size = UDim2.new(1, -20, 0, 40)
		ModuleLabel.BackgroundColor3 = uipal.headerBg
		ModuleLabel.TextColor3 = color.Dark(uipal.text, 0.3)
		ModuleLabel.FontFace = uipal.Font
		ModuleLabel.BackgroundTransparency = 1
		ModuleLabel.TextSize = 14
		ModuleLabel.Text = "     " .. module.Name
		ModuleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ModuleLabel.BorderSizePixel = 0
		ModuleLabel.Parent = Module
		roundify(Module, 13)

		local ModuleGradient = Instance.new("UIGradient")
		ModuleGradient.Enabled = false
		ModuleGradient.Parent = Module
		ModuleGradient.Name = module.Name .. "_ModuleGradient"
		ModuleGradient.Color = Gradient

		local ModuleAmbenience = Instance.new("Frame")
		ModuleAmbenience.Name = module.Name .. "_ModuleAmbience"
		ModuleAmbenience.Position = UDim2.new(0, 10, 0, 29)
		ModuleAmbenience.Size = UDim2.new(1, -20, 0, 15)
		ModuleAmbenience.BackgroundColor3 = uipal.headerBg
		ModuleAmbenience.BackgroundTransparency = 0.5
		ModuleAmbenience.BorderSizePixel = 0
		ModuleAmbenience.Parent = Module
		roundify(ModuleAmbenience, 13)

		local ModuleAmGradient = Instance.new("UIGradient")
		ModuleAmGradient.Enabled = false
		ModuleAmGradient.Parent = ModuleAmbenience
		ModuleAmGradient.Name = module.Name .. "_ModuleGradient"
		ModuleAmGradient.Color = Gradient

		local Icon = Instance.new("ImageButton")
		Icon.Name = module.Name .. "_SettingsIcon"
		Icon.Position = UDim2.new(0, 175, 0, 13)
		Icon.ImageColor3 = color.Dark(uipal.text, 0.3)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.BackgroundColor3 = color.Dark(uipal.text, 0.3)
		Icon.BackgroundTransparency = 1
		Icon.Image = "rbxassetid://135586317594546"--"rbxassetid://109170511503899"
		Icon.BorderSizePixel = 0
		Icon.Parent = Module
		roundify(ModuleAmbenience, 13)

		-- Tooltip
		local tip = Instance.new("TextLabel")
		tip.Name = module.Name.."_Tooltip"
		tip.AnchorPoint = Vector2.new(0, 0)
		tip.Position = UDim2.new(1, 6, 0, 0)
		tip.Size = UDim2.new(0, 170, 0, 22)
		tip.BackgroundColor3 = uipal.tipBg
		tip.TextColor3 = uipal.text
		tip.FontFace = uipal.Font
		tip.TextSize = 12
		tip.TextXAlignment = Enum.TextXAlignment.Left
		tip.Text = def.Tooltip or ""
		tip.ZIndex = 50
		tip.Visible = false
		tip.Parent = Module
		roundify(tip, 4)

		Module.MouseEnter:Connect(function() if def.Tooltip then tip.Visible = true end end)
		Module.MouseLeave:Connect(function() tip.Visible = false end)

		-- Settings container (right-click)
		local settingsframe = Instance.new("Frame")
		settingsframe.Name = module.Name .. "_Settings"
		settingsframe.Size = UDim2.new(0, 175, 0, 350)
		settingsframe.BackgroundColor3 = uipal.Main
		settingsframe.Position = UDim2.new(0, 0, 1, 0)
		settingsframe.BackgroundTransparency = 0
		settingsframe.ClipsDescendants = true
		settingsframe.Visible = false
		settingsframe.Parent = settingsholderframe
		roundify(settingsframe, 13)
		local settingsheader = Instance.new("TextLabel")
		settingsheader.Name = "Header"
		settingsheader.Size = UDim2.new(1, 0, 0, 50)
		settingsheader.BackgroundColor3 = uipal.headerBg
		settingsheader.TextColor3 = color.Dark(uipal.text, 0.3)
		settingsheader.FontFace = uipal.Font
		settingsheader.TextSize = 14
		settingsheader.TextXAlignment = Enum.TextXAlignment.Left
		settingsheader.Text = "     "..module.Name
		settingsheader.BorderSizePixel = 0
		settingsheader.LayoutOrder = -10
		settingsheader.Parent = settingsframe
		roundify(settingsheader, 13)
		makeDraggable(settingsframe, settingsheader)
		local settingsheader2 = Instance.new("Frame")
		settingsheader2.Name = "SettingsHeader2"
		settingsheader2.Size = UDim2.new(1, 0, 0, 10)
		settingsheader2.Position = UDim2.new(0, 0, 0, 40)
		settingsheader2.BackgroundColor3 = uipal.headerBg
		settingsheader2.BorderSizePixel = 0
		settingsheader2.Parent = settingsheader
		local settingsLayout = Instance.new("UIListLayout")
		settingsLayout.Padding = UDim.new(0, 5)
		settingsLayout.Parent = settingsframe
		settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local settingsholder = Instance.new("ScrollingFrame")
		settingsholder.Name = "settingsholder"
		settingsholder.Size = UDim2.new(0, 175, 0, 300)
		settingsholder.ScrollBarThickness = 0
		settingsholder.BackgroundColor3 = uipal.Main
		settingsholder.Position = UDim2.new(0, 0, 0, 0)
		settingsholder.BackgroundTransparency = 1
		settingsholder.Visible = true
		settingsholder.Parent = settingsframe
		local settingsholderlayout = Instance.new("UIListLayout")
		settingsholderlayout.Padding = UDim.new(0, 5)
		settingsholderlayout.Parent = settingsholder
		settingsholderlayout.SortOrder = Enum.SortOrder.LayoutOrder
		local bind = Instance.new("TextLabel")
		bind.Name = module.Name..'_Toggle'
		bind.Size = UDim2.new(1, 0, 0, 30)
		bind.BackgroundTransparency = 0
		bind.BorderSizePixel = 0
		bind.BackgroundColor3 = uipal.Main
		bind.Text = "   Bind"
		bind.TextXAlignment = Enum.TextXAlignment.Left
		bind.TextColor3 = color.Dark(uipal.text, 0.3)
		bind.TextSize = 14
		bind.LayoutOrder = -10
		bind.FontFace = uipal.Font
		bind.Parent = settingsholder
		local bindholder = Instance.new("TextButton")
		bindholder.Name = module.Name..'_Toggle'
		bindholder.Size = UDim2.fromOffset(45, 20)
		bindholder.Position = UDim2.new(1, -55, 0, 8)
		bindholder.BackgroundTransparency = 0
		bindholder.BorderSizePixel = 0
		bindholder.BackgroundColor3 = uipal.headerBg
		bindholder.Text = "none"
		bindholder.TextXAlignment = Enum.TextXAlignment.Center
		bindholder.TextColor3 = color.Dark(uipal.text, 0.3)
		bindholder.TextSize = 12
		bindholder.FontFace = uipal.Font
		bindholder.Parent = bind
		roundify(bindholder, 5)

		function module:_refreshSettingsHeight()
			local count = 0
			for _,child in ipairs(settingsframe:GetChildren()) do
				if child:IsA("GuiObject") then
					count += child.AbsoluteSize.Y + settingsLayout.Padding.Offset
				end
			end
			--TweenService:Create(settingsframe, TWEEN, { Size = UDim2.new(1, -8, 0, count) }):Play()
		end

		-- Toggle module on left-click
		local function setEnabled(state)
			module.Enabled = state
			--Module.Text = module.Name
			if module.Enabled then ModuleGradient.Enabled = true else ModuleGradient.Enabled = false end
			if module.Enabled then ModuleAmGradient.Enabled = true else ModuleAmGradient.Enabled = false end
			TweenService:Create(Module, uipal.TWEEN, { BackgroundColor3 = state and uipal.text or uipal.headerBg }):Play()
			TweenService:Create(ModuleAmbenience, uipal.TWEEN, { BackgroundColor3 = state and uipal.text or uipal.headerBg }):Play()
			TweenService:Create(Icon, uipal.TWEEN, { ImageColor3 = state and uipal.text or color.Dark(uipal.text, 0.3) }):Play()
			TweenService:Create(ModuleLabel, uipal.TWEEN, { TextColor3 = state and uipal.text or color.Dark(uipal.text, 0.3) }):Play()
			API:CreateNotification(module.Name, "<font color='#FFFFFF'> has been </font>"..(module.Enabled and "<font color='#5AFF5A'>Enabled!</font>" or "<font color='#FF5A5A'>Disabled!</font>"), 0.75, "normal")
			if module.Enabled then ArrayList.Create(module.Name) else ArrayList.Remove(module.Name) end
			if typeof(def.Function) == "function" then
				task.spawn(def.Function, state, module)
				Config[module.Name].Enabled = state
				task.delay(0.01, function() ConfigSystem:Save_Config() end)
            end
		end
		Module.MouseButton1Click:Connect(function()
			setEnabled(not module.Enabled)
		end)

		if module.Enabled == true  then
			setEnabled(not module.Enabled)
		end

		local keyConnection
local rebinding = false

-- helper to convert KeyCode -> string
local function KeyToString(keycode)
	return tostring(keycode):gsub("Enum.KeyCode.", "")
end

-- helper to bind listener from config
local function SetupKeyListener()
	if keyConnection then
		keyConnection:Disconnect()
		keyConnection = nil
	end

	local currentKey = Config[module.Name].Keybind
	if not currentKey or currentKey == "none" then return end

	keyConnection = UserInputService.InputBegan:Connect(function(newInput, gpe)
		if gpe then return end
		if newInput.UserInputType == Enum.UserInputType.Keyboard 
			and KeyToString(newInput.KeyCode) == currentKey then
			setEnabled(not module.Enabled)
		end
	end)
end

-- clicking bind button
bindholder.MouseButton1Down:Connect(function()
	if rebinding then return end
	rebinding = true

	bindholder.Text = "..."
	bindholder.TextColor3 = color.Dark(uipal.text, 0.3)

	local tempConnection
	tempConnection = UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		-- only accept keyboard inputs
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if input.KeyCode == Enum.KeyCode.Unknown then return end

		tempConnection:Disconnect()

		local newKey = KeyToString(input.KeyCode)

		-- unbind if same key pressed again
		if Config[module.Name].Keybind == newKey then
			Config[module.Name].Keybind = "none"
			bindholder.Text = "none"
			bindholder.TextColor3 = color.Dark(uipal.text, 0.3)
			if keyConnection then
				keyConnection:Disconnect()
				keyConnection = nil
			end
		else
			-- assign new key
			Config[module.Name].Keybind = newKey
			bindholder.Text = newKey
			bindholder.TextColor3 = uipal.ModuleOn
			SetupKeyListener()
		end

		task.delay(0.01, function() ConfigSystem:Save_Config() end)
		rebinding = false
	end)
end)

-- auto-load on startup
if Config[module.Name].Keybind and Config[module.Name].Keybind ~= "none" then
	bindholder.Text = Config[module.Name].Keybind
	bindholder.TextColor3 = uipal.ModuleOn
	SetupKeyListener()
else
	bindholder.Text = "none"
	bindholder.TextColor3 = color.Dark(uipal.text, 0.3)
end

		Module.MouseButton2Click:Connect(function()
			settingsframe.Visible = not settingsframe.Visible
			if settingsframe.Visible then module:_refreshSettingsHeight() end
		end)

		Icon.MouseButton1Click:Connect(function()
			settingsframe.Visible = not settingsframe.Visible
			if settingsframe.Visible then module:_refreshSettingsHeight() end
		end)

        function module:CreateToggle(togsettings)
			local toggle = {
				Name = togsettings.Name,
				default = togsettings.default
			}
			if Config[module.Name].Toggles[toggle.Name] == nil then
				Config[module.Name].Toggles[toggle.Name] = {Enabled = false}
			end

			local Toggle = Instance.new("TextButton")
			Toggle.Name = togsettings.Name..'_Toggle'
			Toggle.Size = UDim2.new(1, 0, 0, 30)
			Toggle.BackgroundTransparency = 0
			Toggle.BorderSizePixel = 0
			Toggle.AutoButtonColor = false
			Toggle.BackgroundColor3 = uipal.Main
			Toggle.Text = "   "..togsettings.Name
			Toggle.TextXAlignment = Enum.TextXAlignment.Left
			Toggle.TextColor3 = color.Dark(uipal.text, 0.3)
			Toggle.TextSize = 14
			Toggle.LayoutOrder = -9
			Toggle.FontFace = uipal.Font
			Toggle.Parent = settingsholder
			Toggle.BorderColor3 = uipal.Main
			local knob = Instance.new('Frame')
			knob.Name = 'Knob'
			knob.Size = UDim2.fromOffset(35, 17)
			knob.Position = UDim2.new(1, -45, 0, 8)
			knob.BackgroundColor3 = uipal.headerBg
			knob.Parent = Toggle
			roundify(knob, 15)
			local knobmain = knob:Clone()
			knobmain.Size = UDim2.fromOffset(8,8)
			knobmain.Position = UDim2.fromOffset(5, 4)
			knobmain.BackgroundColor3 = uipal.text
			knobmain.Parent = knob

			local function setToggleEnabled(val)
                toggle.default = val
				TweenService:Create(knobmain, TweenInfo.new(0.3), { Position = val and UDim2.fromOffset(22, 4) or UDim2.fromOffset(5, 4) }):Play()
				TweenService:Create(knob, uipal.TWEEN, { BackgroundColor3 = val and uipal.ModuleOn or uipal.headerBg }):Play()
				Config[module.Name].Toggles[toggle.Name].Enabled = val
				task.delay(0.01, function() ConfigSystem:Save_Config() end)
				if module.Enabled then
					if togsettings.callback then togsettings.callback(val) end
					module:_refreshSettingsHeight()
				end
			end

			if togsettings.default == true then
			    setToggleEnabled(not toggle.default)
		    end

            Toggle.MouseButton1Click:Connect(function()
			    setToggleEnabled(not toggle.default)
		    end)
            
            if Config[module.Name].Toggles[toggle.Name].Enabled then
                setToggleEnabled(not toggle.default)
            end

			table.insert(module.ModulesTable, toggle)
		end

        function module:CreateSlider(slidersettings)
        local sliderapi = {
            Name = slidersettings.Name,
            Default = slidersettings.Default,
        }

    -- Ensure config exists
    if Config[module.Name].Sliders[sliderapi.Name] == nil then
        Config[module.Name].Sliders[sliderapi.Name] = {Value = slidersettings.Default}
    end

    -- UI elements
    local SliderHolder = Instance.new('Frame')
    SliderHolder.Size = UDim2.new(1, 0, 0, 40)
    SliderHolder.BackgroundColor3 = uipal.Main
    SliderHolder.BorderSizePixel = 0
    SliderHolder.LayoutOrder = -8
    SliderHolder.Parent = settingsholder
    roundify(SliderHolder, 8)

    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 9, 0, -15)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = color.Dark(uipal.text, 0.3)
    label.FontFace = uipal.Font
    label.TextSize = 14
    label.Text = slidersettings.Name
    label.Parent = SliderHolder

    local valueBox = Instance.new('TextBox')
    valueBox.Size = UDim2.new(0.3, -10, 1, 0)
    valueBox.Position = UDim2.new(0.7, 0, 0, -15)
    valueBox.BackgroundTransparency = 1
    valueBox.ClearTextOnFocus = false
    valueBox.TextXAlignment = Enum.TextXAlignment.Right
    valueBox.TextColor3 = color.Dark(uipal.text, 0.3)
    valueBox.FontFace = uipal.Font
    valueBox.TextSize = 14
    valueBox.Parent = SliderHolder

    local Track = Instance.new('Frame')
    Track.Size = UDim2.new(0.9, 0, 0, 12)
    Track.Position = UDim2.new(0.05, 0, 1, -20)
    Track.BackgroundColor3 = uipal.headerBg
    Track.BorderSizePixel = 0
    Track.Parent = SliderHolder
    roundify(Track, 6)

    local Fill = Instance.new('Frame')
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = uipal.ModuleOn
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    roundify(Fill, 6)

    local Knob = Instance.new('Frame')
    Knob.Size = UDim2.new(0, 8, 0, 8)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.BackgroundColor3 = uipal.ModuleOn
    Knob.Parent = Track
    roundify(Knob, 50)

    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = uipal.headerBg
    UIStroke.Thickness = 3
    UIStroke.Parent = Knob

    -- Values
    local min = slidersettings.Min or 0
    local max = slidersettings.Max or 100
    --local current = slidersettings.Default or min
    --local current = Config[module.Name].Sliders[sliderapi.Name].Value

    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local current = Config[module.Name].Sliders[sliderapi.Name].Value or slidersettings.Default

-- update slider function
local function updateSlider(val)
    -- snap to whole numbers and clamp
    current = math.clamp(math.floor(val), min, max)

    -- update visuals
    local pct = (current - min) / (max - min)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
    valueBox.Text = tostring(current)

    -- save config
    Config[module.Name].Sliders[sliderapi.Name].Value = current
    task.delay(0.01, function()
        ConfigSystem:Save_Config()
    end)
end

-- handle clicking on the track
Track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local val = min + ((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X) * (max - min)
        updateSlider(val)
    end
end)

-- stop dragging
Track.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- handle dragging movement
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local val = min + ((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X) * (max - min)
        updateSlider(val)
    end
end)

-- handle typing in valueBox
valueBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(valueBox.Text)
        if num then
            updateSlider(num)
        else
            valueBox.Text = tostring(current)
        end
    else
        valueBox.Text = tostring(current)
    end
end)


    -- Initialize from config
    updateSlider(current)

    -- API
    sliderapi.Get = function()
        return current
    end
    sliderapi.Set = function(v)
        updateSlider(v)
    end

    table.insert(module.ModulesTable, sliderapi)
    return sliderapi
end

        function module:CreateDropdown(dropdownsettings)
            local dropdownapi = {}
            if Config[module.Name].Dropdowns[dropdownsettings.Name] == nil then
                Config[module.Name].Dropdowns[dropdownsettings.Name] = {
                    Option = dropdownsettings.Default
                        or dropdownsettings.Options[1],
                }
            end

            local TweenService = game:GetService('TweenService')

            -- Holder
            local DropdownHolder = Instance.new('Frame')
            DropdownHolder.Size = UDim2.new(1, 0, 0, 60) -- collapsed height
            DropdownHolder.BackgroundColor3 = uipal.Main
            DropdownHolder.BorderSizePixel = 0
            DropdownHolder.ClipsDescendants = true
            DropdownHolder.LayoutOrder = -7
            DropdownHolder.Parent = settingsholder
            roundify(DropdownHolder, 8)

            -- Label
            local label = Instance.new('TextLabel')
            label.Size = UDim2.new(1, -20, 0, 24)
            label.Position = UDim2.new(0, 10, 0, -5)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextColor3 = color.Dark(uipal.text, 0.3)
            label.FontFace = uipal.Font
            label.TextSize = 14
            label.Text = dropdownsettings.Name
            label.Parent = DropdownHolder

            -- Selected button
            local Selected = Instance.new('TextButton')
            Selected.Size = UDim2.new(0.8, 0, 0, 28)
            Selected.Position = UDim2.new(0.1, 0, 0, 20)
            Selected.BackgroundColor3 = uipal.headerBg
            Selected.TextColor3 = color.Dark(uipal.text, 0.3)
            Selected.FontFace = uipal.Font
            Selected.TextSize = 14
            Selected.Text = Config[module.Name].Dropdowns[dropdownsettings.Name].Option or dropdownsettings.Default
            Selected.Parent = DropdownHolder
            Selected.AutoButtonColor = true
            roundify(Selected, 10)

            -- Options container
            local Container = Instance.new('Frame')
            --Container.BackgroundTransparency = 0
            Container.Visible = false
            Container.BackgroundColor3 = uipal.headerBg
            Container.Position = UDim2.new(0, 8, 0, 55) -- sits below the holder
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Parent = DropdownHolder
            roundify(Container, 10)

            -- Layout
            local UIList = Instance.new('UIListLayout')
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, 0)
            UIList.Parent = Container

            -- State
            local expanded = false
            local visible = false
            local current = Config[module.Name].Dropdowns[dropdownsettings.Name].Option or dropdownsettings.Default
            -- function to select an option
            local function selectOption(opt)
                current = opt
                Selected.Text = opt
				Config[module.Name].Dropdowns[dropdownsettings.Name].Option = opt
				task.delay(0.01, function() ConfigSystem:Save_Config() end)
                -- collapse
                expanded = false
                visible = not visible
                Container.Visible = visible
                TweenService
                    :Create(
                        DropdownHolder,
                        TweenInfo.new(
                            0.25,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.Out
                        ),
                        {
                            Size = UDim2.new(1, 0, 0, 60),
                        }
                    )
                    :Play()
            end

            -- build options
            for _, option in ipairs(dropdownsettings.Options) do
                local optBtn = Instance.new('TextButton')
                optBtn.Size = UDim2.new(0.9, 0, 0, 28)
                optBtn.Position = UDim2.new(0.05, 0, 0, 0)
                optBtn.BackgroundColor3 = uipal.headerBg
                optBtn.TextColor3 = color.Dark(uipal.text, 0.3)
                optBtn.FontFace = uipal.Font
                optBtn.TextSize = 14
                optBtn.Text = option
                optBtn.Parent = Container
                roundify(optBtn, 10)

                optBtn.MouseButton1Click:Connect(function()
                    selectOption(option)
                end)
            end

            -- expand/collapse when clicking Selected
            Selected.MouseButton1Click:Connect(function()
                expanded = not expanded
                visible = not visible
                local targetHeight = expanded
                        and (60 + UIList.AbsoluteContentSize.Y)
                    or 60
                Container.Visible = visible
                TweenService
                    :Create(
                        DropdownHolder,
                        TweenInfo.new(
                            0.25,
                            Enum.EasingStyle.Quad,
                            Enum.EasingDirection.Out
                        ),
                        {
                            Size = UDim2.new(1, 0, 0, targetHeight),
                        }
                    )
                    :Play()
            end)

            -- auto-resize when options change
            UIList:GetPropertyChangedSignal('AbsoluteContentSize')
                :Connect(function()
                    if expanded then
                        local newHeight = 60 + UIList.AbsoluteContentSize.Y
                        DropdownHolder.Size = UDim2.new(1, 0, 0, newHeight)
                    end
                end)

            -- API
            dropdownapi.Get = function()
                return current
            end
            dropdownapi.Set = function(v)
                selectOption(v)
            end

            table.insert(module.ModulesTable.Dropdowns, dropdownapi)
            return dropdownapi
        end

        --[[function module:CreateColorSlider(settings)
			local colorsliderapi = {}

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1,0,0,110)
			holder.BackgroundTransparency = 1
			holder.Parent = settingsframe

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1,0,0,20)
			title.BackgroundTransparency = 1
			title.Text = settings.Name or "Color Picker"
			title.TextColor3 = Color3.new(1,1,1)
			title.Font = Enum.Font.SourceSansBold
			title.TextSize = 16
			title.Parent = holder

			assert(settings.Target and settings.Keys, "Target table and Keys must be provided")

			-- Initialize defaults
			for _, key in ipairs(settings.Keys) do
				if settings.Target[key] == nil then
					settings.Target[key] = (key == "Hue") and 0 or 1
				end
			end

			local hueGrad, satGrad, valGrad

			local function createSlider(y, labelText, gradientFunc, key)
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(1, -20, 0, 20)
				sliderFrame.Position = UDim2.new(0, 10, 0, y)
				sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
				sliderFrame.BorderSizePixel = 0
				sliderFrame.Parent = holder

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0, 60, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = labelText
				label.TextColor3 = Color3.new(1,1,1)
				label.Font = Enum.Font.SourceSans
				label.TextSize = 14
				label.Parent = sliderFrame

				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, -70, 1, -6)
				bar.Position = UDim2.new(0, 65, 0, 3)
				bar.BackgroundColor3 = Color3.new(1,1,1)
				bar.BorderSizePixel = 0
				bar.Parent = sliderFrame

				local uiGradient = Instance.new("UIGradient")
				uiGradient.Color = gradientFunc()
				uiGradient.Parent = bar

				local knob = Instance.new("Frame")
				knob.Size = UDim2.new(0, 10, 1, 0)
				knob.BackgroundColor3 = Color3.new(1,1,1)
				knob.BorderSizePixel = 0
				knob.Parent = bar

				local function setVal(v)
					v = math.clamp(v,0,1)
					knob.Position = UDim2.new(v, -5, 0, 0)
					settings.Target[key] = v

					-- update dependent gradients
					if key == "Hue" and satGrad then
						satGrad.Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromHSV(v,0,1)),
							ColorSequenceKeypoint.new(1, Color3.fromHSV(v,1,1))
						}
						if valGrad then
							valGrad.Color = ColorSequence.new{
								ColorSequenceKeypoint.new(0, Color3.fromHSV(v, settings.Target.Sat,0)),
								ColorSequenceKeypoint.new(1, Color3.fromHSV(v, settings.Target.Sat,1))
							}
						end
					elseif key == "Sat" and valGrad then
						valGrad.Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromHSV(settings.Target.Hue,v,0)),
							ColorSequenceKeypoint.new(1, Color3.fromHSV(settings.Target.Hue,v,1))
						}
					end
				end

				-- drag
				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local conn
						conn = UserInputService.InputChanged:Connect(function(inp)
							if inp.UserInputType == Enum.UserInputType.MouseMovement then
								local rel = (inp.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
								setVal(rel)
							end
						end)
						UserInputService.InputEnded:Connect(function(inp)
							if inp.UserInputType == Enum.UserInputType.MouseButton1 then
								conn:Disconnect()
							end
						end)
					end
				end)

				setVal(settings.Target[key])
				return setVal, uiGradient
			end

			_, hueGrad = createSlider(25, "Hue", function()
				local keys = {}
				for i=0,1,0.1 do
					table.insert(keys, ColorSequenceKeypoint.new(i, Color3.fromHSV(i,1,1)))
				end
				return ColorSequence.new(keys)
			end, "Hue")

			_, satGrad = createSlider(50, "Sat", function()
				return ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromHSV(settings.Target.Hue,0,1)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(settings.Target.Hue,1,1))
				}
			end, "Sat")

			_, valGrad = createSlider(75, "Value", function()
				return ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromHSV(settings.Target.Hue,settings.Target.Sat,0)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(settings.Target.Hue,settings.Target.Sat,1))
				}
			end, "Value")

			function colorsliderapi.GetColor()
				return Color3.fromHSV(settings.Target.Hue, settings.Target.Sat, settings.Target.Value)
			end

			return colorsliderapi, holder
		end--]]
        task.delay(0.1, function()
            if Config[module.Name].Keybind == "none" then
                bindholder.Text = "none"
                Keybind = Enum.KeyCode.Unknown
                --bindholder.TextColor3 = color.Dark
            else
                bindholder.Text = Config[module.Name].Keybind
                Keybind = Enum.KeyCode[Config[module.Name].Keybind]
                --bindholder.TextColor3 = uipal.ModuleOn
            end
            if Config[module.Name].Enabled then
                setEnabled(not module.Enabled)
            end
        end)
        module._Modules = Module
        module._settings = settings
        table.insert(category.Modules, module)
        API.Modules[module.Name] = module
        return module
    end

    API.Categories[categorysettings.name] = category
    return category
end

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.fromScale(0.3, 0.9)
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Visible = false
NotificationFrame.Position = UDim2.fromScale(0.35,0)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = Root
local NotificationFrameSorter = Instance.new("UIListLayout", NotificationFrame)
NotificationFrameSorter.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotificationFrameSorter.Padding = UDim.new(0.015,0)

local function removeTags(str)
    str = str:gsub('<br%s*/>', '\n')
    return str:gsub('<[^<>]->', '')
end

local getfontsize = function(text, size, font)
    fontsize.Text = text
    fontsize.Size = size
    if typeof(font) == 'Font' then
        fontsize.Font = font
    end
    return textservice:GetTextBoundsAsync(fontsize)
end

local normal = "rbxassetid://130793878082616"
local warning = "rbxassetid://138967308321615"
local alert = "rbxassetid://100041711106977"
local configs = "rbxassetid://98039591382241"
local admin = "rbxassetid://89409067527918"

function API:CreateNotification(title, text, duration, iconType)
	local Notification = Instance.new("Frame")
	Notification.Parent = NotificationFrame
	Notification.BorderSizePixel = 0
	Notification.BackgroundColor3 = uipal.Main
	Notification.Size = UDim2.fromOffset(math.max(getfontsize(removeTags(text), 14, uipal.Font).X + 80, 266), 0) -- wider for icon
	Notification.BackgroundTransparency = 0
	Notification.ClipsDescendants = true
	Notification.AnchorPoint = Vector2.new(0.5, 1)
	Notification.Position = UDim2.new(0.5, 0, 1, -20)
	roundify(Notification, 10)

    local IconGradient = Instance.new("UIGradient")
    IconGradient.Enabled = false
    IconGradient.Parent = iconLabel
    IconGradient.Name = "IconGradient"
    IconGradient.Color = Gradient

	-- Icon
	local iconId
	local iconcolor
	if iconType == "normal" then
		iconId = normal
		iconcolor = uipal.text
	elseif iconType == "warning" then
		iconId = warning
		iconcolor = uipal.warn
	elseif iconType == "alert" then
		iconId = alert
		iconcolor = uipal.alert
	elseif iconType == "config" then
		iconId = configs
		iconcolor = uipal.warn
	elseif iconType == "admin" then
		iconId = admin
		iconcolor = uipal.ModuleOn
	end

	local iconLabel = Instance.new("ImageLabel")
	iconLabel.Name = "Icon"
	iconLabel.Size = UDim2.new(0, 25, 0, 25)
	iconLabel.Position = UDim2.fromOffset(10, 8)
	iconLabel.BackgroundTransparency = 1
	iconLabel.ImageColor3 = iconcolor
	iconLabel.Image = iconId
	iconLabel.Parent = Notification

    local IconGradient = Instance.new("UIGradient")
    IconGradient.Enabled = false
    IconGradient.Parent = iconLabel
    IconGradient.Name = "IconGradient"
    IconGradient.Color = Gradient

	-- Title
	local titleLabel = Instance.new('TextLabel')
	titleLabel.Name = 'Title'
	titleLabel.Size = UDim2.new(1, -56, 0, 20) 
	titleLabel.Position = UDim2.fromOffset(20, 10)
	titleLabel.ZIndex = 5
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "<stroke color='#FFFFFF' joins='round' thickness='0.3' transparency='0.5'>"..title..'</stroke>'
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Top
	titleLabel.TextColor3 = iconcolor
	titleLabel.TextSize = 18
	titleLabel.RichText = true
	titleLabel.FontFace = uipal.Font
	titleLabel.Parent = Notification

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Enabled = false
    TitleGradient.Parent = titleLabel
    TitleGradient.Name = "TitleGradient"
    TitleGradient.Color = Gradient

        if iconType == "normal" then
        TitleGradient.Enabled = true
        IconGradient.Enabled = true
    end

	-- Close button (X)
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "Close"
	closeButton.Size = UDim2.new(0, 20, 0, 20)
	closeButton.Position = UDim2.new(1, -27, 0, 8)
	closeButton.AnchorPoint = Vector2.new(0, 0)
	closeButton.Text = "X"
    closeButton.Visible = false
	closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
	closeButton.BackgroundTransparency = 1
	closeButton.TextSize = 18
	closeButton.FontFace = uipal.Font
	closeButton.Parent = Notification

	-- Message text
	local textLabel = Instance.new('TextLabel')
	textLabel.Name = 'Text'
	textLabel.Size = UDim2.new(1, -56, 0, 20) 
	textLabel.Position = UDim2.fromOffset(20, 30)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextColor3 = Color3.fromRGB(209, 209, 209)
	textLabel.TextSize = 14
	textLabel.RichText = true
	textLabel.FontFace = uipal.Font
	textLabel.TextWrapped = true
	textLabel.Parent = Notification

	-- Countdown timer label
	local timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "Timer"
	timerLabel.Size = UDim2.new(0, 60, 0, 20)
	timerLabel.Position = UDim2.new(1, -55, 1, -25)
	timerLabel.BackgroundTransparency = 1
	timerLabel.Text = string.format("%.2f", duration)
	timerLabel.TextColor3 = uipal.text
	timerLabel.TextSize = 14
	timerLabel.FontFace = uipal.Font
	timerLabel.Parent = Notification
    timerLabel.Visible = false

	-- Animate in (grow height)
	local fullHeight = 75
	TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(Notification.Size.X.Offset, fullHeight)
	}):Play()

	local function slideOutNotification()
		local slideOut = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(Notification.Size.X.Offset, 0)
		})
		slideOut:Play()
		slideOut.Completed:Wait()
		Notification:Destroy()
	end

	-- Countdown loop
	task.spawn(function()
		local remaining = duration
		while remaining > 0 do
			timerLabel.Text = string.format("%.2f", remaining)
			task.wait(0.01)
			remaining -= 0.01
		end
		timerLabel.Text = "0.00"
		slideOutNotification()
	end)

	-- Close button click
	closeButton.MouseButton1Click:Connect(function()
		slideOutNotification()
	end)
end

-- ===================== EXAMPLE USAGE =====================
local Combat = API:CreateCategory({
    name = 'Combat',
    posX = 250,
    posY = 100,
    Icon = 'rbxassetid://124357178154991',
    Parent = categoryContainer,
})
local Movement = API:CreateCategory({
    name = 'Movement',
    posX = 480,
    posY = 100,
    Icon = 'rbxassetid://108815009799422',
    Parent = categoryContainer,
})
local Player = API:CreateCategory({
    name = 'Player',
    posX = 710,
    posY = 100,
    Icon = 'rbxassetid://91243494248123',
    Parent = categoryContainer,
})
local Render = API:CreateCategory({
    name = 'Render',
    posX = 940,
    posY = 100,
    Icon = 'rbxassetid://105858249804226',
    Parent = categoryContainer,
})
local Misc = API:CreateCategory({
    name = 'Misc',
    posX = 1170,
    posY = 100,
    Icon = 'rbxassetid://83125383106926',
    Parent = categoryContainer,
})
local Settings = API:CreateCategory({
    name = 'Settings',
    posX = 1400,
    posY = 100,
    Icon = 'rbxassetid://135586317594546',
    Parent = footer,
})
local Configs = API:CreateCategory({
    name = 'Configs',
    posX = 1630,
    posY = 100,
    Icon = 'rbxassetid://85433960710965',
    Parent = footer,
})

local Uninject = Settings:CreateModule({
    Name = 'Uninject',
    Legit = true,
    Function = function(state)
        if state then
            ConfigSystem.CanSave = false
            task.wait(1)
            Root:Destroy()
            blur:Destroy()
        end
    end,
    Tooltip = 'Uninjects Galaxy',
})
local GUI = Settings:CreateModule({
	Name = "Gui",
    Legit = true,
	Function = function(state)
	end,
	Tooltip = "Make changes to the UI!"
})
local ArrayTog = GUI:CreateToggle({
	Name = "Legit (soon)",
	default = false,
	callback = function(val)
	end,
})
local Colors = Settings:CreateModule({
	Name = "Colors",
    Legit = true,
	Function = function(state)
	end,
	Tooltip = "Make changes to the Colors of the UI!"
})
local ModuleList = Settings:CreateModule({
	Name = "Module List",
    Legit = true,
	Function = function(state)
        if state then
			ArrayListFrame.Visible = true
		else
			ArrayListFrame.Visible = false
		end
	end,
	Tooltip = "Toggle the Module List"
})
local WaterMarkTog = ModuleList:CreateToggle({
	Name = "Watermark",
	default = false,
	callback = function(state)
		if state then
			arraylistlabel.Visible = true
		else
			arraylistlabel.Visible = false
		end
	end,
})
local Hud = Settings:CreateModule({
	Name = "Hud",
    Legit = true,
	Function = function(state)
	end,
	Tooltip = "Make changes to the Hud!"
})
local NotifTog = Hud:CreateToggle({
	Name = "Notifications",
	default = false,
	callback = function(val)
		if val then
			NotificationFrame.Visible = true
		else
			NotificationFrame.Visible = false
		end
	end,
})
local MainWaterMarkTog = Hud:CreateToggle({
	Name = "Watermark",
	default = false,
	callback = function(val)
		if val then
			GalaxyWatermark.Visible = true
		else
			GalaxyWatermark.Visible = false
		end
	end,
})

local visibleclickui = false
local blurenabled = false
local function getKeyCodeFromString(keyString)
    for _, enum in ipairs(Enum.KeyCode:GetEnumItems()) do
        if enum.Name:lower() == keyString:lower() then
            return enum
        end
    end
    return nil
end
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then
        return
    end
    local keyEnum = getKeyCodeFromString(API.Keybind[1])
    if keyEnum and input.KeyCode == keyEnum then
        visibleclickui = not visibleclickui
        blurenabled = not blurenabled
        blur.Enabled = blurenabled
        ClickGUI.Visible = visibleclickui
        Arraylistmover.Visible = visibleclickui
    end
end)

API.Loaded = true
task.wait(2)
NotificationFrame.Visible = true
task.wait(1)
API:CreateNotification(
    'Galaxy',
    'Press ' .. tostring(API.Keybind[1]) .. ' to open GUI',
    2,
"normal"
)

print(API.Categories)

return API
