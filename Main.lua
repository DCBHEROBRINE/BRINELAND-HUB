--[[
    UNIVERSAL GITHUB LOADER
    Load string for users:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/loader.lua"))()
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- CONFIGURATION: Replace with your GitHub Username & Repository Name
local GITHUB_USER = "YOUR_USERNAME"
local GITHUB_REPO = "YOUR_REPO"
local BRANCH = "main"

local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/" .. BRANCH .. "/"

-- Game Script URLs
local TAXI_BOSS_URL             = BASE_URL .. "TaxiBoss.lua"
local STEAL_AN_EGG_URL          = BASE_URL .. "StealAnEgg.lua"
local SPEED_KEYBOARD_ESCAPE_URL = BASE_URL .. "Plus1SpeedKeyboardEscape.lua"

-- Place ID Lists
local TAXI_BOSS_IDS             = {6918802270}
local STEAL_AN_EGG_IDS          = {0000000000} -- Replace with Steal an Egg Place ID
local SPEED_KEYBOARD_ESCAPE_IDS = {0000000000} -- Replace with +1 Speed Keyboard Escape Place ID

local currentPlaceId = game.PlaceId

local function isGame(idList)
    for _, id in ipairs(idList) do
        if currentPlaceId == id then return true end
    end
    return false
end

-- 1. Check by Place ID
if isGame(TAXI_BOSS_IDS) then
    print("[LOADER] Taxi Boss detected. Loading script...")
    loadstring(game:HttpGet(TAXI_BOSS_URL))()
    return
elseif isGame(STEAL_AN_EGG_IDS) then
    print("[LOADER] Steal an Egg detected. Loading script...")
    loadstring(game:HttpGet(STEAL_AN_EGG_URL))()
    return
elseif isGame(SPEED_KEYBOARD_ESCAPE_IDS) then
    print("[LOADER] +1 Speed Keyboard Escape detected. Loading script...")
    loadstring(game:HttpGet(SPEED_KEYBOARD_ESCAPE_URL))()
    return
end

-- 2. Fallback: Check by Game Name
local success, placeInfo = pcall(function()
    return MarketplaceService:GetProductInfo(currentPlaceId)
end)

local gameName = (success and placeInfo and placeInfo.Name) and placeInfo.Name:lower() or ""

if gameName:find("taxi") or gameName:find("boss") then
    print("[LOADER] Taxi Boss detected by Name. Loading script...")
    loadstring(game:HttpGet(TAXI_BOSS_URL))()

elseif gameName:find("steal") or gameName:find("egg") then
    print("[LOADER] Steal an Egg detected by Name. Loading script...")
    loadstring(game:HttpGet(STEAL_AN_EGG_URL))()

elseif gameName:find("keyboard") or (gameName:find("speed") and gameName:find("escape")) then
    print("[LOADER] +1 Speed Keyboard Escape detected by Name. Loading script...")
    loadstring(game:HttpGet(SPEED_KEYBOARD_ESCAPE_URL))()

else
    warn("[LOADER] Unsupported Game! Please join a supported game.")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Brineland Hub",
        Text = "Unsupported Game!",
        Duration = 5
    })
end
