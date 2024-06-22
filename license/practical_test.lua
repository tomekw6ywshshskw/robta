local checkpoints = {
    {x = 1175, y = -1322, z = 14},
    {x = 1180, y = -1300, z = 14},
    {x = 1200, y = -1280, z = 14},
    -- Dodaj więcej checkpointów tutaj
}

local currentCheckpoint = 1
local vehicle = nil

-- Funkcja rozpoczęcia testu praktycznego
function startPracticalTest()
    local player = localPlayer
    vehicle = createVehicle(411, 1178.27, -1323.91, 14.18) -- ID pojazdu, współrzędne x, y, z
    warpPedIntoVehicle(player, vehicle)
    addEventHandler("onClientRender", root, drawCheckpoint)
end
addEvent("startPracticalTest", true)
addEventHandler("startPracticalTest", root, startPracticalTest)

-- Funkcja rysująca checkpoint
function drawCheckpoint()
    local checkpoint = checkpoints[currentCheckpoint]
    if checkpoint then
        local screenX, screenY = getScreenFromWorldPosition(checkpoint.x, checkpoint.y, checkpoint.z, 0.06)
        if screenX and screenY then
            dxDrawText("Checkpoint", screenX, screenY, screenX, screenY, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")
        end
    end
end

-- Funkcja przejścia do następnego checkpointa
function nextCheckpoint()
    currentCheckpoint = currentCheckpoint + 1
    if currentCheckpoint > #checkpoints then
        -- Zakończ test
        removeEventHandler("onClientRender", root, drawCheckpoint)
        destroyElement(vehicle)
        outputChatBox("Zdałeś część praktyczną!", 0, 255, 0)
        triggerServerEvent("givePlayerLicense", resourceRoot)
    else
        -- Przenieś gracza do następnego checkpointa
        local checkpoint = checkpoints[currentCheckpoint]
        setElementPosition(vehicle, checkpoint.x, checkpoint.y, checkpoint.z)
    end
end

-- Funkcja obsługująca przejazd przez checkpoint
function onCheckpointHit(hitElement)
    if hitElement == vehicle then
        nextCheckpoint()
    end
end

-- Tworzenie checkpointów
for _, checkpoint in ipairs(checkpoints) do
    local col = createColSphere(checkpoint.x, checkpoint.y, checkpoint.z, 3)
    addEventHandler("onColShapeHit", col, onCheckpointHit)
end
