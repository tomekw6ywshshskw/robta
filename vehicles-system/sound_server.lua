-- Tabela z dźwiękami dla różnych kategorii
local engineSounds = {
    ["Sport cars"] = "sound/sport_engine_start.wav",
    ["Muscle cars"] = "sound/muscle_engine_start.wav",
    ["Off road"] = "sound/offroad_engine_start.wav",
    ["Lowrider"] = "sound/lowrider_engine_start.wav",
    ["Truck"] = "sound/truck_engine_start.wav",
    ["Regular"] = "sound/regular_engine_start.wav"
}

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
