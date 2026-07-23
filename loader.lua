local Library = {}
Library.__index = Library

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Функция создания главного окна
function Library.new(titleText)
    local self = setmetatable({}, Library)
    
    -- Создаем главный ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomUILibrary"
    self.ScreenGui.Parent = CoreGui
    
    -- Главный фрейм (окно)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.fromOffset(500, 350)
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Скругляем углы
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
    -- Заголовок окна
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, 0, 0, 40)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = titleText or "My UI Library"
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 16
    self.Title.FontFace = Font.fromName("SourceSansPro", Enum.FontWeight.Bold)
    self.Title.Parent = self.MainFrame
    
    -- Контейнер для вкладок / элементов
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, -20, 1, -60)
    self.Container.Position = UDim2.new(0, 10, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = self.Container
    
    return self
end

-- Метод для создания кнопки
function Library:AddButton(buttonText, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = buttonText
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.FontFace = Font.fromName("SourceSansPro")
    Button.Parent = self.Container
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button
    
    -- Обработка нажатия
    Button.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
end

-- Метод полного удаления (Unload / Destroy)
function Library:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Library
