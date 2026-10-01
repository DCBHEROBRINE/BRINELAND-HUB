--[[
    UNIVERSAL GITHUB LOADER
    Load this script in your executor:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/main.lua"))()
]]

local MarketplaceService = game:GetService("MarketplaceService")
local placeInfo = nil

pcall(function()
    placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName = placeInfo and placeInfo.Name:lower() or ""

-- RAW GITHUB URLS
local TAXI_BOSS_URL    = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/TaxiBoss.lua"
local STEAL_AN_EGG_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/StealAnEgg.lua"

if gameName:find("taxi") or gameName:find("boss") then
    print("[LOADER] Loading Taxi Boss Script...")
    loadstring(game:HttpGet(TAXI_BOSS_URL))()

elseif gameName:find("steal") and gameName:find("egg") then
    print("[LOADER] Loading Steal an Egg Script...")
    loadstring(game:HttpGet(STEAL_AN_EGG_URL))()

else
    warn("[LOADER] Unsupported Game! Please join Taxi Boss or Steal an Egg.")
end
