local screenWidth, screenHeight = guiGetScreenSize()
local scale = screenWidth / 1920
local font = "default-bold"
local showMiniMap = false

function drawSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        -- Tło licznika z mapą
        dxDrawImage(screenWidth / 2 - 150 * scale, screenHeight - 150 * scale, 300 * scale, 150 * scale, "images/custom_background.png")

        -- Nazwa pojazdu
        local vehicleName = getVehicleName(vehicle)
        dxDrawText(vehicleName, screenWidth / 2, screenHeight - 145 * scale, screenWidth / 2, screenHeight - 145 * scale, tocolor(255, 255, 255), 1.5 * scale, font, "center", "top")

        -- Cyfrowy prędkościomierz
        local speed = getSpeed(vehicle)
        local color = getSpeedColor(speed)
        dxDrawText(string.format("%d km/h", speed), screenWidth / 2, screenHeight - 115 * scale, screenWidth / 2, screenHeight - 115 * scale, color, 2 * scale, font, "center", "top")

        -- Poziom paliwa
        local fuel = getElementData(vehicle, "vehicle:fuel")
        dxDrawImage(screenWidth / 2 + 70 * scale, screenHeight - 90 * scale, 20 * scale, 20 * scale, "images/fuel_icon.png")
        dxDrawText(string.format("Fuel: %.1f L", fuel), screenWidth / 2 + 100 * scale, screenHeight - 90 * scale, screenWidth / 2 +
