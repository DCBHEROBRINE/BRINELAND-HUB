-- ============================================================
-- BRINELAND MASTER MULTI-GAME HUB ROUTER
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(PlaceId)
end)
local gameName = (success and info and info.Name) or ""
local nameLower = gameName:lower()

-- Game Detection & External Script Connector
if nameLower:find("taxi boss") or PlaceId == 7305826609 then
    print("[BRINELAND] Loading Taxi Boss script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/taxiboss.lua"))()
elseif nameLower:find("steal an egg") or PlaceId == 115049386348611 then
    print("[BRINELAND] Loading Steal An Egg script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/stealamegg.lua"))()
elseif nameLower:find("speed keyboard escape") or nameLower:find("+1 speed") then
    print("[BRINELAND] Loading Speed Keyboard Escape script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/SpeedKeyboardEscape.lua"))()
else
    print("[BRINELAND] Running Universal Hub fallback...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/universal.lua"))()
end
