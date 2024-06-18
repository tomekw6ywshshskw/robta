-- Ustawienia GUI
local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth = screenWidth * 0.3
local windowHeight = screenHeight * 0.6
local windowX = (screenWidth - windowWidth) / 2
local windowY = (screenHeight - windowHeight) / 2

-- Zmienne pomocnicze
local vehicles = {}  -- Tabela przechowująca pojazdy dostępne w salonie
local selectedVehicle = nil  -- Wybrany pojazd do zakupu

-- Funkcja do rysowania GUI salonu pojazdów
local function drawCarDealershipUI()
    -- Rysowanie tła okna
    dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 180))

    -- Nagłówek
    dxDrawText("Salon Pojazdów", windowX, windowY, windowX + windowWidth, windowY + 50, tocolor(255, 255, 255), 1.5, "default-bold", "center", "top")

    -- Rysowanie informacji o pojazdach
    local startY = windowY + 70
    local buttonHeight = 30
    local buttonMargin = 10
    local buttonColor = tocolor(50, 150, 50, 200)

    for index, vehicle in ipairs(vehicles) do
        -- Pozycja przycisku
        local buttonY = startY + (index - 1) * (buttonHeight + buttonMargin)

        -- Rysowanie przycisku informacyjnego
        dxDrawRectangle(windowX + 10, buttonY, windowWidth - 20, buttonHeight, buttonColor)
        dxDrawText(vehicle.name .. " - " .. vehicle.engineType .. " " .. vehicle.capacity .. " L (" .. vehicle.fuelType .. ")\n" ..
                   "HP: " .. vehicle.horsepower .. " | NM: " .. vehicle.torque .. "\n" ..
                   "V-Max: " .. vehicle.vMax .. " km/h\n" ..
                   "Cena: $" .. vehicle.price, windowX + 20, buttonY, windowX + windowWidth - 20, buttonY + buttonHeight, tocolor(255, 255, 255), 1, "default", "left", "center")
        
        -- Obsługa kliknięcia na przycisk
        if isCursorOnElement(windowX + 10, buttonY, windowWidth - 20, buttonHeight) then
            if getKeyState("mouse1") then
                selectedVehicle = vehicle
                triggerServerEvent("buyVehicleFromDealership", localPlayer, selectedVehicle)
            end
        end
    end
end

-- Funkcja sprawdzająca, czy kursor jest na elemencie
function isCursorOnElement(x, y, width, height)
    local cx, cy = getCursorPosition()
    local cursorX, cursorY = cx * screenWidth, cy * screenHeight
    if cursorX > x and cursorX < x + width and cursorY > y and cursorY < y + height then
        return true
    end
    return false
end

-- Funkcja do odbierania danych o pojazdach z serwera
function receiveVehiclesList(vehiclesList)
    vehicles = vehiclesList
end
addEvent("sendVehiclesList", true)
addEventHandler("sendVehiclesList", resourceRoot, receiveVehiclesList)

-- Funkcja do rysowania UI na ekranie
addEventHandler("onClientRender", root, function()
    drawCarDealershipUI()
end)
