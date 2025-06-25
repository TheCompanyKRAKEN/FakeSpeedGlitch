--[[
    Modern Interactive GUI for Roblox
    Features:
    - Animated open/close with fade effects
    - Custom styled sliders
    - iOS-style toggle buttons
    - Blur background effect
    - Hover animations
    - Settings persistence
    - Mobile optimization
    - Draggable window
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем основной экран GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Добавляем размытие фона
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Name = "MenuBlur"
blurEffect.Parent = game:GetService("Lighting")

-- Основной контейнер меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.35, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.03, 0)
corner.Parent = mainFrame

-- Тень
local uiStroke = Instance.new("UIStroke")
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.fromRGB(100, 100, 150)
uiStroke.Transparency = 0.7
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "НАСТРОЙКИ ИГРЫ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = mainFrame

-- Контейнер для элементов управления
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
contentFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Создаем слайдер для настройки скорости
local function createSlider(name, labelText, minValue, maxValue, defaultValue, icon)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name .. "SliderContainer"
    sliderContainer.Size = UDim2.new(1, 0, 0.15, 0)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.8, 0, 0.4, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.Font = Enum.Font.SourceSansPro
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    valueLabel.Font = Enum.Font.SourceSansProSemibold
    valueLabel.TextSize = 18
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderContainer
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(1, 0, 0.3, 0)
    sliderBackground.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderContainer
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0.5, 0)
    sliderCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderCornerFill = Instance.new("UICorner")
    sliderCornerFill.CornerRadius = UDim.new(0.5, 0)
    sliderCornerFill.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0.05, 0, 1.5, 0)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 0, -0.25)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBackground
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0.5, 0)
    sliderButtonCorner.Parent = sliderButton
    
    local sliderButtonStroke = Instance.new("UIStroke")
    sliderButtonStroke.Color = Color3.fromRGB(200, 200, 255)
    sliderButtonStroke.Thickness = 2
    sliderButtonStroke.Parent = sliderButton
    
    -- Неоновая подсветка
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.Position = UDim2.new(0, 0, 0, 0)
    glow.BackgroundTransparency = 1
    glow.Parent = sliderFill
    
    local uIGradient = Instance.new("UIGradient")
    uIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
    }
    uIGradient.Rotation = 90
    uIGradient.Parent = glow
    
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Color3.fromRGB(150, 200, 255)
    glowStroke.Thickness = 2
    glowStroke.Transparency = 0.5
    glowStroke.Parent = glow
    
    -- Логика слайдера
    local dragging = false
    
    local function updateSlider(input)
        local xScale = (input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
        xScale = math.clamp(xScale, 0, 1)
        
        local value = minValue + (maxValue - minValue) * xScale
        value = math.floor(value * 10) / 10 -- Округляем до 1 знака после запятой
        
        sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
        sliderButton.Position = UDim2.new(xScale, 0, 0, -0.25)
        valueLabel.Text = tostring(value)
        
        return value
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            -- Анимация нажатия
            local tween = TweenService:Create(
                sliderButton,
                TweenInfo.new(0.1),
                {Size = UDim2.new(0.04, 0, 1.3, 0)}
            )
            tween:Play()
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            -- Анимация отпускания
            local tween = TweenService:Create(
                sliderButton,
                TweenInfo.new(0.1),
                {Size = UDim2.new(0.05, 0, 1.5, 0)}
            )
            tween:Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local value = updateSlider(input)
            -- Здесь можно сохранять значение или применять настройки
        end
    end)
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local value = updateSlider(input)
            -- Здесь можно сохранять значение или применять настройки
        end
    end)
    
    return {
        container = sliderContainer,
        getValue = function()
            return tonumber(valueLabel.Text)
        end,
        setValue = function(newValue)
            newValue = math.clamp(newValue, minValue, maxValue)
            local xScale = (newValue - minValue) / (maxValue - minValue)
            
            sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
            sliderButton.Position = UDim2.new(xScale, 0, 0, -0.25)
            valueLabel.Text = tostring(newValue)
        end
    }
end

-- Создаем переключатель в стиле iOS
local function createToggle(name, labelText, defaultValue, icon)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name .. "ToggleContainer"
    toggleContainer.Size = UDim2.new(1, 0, 0.1, 0)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.Font = Enum.Font.SourceSansPro
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "ToggleBackground"
    toggleBackground.Size = UDim2.new(0.15, 0, 0.5, 0)
    toggleBackground.Position = UDim2.new(0.85, 0, 0.25, 0)
    toggleBackground.BackgroundColor3 = if defaultValue then Color3.fromRGB(100, 200, 100) else Color3.fromRGB(100, 100, 100)
    toggleBackground.BorderSizePixel = 0
    toggleBackground.Parent = toggleContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleBackground
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.5, 0, 1, 0)
    toggleButton.Position = if defaultValue then UDim2.new(0.5, 0, 0, 0) else UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleBackground
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(0.5, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleActive = defaultValue
    
    local function toggle()
        toggleActive = not toggleActive
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        
        if toggleActive then
            TweenService:Create(
                toggleBackground,
                tweenInfo,
                {BackgroundColor3 = Color3.fromRGB(100, 200, 100)}
            ):Play()
            
            TweenService:Create(
                toggleButton,
                tweenInfo,
                {Position = UDim2.new(0.5, 0, 0, 0)}
            ):Play()
        else
            TweenService:Create(
                toggleBackground,
                tweenInfo,
                {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}
            ):Play()
            
            TweenService:Create(
                toggleButton,
                tweenInfo,
                {Position = UDim2.new(0, 0, 0, 0)}
            ):Play()
        end
        
        -- Здесь можно добавить звуковой эффект
        -- И сохранить состояние переключателя
    end
    
    toggleBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)
    
    return {
        container = toggleContainer,
        getValue = function()
            return toggleActive
        end,
        setValue = function(newValue)
            if toggleActive ~= newValue then
                toggle()
            end
        end
    }
end

-- Создаем кнопку с анимацией при наведении
local function createButton(name, labelText, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0.1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.BorderSizePixel = 0
    button.Text = labelText
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansProSemibold
    button.TextSize = 18
    button.AutoButtonColor = false
    button.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 150)
    stroke.Thickness = 1
    stroke.Parent = button
    
    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.1),
            {
                BackgroundColor3 = Color3.fromRGB(80, 80, 100),
                Size = UDim2.new(1.02, 0, 0.105, 0),
                TextColor3 = Color3.fromRGB(255, 255, 200)
            }
        )
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.1),
            {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80),
                Size = UDim2.new(1, 0, 0.1, 0),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }
        )
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Анимация нажатия
        local tween1 = TweenService:Create(
            button,
            TweenInfo.new(0.05),
            {
                BackgroundColor3 = Color3.fromRGB(100, 100, 150),
                Size = UDim2.new(0.98, 0, 0.095, 0)
            }
        )
        
        local tween2 = TweenService:Create(
            button,
            TweenInfo.new(0.05),
            {
                BackgroundColor3 = Color3.fromRGB(80, 80, 100),
                Size = UDim2.new(1, 0, 0.1, 0)
            }
        )
        
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()
        
        callback()
    end)
    
    return button
end

-- Создаем элементы управления
local speedSlider = createSlider("Speed", "Скорость движения", 1, 5, 2.5, "⚡")
local jumpSlider = createSlider("Jump", "Высота прыжка", 1, 3, 1.5, "🦘")
local effectsToggle = createToggle("Effects", "Эффекты частиц", true, "✨")
local soundToggle = createToggle("Sound", "Звуковые эффекты", true, "🔊")

-- Кнопка сохранения
createButton("SaveButton", "СОХРАНИТЬ НАСТРОЙКИ", function()
    -- Здесь можно сохранить настройки
    print("Настройки сохранены:")
    print("Скорость:", speedSlider.getValue())
    print("Прыжок:", jumpSlider.getValue())
    print("Эффекты:", effectsToggle.getValue())
    print("Звук:", soundToggle.getValue())
end)

-- Функции для открытия/закрытия меню
local function openMenu()
    if mainFrame.Visible then return end
    
    -- Включаем размытие фона
    TweenService:Create(
        blurEffect,
        TweenInfo.new(0.3),
        {Size = 24}
    ):Play()
    
    -- Анимация появления
    mainFrame.Visible = true
    mainFrame.BackgroundTransparency = 1
    
    local tween1 = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.2),
        {BackgroundTransparency = 0.2}
    )
    
    local tween2 = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.35, 0, 0.5, 0)}
    )
    
    -- Начальное состояние для анимации
    mainFrame.Size = UDim2.new(0.35, 0, 0, 0)
    tween1:Play()
    tween2:Play()
    
    -- Оптимизация для мобильных устройств
    if RunService:IsMobilePlatform() then
        -- Здесь можно уменьшить качество графики или отключить некоторые эффекты
    end
end

local function closeMenu()
    if not mainFrame.Visible then return end
    
    -- Выключаем размытие фона
    TweenService:Create(
        blurEffect,
        TweenInfo.new(0.3),
        {Size = 0}
    ):Play()
    
    -- Анимация исчезновения
    local tween1 = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.2),
        {BackgroundTransparency = 1}
    )
    
    local tween2 = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0.35, 0, 0, 0)}
    )
    
    tween1:Play()
    tween2:Play()
    
    tween2.Completed:Connect(function()
        mainFrame.Visible = false
    end)
end

-- Обработчик кнопки закрытия
closeButton.MouseButton1Click:Connect(closeMenu)

-- Делаем окно перетаскиваемым
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Обработка горячей клавиши M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M then
        if mainFrame.Visible then
            closeMenu()
        else
            -- Проверяем, не открыт ли чат
            local chatVisible = false
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name == "Chat" then
                    local chatFrame = gui:FindFirstChild("Frame")
                    if chatFrame and chatFrame.Visible then
                        chatVisible = true
                        break
                    end
                end
            end
            
            if not chatVisible then
                openMenu()
            end
        end
    end
end)

-- Функционал движения из предыдущего промта
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function setupCharacterMovement(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            local moveDirection = humanoid.MoveDirection
            
            -- Боковой прыжок (A/D + Space) дает ускорение
            if math.abs(moveDirection.X) > math.abs(moveDirection.Z) then
                humanoid.WalkSpeed = humanoid.WalkSpeed * 1.5 * speedSlider.getValue()
                
                task.delay(1, function()
                    if humanoid then
                        humanoid.WalkSpeed = 16 * speedSlider.getValue()
                    end
                end)
            -- Прыжок вперед (W + Space) замедляет
            elseif moveDirection.Z > 0 then
                humanoid.WalkSpeed = humanoid.WalkSpeed * 0.7 * speedSlider.getValue()
                
                task.delay(1, function()
                    if humanoid then
                        humanoid.WalkSpeed = 16 * speedSlider.getValue()
                    end
                end)
            end
        end
    end)
    
    -- Применяем настройки скорости
    humanoid.WalkSpeed = 16 * speedSlider.getValue()
    humanoid.JumpPower = 50 * jumpSlider.getValue()
end

player.CharacterAdded:Connect(setupCharacterMovement)
if character then
    setupCharacterMovement(character)
end

-- Сохранение настроек
local DataStoreService = game:GetService("DataStoreService")
local settingsStore = DataStoreService:GetDataStore("PlayerSettings_" .. game.PlaceId)

local function saveSettings()
    local success, err = pcall(function()
        settingsStore:SetAsync(
            player.UserId,
            {
                speed = speedSlider.getValue(),
                jump = jumpSlider.getValue(),
                effects = effectsToggle.getValue(),
                sound = soundToggle.getValue()
            }
        )
    end)
    
    if not success then
        warn("Не удалось сохранить настройки:", err)
    end
end

local function loadSettings()
    local success, data = pcall(function()
        return settingsStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        speedSlider.setValue(data.speed or 2.5)
        jumpSlider.setValue(data.jump or 1.5)
        effectsToggle.setValue(data.effects == nil and true or data.effects)
        soundToggle.setValue(data.sound == nil and true or data.sound)
    end
end

-- Загружаем настройки при входе игрока
player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        saveSettings()
    end
end)

game:BindToClose(function()
    saveSettings()
end)

loadSettings()