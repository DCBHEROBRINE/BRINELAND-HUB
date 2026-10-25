-- ============================================================
-- BRINELAND THEME & BACKGROUND MANAGER
-- ============================================================
local ThemeManager = {}

-- Map your game/script names to their specific background Image IDs
ThemeManager.Backgrounds = {
    ["Blox Fruits"]  = "rbxassetid://135283494832557", -- Your anime background
    ["Taxi Boss"]    = "rbxassetid://135283494832557", -- (Change ID if you want a car theme)
    ["Steal An Egg"] = "rbxassetid://135283494832557", -- (Change ID if you want an egg theme)
    ["Default"]      = "rbxassetid://135283494832557"  -- Universal fallback background
}

function ThemeManager.ApplyBackground(parentFrame, gameName)
    local assetId = ThemeManager.Backgrounds[gameName] or ThemeManager.Backgrounds["Default"]

    -- 1. Create Background Image Label
    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "HubBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = assetId
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.Parent = parentFrame

    -- 2. Dark Overlay (Keeps text, toggles, and buttons high contrast & readable)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
    overlay.BackgroundTransparency = 0.42 -- Adjust transparency (0 = pitch black, 1 = fully transparent)
    overlay.ZIndex = 1
    overlay.Parent = bgImage
    
    -- 3. Push UI elements above the background layer
    for _, child in pairs(parentFrame:GetChildren()) do
        if child ~= bgImage and child:IsA("GuiObject") then
            child.ZIndex = math.max(2, child.ZIndex)
        end
    end
end

return ThemeManager
