local screenWidth, screenHeight = guiGetScreenSize()
local scale = screenWidth / 1920
local font = "default-bold"
local showMiniMap = false

local backgroundImg = "images/background.png"
local mapImg = "images/map.png"

function drawSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        -- Tło licznika
        dxDrawImage(screenWidth / 2 - 300 * scale, screenHeight - 300 * scale, 600 * scale, 300 * scale, backgroundImg)

        -- Nazwa pojazdu na górze
        local vehicleName = getVehicleName(vehicle)
        dxDrawText(vehicleName, screenWidth / 2, screenHeight - 295 * scale, screenWidth / 2, screenHeight - 295 * scale, tocolor(255, 255, 255), 1.5 * scale, font, "center", "top")

        -- Cyfrowy prędkościomierz
        local speed = getSpeed(vehicle)
        local color = getSpeedColor(speed)
        dxDrawText(string.format("%d km/h", speed), screenWidth / 2, screenHeight - 220 * scale, screenWidth / 2, screenHeight - 220 * scale, color, 2 * scale, font, "center", "top")

        -- Poziom paliwa
        local fuel = getElementData(vehicle, "vehicle:fuel") or 0
        dxDrawImage(screenWidth / 2 - 290 * scale, screenHeight - 190 * scale, 30 * scale, 30 * scale, "images/fuel_icon.png")
        dxDrawText(string.format("Fuel: %.1f L", fuel), screenWidth / 2 - 255 * scale, screenHeight - 185 * scale, screenWidth / 2 - 255 * scale, screenHeight - 185 * scale, tocolor(255, 255, 255), 1 * scale, font, "left", "top")

        -- Przebieg pojazdu
        local mileage = getElementData(vehicle, "vehicle:mileage") or 0
        dxDrawText(string.format("Mileage: %d km", mileage), screenWidth / 2 + 150 * scale, screenHeight - 185 * scale, screenWidth / 2 + 150 * scale, screenHeight - 185 * scale, tocolor(255, 255, 255), 1 * scale, font, "left", "top")

        -- Mini mapa na dole
        drawMiniMap(screenWidth / 2 - 295 * scale, screenHeight - 100 * scale, 590 * scale, 80 * scale)
    else
        drawStandardRadar()
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)

function drawMiniMap(x, y, width, height)
    -- Rysowanie realistycznej mini mapy
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local mapWidth, mapHeight = 6000, 6000 -- Zakładamy, że mapa ma rozmiar 6000x6000 jednostek
    local mapScale = width / mapWidth
    local mapX = x - (playerX * mapScale)
    local mapY = y - (playerY * mapScale)
    
    dxDrawImage(mapX, mapY, mapWidth * mapScale, mapHeight * mapScale, mapImg)
    dxDrawRectangle(x + (width / 2) - 5 * scale, y + (height / 2) - 5 * scale, 10 * scale, 10 * scale, tocolor(255, 0, 0, 255)) -- Pozycja gracza
end

function drawStandardRadar()
    -- Funkcja rysowania standardowego radaru
end

function getSpeed(vehicle)
    local speedX, speedY, speedZ = getElementVelocity(vehicle)
    return (speedX^2 + speedY^2 + speedZ^2)^(0.5) * 180
end

function getSpeedColor(speed)
    if speed >= 100 then
        return tocolor(255, 0, 0) -- Czerwony
    elseif speed >= 50 then
        return tocolor(255, 165, 0) -- Pomarańczowy
    else
        return tocolor(0, 255, 0) -- Zielony
    end
end

-- Ukrywanie prostokąta gdy nie jest w pojeździe
addEventHandler("onClientVehicleExit", root, function()
    showMiniMap = false
end)

addEventHandler("onClientVehicleEnter", root, function()
    showMiniMap = true
end)
