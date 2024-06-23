-- Połączenie z bazą danych
local dbConnection

addEventHandler("onResourceStart", resourceRoot, function()
    dbConnection = dbConnect("mysql", "dbname=my_mta_server;host=127.0.0.1", "username", "password")
    if dbConnection then
        outputServerLog("Połączenie z bazą danych nawiązane.")
    else
        outputServerLog("Błąd połączenia z bazą danych.")
    end
end)

function queryDatabase(query, ...)
    if not dbConnection then
        outputServerLog("Brak połączenia z bazą danych.")
        return false
    end
    local queryHandle = dbQuery(dbConnection, query, ...)
    if not queryHandle then
        return false
    end
    local result, numRows, lastInsertId = dbPoll(queryHandle, -1)
    return result, numRows, lastInsertId
end

function executeDatabase(query, ...)
    if not dbConnection then
        outputServerLog("Brak połączenia z bazą danych.")
        return false
    end
    local success = dbExec(dbConnection, query, ...)
    return success
end

function fetchPlayerData(player, callback)
    local playerName = getPlayerName(player)
    local query = "SELECT * FROM users WHERE username = ?"
    dbQuery(
        function(queryHandle)
            local result, numRows = dbPoll(queryHandle, 0)
            if numRows > 0 then
                callback(result[1])
            else
                callback(nil)
            end
        end,
        dbConnection, query, playerName
    )
end

function savePlayerData(player, data)
    local query = "UPDATE users SET money = ?, score = ?, kills = ?, deaths = ?, reputation = ?, sid = ?, serial = ?, license_category_a = ?, license_category_b = ?, license_category_c = ?, license_category_ce = ?, last_login = NOW() WHERE username = ?"
    local success = dbExec(dbConnection, query, data.money, data.score, data.kills, data.deaths, data.reputation, data.sid, data.serial, data.license_category_a, data.license_category_b, data.license_category_c, data.license_category_ce, getPlayerName(player))
    return success
end

function logPunishment(username, punishType, reason, duration)
    local query = "INSERT INTO punishments (username, type, reason, duration, punishment_date) VALUES (?, ?, ?, ?, NOW())"
    executeDatabase(query, username, punishType, reason, duration)
end

addEvent("onRequestPlayerStats", true)
addEventHandler("onRequestPlayerStats", resourceRoot, function(player)
    fetchPlayerData(player, function(data)
        if data then
            triggerClientEvent(player, "onReceivePlayerStats", resourceRoot, data)
        end
    end)
end)

addEvent("onSavePlayerStats", true)
addEventHandler("onSavePlayerStats", resourceRoot, function(player, data)
    savePlayerData(player, data)
end)
