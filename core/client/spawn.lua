-- Example client/spawn.lua
addEvent("onClientPlayerSpawn", true)
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    -- Kod obsługi spawnowania postaci po stronie klienta
    outputChatBox("You have spawned!")
end)
