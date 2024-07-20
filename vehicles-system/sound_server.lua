-- Globalna tabela do przechowywania ustawień dla graczy
local playerCustomSounds = {}

-- Funkcja ustawiająca dźwięk silnika
function setEngineSound(vehicle, player)
    local category = getVehicleCategory(vehicle)
    local useCustomSounds = playerCustomSounds[player] ~= false -- domyślnie włączone

    local soundFile
    if useCustomSounds then
        soundFile = engineSounds[category]
    else
        -- Ustawienie dźwięku silnika na standardowy
        soundFile = "standard"  -- Specjalne oznaczenie dla standardowych dźwięków
    end
    
    -- Przesyłamy ustawienie dźwięku do klienta
    triggerClientEvent(player, "onClientSetEngineSound", player, soundFile, category)
end

-- Komenda do wyłączenia niestandardowych dźwięków
addCommandHandler("disablecustomsounds", function(player)
    playerCustomSounds[player] = false
    outputChatBox("Custom vehicle sounds have been disabled. Default sounds will now be used.", player)
end)

-- Komenda do włączenia niestandardowych dźwięków
addCommandHandler("enablecustomsounds", function(player)
    playerCustomSounds[player] = true
    outputChatBox("Custom vehicle sounds have been enabled.", player)
end)

-- Funkcja zarządzająca zmianą dźwięków po wsiadaniu do pojazdu
addEventHandler("onVehicleStartEnter", root, function(vehicle, player)
    setEngineSound(vehicle, player)
end)
