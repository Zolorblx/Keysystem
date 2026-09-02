--// BLUE GALAXY KEY UI
--// Clean UI + Moving Stars + Vertical Spaceship Intro

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--//==================================================
--// CONFIG
--//==================================================

local Config = {
    HubName = "ZOLO",
    HubDescription = "5$ for lifetime?",

    Background = Color3.fromRGB(4, 8, 22),
    Panel = Color3.fromRGB(9, 16, 38),

    Blue = Color3.fromRGB(45, 150, 255),
    LightBlue = Color3.fromRGB(100, 200, 255),
    Purple = Color3.fromRGB(100, 90, 255),

    StarCount = 75,
    IntroDuration = 3.2,
}

--//==================================================
--// REMOVE OLD UI
--//==================================================

local old = playerGui:FindFirstChild("ZOLO_GalaxyUI")
if old then
    old:Destroy()
end

--//==================================================
--// SCREEN GUI
--//==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZOLO_GalaxyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = playerGui

--//==================================================
--// GALAXY BACKGROUND
--//==================================================

local Background = Instance.new("Frame")
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = Config.Background
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- Subtle blue center glow
local Glow = Instance.new("Frame")
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.Position = UDim2.fromScale(0.5, 0.48)
Glow.Size = UDim2.fromScale(0.65, 0.65)
Glow.BackgroundColor3 = Color3.fromRGB(15, 55, 130)
Glow.BackgroundTransparency = 0.88
Glow.BorderSizePixel = 0
Glow.Parent = Background

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(1, 0)
GlowCorner.Parent = Glow

--//==================================================
--// STARS
--//==================================================

local Stars = {}

local function createStar()
    local star = Instance.new("Frame")

    local size = math.random(1, 3)

    star.Size = UDim2.fromOffset(size, size)
    star.Position = UDim2.fromScale(
        math.random(),
        math.random()
    )

    star.BackgroundColor3 =
        math.random(1, 3) == 1
        and Config.LightBlue
        or Color3.fromRGB(180, 220, 255)

    star.BackgroundTransparency = math.random(15, 55) / 100
    star.BorderSizePixel = 0
    star.ZIndex = 1
    star.Parent = Background

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = star

    table.insert(Stars, {
        Object = star,
        Speed = math.random(3, 12) / 10000,
        Twinkle = math.random(1, 3),
        BaseTransparency = star.BackgroundTransparency
    })
end

for _ = 1, Config.StarCount do
    createStar()
end

-- Moving stars
local starConnection

starConnection = RunService.RenderStepped:Connect(function()
    for _, data in ipairs(Stars) do
        local star = data.Object

        if star and star.Parent then
            local pos = star.Position

            star.Position = UDim2.new(
                pos.X.Scale,
                pos.X.Offset,
                pos.Y.Scale + data.Speed,
                pos.Y.Offset
            )

            -- Wrap around
            if star.Position.Y.Scale > 1.02 then
                star.Position = UDim2.new(
                    math.random(),
                    0,
                    -0.02,
                    0
                )
            end

            -- Gentle twinkle
            local pulse =
                (math.sin(os.clock() * data.Twinkle) + 1) / 2

            star.BackgroundTransparency =
                math.clamp(
                    data.BaseTransparency + pulse * 0.12,
                    0,
                    0.9
                )
        end
    end
end)

--//==================================================
--// SHOOTING STAR
--//==================================================

local function shootingStar()
    local meteor = Instance.new("Frame")

    meteor.Size = UDim2.fromOffset(3, 70)
    meteor.Position = UDim2.fromScale(
        math.random(10, 90) / 100,
        -0.1
    )

    meteor.BackgroundColor3 = Config.LightBlue
    meteor.BackgroundTransparency = 0.15
    meteor.BorderSizePixel = 0
    meteor.Rotation = 25
    meteor.ZIndex = 3
    meteor.Parent = Background

    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = meteor

    local tween = TweenService:Create(
        meteor,
        TweenInfo.new(
            1.2,
            Enum.EasingStyle.Linear
        ),
        {
            Position = UDim2.fromScale(
                meteor.Position.X.Scale - 0.3,
                1.1
            )
        }
    )

    tween:Play()

    tween.Completed:Connect(function()
        meteor:Destroy()
    end)
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(math.random(5, 9))
        shootingStar()
    end
end)

--//==================================================
--// SPACESHIP
--//==================================================

local Ship = Instance.new("Frame")
Ship.Name = "Spaceship"
Ship.AnchorPoint = Vector2.new(0.5, 0.5)
Ship.Position = UDim2.fromScale(0.5, 1.2)
Ship.Size = UDim2.fromOffset(80, 120)
Ship.BackgroundTransparency = 1
Ship.ZIndex = 10
Ship.Parent = ScreenGui

-- Ship body
local Body = Instance.new("Frame")
Body.AnchorPoint = Vector2.new(0.5, 0.5)
Body.Position = UDim2.fromScale(0.5, 0.42)
Body.Size = UDim2.fromOffset(42, 75)
Body.BackgroundColor3 = Color3.fromRGB(190, 215, 235)
Body.BorderSizePixel = 0
Body.Rotation = 0
Body.ZIndex = 11
Body.Parent = Ship

local BodyCorner = Instance.new("UICorner")
BodyCorner.CornerRadius = UDim.new(0.5, 0)
BodyCorner.Parent = Body

-- Blue cockpit
local Cockpit = Instance.new("Frame")
Cockpit.AnchorPoint = Vector2.new(0.5, 0.5)
Cockpit.Position = UDim2.fromScale(0.5, 0.28)
Cockpit.Size = UDim2.fromOffset(25, 25)
Cockpit.BackgroundColor3 = Config.LightBlue
Cockpit.BorderSizePixel = 0
Cockpit.ZIndex = 12
Cockpit.Parent = Ship

local CockpitCorner = Instance.new("UICorner")
CockpitCorner.CornerRadius = UDim.new(1, 0)
CockpitCorner.Parent = Cockpit

local CockpitStroke = Instance.new("UIStroke")
CockpitStroke.Color = Color3.fromRGB(180, 235, 255)
CockpitStroke.Thickness = 2
CockpitStroke.Parent = Cockpit

-- Wings
for side = -1, 1 do
    local wing = Instance.new("Frame")

    wing.AnchorPoint = Vector2.new(0.5, 0.5)
    wing.Position = UDim2.new(
        0.5 + side * 0.42,
        0,
        0.55,
        0
    )

    wing.Size = UDim2.fromOffset(25, 55)
    wing.BackgroundColor3 = Color3.fromRGB(45, 95, 160)
    wing.BorderSizePixel = 0
    wing.Rotation = side * -12
    wing.ZIndex = 10
    wing.Parent = Ship

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = wing
end

-- Engine glow
local Engine = Instance.new("Frame")
Engine.AnchorPoint = Vector2.new(0.5, 0)
Engine.Position = UDim2.fromScale(0.5, 0.78)
Engine.Size = UDim2.fromOffset(18, 35)
Engine.BackgroundColor3 = Config.LightBlue
Engine.BackgroundTransparency = 0.15
Engine.BorderSizePixel = 0
Engine.ZIndex = 9
Engine.Parent = Ship

local EngineCorner = Instance.new("UICorner")
EngineCorner.CornerRadius = UDim.new(1, 0)
EngineCorner.Parent = Engine

-- Engine animation
task.spawn(function()
    while Ship.Parent do
        local tween = TweenService:Create(
            Engine,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.fromOffset(18, 48),
                BackgroundTransparency = 0.4
            }
        )

        tween:Play()
        tween.Completed:Wait()

        local tween2 = TweenService:Create(
            Engine,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.fromOffset(18, 30),
                BackgroundTransparency = 0.1
            }
        )

        tween2:Play()
        tween2.Completed:Wait()
    end
end)

--//==================================================
--// INTRO TEXT
--//==================================================

local IntroText = Instance.new("TextLabel")
IntroText.AnchorPoint = Vector2.new(0.5, 0.5)
IntroText.Position = UDim2.fromScale(0.5, 0.73)
IntroText.Size = UDim2.fromOffset(500, 50)
IntroText.BackgroundTransparency = 1
IntroText.Text = "ENTERING GALAXY..."
IntroText.TextColor3 = Config.LightBlue
IntroText.Font = Enum.Font.GothamBold
IntroText.TextSize = 18
IntroText.TextTransparency = 0
IntroText.ZIndex = 10
IntroText.Parent = ScreenGui

--//==================================================
--// SHIP INTRO ANIMATION
--//==================================================

local shipTween = TweenService:Create(
    Ship,
    TweenInfo.new(
        Config.IntroDuration,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    {
        Position = UDim2.fromScale(0.5, -0.25)
    }
)

shipTween:Play()

-- Slight text fade
task.delay(1.8, function()
    TweenService:Create(
        IntroText,
        TweenInfo.new(0.8),
        {
            TextTransparency = 1
        }
    ):Play()
end)

shipTween.Completed:Wait()

Ship:Destroy()
IntroText:Destroy()

--//==================================================
--// MAIN UI
--//==================================================

local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.Size = UDim2.fromOffset(350, 400)
MainFrame.BackgroundColor3 = Config.Panel
MainFrame.BackgroundTransparency = 0.04
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 20
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.Blue
MainStroke.Transparency = 0.35
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

--// Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -40, 0, 55)
Header.Position = UDim2.fromOffset(20, 18)
Header.BackgroundTransparency = 1
Header.Text = Config.HubName
Header.TextColor3 = Config.LightBlue
Header.Font = Enum.Font.GothamBold
Header.TextSize = 25
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 21
Header.Parent = MainFrame

local Description = Instance.new("TextLabel")
Description.Size = UDim2.new(1, -40, 0, 35)
Description.Position = UDim2.fromOffset(20, 62)
Description.BackgroundTransparency = 1
Description.Text = Config.HubDescription
Description.TextColor3 = Color3.fromRGB(160, 185, 215)
Description.Font = Enum.Font.Gotham
Description.TextSize = 13
Description.TextXAlignment = Enum.TextXAlignment.Left
Description.ZIndex = 21
Description.Parent = MainFrame

--// Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -42, 0, 18)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(150, 180, 220)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 25
Close.ZIndex = 25
Close.Parent = MainFrame

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// Key box
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 48)
KeyInput.Position = UDim2.fromOffset(20, 125)
KeyInput.BackgroundColor3 = Color3.fromRGB(5, 12, 30)
KeyInput.TextColor3 = Color3.fromRGB(235, 245, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 125, 160)
KeyInput.PlaceholderText = "Enter your key..."
KeyInput.Text = ""
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 21
KeyInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = KeyInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(35, 80, 140)
InputStroke.Thickness = 1
InputStroke.Parent = KeyInput

--// Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 30)
Status.Position = UDim2.fromOffset(20, 185)
Status.BackgroundTransparency = 1
Status.Text = "Waiting for key..."
Status.TextColor3 = Color3.fromRGB(130, 160, 195)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.ZIndex = 21
Status.Parent = MainFrame

--// Button creator
local function createButton(text, position, color)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(0.46, 0, 0, 45)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.AutoButtonColor = false
    button.ZIndex = 21
    button.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 190, 255)
    stroke.Transparency = 0.55
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(color.R * 255 + 20, 255),
                    math.min(color.G * 255 + 20, 255),
                    math.min(color.B * 255 + 20, 255)
                )
            }
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = color
            }
        ):Play()
    end)

    return button
end

local VerifyButton = createButton(
    "VERIFY",
    UDim2.fromOffset(20, 225),
    Color3.fromRGB(20, 105, 205)
)

local GetKeyButton = createButton(
    "GET KEY",
    UDim2.new(0.54, 0, 0, 225),
    Color3.fromRGB(25, 35, 65)
)

--//==================================================
--// BACKEND PLACEHOLDERS
--//==================================================

local function verifyKey(key)
    -- Put your own key verification code here.
    -- Return:
    -- true, "Success"
    -- or
    -- false, "Invalid key"

    if key == "" then
        return false, "Enter a key first."
    end

    return false, "Connect your key verification here."
end

local function getKey()
    -- Put your own key-generation/link code here.
    -- Return:
    -- true, "https://example.com/..."
    -- or
    -- false, "Error message"

    return false, "Connect your key system here."
end

--//==================================================
--// BUTTON EVENTS
--//==================================================

VerifyButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text

    if key == "" then
        Status.Text = "Please enter a key."
        Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    Status.Text = "Verifying..."
    Status.TextColor3 = Config.LightBlue

    local success, message = verifyKey(key)

    if success then
        Status.Text = message or "Success!"
        Status.TextColor3 = Color3.fromRGB(80, 255, 160)
    else
        Status.Text = message or "Invalid key."
        Status.TextColor3 = Color3.fromRGB(255, 100, 110)
    end
end)

GetKeyButton.MouseButton1Click:Connect(function()
    Status.Text = "Generating key link..."
    Status.TextColor3 = Config.LightBlue

    local success, result = getKey()

    if success then
        Status.Text = "Key link generated!"
        Status.TextColor3 = Color3.fromRGB(80, 210, 255)

        if setclipboard then
            setclipboard(result)
        end
    else
        Status.Text = result or "Unable to generate link."
        Status.TextColor3 = Color3.fromRGB(255, 100, 110)
    end
end)

--//==================================================
--// UI FADE IN
--//==================================================

MainFrame.BackgroundTransparency = 1

for _, object in ipairs(MainFrame:GetDescendants()) do
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        object.TextTransparency = 1
    elseif object:IsA("UIStroke") then
        object.Transparency = 1
    end
end

TweenService:Create(
    MainFrame,
    TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    {
        BackgroundTransparency = 0.04
    }
):Play()

for _, object in ipairs(MainFrame:GetDescendants()) do
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        TweenService:Create(
            object,
            TweenInfo.new(0.7),
            {
                TextTransparency = 0
            }
        ):Play()

    elseif object:IsA("UIStroke") then
        TweenService:Create(
            object,
            TweenInfo.new(0.7),
            {
                Transparency = 0.35
            }
        ):Play()
    end
end

--//==================================================
--// DRAGGING
--//==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local connection

        connection = RunService.RenderStepped:Connect(function()
            if not dragging then
                connection:Disconnect()
                return
            end

            local delta = input.Position - dragStart

            MainFrame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end)
    end
end)
