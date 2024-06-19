-- vehicle_maintenance.lua

-- Funkcja aktualizująca zużycie części pojazdu
function updateVehicleParts(vehicle)
    local brakePads = getElementData(vehicle, "brakePads") or 100
    local camshafts = getElementData(vehicle, "camshafts") or 100
    local bulbs = getElementData(vehicle, "bulbs") or 100
    local pistons = getElementData(vehicle, "pistons") or 100
    local turbocharger = getElementData(vehicle, "turbocharger") or 100

    -- Zużycie części (przykład, zmniejszamy stan o 1 na każde 1000 km)
    local mileage = getElementData(vehicle, "mileage") or 0
    local factor = mileage / 1000

    brakePads = brakePads - factor
    camshafts = camshafts - factor
    bulbs = bulbs - factor
    pistons = pistons - factor
    turbocharger = turbocharger - factor

    -- Aktualizacja stanu części
    setElementData(vehicle, "brakePads", brakePads)
    setElementData(vehicle, "camshafts", camshafts)
    setElementData(vehicle, "bulbs", bulbs)
    setElementData(vehicle, "pistons", pistons)
    setElementData(vehicle, "turbocharger", turbocharger)
end

-- Funkcja sprawdzająca konieczność wymiany oleju
function checkOilChange(vehicle)
    local mileage = getElementData(vehicle, "mileage") or 0
    local lastOilChange = getElementData(vehicle, "lastOilChange") or 0

    if mileage - lastOilChange >= 50000 then
        outputChatBox("Musisz wymienić olej! Silnik ulegnie uszkodzeniu jeśli tego nie zrobisz.", getVehicleOccupant(vehicle))
    end
end

-- Funkcja aktualizująca moc pojazdu na podstawie map komputera i chip tuningu
function updateVehiclePower(vehicle)
    local horsepower = getElementData(vehicle, "horsepower") or 0
    local torque = getElementData(vehicle, "torque") or 0

    local mk1 = getElementData(vehicle, "computer1") and 20 or 0
    local mk2 = getElementData(vehicle, "computer2") and 40 or 0
    local mk3 = getElementData(vehicle, "computer3") and 120 or 0
    local mk4 = getElementData(vehicle, "computer4") and 140 or 0
    local chipTuning = getElementData(vehicle, "chipTuning") and 200 or 0

    local totalMkHorsepower = mk1 + mk2 + mk3 + mk4
    local totalMkTorque = mk1 * 2 + mk2 * 4 + mk3 * 12 + mk4 * 14 -- Przyklad przeliczania Nm dla kazdego MK

    horsepower = horsepower + totalMkHorsepower
    torque = torque + totalMkTorque + chipTuning

    setElementData(vehicle, "horsepower", horsepower)
    setElementData(vehicle, "torque", torque)
end

-- Funkcja inicjalizująca przetwarzanie stanu pojazdu
function initializeVehicleMaintenance(vehicle)
    updateVehicleParts(vehicle)
    checkOilChange(vehicle)
    updateVehiclePower(vehicle)
end

-- Event handler na aktualizację stanu pojazdu
addEventHandler("onVehicleEnter", root, function(player, seat)
    if seat == 0 then -- Tylko kierowca
        initializeVehicleMaintenance(source)
    end
end)
