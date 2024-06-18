-- Ładowanie grafik
local logo = dxCreateTexture("logo.png")
local hpBarBg = dxCreateTexture("hp_bar_bg.png")
local hpBarFg = dxCreateTexture("hp_bar_fg.png")

-- Funkcja formatowania liczb z przecinkami
function formatNumber(number)
    local formatted = number
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

-- Funkcja rysująca HUD
function drawHUD()
    -- Pobieranie lokalnego gracza
    local player = getLocalPlayer()
    
    -- Pobieranie informacji o graczu
    local health = getElementHealth(player)
    local maxHealth = 100 -- maksymalne zdrowie
    local money = getPlayerMoney(player)
    local nick = getPlayerName(player)
    local sid = getElementData(player, "sid") or "N/A"
    local ping = getPlayerPing(player)
    local srp = getElementData(player, "srp") or "N/A"
    local weapon = getPedWeapon(player)
    local ammo = getPedTotalAmmo(player) - getPedAmmoInClip(player)
    local clipAmmo = getPedAmmoInClip(player)
    
    -- Konwersja zdrowia i formatowanie liczb
    health = math.floor(health)
    local healthPercentage = health / maxHealth
    local formattedMoney = "$" .. formatNumber(money)
    
    -- Ustalanie pozycji na ekranie
    local screenWidth, screenHeight = guiGetScreenSize()
    local logoSize = 50 -- wielkość logo (kwadrat)
    local hpBarWidth = 150 -- szerokość paska zdrowia
    local hpBarHeight = 25 -- wysokość paska zdrowia
    local padding = 5 -- odstęp między elementami
    local x = screenWidth - logoSize - hpBarWidth - 2 * padding
    local y = 20
    
    -- Rysowanie logo serwera (kwadrat)
    dxDrawImage(x + hpBarWidth + padding, y, logoSize, logoSize, logo)
    
    -- Rysowanie paska zdrowia
    dxDrawImage(x, y, hpBarWidth, hpBarHeight, hpBarBg)
    dxDrawImageSection(x, y, hpBarWidth * healthPercentage, hpBarHeight, 0, 0, hpBarWidth * healthPercentage, hpBarHeight, hpBarFg)
    
    -- Ustalanie pozycji dla tekstów
    local textX = x
    local textY = y + hpBarHeight + padding
    
    -- Rysowanie tekstów
    dxDrawText("Nick: " .. nick, textX, textY, textX + hpBarWidth + logoSize, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    textY = textY + 20 + padding
    dxDrawText("SID: " .. sid, textX, textY, textX + (hpBarWidth + logoSize) / 2, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("SRP: " .. srp, textX + (hpBarWidth + logoSize) / 2, textY, textX + hpBarWidth + logoSize, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    textY = textY + 20 + padding
    dxDrawText("Pieniądze: " .. formattedMoney, textX, textY, textX + hpBarWidth + logoSize, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    textY = textY + 20 + padding
    dxDrawText("Broń: " .. getWeaponNameFromID(weapon) .. " (" .. clipAmmo .. "/" .. ammo .. ")", textX, textY, textX + hpBarWidth + logoSize, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    textY = textY + 20 + padding
    dxDrawText("Ping: " .. ping, textX, textY, textX + hpBarWidth + logoSize, textY + 20, tocolor(255, 255, 255, 255), 1.0, "default-bold")
end

-- Dodanie eventu, który rysuje HUD co klatkę
addEventHandler("onClientRender", root, drawHUD)
