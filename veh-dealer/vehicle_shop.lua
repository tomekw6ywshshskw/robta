-- vehicle_shop.lua

local vehiclesForSale = {
    {model = 411, x = 2055.21, y = 1529.45, z = 10.67, price = 100}, -- Infernus
    {model = 415, x = 2058.21, y = 1529.45, z = 10.67, price = 150}, -- Cheetah
    {model = 451, x = 2061.21, y = 1529.45, z = 10.67, price = 200}, -- Turismo
}

local shopBlip = createBlip(2055.21, 1529.45, 10.67, 10) -- Blip na mapie

local screenWidth, screenHeight = guiGetScreenSize()
local isGUIVisible = false
local selectedVehicle = nil

function createVehiclesForSale()
    for _, info in ipairs(vehiclesForSale) do
        local vehicle = createVehicle(info.model, info.x, info.y, info.z)
        setElementData(vehicle, "forSale", true)
        setElementData(vehicle, "price", info.price)
    end
end

function showVehicleShopGUI(vehicle)
    if not isGUIVisible then
        selectedVehicle = vehicle
        isGUIVisible = true
        showCursor(true)
    end
end

function hideVehicleShopGUI()
    isGUIVisible = false
    showCursor(false)
    selectedVehicle = nil
end

function drawVehicleShopGUI()
    if isGUIVisible and selectedVehicle then
        local price = getElementData(selectedVehicle, "price") or 0
        local horsepower = 200 -- Przykladowe dane
        local maxSpeed = 220 -- Przykladowe dane
        local name = getVehicleName(selectedVehicle)
        local torque = 300 -- Przykladowe dane
        local capacity = 4.5 -- Przykladowe dane

        dxDrawRectangle(screenWidth * 0.35, screenHeight * 0.35, screenWidth * 0.3, screenHeight * 0.3, tocolor(0, 0, 0, 200))
        dxDrawText("Nazwa: " .. name, screenWidth * 0.36, screenHeight * 0.36)
        dxDrawText("Cena: " .. price .. " zł", screenWidth * 0.36, screenHeight * 0.39)
        dxDrawText("Konie mechaniczne: " .. horsepower .. " KM", screenWidth * 0.36, screenHeight * 0.42)
        dxDrawText("V-Max: " .. maxSpeed .. " km/h", screenWidth * 0.36, screenHeight * 0.45)
        dxDrawText("Niutonometry: " .. torque .. " Nm", screenWidth * 0.36, screenHeight * 0.48)
        dxDrawText("Pojemność: " .. capacity .. " L", screenWidth * 0.36, screenHeight * 0.51)

        dxDrawRectangle(screenWidth * 0.36, screenHeight * 0.54, screenWidth * 0.12, screenHeight * 0.05, tocolor(0, 100, 0, 200))
        dxDrawText("Zakup", screenWidth * 0.365, screenHeight * 0.555)
        
        dxDrawRectangle(screenWidth * 0.53, screenHeight * 0.54, screenWidth * 0.12, screenHeight * 0.05, tocolor(100, 0, 0, 200))
        dxDrawText("Zamknij", screenWidth * 0.535, screenHeight * 0.555)
    end
end
addEventHandler("onClientRender", root, drawVehicleShopGUI)

function onClick(button, state, absoluteX, absoluteY)
    if isGUIVisible and selectedVehicle and button == "left" and state == "up" then
        local shopX, shopY, shopWidth, shopHeight = screenWidth * 0.36, screenHeight * 0.54, screenWidth * 0.12, screenHeight * 0.05
        local closeX, closeY, closeWidth, closeHeight = screenWidth * 0.53, screenHeight * 0.54, screenWidth * 0.12, screenHeight * 0.05

        if absoluteX >= shopX and absoluteX <= shopX + shopWidth and absoluteY >= shopY and absoluteY <= shopY + shopHeight then
            triggerServerEvent("onPlayerBuyVehicle", resourceRoot, selectedVehicle)
        elseif absoluteX >= closeX and absoluteX <= closeX + closeWidth and absoluteY >= closeY and absoluteY >= closeY + closeHeight then
            hideVehicleShopGUI()
        end
    end
end
addEventHandler("onClientClick", root, onClick)

addEventHandler("onClientMarkerHit", resourceRoot, function(hitElement)
    if getElementType(hitElement) == "player" and hitElement == localPlayer then
        local vehicle = getElementParent(source)
        if getElementData(vehicle, "forSale") then
            showVehicleShopGUI(vehicle)
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, createVehiclesForSale)
