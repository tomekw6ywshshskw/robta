-- server.lua

function createCustomVehicle(player, vehicleModel, x, y, z)
    local vehicle = createVehicle(vehicleModel, x, y, z)
    local id = #getElementsByType("vehicle") + 1
    setElementData(vehicle, "id", id)
    setElementData(vehicle, "owner", getPlayerName(player))
    saveVehicleData(vehicle)
    return vehicle
end

addEvent("onPlayerBuyVehicle", true)
addEventHandler("onPlayerBuyVehicle", resourceRoot, function(vehicle)
    local player = client
    local price = getElementData(vehicle, "price")
    
    if getPlayerMoney(player) >= price then
        takePlayerMoney(player, price)
        local x, y, z = getElementPosition(vehicle)
        local vehicleModel = getElementModel(vehicle)
        local newVehicle = createCustomVehicle(player, vehicleModel, x, y, z)
        warpPedIntoVehicle(player, newVehicle)
        destroyElement(vehicle)
        hideVehicleShopGUI()
        outputChatBox("Zakupiłeś pojazd!", player)
    else
        outputChatBox("Nie masz wystarczająco pieniędzy!", player)
    end
end)

function saveVehicleData(vehicle)
    local id = getElementData(vehicle, "id")
    local owner = getElementData(vehicle, "owner")
    local model = getElementModel(vehicle)
    local x, y, z = getElementPosition(vehicle)
    local rx, ry, rz = getElementRotation(vehicle)
    local mileage = getElementData(vehicle, "mileage") or 0
    local oilType = getElementData(vehicle, "oilType") or "brak"

    executeQuery("INSERT INTO Vehicles (id, owner, model, x, y, z, rx, ry, rz, mileage, oilType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        id, owner, model, x, y, z, rx, ry, rz, mileage, oilType)
end
