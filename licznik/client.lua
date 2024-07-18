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

        -- Draw background
        dxDrawImage(screenWidth / 2 - 100 * scale, screenHeight - 150 * scale, 200 * scale, 100 * scale, "images/background.png")

        -- Draw speed
        dxDrawText(string.format("%d km/h", speed), screenWidth / 2, screenHeight - 130 * scale, screenWidth / 2, screenHeight - 130 * scale, color, 1.5 * scale, font, "center", "top")

        -- Draw mileage
        dxDrawText(string.format("Mileage: %.1f km", mileage), screenWidth / 2, screenHeight - 100 * scale, screenWidth / 2, screenHeight - 100 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")

        -- Draw vehicle name
        dxDrawText(vehicleName, screenWidth / 2, screenHeight - 80 * scale, screenWidth / 2, screenHeight - 80 * scale, tocolor(255, 255, 255), 1 * scale, font, "center", "top")

        -- Draw blue border
        dxDrawLine(screenWidth / 2 - 100 * scale, screenHeight - 150 * scale, screenWidth / 2 + 100 * scale, screenHeight - 150 * scale, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 - 100 * scale, screenHeight - 50 * scale, screenWidth / 2 + 100 * scale, screenHeight - 50 * scale, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 - 100 * scale, screenHeight - 150 * scale, screenWidth / 2 - 100 * scale, screenHeight - 50 * scale, tocolor(0, 0, 255), 2)
        dxDrawLine(screenWidth / 2 + 100 * scale, screenHeight - 150 * scale, screenWidth / 2 + 100 * scale, screenHeight - 50 * scale, tocolor(0, 0, 255), 2)
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)
