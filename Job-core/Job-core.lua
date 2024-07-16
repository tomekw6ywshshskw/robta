-- job-core.lua

-- Importujemy upgrades.lua
loadstring(exports.interfacer:load("upgrades.lua"))()

-- Funkcja do rozpoczęcia pracy, teraz uwzględnia ulepszenia
addEvent("startWarehouseJob", true)
addEventHandler("startWarehouseJob", root, function()
    local player = client
    local jobCode = "Warehouse"

    -- Sprawdzenie i zastosowanie ulepszeń
    if getElementData(player, "has_upgrade_lepsza_kasa") then
        applyUpgrade(player, "lepsza_kasa", jobCode)
    end
    if getElementData(player, "has_upgrade_szybsze_pakowanie") then
        applyUpgrade(player, "szybsze_pakowanie", jobCode)
    end
    if getElementData(player, "has_upgrade_dodatkowe_bonusy") then
        applyUpgrade(player, "dodatkowe_bonusy", jobCode)
    end

    setElementData(player, "onJob", true)
    triggerClientEvent(player, "onWarehouseJobStart", resourceRoot)
    outputChatBox("Rozpocząłeś pracę magazyniera.", player)
end)

-- Funkcja do zakończenia pracy
addEvent("endWarehouseJob", true)
addEventHandler("endWarehouseJob", root, function()
    local player = client
    setElementData(player, "onJob", false)
    triggerClientEvent(player, "onWarehouseJobEnd", resourceRoot)
    outputChatBox("Zakończyłeś pracę magazyniera.", player)
end)
