-- ============================================================
-- BRINELAND GLOBAL BACKGROUND MANAGER
-- ============================================================
local ThemeManager = {}

-- Your custom anime background asset ID
ThemeManager.BackgroundId = "rbxassetid://135283494832557"

function ThemeManager.Apply(parentFrame)
    -- Prevent duplicate backgrounds if applied twice
    if parentFrame:FindFirstChild("HubBackground") then return end

    -- 1. Create Background Image Label
    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "HubBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = ThemeManager.BackgroundId
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.Parent = parentFrame

    -- 2. Dark Overlay (Keeps text and buttons high contrast & readable)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
    overlay.BackgroundTransparency = 0.42
    overlay.ZIndex = 1
    overlay.Parent = bgImage
    
    -- 3. Push all existing UI elements above the background layer
    for _, child in pairs(parentFrame:GetChildren()) do
        if child ~= bgImage and child:IsA("GuiObject") then
            child.ZIndex = math.max(2, child.ZIndex)
        end
    end
end

return ThemeManager
