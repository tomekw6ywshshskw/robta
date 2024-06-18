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
    local x, y = screenWidth - 220, 20
    
    -- Rysowanie logo serwera
    dxDrawImage(x, y, 200, 50, logo)
    
    -- Rysowanie paska zdrowia
    dxDrawImage(x, y + 60, 200, 25, hpBarBg)
    dxDrawImageSection(x, y + 60, 200 * healthPercentage, 25, 0, 0, 200 * healthPercentage, 25, hpBarFg)
    
    -- Rysowanie tekstów
    dxDrawText("Nick: " .. nick, x, y + 90, x + 200, y + 110, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("SID: " .. sid, x, y + 110, x + 200, y + 130, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("Ping: " .. ping, x, y + 130, x + 200, y + 150, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("SRP: " .. srp, x, y + 150, x + 200, y + 170, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("Pieniądze: " .. formattedMoney, x, y + 170, x + 200, y + 190, tocolor(255, 255, 255, 255), 1.0, "default-bold")
    dxDrawText("Broń: " .. getWeaponNameFromID(weapon) .. " (" .. clipAmmo .. "/" .. ammo .. ")", x, y + 190, x + 200, y + 210, tocolor(255, 255, 255, 255), 1.0, "default-bold")
end

-- Dodanie eventu, który rysuje HUD co klatkę
addEventHandler("onClientRender", root, drawHUD)
