local screenWidth, screenHeight = guiGetScreenSize()

-- Rysowanie licznika
function drawSpeedometer()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getVehicleType(vehicle) == "Automobile" then
        local speedX, speedY, speedZ = getElementVelocity(vehicle)
        local kmh = math.floor(((speedX^2 + speedY^2 + speedZ^2) ^ 0.5) * 180)
        local fuel = getElementData(vehicle, "vehicle:fuel") or 0
        local mileage = getElementData(vehicle, "vehicle:mileage") or 0

        -- Aktualizowanie przebiegu
        setElementData(vehicle, "vehicle:mileage", mileage + (kmh / 1000 / 60)) -- Dodawanie do przebiegu

        -- Wyświetlanie licznika prędkości, paliwa i przebiegu
        dxDrawText("Prędkość: " .. kmh .. " km/h", screenWidth - 200, screenHeight - 100, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1.5)
        dxDrawText("Paliwo: " .. math.floor(fuel) .. " L", screenWidth - 200, screenHeight - 75, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1.5)
        dxDrawText("Przebieg: " .. string.format("%.2f", mileage) .. " km", screenWidth - 200, screenHeight - 50, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1.5)
    end
end
addEventHandler("onClientRender", root, drawSpeedometer)

-- Funkcja aktualizująca stan paliwa (przykład)
function consumeFuel()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getVehicleType(vehicle) == "Automobile" then
        local fuel = getElementData(vehicle, "vehicle:fuel") or 0
        if fuel > 0 then
            setElementData(vehicle, "vehicle:fuel", fuel - 0.1)
        else
            setElementData(vehicle, "vehicle:fuel", 0)
        end
    end
end
setTimer(consumeFuel, 1000, 0)
