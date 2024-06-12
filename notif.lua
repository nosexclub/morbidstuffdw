--[[
my very shit notification shit
]]

-- Constants
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local TEXT_SIZE = 16
local FADE_DURATION = 4  
local FADE_DELAY = 2  
local NOTIFICATION_HEIGHT = 25  
local OFFSET_FROM_BOTTOM = 50  

local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local notifications = {}

local function CreateNotification(message)
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local textSize = TextService:GetTextSize(message, TEXT_SIZE, Enum.Font.SourceSans, Vector2.new(viewportSize.X, 0))

    local notification = {
        Text = message,
        Size = textSize + Vector2.new(10, 10),
        StartTime = tick(),
        TextDrawing = Drawing.new("Text"),
        AccentFrame = Drawing.new("Square"),
        YPosition = viewportSize.Y - OFFSET_FROM_BOTTOM - (#notifications + 1) * NOTIFICATION_HEIGHT
    }

    notification.TextDrawing.Text = message
    notification.TextDrawing.Font = 2
    notification.TextDrawing.Size = TEXT_SIZE
    notification.TextDrawing.Color = TEXT_COLOR
    notification.TextDrawing.Center = true
    notification.TextDrawing.Outline = true
    notification.TextDrawing.OutlineColor = Color3.new(0, 0, 0)
    notification.TextDrawing.Position = Vector2.new(viewportSize.X / 2, notification.YPosition + 10)
    notification.TextDrawing.Visible = true

    notification.AccentFrame.Color = Color3.fromRGB(145, 145, 255)
    notification.AccentFrame.Size = Vector2.new(0, 3)  -- Start with a small width
    notification.AccentFrame.Position = Vector2.new(viewportSize.X / 2 - notification.Size.X / 2, notification.YPosition + notification.Size.Y)
    notification.AccentFrame.Visible = true

    table.insert(notifications, notification)

    local function Update()
        local elapsedTime = tick() - notification.StartTime
        if elapsedTime >= FADE_DELAY then
            local fadeElapsedTime = elapsedTime - FADE_DELAY
            if fadeElapsedTime >= FADE_DURATION then
                notification.TextDrawing.Visible = false
                notification.AccentFrame.Visible = false
                return true
            end

            local alpha = 1 - (fadeElapsedTime / FADE_DURATION)
            notification.TextDrawing.Transparency = alpha
            notification.AccentFrame.Transparency = alpha
        end

        local accentWidth = (notification.Size.X / FADE_DURATION) * math.min(elapsedTime, FADE_DURATION)
        notification.AccentFrame.Size = Vector2.new(accentWidth, 3)  -- Fixed height for accent frame

        return false
    end

    RunService.RenderStepped:Connect(function()
        if Update() then
            notification.TextDrawing:Remove()
            notification.AccentFrame:Remove()
            table.remove(notifications, 1)
            for index, notification in ipairs(notifications) do
                notification.TextDrawing.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y - OFFSET_FROM_BOTTOM - index * NOTIFICATION_HEIGHT + 10)
                notification.AccentFrame.Position = Vector2.new(viewportSize.X / 2 - notification.Size.X / 2, notification.YPosition + notification.Size.Y)
            end
        end
    end)
end

-- example:
-- CreateNotification("Notification 1")