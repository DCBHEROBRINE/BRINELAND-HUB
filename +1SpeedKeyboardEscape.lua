-- +1 Speed Keyboard Escape (Brineland)
if _G.BrinelandScriptLoaded then return end
_G.BrinelandScriptLoaded = true

local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local customName = "Brineland"
local customAnimName = "Brineland"
local unlockPacks = {"Premium", "Water", "Bubble", "Christmas", "Lava", "Honey", "Snow", "Slime", customAnimName}

for _, packName in ipairs(unlockPacks) do
    LocalPlayer:SetAttribute("Sound_" .. packName, true)
    LocalPlayer:SetAttribute("Owns_" .. packName, true)
    LocalPlayer:SetAttribute("Anim_" .. packName, true)
    LocalPlayer:SetAttribute("Unlocked_" .. packName, true)
end

LocalPlayer:SetAttribute("CustomName", customName)
LocalPlayer:SetAttribute("SelectedAnimation", customAnimName)

local function unlockGuiElements()
    for _, guiObj in ipairs(PlayerGui:GetDescendants()) do
        local nameLower = guiObj.Name:lower()
        if nameLower:find("sound") or nameLower:find("anim") then
            if guiObj:IsA("ImageButton") or guiObj:IsA("TextButton") then guiObj.Active = true end
            if guiObj:IsA("ImageLabel") and (nameLower:find("lock") or nameLower:find("padlock")) then guiObj.Visible = false end
        end
    end
end

unlockGuiElements()
PlayerGui.DescendantAdded:Connect(unlockGuiElements)

local function protectHumanoid(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid and hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__newindex", function(self, key, value)
            if not checkcaller() and self == humanoid and key == "Health" and value == 0 then return nil end
            return oldIndex(self, key, value)
        end)
    end
end

if LocalPlayer.Character then protectHumanoid(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(protectHumanoid)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            -- Active script loop ensuring unlock state remains persistent
        end
    end
end)
