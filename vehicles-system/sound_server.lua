-- Funkcja sprawdzająca, czy pojazd to muscle car
function isMuscleCar(model)
    local muscleCarIDs = {
        400, 601, 426, 487, 484, 470, 603, 566
    }
    for _, id in ipairs(muscleCarIDs) do
        if model == id then
            return true
        end
    end
    return false
end

-- Funkcja ustawiająca dźwięk silnika
function setEngineSound(vehicle, player)
    local category = getVehicleCategory(vehicle)
    local useCustomSounds = playerCustomSounds[player] ~= false -- domyślnie włączone
    local soundFile = useCustomSounds and engineSounds[category] or "standard"
    triggerClientEvent(player, "onClientSetEngineSound", player, soundFile, category)
end

-- Komendy do włączania/wyłączania niestandardowych dźwięków
addCommandHandler("disablecustomsounds", function(player)
    playerCustomSounds[player] = false
    outputChatBox("Custom vehicle sounds have been disabled. Default sounds will now be used.", player)
end)

addCommandHandler("enablecustomsounds", function(player)
    playerCustomSounds[player] = true
    outputChatBox("Custom vehicle sounds have been enabled.", player)
end)

-- Event do ustawienia dźwięku silnika przy wsiadaniu do pojazdu
addEventHandler("onVehicleStartEnter", root, function(vehicle, player)
    setEngineSound(vehicle, player)
end)
