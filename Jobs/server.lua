local jobData = {
    points = 0,
    pendingCash = 0,
    pendingSRP = 0
}

addEvent("requestJobData", true)
addEventHandler("requestJobData", resourceRoot, function()
    local data = getJobData()
    data.points = jobData.points
    data.pendingCash = jobData.pendingCash
    data.pendingSRP = jobData.pendingSRP
    triggerClientEvent(client, "receiveJobData", resourceRoot, data)
end)

addEvent("startWarehouseJob", true)
addEventHandler("startWarehouseJob", root, function(player)
    triggerClientEvent(player, "startWarehouseJobClient", root)
    -- Logika startu pracy magazyniera
end)

addEvent("stopWarehouseJob", true)
addEventHandler("stopWarehouseJob", root, function(player)
    triggerClientEvent(player, "stopWarehouseJobClient", root)
    -- Logika zakończenia pracy magazyniera
end)

addEvent("collectWages", true)
addEventHandler("collectWages", root, function(player)
    -- Logika odbierania wypłaty
    jobData.pendingCash = 0
    jobData.pendingSRP = 0
    triggerClientEvent(player, "updatePendingWagesClient", root, jobData.pendingCash, jobData.pendingSRP)
end)
