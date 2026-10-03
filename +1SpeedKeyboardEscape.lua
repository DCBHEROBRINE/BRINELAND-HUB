-- Brineland Hub | Sound, Animation & Auto-Win Fix
-- GitHub Hosted Version

if _G.BrinelandScriptLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Brineland Hub",
        Text = "Script is already running!",
        Duration = 3
    })
    return
end
_G.BrinelandScriptLoaded = true

-- Compatibility Check
if not hookmetamethod then
    warn("[Brineland Hub] Your executor does not support hookmetamethod. Anti-kill features may not work fully.")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------
-- 1. BRINELAND CUSTOM NAME & ANIMATION/SOUND PACK UNLOCK
---------------------------------------------------------
local customName = "Brineland"
local customAnimName = "Brineland"

-- Include Brineland alongside standard sound/anim packs
local unlockPacks = {"Premium", "Water", "Bubble", "Christmas", "Lava", "Honey", "Snow", "Slime", customAnimName}

-- Set player custom attributes for sounds & animations
for _, packName in ipairs(unlockPacks) do
    LocalPlayer:SetAttribute("Sound_" .. packName, true)
    LocalPlayer:SetAttribute("Owns_" .. packName, true)
    LocalPlayer:SetAttribute("Anim_" .. packName, true)
    LocalPlayer:SetAttribute("Animation_" .. packName, true)
    LocalPlayer:SetAttribute("Owns_Anim_" .. packName, true)
    LocalPlayer:SetAttribute(packName, true)
    LocalPlayer:SetAttribute("Unlocked_" .. packName, true)
end

-- Spoof custom name and animation attributes
LocalPlayer:SetAttribute("CustomName", customName)
LocalPlayer:SetAttribute("SelectedAnimation", customAnimName)
LocalPlayer:SetAttribute("EquippedAnim", customAnimName)

-- Unlock GUI buttons and lock overlays
local function unlockGuiElements()
    for _, guiObj in ipairs(PlayerGui:GetDescendants()) do
        local nameLower = guiObj.Name:lower()
        if nameLower:find("sound") or nameLower:find("anim") or nameLower:find("brineland") then
            if guiObj:IsA("ImageButton") or guiObj:IsA("TextButton") then
                guiObj.Active = true
            end
            if guiObj:IsA("ImageLabel") and (nameLower:find("lock") or nameLower:find("padlock")) then
                guiObj.Visible = false
            end
        end
    end
end

unlockGuiElements()
PlayerGui.DescendantAdded:Connect(unlockGuiElements)

---------------------------------------------------------
-- 2. NPC ANTI-KILL & SAFE AUTO-WIN DISTANCE FIX
---------------------------------------------------------
local function protectHumanoid(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    if hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__newindex", function(self, key, value)
            -- Prevents client script distance/cone checks from setting Health to 0
            if not checkcaller() and self == humanoid and key == "Health" and value == 0 then
                return nil
            end
            return oldIndex(self, key, value)
        end)
    end
end

if LocalPlayer.Character then
    protectHumanoid(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(protectHumanoid)

-- Disable client NPC kill hitboxes in workspace
RunService.Stepped:Connect(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if obj.Name:find("Hitbox") or obj.Name:find("AttackZone") then
                obj.CanTouch = false
                obj.CanCollide = false
            end
        end
    end
end)

-- Success Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Brineland Hub",
        Text = "Successfully loaded Brineland script!",
        Duration = 5
    })
end)
