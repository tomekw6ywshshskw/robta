-- System statystyk gracza
function loadPlayerStats(player)
    triggerEvent("onRequestPlayerStats", resourceRoot, player)
end

function savePlayerStats(player)
    local data = {
        money = getElementData(player, "money") or 0,
        score = getElementData(player, "score") or 0,
        kills = getElementData(player, "kills") or 0,
        deaths = getElementData(player, "deaths") or 0,
        ban_status = getElementData(player, "ban_status") or 0,
        kick_count = getElementData(player, "kick_count") or 0,
        notes = getElementData(player, "notes") or "",
        warning_count = getElementData(player, "warning_count") or 0,
        reputation = getElementData(player, "reputation") or 0,
        sid = getElementData(player, "sid") or "",
        serial = getElementData(player, "serial") or "",
        license_a = getElementData(player, "license_a") or false,
        license_b = getElementData(player, "license_b") or false,
        license_c = getElementData(player, "license_c") or false,
        license_ce = getElementData(player, "license_ce") or false
    }
    triggerEvent("onSavePlayerStats", resourceRoot, player, data)
end

addEventHandler("onPlayerQuit", root, function()
    savePlayerStats(source)
end)

addEventHandler("onPlayerLogin", root, function()
    loadPlayerStats(source)
end)
