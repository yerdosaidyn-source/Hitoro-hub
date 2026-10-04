--[[
    ═══════════════════════════════════════════════════════════════════════
    ██╗██╗  ██╗ ██████╗ ██████╗ ██╗███████╗██╗   ██╗██████╗ 
    ██║██║ ██╔╝██╔═══██╗██╔══██╗██║██╔════╝██║   ██║██╔══██╗
    ██║█████╔╝ ██║   ██║██║  ██║██║█████╗  ██║   ██║██████╔╝
██  ██║██╔═██╗ ██║   ██║██║  ██║██║██╔══╝  ██║   ██║██╔══██╗
╚█████╔╝██║  ██╗╚██████╔╝██████╔╝██║███████╗╚██████╔╝██████╔╝
 ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═════╝ 
    ═══════════════════════════════════════════════════════════════════════
    jkodihub | MM2 | v6.0 | Delta Executor Optimized
    GitHub Gist Ready | Mobile + PC | RGB Color Picker
    ═══════════════════════════════════════════════════════════════════════
]]

--[[ CONFIGURATION ]]--
local cfg = {
    Aimbot = false,
    SilentAim = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    AimbotTarget = "Murderer",
    AutoKillMurder = false,
    AutoKillRange = 8,
    AutoPickupGun = false,
    AutoPickupRange = 250,
    FlingMurder = false,
    FlingSheriff = false,
    FlingPower = 80,
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPRole = true,
    ESPDistance = true,
    FullBright = false,
    NoFog = false,
    FOVCircle = false,
    Fly = false,
    FlySpeed = 80,
    Speed = false,
    SpeedValue = 60,
    Noclip = false,
    InfiniteJump = false,
    Wallbang = false,
    HitboxExpander = false,
    HitboxSize = 15,
}

--[[ SERVICES ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--[[ HELPERS ]]--
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function notify(text, color)
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local old = pg:FindFirstChild("jkodihubNotify")
    if old then old:Destroy() end
    
    local n = new("TextLabel", {
        Name = "jkodihubNotify",
        Size = UDim2.new(0, 280, 0, 46),
        Position = UDim2.new(0.5, -140, 0, 70),
        BackgroundColor3 = Color3.fromRGB(8, 8, 12),
        Text = "  " .. text,
        TextColor3 = color or Color3.fromRGB(100, 255, 120),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9999,
    }, pg)
    new("UICorner", {CornerRadius = UDim.new(0, 10)}, n)
    new("UIStroke", {Color = color or Color3.fromRGB(100, 255, 120), Thickness = 1.5, Transparency = 0.4}, n)
    
    task.delay(2.5, function()
        TweenService:Create(n, TweenInfo.new(0.35), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        task.wait(0.4)
        n:Destroy()
    end)
end

--[[ ROLES ]]--
local function getRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") then return "Sheriff" end
    return "Innocent"
end

local function isAlive(p)
    local h = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Murderer" and isAlive(p) then return p end
    end
end

local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "Sheriff" and isAlive(p) then return p end
    end
end

--[[ CLEANUP ]]--
pcall(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    for _, name in ipairs({"jkodihub", "jkodihubFOV", "jkodihubNotify"}) do
        local old = pg:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)

--[[ UI ]]--
local ScreenGui = new("ScreenGui", {
    Name = "jkodihub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, LocalPlayer:WaitForChild("PlayerGui"))

-- Цветовая тема панели (по умолчанию чёрная)
local PanelColor = Color3.fromRGB(0, 0, 0)
local HeaderColor = Color3.fromRGB(12, 12, 18)

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.new(0, isMobile and 290 or 340, 0, isMobile and 420 or 560),
    Position = UDim2.new(0.02, 0, 0.12, 0),
    BackgroundColor3 = PanelColor,
    BorderSizePixel = 0,
    Active = true,
    Draggable = not isMobile,
}, ScreenGui)

new("UICorner", {CornerRadius = UDim.new(0, 12)}, Main)
local MainStroke = new("UIStroke", {
    Color = Color3.fromRGB(70, 70, 80),
    Thickness = 1.5,
    Transparency = 0.2,
}, Main)

-- HEADER
local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = HeaderColor,
    BorderSizePixel = 0,
}, Main)
new("UICorner", {CornerRadius = UDim.new(0, 12)}, Header)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = HeaderColor,
    BorderSizePixel = 0,
}, Header)

new("TextLabel", {
    Size = UDim2.new(1, -140, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "jkodihub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

new("TextLabel", {
    Size = UDim2.new(1, -140, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "  jkodihub",
    TextColor3 = Color3.fromRGB(60, 160, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 0.45,
}, Header)

-- HEADER BUTTONS
local function hBtn(txt, x, cb)
    local b = new("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, x, 0, 7),
        BackgroundColor3 = Color3.fromRGB(28, 28, 38),
        Text = txt,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        AutoButtonColor = true,
    }, Header)
    new("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- ================================================================
-- COLOR PICKER SYSTEM
-- ================================================================
local ColorPickerGui = new("Frame", {
    Name = "ColorPicker",
    Size = UDim2.new(0, 240, 0, 220),
    Position = UDim2.new(0.5, -120, 0.5, -110),
    BackgroundColor3 = Color3.fromRGB(15, 15, 22),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 500,
}, ScreenGui)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, ColorPickerGui)
new("UIStroke", {Color = Color3.fromRGB(80, 80, 100), Thickness = 1.5}, ColorPickerGui)

local CP_Title = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Text = "Выбор цвета панели",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 501,
}, ColorPickerGui)

-- Превью цвета
local CP_Preview = new("Frame", {
    Size = UDim2.new(1, -40, 0, 26),
    Position = UDim2.new(0, 20, 0, 36),
    BackgroundColor3 = PanelColor,
    BorderSizePixel = 0,
    ZIndex = 501,
}, ColorPickerGui)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, CP_Preview)
new("UIStroke", {Color = Color3.fromRGB(80, 80, 100), Thickness = 1}, CP_Preview)

-- Пресеты цветов
local presets = {
    {name = "Чёрный", color = Color3.fromRGB(0, 0, 0)},
    {name = "Тёмно-синий", color = Color3.fromRGB(10, 15, 40)},
    {name = "Тёмно-красный", color = Color3.fromRGB(40, 8, 8)},
    {name = "Тёмно-зелёный", color = Color3.fromRGB(8, 35, 8)},
    {name = "Фиолетовый", color = Color3.fromRGB(35, 10, 45)},
    {name = "Тёмно-жёлтый", color = Color3.fromRGB(45, 35, 5)},
    {name = "Бирюзовый", color = Color3.fromRGB(5, 35, 40)},
    {name = "Серый", color = Color3.fromRGB(30, 30, 30)},
    {name = "Розовый", color = Color3.fromRGB(45, 10, 25)},
    {name = "Оранжевый", color = Color3.fromRGB(45, 20, 5)},
}

local PresetFrame = new("Frame", {
    Size = UDim2.new(1, -20, 0, 90),
    Position = UDim2.new(0, 10, 0, 68),
    BackgroundTransparency = 1,
    ZIndex = 501,
}, ColorPickerGui)

local presetGrid = new("UIGridLayout", {
    CellSize = UDim2.new(0, 42, 0, 42),
    CellPadding = UDim2.new(0, 4, 0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, PresetFrame)

local function applyPanelColor(color)
    PanelColor = color
    Main.BackgroundColor3 = color
    Header.BackgroundColor3 = color:Lerp(Color3.new(0.1, 0.1, 0.15), 0.7)
    MainStroke.Color = color:Lerp(Color3.new(1, 1, 1), 0.55)
    CP_Preview.BackgroundColor3 = color
end

for _, preset in ipairs(presets) do
    local btn = new("TextButton", {
        Size = UDim2.new(0, 42, 0, 42),
        BackgroundColor3 = preset.color,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 502,
    }, PresetFrame)
    new("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
    new("UIStroke", {Color = Color3.fromRGB(90, 90, 110), Thickness = 1}, btn)
    btn.MouseButton1Click:Connect(function()
        applyPanelColor(preset.color)
        notify("Цвет: " .. preset.name, Color3.fromRGB(100, 255, 120))
    end)
end

-- RGB Слайдеры
local function rgbSlider(name, y, color, cb)
    local label = new("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 20, 0, y),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = color,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ZIndex = 501,
    }, ColorPickerGui)
    
    local bar = new("Frame", {
        Size = UDim2.new(0, 150, 0, 10),
        Position = UDim2.new(0, 45, 0, y + 5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        ZIndex = 501,
    }, ColorPickerGui)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, bar)
    
    local fill = new("Frame", {
        Size = UDim2.new(cb.default or 0, 0, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        ZIndex = 502,
    }, bar)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
    
    local valueLabel = new("TextLabel", {
        Size = UDim2.new(0, 30, 0, 20),
        Position = UDim2.new(1, -32, 0, y),
        BackgroundTransparency = 1,
        Text = tostring(math.floor((cb.default or 0) * 255)),
        TextColor3 = Color3.fromRGB(220, 220, 230),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ZIndex = 501,
    }, ColorPickerGui)
    
    local drag = false
    local function upd(inp)
        local pos = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(math.floor(pos * 255))
        cb.set(pos)
    end
    
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(inp)
        end
    end)
    bar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            upd(inp)
        end
    end)
end

-- RGB значения
local rgbVals = {r = 0, g = 0, b = 0}

local function updateFromRGB()
    local c = Color3.fromRGB(rgbVals.r * 255, rgbVals.g * 255, rgbVals.b * 255)
    applyPanelColor(c)
end

rgbSlider("R", 168, Color3.fromRGB(255, 80, 80), {
    default = 0,
    set = function(v) rgbVals.r = v; updateFromRGB() end,
})

rgbSlider("G", 194, Color3.fromRGB(80, 255, 80), {
    default = 0,
    set = function(v) rgbVals.g = v; updateFromRGB() end,
})

rgbSlider("B", 220, Color3.fromRGB(80, 80, 255), {
    default = 0,
    set = function(v) rgbVals.b = v; updateFromRGB() end,
})

-- Кнопки "Применить" и "Закрыть"
local ApplyBtn = new("TextButton", {
    Size = UDim2.new(0, 100, 0, 28),
    Position = UDim2.new(0, 20, 1, -38),
    BackgroundColor3 = Color3.fromRGB(30, 80, 30),
    Text = "Применить",
    TextColor3 = Color3.fromRGB(100, 255, 120),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 502,
}, ColorPickerGui)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, ApplyBtn)
ApplyBtn.MouseButton1Click:Connect(function()
    ColorPickerGui.Visible = false
    notify("Цвет применён", Color3.fromRGB(100, 255, 120))
end)

local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 100, 0, 28),
    Position = UDim2.new(1, -120, 1, -38),
    BackgroundColor3 = Color3.fromRGB(60, 25, 25),
    Text = "Закрыть",
    TextColor3 = Color3.fromRGB(255, 100, 100),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 502,
}, ColorPickerGui)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    ColorPickerGui.Visible = false
end)

-- Кнопка палитры в хедере
hBtn("🎨", -80, function()
    ColorPickerGui.Visible = not ColorPickerGui.Visible
    ColorPickerGui.ZIndex = 500
    -- Обновляем превью
    CP_Preview.BackgroundColor3 = PanelColor
end)

-- Свернуть
local minimized = false
local MinBtn = hBtn("—", -42, function()
    minimized = not minimized
    Scroll.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, isMobile and 290 or 340, 0, 46) or UDim2.new(0, isMobile and 290 or 340, 0, isMobile and 420 or 560)
end)

hBtn("✕", -8, function()
    ScreenGui.Enabled = false
    task.wait(0.3)
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local toggle = new("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(0, 12, 0.5, -26),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Text = "jk",
        TextColor3 = Color3.fromRGB(60, 160, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        ZIndex = 99,
    }, pg)
    new("UICorner", {CornerRadius = UDim.new(0, 26)}, toggle)
    new("UIStroke", {Color = Color3.fromRGB(60, 160, 255), Thickness = 1.5}, toggle)
    toggle.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = true
        toggle:Destroy()
    end)
end)

-- SCROLL
local Scroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -14, 1, -60),
    Position = UDim2.new(0, 7, 0, 52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = Color3.fromRGB(60, 160, 255),
    CanvasSize = UDim2.new(0, 0, 0, 1600),
    ScrollingDirection = Enum.ScrollingDirection.Y,
}, Main)

new("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Scroll)

--[[ UI COMPONENTS ]]--
local function Section(text)
    local s = new("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = Color3.fromRGB(18, 18, 24),
        BorderSizePixel = 0,
    }, Scroll)
    new("UICorner", {CornerRadius = UDim.new(0, 6)}, s)
    new("UIStroke", {Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.4}, s)
    new("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = "▸ " .. text,
        TextColor3 = Color3.fromRGB(60, 160, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, s)
end

local function Toggle(name, default, cb)
    local b = new("TextButton", {
        Size = UDim2.new(1, -10, 0, 36),
        BackgroundColor3 = Color3.fromRGB(22, 22, 28),
        Text = "",
        AutoButtonColor = false,
    }, Scroll)
    new("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
    local st = new("UIStroke", {Color = Color3.fromRGB(45, 45, 55), Thickness = 1}, b)
    
    new("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(235, 235, 245),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, b)
    
    local status = new("TextLabel", {
        Size = UDim2.new(0, 48, 0, 24),
        Position = UDim2.new(1, -56, 0.5, -12),
        BackgroundColor3 = default and Color3.fromRGB(25, 55, 25) or Color3.fromRGB(55, 25, 25),
        Text = default and "ON" or "OFF",
        TextColor3 = default and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
    }, b)
    new("UICorner", {CornerRadius = UDim.new(0, 4)}, status)
    
    local state = default
    b.MouseButton1Click:Connect(function()
        state = not state
        status.Text = state and "ON" or "OFF"
        status.TextColor3 = state and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
        status.BackgroundColor3 = state and Color3.fromRGB(25, 55, 25) or Color3.fromRGB(55, 25, 25)
        st.Color = state and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(45, 45, 55)
        cb(state)
    end)
end

local function Slider(name, min, max, default, cb)
    local f = new("Frame", {
        Size = UDim2.new(1, -10, 0, 48),
        BackgroundColor3 = Color3.fromRGB(22, 22, 28),
        BorderSizePixel = 0,
    }, Scroll)
    new("UICorner", {CornerRadius = UDim.new(0, 6)}, f)
    new("UIStroke", {Color = Color3.fromRGB(45, 45, 55), Thickness = 1}, f)
    
    local label = new("TextLabel", {
        Size = UDim2.new(1, -22, 0, 18),
        Position = UDim2.new(0, 14, 0, 4),
        BackgroundTransparency = 1,
        Text = name .. ": " .. default,
        TextColor3 = Color3.fromRGB(235, 235, 245),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)
    
    local bar = new("Frame", {
        Size = UDim2.new(1, -28, 0, 8),
        Position = UDim2.new(0, 14, 0, 30),
        BackgroundColor3 = Color3.fromRGB(12, 12, 16),
        BorderSizePixel = 0,
    }, f)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, bar)
    
    local fill = new("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 160, 255),
        BorderSizePixel = 0,
    }, bar)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
    
    local drag = false
    local function upd(inp)
        local pos = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * pos + 0.5)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. ": " .. v
        cb(v)
    end
    
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(inp)
        end
    end)
    bar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            upd(inp)
        end
    end)
end

local function Button(name, cb)
    local b = new("TextButton", {
        Size = UDim2.new(1, -10, 0, 34),
        BackgroundColor3 = Color3.fromRGB(32, 32, 40),
        Text = name,
        TextColor3 = Color3.fromRGB(235, 235, 245),
        Font = Enum.Font.Gotham,
        TextSize = 13,
    }, Scroll)
    new("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
    new("UIStroke", {Color = Color3.fromRGB(50, 50, 60), Thickness = 1}, b)
    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
        task.wait(0.1)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        cb()
    end)
end

--[[ FOV CIRCLE ]]--
local FovGui = new("ScreenGui", {Name = "jkodihubFOV", ResetOnSpawn = false, IgnoreGuiInset = true}, LocalPlayer:WaitForChild("PlayerGui"))
local FovCircle = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, cfg.AimbotFOV * 2, 0, cfg.AimbotFOV * 2),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Visible = false,
}, FovGui)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, FovCircle)
new("UIStroke", {Color = Color3.fromRGB(60, 160, 255), Thickness = 1.5, Transparency = 0.3}, FovCircle)

--[[ ESP ]]--
local espData = {}

local function clearESP()
    for _, d in pairs(espData) do
        if d.HL then d.HL:Destroy() end
        if d.BB then d.BB:Destroy() end
    end
    espData = {}
end

local function applyESP(p)
    if p == LocalPlayer or not p.Character then return end
    if espData[p] then
        if espData[p].HL then espData[p].HL:Destroy() end
        if espData[p].BB then espData[p].BB:Destroy() end
        espData[p] = nil
    end
    
    local role = getRole(p)
    local color = role == "Murderer" and Color3.fromRGB(255, 40, 40)
        or role == "Sheriff" and Color3.fromRGB(40, 120, 255)
        or Color3.fromRGB(40, 255, 80)
    
    local char = p.Character
    local d = {}
    
    if cfg.ESPBox then
        d.HL = new("Highlight", {
            Adornee = char,
            FillColor = color,
            OutlineColor = Color3.new(1, 1, 1),
            FillTransparency = 0.65,
            OutlineTransparency = 0,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        }, char)
    end
    
    if cfg.ESPName or cfg.ESPRole or cfg.ESPDistance then
        local bb = new("BillboardGui", {
            Size = UDim2.new(0, 200, 0, 50),
            StudsOffset = Vector3.new(0, 3.4, 0),
            AlwaysOnTop = true,
            Adornee = char,
        }, char)
        
        if cfg.ESPName then
            new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                Text = p.Name,
                TextColor3 = color,
                TextStrokeTransparency = 0,
                TextStrokeColor3 = Color3.new(0, 0, 0),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
            }, bb)
        end
        
        if cfg.ESPRole then
            new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 14),
                Position = UDim2.new(0, 0, 0, 16),
                BackgroundTransparency = 1,
                Text = "[" .. role .. "]",
                TextColor3 = color,
                TextStrokeTransparency = 0,
                TextStrokeColor3 = Color3.new(0, 0, 0),
                Font = Enum.Font.Gotham,
                TextSize = 11,
            }, bb)
        end
        
        if cfg.ESPDistance then
            d.DistLabel = new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = Color3.fromRGB(180, 180, 190),
                TextStrokeTransparency = 0,
                Font = Enum.Font.Gotham,
                TextSize = 10,
            }, bb)
        end
        
        d.BB = bb
    end
    
    espData[p] = d
end

local function refreshESP()
    if not cfg.ESP then
        clearESP()
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            applyESP(p)
        end
    end
end

--[[ AIMBOT ]]--
local function getTarget()
    local closest, shortest = nil, cfg.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            local role = getRole(p)
            if cfg.AimbotTarget == "Murderer" and role ~= "Murderer" then continue end
            if cfg.AimbotTarget == "Sheriff" and role ~= "Sheriff" then continue end
            
            local part = p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X, screen.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

--[[ FLING ]]--
local function doFling(t)
    if not t or not t.Character then return end
    local hrp = t.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not myHrp then return end
    
    local dir = (hrp.Position - myHrp.Position)
    if dir.Magnitude < 0.1 then dir = Vector3.new(1, 0, 0) end
    dir = dir.Unit
    
    pcall(function()
        hrp.Velocity = dir * cfg.FlingPower * 15 + Vector3.new(0, cfg.FlingPower * 2.5, 0)
        hrp.RotVelocity = Vector3.new(math.random(-200, 200), math.random(-200, 200), math.random(-200, 200)) * (cfg.FlingPower / 100)
    end)
end

--[[ AUTO KILL ]]--
local function autoKillStep()
    if not cfg.AutoKillMurder then return end
    local m = getMurderer()
    if not m then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHum or not myHrp then return end
    
    local tHrp = m.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    
    local dist = (myHrp.Position - tHrp.Position).Magnitude
    if dist > cfg.AutoKillRange then
        myHum:MoveTo(tHrp.Position)
    else
        pcall(function()
            myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, -2)
        end)
        local knife = myChar:FindFirstChild("Knife")
        if knife then
            local slash = knife:FindFirstChild("Slash") or knife:FindFirstChild("Attack")
            if slash and slash:IsA("RemoteEvent") then
                pcall(function() slash:FireServer() end)
            end
            pcall(function()
                if knife:FindFirstChild("Handle") then
                    firetouchinterest(knife.Handle, tHrp, 0)
                    task.wait(0.05)
                    firetouchinterest(knife.Handle, tHrp, 1)
                end
            end)
        end
    end
end

--[[ AUTO PICKUP ]]--
local function autoPickupStep()
    if not cfg.AutoPickupGun then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHum or not myHrp then return end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Gun" or obj.Name == "Revolver") and obj:IsA("BasePart") and obj.Parent then
            local dist = (myHrp.Position - obj.Position).Magnitude
            if dist < cfg.AutoPickupRange then
                if dist > 5 then
                    myHum:MoveTo(obj.Position)
                else
                    pcall(function()
                        firetouchinterest(myHrp, obj, 0)
                        task.wait(0.05)
                        firetouchinterest(myHrp, obj, 1)
                    end)
                end
            end
        end
    end
end

--[[ FLY ]]--
local flyBV, flyBG

local function setFly(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if state then
        flyBV = new("BodyVelocity", {MaxForce = Vector3.new(1e5, 1e5, 1e5), Velocity = Vector3.new(0, 0, 0), P = 1250}, hrp)
        flyBG = new("BodyGyro", {MaxTorque = Vector3.new(1e5, 1e5, 1e5), P = 1000, D = 50, CFrame = hrp.CFrame}, hrp)
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
    end
end

local function flyStep()
    if not cfg.Fly or not flyBV then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dir = Vector3.new()
    
    if isMobile then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            dir = hum.MoveDirection
            if dir.Magnitude > 0 then dir = dir.Unit end
        end
    else
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
    end
    
    if dir.Magnitude > 0 then
        flyBV.Velocity = dir.Unit * cfg.FlySpeed
    else
        flyBV.Velocity = Vector3.new(0, 0, 0)
    end
end

--[[ INFINITE JUMP ]]--
local infJumpConn
local function setInfJump(state)
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

--[[ MAIN LOOPS ]]--
RunService.RenderStepped:Connect(function()
    if cfg.Aimbot then
        local t = getTarget()
        if t and t.Character then
            local part = t.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local goal = CFrame.new(Camera.CFrame.Position, part.Position)
                Camera.CFrame = Camera.CFrame:Lerp(goal, cfg.AimbotSmooth)
            end
        end
    end
    
    flyStep()
    
    if cfg.FullBright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        Lighting.GlobalShadows = false
    end
    
    if cfg.NoFog then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 0
    end
end)

RunService.Heartbeat:Connect(function()
    autoKillStep()
    autoPickupStep()
    
    if cfg.FlingMurder then
        local m = getMurderer()
        if m then doFling(m) end
    end
    if cfg.FlingSheriff then
        local s = getSheriff()
        if s then doFling(s) end
    end
    
    if cfg.Speed then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = cfg.SpeedValue end
        end
    end
    
    if cfg.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
    
    if cfg.Wallbang then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if cfg.HitboxExpander then
                    hrp.Size = Vector3.new(cfg.HitboxSize, cfg.HitboxSize, cfg.HitboxSize)
                    hrp.Transparency = 0.6
                    hrp.CanCollide = false
                    hrp.Massless = true
                elseif hrp.Size ~= Vector3.new(2, 2, 1) then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                    hrp.Massless = false
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        FovCircle.Size = UDim2.new(0, cfg.AimbotFOV * 2, 0, cfg.AimbotFOV * 2)
        FovCircle.Visible = cfg.FOVCircle
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        refreshESP()
        for p, d in pairs(espData) do
            if d.DistLabel and p.Character and LocalPlayer.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then
                    d.DistLabel.Text = math.floor((hrp.Position - myHrp.Position).Magnitude) .. " studs"
                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if cfg.Fly then setFly(true) end
    if cfg.InfiniteJump then setInfJump(true) end
end)

for _, p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.ESP then applyESP(p) end
    end)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if cfg.ESP then applyESP(p) end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        if espData[p].HL then espData[p].HL:Destroy() end
        if espData[p].BB then espData[p].BB:Destroy() end
        espData[p] = nil
    end
end)

--[[ MENU ]]--
Section("⚔ COMBAT")
Toggle("Aimbot", cfg.Aimbot, function(s) cfg.Aimbot = s end)
Toggle("Silent Aim", cfg.SilentAim, function(s) cfg.SilentAim = s end)
Slider("Aimbot FOV", 20, 500, cfg.AimbotFOV, function(v) cfg.AimbotFOV = v end)
Slider("Aimbot Smooth", 1, 100, 25, function(v) cfg.AimbotSmooth = v / 100 end)

Section("🔪 AUTO")
Toggle("Auto Kill Murder", cfg.AutoKillMurder, function(s) cfg.AutoKillMurder = s end)
Slider("Auto Kill Range", 3, 30, cfg.AutoKillRange, function(v) cfg.AutoKillRange = v end)
Toggle("Auto Pickup Gun", cfg.AutoPickupGun, function(s) cfg.AutoPickupGun = s end)
Slider("Pickup Range", 50, 500, cfg.AutoPickupRange, function(v) cfg.AutoPickupRange = v end)

Section("💥 FLING")
Toggle("Fling Murder", cfg.FlingMurder, function(s) cfg.FlingMurder = s end)
Toggle("Fling Sheriff", cfg.FlingSheriff, function(s) cfg.FlingSheriff = s end)
Slider("Fling Power", 10, 500, cfg.FlingPower, function(v) cfg.FlingPower = v end)

Section("👁 ESP")
Toggle("ESP Master", cfg.ESP, function(s) cfg.ESP = s; refreshESP() end)
Toggle("ESP Box", cfg.ESPBox, function(s) cfg.ESPBox = s; refreshESP() end)
Toggle("ESP Name", cfg.ESPName, function(s) cfg.ESPName = s; refreshESP() end)
Toggle("ESP Role", cfg.ESPRole, function(s) cfg.ESPRole = s; refreshESP() end)
Toggle("ESP Distance", cfg.ESPDistance, function(s) cfg.ESPDistance = s; refreshESP() end)

Section("🏃 MOVEMENT")
Toggle("Fly", cfg.Fly, function(s) cfg.Fly = s; setFly(s) end)
Slider("Fly Speed", 20, 300, cfg.FlySpeed, function(v) cfg.FlySpeed = v end)
Toggle("Speed Hack", cfg.Speed, function(s) cfg.Speed = s end)
Slider("Speed Value", 16, 200, cfg.SpeedValue, function(v) cfg.SpeedValue = v end)
Toggle("Noclip", cfg.Noclip, function(s) cfg.Noclip = s end)
Toggle("Infinite Jump", cfg.InfiniteJump, function(s) cfg.InfiniteJump = s; setInfJump(s) end)

Section("🎯 EXTRA")
Toggle("Wallbang", cfg.Wallbang, function(s) cfg.Wallbang = s end)
Toggle("Hitbox Expander", cfg.HitboxExpander, function(s) cfg.HitboxExpander = s end)
Slider("Hitbox Size", 5, 50, cfg.HitboxSize, function(v) cfg.HitboxSize = v end)

Section("🌍 VISUAL")
Toggle("Fullbright", cfg.FullBright, function(s) cfg.FullBright = s end)
Toggle("No Fog", cfg.NoFog, function(s) cfg.NoFog = s end)
Toggle("FOV Circle", cfg.FOVCircle, function(s) cfg.FOVCircle = s end)

Section("🎨 ПАНЕЛЬ")
Button("Открыть выбор цвета", function()
    ColorPickerGui.Visible = true
end)
Button("Сбросить на чёрный", function()
    applyPanelColor(Color3.fromRGB(0, 0, 0))
    notify("Цвет сброшен на чёрный", Color3.fromRGB(100, 255, 120))
end)

Section("⚙ MISC")
Button("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
Button("Server Hop", function()
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if ok and res and res.data then
        for _, srv in ipairs(res.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                return
            end
        end
    end
    notify("Сервер не найден", Color3.fromRGB(255, 100, 100))
end)
Button("Reset Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

Section("ℹ INFO")
local InfoLabel = new("TextLabel", {
    Size = UDim2.new(1, -10, 0, 52),
    BackgroundColor3 = Color3.fromRGB(16, 16, 22),
    Text = "jkodihub v6.0\nDelta Executor | Mobile + PC\nRGB Color Picker",
    TextColor3 = Color3.fromRGB(140, 140, 160),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextYAlignment = Enum.TextYAlignment.Center,
}, Scroll)
new("UICorner", {CornerRadius = UDim.new(0, 6)}, InfoLabel)

--[[ STARTUP ]]--
notify("jkodihub v6.0 загружен ✓", Color3.fromRGB(100, 255, 120))
task.wait(0.5)
notify(isMobile and "Мобильный режим" or "PC режим", Color3.fromRGB(60, 160, 255))

print("[jkodihub] v6.0 loaded")
