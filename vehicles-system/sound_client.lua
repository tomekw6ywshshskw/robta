-- Funkcja ustawiająca dźwięk silnika na kliencie
function onSetEngineSound(soundFile, category)
    if soundFile == "standard" then
        -- Usunięcie dźwięku silnika
        if isElement(engineSound) then
            destroyElement(engineSound)
        end
        -- Ustawienie domyślnego dźwięku silnika
        -- MTA:SA automatycznie zarządza standardowymi dźwiękami, więc nie trzeba ręcznie ich ustawiać
    else
        -- Ustawienie niestandardowego dźwięku silnika
        if isElement(engineSound) then
            destroyElement(engineSound)
        end
        
        engineSound = playSound3D(soundFile, 0, 0, 0, true)
        attachElements(engineSound, localPlayer.vehicle)
    end
end

addEvent("onClientSetEngineSound", true)
addEventHandler("onClientSetEngineSound", root, onSetEngineSound)

-- Tabela z niestandardowymi dźwiękami
local engineSounds = {
    ["Sport cars"] = "sound/sport_engine_start.wav",
    ["Muscle cars"] = "sound/muscle_engine_start.wav",
    ["Off road"] = "sound/offroad_engine_start.wav",
    ["Lowrider"] = "sound/lowrider_engine_start.wav",
    ["Truck"] = "sound/truck_engine_start.wav",
    ["Regular"] = "sound/regular_engine_start.wav"
}
