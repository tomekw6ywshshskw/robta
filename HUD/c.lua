-- Ładowanie grafik
local logo = dxCreateTexture("logo.png")
local hpBarBg = dxCreateTexture("hp_bar_bg.png")
local hpBarFg = dxCreateTexture("hp_bar_fg.png")

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
    local formattedMoney = string.format("$%d", money)
    
    -- Ustalanie pozycji na ekranie
    local screenWidth, screenHeight = guiGetScreenSize()
    local x, y = 20, 20
    
    -- Rysowanie logo serwera
    dxDrawImage(x, y, 200, 100, logo)
    
    -- Rysowanie paska zdrowia
    dxDrawImage(x, y + 110, 200, 25, hpBarBg)
    dxDrawImageSection(x, y + 110, 200 * healthPercentage, 25, 0, 0, 200 * healthPercentage, 25, hpBarFg)
    
    -- Rysowanie tekstów
    dxDrawText("Nick: " .. nick, x, y + 140, x + 200, y + 160, tocolor(255, 255, 255, 255), 1.5, "default-bold")
    dxDrawText("SID: " .. sid, x, y + 165, x + 200, y + 185, tocolor(255, 255, 255, 255), 1.5, "default-bold")
    dxDrawText("Ping: " .. ping, x, y + 190, x + 200, y + 210, tocolor(255, 255, 255, 255), 1.5, "default-bold")
    dxDrawText("SRP: " .. srp, x, y + 215, x + 200, y + 235, tocolor(255, 255, 255, 255), 1.5, "default-bold")
    dxDrawText("Pieniądze: " .. formattedMoney, x, y + 240, x + 200, y + 260, tocolor(255, 255, 255, 255), 1.5, "default-bold")
    dxDrawText("Broń: " .. getWeaponNameFromID(weapon) .. " (" .. clipAmmo .. "/" .. ammo .. ")", x, y + 265, x + 200, y + 285, tocolor(255, 255, 255, 255), 1.5, "default-bold")
end

-- Dodanie eventu, który rysuje HUD co klatkę
addEventHandler("onClientRender", root, drawHUD)
