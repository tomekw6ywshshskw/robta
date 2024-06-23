-- System mutów (wyciszeń)
function mutePlayer(player, reason, duration)
    local playerName = getPlayerName(player)
    outputChatBox(playerName .. " został wyciszony: " .. reason, root)
    -- Zapisz mut do bazy danych
    local query = "UPDATE users SET mute_status = 1, mute_reason = ?, mute_expiry = DATE_ADD(NOW(), INTERVAL ? SECOND) WHERE username = ?"
    executeDatabase(query, reason, duration, playerName)
    -- Zaktualizuj mute_status w danych gracza
    local data = {
        mute_status = 1, -- 1 oznacza, że gracz jest wyciszony
        mute_reason = reason,
        mute_expiry = getBanTimeExpiry(duration)
    }
    savePlayerData(player, data)
end

function unmutePlayer(player)
    local playerName = getPlayerName(player)
    outputChatBox(playerName .. " został odciszony.", root)
    -- Usuń mut z bazy danych
    local query = "UPDATE users SET mute_status = 0, mute_reason = NULL, mute_expiry = NULL WHERE username = ?"
    executeDatabase(query, playerName)
    -- Zaktualizuj mute_status w danych gracza
    local data = {
        mute_status = 0,
        mute_reason = nil,
        mute_expiry = nil
    }
    savePlayerData(player, data)
end
