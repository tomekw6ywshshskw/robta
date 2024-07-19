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

        -- Get RPM
        local rpm = getVehicleRPM(vehicle)

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

        -- Draw RPM
        dxDrawText(string.format("RPM: %d", rpm / 1000), screenWidth / 2 - 100 * scale, screenHeight - 100 * scale, screenWidth / 2 - 100 * scale, screenHeight - 100 * scale, tocolor(255, 255, 255), 1.2 * scale, font, "left", "top")

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
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)

-- Function to calculate RPM
function getVehicleRPM(vehicle)
    if vehicle then
        local speedX, speedY, speedZ = getElementVelocity(vehicle)
        local speed = (speedX^2 + speedY^2 + speedZ^2)^(0.5)
        local gear = getVehicleCurrentGear(vehicle)
        local maxSpeed = getVehicleHandling(vehicle).maxVelocity
        local rpm = (speed / maxSpeed) * gear * 10000
        return math.floor(rpm)
    end
    return 0
end
