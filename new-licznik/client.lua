local screenWidth, screenHeight = guiGetScreenSize()
local scale = 1
local font = "default-bold"

function drawSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        local speedX, speedY, speedZ = getElementVelocity(vehicle)
        local speed = (speedX^2 + speedY^2 + speedZ^2)^(0.5) * 180
        local vehicleName = getVehicleName(vehicle)
        local mileage = getElementData(vehicle, "mileage") or 0

        -- Update mileage
        setElementData(vehicle, "mileage", mileage + speed / 10000)

        -- Determine color based on speed
        local color = tocolor(0, 255, 0)  -- Green
        if speed >= 50 then color = tocolor(255, 165, 0) end  -- Orange
        if speed >= 100 then color = tocolor(255, 0, 0) end  -- Red

        -- Get fuel level in liters
        local fuel = getElementData(vehicle, "vehicle:fuel") or 0

        -- Decrease fuel level based on speed
        if speed > 0 then
            setElementData(vehicle, "vehicle:fuel", math.max(0, fuel - speed / 5000))
        end

        -- Draw background
        dxDrawImage(screenWidth / 2 - 150 * scale, screenHeight - 150 * scale, 300 * scale, 150 * scale, "images/background.png")

        -- Draw speed
        dxDrawText(string.format("%d km/h", speed), screenWidth / 2, screenHeight - 140 * scale, screenWidth / 2, screenHeight - 140 * scale, color, 1.5 * scale, font, "center", "top")

        -- Draw fuel level
        dxDrawText(string.format("Fuel: %.1f L", fuel), screenWidth / 2 + 100 * scale, screenHeight - 100 * scale, screenWidth / 2 + 100 * scale, screenHeight - 100 * scale, tocolor(255, 255, 255), 1 * scale, font, "right", "top")

        -- Draw mileage
        dxDrawText(string.format("Mileage: %.1f km", mileage), screenWidth / 2, screenHeight - 70 * scale, screenWidth / 2, screenHeight - 70 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")

        -- Draw vehicle name
        dxDrawText(vehicleName, screenWidth / 2, screenHeight - 40 * scale, screenWidth / 2, screenHeight - 40 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")

        -- Draw blue border
        dxDrawLine(screenWidth / 2 - 150 * scale, screenHeight - 150 * scale, screenWidth / 2 + 150 * scale, screenHeight - 150 * scale, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 - 150 * scale, screenHeight - 150 * scale, screenWidth / 2 - 150 * scale, screenHeight, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 + 150 * scale, screenHeight - 150 * scale, screenWidth / 2 + 150 * scale, screenHeight, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 - 150 * scale, screenHeight, screenWidth / 2 + 150 * scale, screenHeight, tocolor(0, 0, 255), 2)

        -- Draw mini map (left side)
        local mapWidth, mapHeight = 150 * scale, 150 * scale
        local mapX, mapY = screenWidth / 2 - 320 * scale, screenHeight - 150 * scale
        dxDrawRectangle(mapX, mapY, mapWidth, mapHeight, tocolor(0, 0, 0, 150))
        drawMiniMap(mapX, mapY, mapWidth, mapHeight)

        -- Draw additional functionalities (right side)
        local infoX, infoY = screenWidth / 2 + 170 * scale, screenHeight - 150 * scale
        local infoWidth, infoHeight = 150 * scale, 150 * scale
        dxDrawRectangle(infoX, infoY, infoWidth, infoHeight, tocolor(0, 0, 0, 150))
        drawAdditionalInfo(infoX, infoY, infoWidth, infoHeight)
    else
        -- Draw standard radar when not in vehicle
        drawStandardRadar()
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)

function drawMiniMap(x, y, width, height)
    -- Drawing a simple placeholder for mini map
    local mapTexture = dxCreateTexture("images/map.png")
    dxDrawImage(x, y, width, height, mapTexture)
end

function drawAdditionalInfo(x, y, width, height)
    -- Example: Display vehicle's health and temperature
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        local health = getElementHealth(vehicle)
        local temperature = getElementData(vehicle, "temperature") or 90 -- Example temperature
        local lightsOn = getVehicleOverrideLights(vehicle) == 2
        local doorStatus = getVehicleDoorOpenRatio(vehicle, 0) > 0 and "Open" or "Closed"

        dxDrawText(string.format("Health: %d%%", health / 10), x + width / 2, y + 10 * scale, x + width / 2, y + 10 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")
        dxDrawText(string.format("Temp: %.1f°C", temperature), x + width / 2, y + 40 * scale, x + width / 2, y + 40 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")
        dxDrawText("Lights: " .. (lightsOn and "On" or "Off"), x + width / 2, y + 70 * scale, x + width / 2, y + 70 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")
        dxDrawText("Doors: " .. doorStatus, x + width / 2, y + 100 * scale, x + width / 2, y + 100 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")
    end
end

function drawStandardRadar()
    -- Default radar drawing code
    local radarWidth, radarHeight = 150 * scale, 150 * scale
    local radarX, radarY = screenWidth / 2 - radarWidth / 2, screenHeight - radarHeight - 20 * scale
    dxDrawRectangle(radarX, radarY, radarWidth, radarHeight, tocolor(0, 0, 0, 150))
    -- Draw the radar here
end
