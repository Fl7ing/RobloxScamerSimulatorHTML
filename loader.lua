local Library = {}
Library.__index = Library

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Функция создания окна с возможностью перетаскивания
function Library.new(titleText)
    local self = setmetatable({}, Library)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomUILibrary"
    self.ScreenGui.Parent = CoreGui
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.fromOffset(550, 400)
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = self.MainFrame
    
    -- Шапка окна (для перетаскивания)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    self.TopBar.Parent = self.MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = self.TopBar
    
    -- Исправление острых углов снизу шапки
    local FixFrame = Instance.new("Frame")
    FixFrame.Size = UDim2.new(1, 0, 0, 5)
    FixFrame.Position = UDim2.new(0, 0, 1, -5)
    FixFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    FixFrame.BorderSizePixel = 0
    FixFrame.Parent = self.TopBar
    
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, -20, 1, 0)
    self.Title.Position = UDim2.new(0, 15, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = titleText or "UI Library"
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 15
    self.Title.FontFace = Font.fromName("SourceSansPro", Enum.FontWeight.Bold)
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TopBar
    
    -- Логика перетаскивания окна (Dragging)
    local dragging, dragInput, dragStart, startPos
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Контейнер для кнопок вкладок слева
    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(0, 130, 1, -55)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.ScrollBarThickness = 2
    self.TabContainer.Parent = self.MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = self.TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.Parent = self.TabContainer
    
    -- Контейнер для страниц (элементов) справа
    self.PagesFolder = Instance.new("Folder")
    self.PagesFolder.Name = "Pages"
    self.PagesFolder.Parent = self.MainFrame
    
    self.FirstTab = true
    return self
end

-- Система вкладок (Tabs)
function Library:AddTab(tabName)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, -145, 1, -60)
    TabPage.Position = UDim2.new(0, 140, 0, 50)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 3
    TabPage.Parent = self.PagesFolder
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = TabPage
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingTop = UDim.new(0, 8)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.Parent = TabPage
    
    -- Кнопка вкладки в левом меню
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 170)
    TabButton.TextSize = 13
    TabButton.FontFace = Font.fromName("SourceSansPro", Enum.FontWeight.SemiBold)
    TabButton.Parent = self.TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton
    
    if self.FirstTab then
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.FirstTab = false
    end
    
    TabButton.MouseButton1Click:Connect(function()
        for _, page in ipairs(self.PagesFolder:GetChildren()) do
            page.Visible = false
        end
        for _, btn in ipairs(self.TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38), TextColor3 = Color3.fromRGB(160, 160, 170)}):Play()
            end
        end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    local TabAPI = {}
    
    -- Элемент: Кнопка
    function TabAPI:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        Button.Text = "  " .. text
        Button.TextColor3 = Color3.fromRGB(220, 220, 225)
        Button.TextSize = 13
        Button.FontFace = Font.fromName("SourceSansPro")
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.Parent = TabPage
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 50)}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
    end
    
    -- Элемент: Переключатель (Toggle)
    function TabAPI:AddToggle(text, default, callback)
        local toggled = default or false
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, 0, 0, 35)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        ToggleBtn.Text = "  " .. text
        ToggleBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
        ToggleBtn.TextSize = 13
        ToggleBtn.FontFace = Font.fromName("SourceSansPro")
        ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
        ToggleBtn.Parent = TabPage
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleBtn
        
        local CheckBox = Instance.new("Frame")
        CheckBox.Size = UDim2.fromOffset(18, 18)
        CheckBox.Position = UDim2.new(1, -28, 0.5, -9)
        CheckBox.BackgroundColor3 = toggled and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(45, 45, 52)
        CheckBox.Parent = ToggleBtn
        
        local CheckCorner = Instance.new("UICorner")
        CheckCorner.CornerRadius = UDim.new(0, 4)
        CheckCorner.Parent = CheckBox
        
        ToggleBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(CheckBox, TweenInfo.new(0.2), {
                BackgroundColor3 = toggled and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(45, 45, 52)
            }):Play()
            if callback then pcall(callback, toggled) end
        end)
    end
    
    -- Элемент: Слайдер (Slider)
    function TabAPI:AddSlider(text, min, max, default, callback)
        local value = default or min
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        SliderFrame.Parent = TabPage
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = SliderFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.new(0, 10, 0, 2)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = text
        TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        TitleLabel.TextSize = 13
        TitleLabel.FontFace = Font.fromName("SourceSansPro")
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(1, -20, 0, 25)
        ValueLabel.Position = UDim2.new(0, -10, 0, 2)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(value)
        ValueLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
        ValueLabel.TextSize = 13
        ValueLabel.FontFace = Font.fromName("SourceSansPro", Enum.FontWeight.Bold)
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, -20, 0, 6)
        Track.Position = UDim2.new(0, 10, 0, 32)
        Track.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        Track.Parent = SliderFrame
        
        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(0, 3)
        TrackCorner.Parent = Track
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        Fill.Parent = Track
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 3)
        FillCorner.Parent = Fill
        
        local draggingSlider = false
        
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if draggingSlider then
                local mousePos = UserInputService:GetMouseLocation().X
                local trackPos = Track.AbsolutePosition.X
                local trackSize = Track.AbsoluteSize.X
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                
                value = math.floor(min + (max - min) * percent)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                
                if callback then pcall(callback, value) end
            end
        end)
    end
    
    -- Элемент: Выпадающий список (Dropdown)
    function TabAPI:AddDropdown(text, options, callback)
        local opened = false
        local dropdownHeight = 35
        local optionHeight = 28
        
        local DropFrame = Instance.new("Frame")
        DropFrame.Size = UDim2.new(1, 0, 0, 35)
        DropFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
        DropFrame.ClipsDescendants = true
        DropFrame.Parent = TabPage
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = DropFrame
        
        local MainBtn = Instance.new("TextButton")
        MainBtn.Size = UDim2.new(1, 0, 0, 35)
        MainBtn.BackgroundTransparency = 1
        MainBtn.Text = "  " .. text .. " : Выбрать"
        MainBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
        MainBtn.TextSize = 13
        MainBtn.FontFace = Font.fromName("SourceSansPro")
        MainBtn.TextXAlignment = Enum.TextXAlignment.Left
        MainBtn.Parent = DropFrame
        
        local DropList = Instance.new("UIListLayout")
        DropList.SortOrder = Enum.SortOrder.LayoutOrder
        DropList.Parent = DropFrame
        
        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, optionHeight)
            OptBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
            OptBtn.Text = "    " .. opt
            OptBtn.TextColor3 = Color3.fromRGB(170, 170, 180)
            OptBtn.TextSize = 13
            OptBtn.FontFace = Font.fromName("SourceSansPro")
            OptBtn.TextXAlignment = Enum.TextXAlignment.Left
            OptBtn.Parent = DropFrame
            
            OptBtn.MouseButton1Click:Connect(function()
                MainBtn.Text = "  " .. text .. " : " .. opt
                opened = false
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                if callback then pcall(callback, opt) end
            end)
        end
        
        MainBtn.MouseButton1Click:Connect(function()
            opened = not opened
            local targetSize = opened and (35 + (#options * optionHeight)) or 35
            TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
        end)
    end
    
    return TabAPI
end

function Library:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return Library
