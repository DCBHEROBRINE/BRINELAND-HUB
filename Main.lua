-- Main Repository Auto-Loader
local MarketplaceService = game:GetService("MarketplaceService")

local success, placeInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local gameName = (success and placeInfo and placeInfo.Name) and placeInfo.Name:lower() or ""

local repoUrl = "https://raw.githubusercontent.com/DCBHEROBRINE/Taxi-boss/main/"

if gameName:find("taxi") and gameName:find("boss") then
    loadstring(game:HttpGet(repoUrl .. "taxiboss.lua"))()
elseif gameName:find("steal") and gameName:find("egg") then
    loadstring(game:HttpGet(repoUrl .. "Stealanegg.lua"))()
elseif gameName:find("keyboard") or gameName:find("escape") or gameName:find("brineland") or gameName:find("speed") then
    loadstring(game:HttpGet(repoUrl .. "%2B1SpeedKeyboardEscape.lua"))()
else
    -- Default fallback
    loadstring(game:HttpGet(repoUrl .. "%2B1SpeedKeyboardEscape.lua"))()
end
