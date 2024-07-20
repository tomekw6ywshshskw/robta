-- Tabela z niestandardowymi dźwiękami dla różnych kategorii
local engineSounds = {
    ["Sport cars"] = "sound/sport_engine_start.wav",
    ["Muscle cars"] = "sound/muscle_engine_start.wav",
    ["Off road"] = "sound/offroad_engine_start.wav",
    ["Lowrider"] = "sound/lowrider_engine_start.wav",
    ["Truck"] = "sound/truck_engine_start.wav",
    ["Regular"] = "sound/regular_engine_start.wav"
}

-- Tabela do przechowywania preferencji dźwięków dla graczy
local playerCustomSounds = {}

-- Funkcja sprawdzająca, czy pojazd to muscle car
function isMuscleCar(model)
    local muscleCarIDs = {400, 601, 426, 487, 484, 470, 603, 566}
    for _, id in ipairs(muscleCarIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja sprawdzająca, czy pojazd to sport car
function isSportCar(model)
    local sportCarIDs = {411, 401, 560, 420, 556, 560, 429, 543}
    for _, id in ipairs(sportCarIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja sprawdzająca, czy pojazd to off road
function isOffRoadCar(model)
    local offRoadIDs = {446, 448, 523, 472, 500}
    for _, id in ipairs(offRoadIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja sprawdzająca, czy pojazd to lowrider
function isLowriderCar(model)
    local lowriderIDs = {516, 567, 517, 515, 426}
    for _, id in ipairs(lowriderIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja sprawdzająca, czy pojazd to truck
function isTruck(model)
    local truckIDs = {464, 514, 486, 515, 421}
    for _, id in ipairs(truckIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja zwracająca kategorię pojazdu
function getVehicleCategory(vehicle)
    local model = getElementModel(vehicle)
    
    if isSportCar(model) then
        return "Sport cars"
    elseif isMuscleCar(model) then
        return "Muscle cars"
    elseif isOffRoadCar(model) then
        return "Off road"
    elseif isLowriderCar(model) then
        return "Lowrider"
    elseif isTruck(model) then
        return "Truck"
    else
        return "Regular"
    end
end

-- Funkcja ustawiająca dźwięk silnika
function setEngineSound(vehicle, player)
    local category = getVehicleCategory(vehicle)
    local useCustomSounds = playerCustomSounds[player] ~= false -- domyślnie włączone
    local soundFile = useCustomSounds and engineSounds[category] or "standard"
    
    -- Przesyłamy ustawienie dźwięku do klienta
    triggerClientEvent(player, "onClientSetEngineSound", player, soundFile, category)
end

-- Funkcja ustawiająca dźwięk silnika po wsiadaniu do pojazdu
addEventHandler("onVehicleStartEnter", root, function(vehicle, player)
    setEngineSound(vehicle, player)
end)

-- Komenda do wyłączania niestandardowych dźwięków
addCommandHandler("disablecustomsounds", function(player)
    playerCustomSounds[player] = false
    outputChatBox("Custom vehicle sounds have been disabled. Default sounds will now be used.", player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        setEngineSound(vehicle, player)
    end
end)

-- Komenda do włączania niestandardowych dźwięków
addCommandHandler("enablecustomsounds", function(player)
    playerCustomSounds[player] = true
    outputChatBox("Custom vehicle sounds have been enabled.", player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        setEngineSound(vehicle, player)
    end
end)
