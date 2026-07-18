local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Colors = {
    FontColor = Color3.fromRGB(255, 255, 255),
    MainColor = Color3.fromRGB(28, 28, 28),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    AccentColor = Color3.fromRGB(0, 85, 255),
    DisabledTextColor = Color3.fromRGB(142, 142, 142),
    OutlineColor = Color3.fromRGB(50, 50, 50),
    Black = Color3.new(0, 0, 0),
}

local Font = Enum.Font.Code

local function Create(Class, Properties)
    local Instance = Instance.new(Class)
    for Property, Value in next, Properties do
        pcall(function() Instance[Property] = Value end)
    end
    return Instance
end

local function ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1
    return Create("UIStroke", {
        Color = Color3.new(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = Inst,
    })
end

local function CreateLabel(Properties)
    local Instance = Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Font,
        TextColor3 = Colors.FontColor,
        TextSize = 16,
        TextStrokeTransparency = 0,
    })
    ApplyTextStroke(Instance)
    return Create(Instance, Properties)
end

local function GetParentUI()
    local Success, Result = pcall(function() return CoreGui end)
    if Success and Result then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local LoadingConfig = {
    Title = "LOADING...",
    Subtitle = "Please wait",
    Duration = 5,
    Steps = {
        "Initializing...",
        "Loading assets...",
        "Setting up interface...",
        "Preparing scripts...",
        "Finalizing..."
    }
}

local LoadingScreen = {}
local ScreenGui
local Elements = {}
local Connections = {}

function LoadingScreen:Create(Config)
    Config = Config or {}
    
    for Key, Value in next, Config do
        if type(Value) == "table" and type(LoadingConfig[Key]) == "table" then
            for SubKey, SubValue in next, Value do
                LoadingConfig[Key][SubKey] = SubValue
            end
        else
            LoadingConfig[Key] = Value
        end
    end
    
    ScreenGui = Create("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999,
        ResetOnSpawn = false,
        Parent = GetParentUI()
    })
    
    local MainFrame = Create("Frame", {
        BackgroundColor3 = Colors.BackgroundColor,
        BorderColor3 = Colors.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 9999,
        Parent = ScreenGui
    })
    Elements.MainFrame = MainFrame
    
    local CenterContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 10000,
        Parent = MainFrame
    })
    
    local Icon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(80, 80),
        Position = UDim2.fromScale(0.5, 0.32),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://6031090271",
        ImageColor3 = Colors.AccentColor,
        ZIndex = 10000,
        Parent = CenterContainer
    })
    Elements.Icon = Icon
    
    local IconRotation = Create("UIRotation", { Parent = Icon })
    Elements.IconRotation = IconRotation
    
    local TitleLabel = CreateLabel({
        Size = UDim2.fromOffset(500, 45),
        Position = UDim2.fromScale(0.5, 0.46),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = LoadingConfig.Title,
        TextSize = 36,
        TextColor3 = Colors.FontColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 10000,
        Parent = CenterContainer
    })
    Elements.TitleLabel = TitleLabel
    
    local SubtitleLabel = CreateLabel({
        Size = UDim2.fromOffset(500, 25),
        Position = UDim2.fromScale(0.5, 0.51),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = LoadingConfig.Subtitle,
        TextSize = 18,
        TextColor3 = Colors.DisabledTextColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 10000,
        Parent = CenterContainer
    })
    Elements.SubtitleLabel = SubtitleLabel
    
    local StepLabel = CreateLabel({
        Size = UDim2.fromOffset(500, 20),
        Position = UDim2.fromScale(0.5, 0.57),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = LoadingConfig.Steps[1] or "Loading...",
        TextSize = 14,
        TextColor3 = Colors.DisabledTextColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 10000,
        Parent = CenterContainer
    })
    Elements.StepLabel = StepLabel
    
    local ProgressContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(400, 30),
        Position = UDim2.fromScale(0.5, 0.66),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 10000,
        Parent = CenterContainer
    })
    
    local ProgressBarOuter = Create("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderColor3 = Colors.OutlineColor,
        Size = UDim2.fromScale(1, 0.6),
        Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        ZIndex = 10000,
        Parent = ProgressContainer
    })
    
    local ProgressBarInner = Create("Frame", {
        BackgroundColor3 = Colors.MainColor,
        BorderColor3 = Colors.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 10001,
        Parent = ProgressBarOuter
    })
    Elements.ProgressBar = ProgressBarInner
    
    local ProgressFill = Create("Frame", {
        BackgroundColor3 = Colors.AccentColor,
        BorderColor3 = Colors.AccentColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.fromScale(0, 1),
        ZIndex = 10002,
        Parent = ProgressBarInner
    })
    Elements.ProgressFill = ProgressFill
    
    local Shimmer = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        ZIndex = 10003,
        Parent = ProgressFill
    })
    Elements.Shimmer = Shimmer
    
    local PercentLabel = CreateLabel({
        Size = UDim2.fromScale(1, 1),
        Text = "0%",
        TextSize = 14,
        TextColor3 = Colors.FontColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 10004,
        Parent = ProgressContainer
    })
    Elements.PercentLabel = PercentLabel
    
    local Footer = CreateLabel({
        Size = UDim2.fromOffset(400, 20),
        Position = UDim2.fromScale(0.5, 0.92),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "Your Footer",
        TextSize = 12,
        TextColor3 = Colors.DisabledTextColor,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 10000,
        Parent = CenterContainer
    })
    
    return LoadingScreen
end

function LoadingScreen:SetProgress(Percent)
    Percent = math.clamp(Percent, 0, 100)
    local Normalized = Percent / 100
    
    if Elements.ProgressFill then
        Elements.ProgressFill.Size = UDim2.fromScale(Normalized, 1)
    end
    
    if Elements.Shimmer then
        Elements.Shimmer.Size = UDim2.fromScale(Normalized, 1)
    end
    
    if Elements.PercentLabel then
        Elements.PercentLabel.Text = string.format("%d%%", Percent)
    end
    
    local StepIndex = math.ceil((Percent / 100) * #LoadingConfig.Steps)
    StepIndex = math.clamp(StepIndex, 1, #LoadingConfig.Steps)
    
    if Elements.StepLabel then
        Elements.StepLabel.Text = LoadingConfig.Steps[StepIndex] or "Loading..."
    end
    
    local Hue = Percent / 100 * 0.6
    if Elements.ProgressFill then
        Elements.ProgressFill.BackgroundColor3 = Color3.fromHSV(Hue, 0.8, 1)
    end
end

function LoadingScreen:SimulateLoading(Duration, Callback)
    Duration = Duration or LoadingConfig.Duration
    local StartTime = tick()
    
    local RotationConnection
    RotationConnection = RunService.Heartbeat:Connect(function(Delta)
        if Elements.IconRotation then
            Elements.IconRotation.Rotation = (Elements.IconRotation.Rotation or 0) + Delta * 60
        end
    end)
    table.insert(Connections, RotationConnection)
    
    while true do
        local Elapsed = tick() - StartTime
        local Percent = math.min((Elapsed / Duration) * 100, 100)
        
        self:SetProgress(Percent)
        
        if Percent >= 100 then
            break
        end
        
        RunService.Heartbeat:Wait()
    end
    
    for _, Connection in ipairs(Connections) do
        pcall(function() Connection:Disconnect() end)
    end
    Connections = {}
    
    if Callback then
        Callback()
    end
    
    self:FadeOut()
end

function LoadingScreen:FadeOut(Duration)
    Duration = Duration or 0.5
    
    if not Elements.MainFrame then return end
    
    local FadeTween = TweenService:Create(Elements.MainFrame,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear),
        { BackgroundTransparency = 1 }
    )
    
    FadeTween:Play()
    FadeTween.Completed:Connect(function()
        self:Destroy()
    end)
end

function LoadingScreen:Destroy()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
    
    Elements = {}
    Connections = {}
end

function CreateLoadingScreen(Config)
    Config = Config or {}
    
    local NewLoading = setmetatable({}, { __index = LoadingScreen })
    NewLoading:Create(Config)
    NewLoading:SimulateLoading(Config.Duration, Config.OnComplete)
    
    return NewLoading
end

CreateLoadingScreen({
    Title = "MY SCRIPT",
    Subtitle = "Loading...",
    Duration = 3,
    Steps = {
        "Initializing...",
        "Loading modules...",
        "Setting up UI...",
        "Ready!"
    },
    OnComplete = function()
        print("Loading complete!")
    end
})
