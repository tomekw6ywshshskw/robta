local screenWidth, screenHeight = guiGetScreenSize()
local scale = screenWidth / 1920
local font = "default-bold"
local showMiniMap = false

function drawSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        -- Nazwa pojazdu na górze
        local vehicleName = getVehicleName(vehicle)
        dxDrawText(vehicleName, screenWidth / 2, screenHeight - 170 * scale, screenWidth / 2, screenHeight - 170 * scale, tocolor(255, 255, 255), 1.5 * scale, font, "center", "top")

        -- Cyfrowy prędkościomierz
        local speed = getSpeed(vehicle)
        local color = getSpeedColor(speed)
        dxDrawText(string.format("%d km/h", speed), screenWidth / 2, screenHeight - 140 * scale, screenWidth / 2, screenHeight - 140 * scale, color, 2 * scale, font, "center", "top")

        -- Poziom paliwa
        local fuel = getElementData(vehicle, "vehicle:fuel")
        dxDrawImage(screenWidth / 2 + 70 * scale, screenHeight - 90 * scale, 20 * scale, 20 * scale, "images/fuel_icon.png")
        dxDrawText(string.format("Fuel: %.1f L", fuel), screenWidth / 2 + 100 * scale, screenHeight - 90 * scale, screenWidth / 2 + 100 * scale, screenHeight - 90 * scale, tocolor(255, 255, 255), 1 * scale, font, "left", "top")

        -- Realistyczna mini mapa na dole
        dxDrawRectangle(screenWidth / 2 - 150 * scale, screenHeight - 60 * scale, 300 * scale, 50 * scale, tocolor(0, 0, 0, 150))
        drawMiniMap(screenWidth / 2 - 145 * scale, screenHeight - 55 * scale, 290 * scale, 40 * scale)
    else
        drawStandardRadar()
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)

function drawMiniMap(x, y, width, height)
    -- Rysowanie realistycznej mini mapy
    dxDrawImage(x, y, width, height, "images/mini_map.png")
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
