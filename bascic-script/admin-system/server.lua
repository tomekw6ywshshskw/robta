-- Rangi administracyjne
local adminRanks = {
    [1] = "Test pomocnik",
    [2] = "Pomocnik",
    [3] = "Moderator",
    [4] = "Administrator",
    [5] = "Starszy Administrator",
    [6] = "Opiekun administracji",
    [7] = "Zarząd"
}

-- Ładowanie zasobu
addEventHandler("onResourceStart", resourceRoot, function()
    outputDebugString("Admin system loaded.")
end)

-- Funkcja włączania służby admina
function adminDuty(player, cmd)
    local serial = getPlayerSerial(player)
    local query = dbQuery("SELECT * FROM admins WHERE serial = ?", serial)
    local result = dbPoll(query, -1)
    if #result > 0 then
        setElementData(player, "adminLvl", result[1].admin_lvl)
        setElementData(player, "adminRank", adminRanks[result[1].admin_lvl])
        outputChatBox("You are now on duty as " .. adminRanks[result[1].admin_lvl] .. ".", player)
        logAdminAction(getPlayerName(player), "Went on duty as " .. adminRanks[result[1].admin_lvl])
    else
        outputChatBox("You are not registered as an admin.", player)
    end
end
addCommandHandler("duty", adminDuty)

-- Funkcja sprawdzająca poziom admina
function isAdmin(player)
    local adminLvl = getElementData(player, "adminLvl")
    return adminLvl and adminLvl > 0
end

-- Funkcja sprawdzająca poziom admina
function getAdminLevel(player)
    return getElementData(player, "adminLvl") or 0
end

-- Funkcja logowania czynności administracyjnych
function logAdminAction(adminNick, action)
    dbExec("INSERT INTO logs (admin_nick, action) VALUES (?, ?)", adminNick, action)
end

-- Przykładowe funkcje administracyjne
function repairVehicleCommand(player, cmd, targetNick)
    if getAdminLevel(player) < 3 then -- Poziom 3 to minimalny poziom do użycia tej komendy
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        local vehicle = getPedOccupiedVehicle(targetPlayer)
        if vehicle then
            fixVehicle(vehicle)
            outputChatBox("Vehicle repaired.", player)
            logAdminAction(getPlayerName(player), "Repaired vehicle of " .. targetNick)
        else
            outputChatBox("Player is not in a vehicle.", player)
        end
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("repairveh", repairVehicleCommand)

function repairAllVehiclesCommand(player, cmd)
    if getAdminLevel(player) < 4 then -- Poziom 4 to minimalny poziom do użycia tej komendy
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    for _, veh in ipairs(getElementsByType("vehicle")) do
        fixVehicle(veh)
    end
    outputChatBox("All vehicles repaired.", player)
    logAdminAction(getPlayerName(player), "Repaired all vehicles")
end
addCommandHandler("repairallveh", repairAllVehiclesCommand)

function addFuelCommand(player, cmd, targetNick, fuelAmount)
    if getAdminLevel(player) < 3 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        local vehicle = getPedOccupiedVehicle(targetPlayer)
        if vehicle then
            setElementData(vehicle, "fuel", tonumber(fuelAmount))
            outputChatBox("Fuel added to vehicle.", player)
            logAdminAction(getPlayerName(player), "Added fuel to vehicle of " .. targetNick)
        else
            outputChatBox("Player is not in a vehicle.", player)
        end
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("addfuel", addFuelCommand)

function teleportPlayerToPlayerCommand(player, cmd, targetNick)
    if getAdminLevel(player) < 2 then -- Poziom 2 to minimalny poziom do użycia tej komendy
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        local x, y, z = getElementPosition(targetPlayer)
        setElementPosition(player, x, y, z + 1)
        outputChatBox("Teleported to " .. targetNick .. ".", player)
        logAdminAction(getPlayerName(player), "Teleported to " .. targetNick)
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("tp", teleportPlayerToPlayerCommand)

function teleportPlayerToMeCommand(player, cmd, targetNick)
    if getAdminLevel(player) < 2 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        local x, y, z = getElementPosition(player)
        setElementPosition(targetPlayer, x, y, z + 1)
        outputChatBox("Teleported " .. targetNick .. " to you.", player)
        logAdminAction(getPlayerName(player), "Teleported " .. targetNick .. " to them")
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("tpme", teleportPlayerToMeCommand)

function kickPlayerCommand(player, cmd, targetNick, reason)
    if getAdminLevel(player) < 1 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        kickPlayer(targetPlayer, reason or "Kicked by admin.")
        outputChatBox("Player " .. targetNick .. " has been kicked.", player)
        logAdminAction(getPlayerName(player), "Kicked " .. targetNick .. " for " .. (reason or "No reason given"))
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("kick", kickPlayerCommand)

function banPlayerCommand(player, cmd, targetNick, duration, reason)
    if getAdminLevel(player) < 4 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        local serial = getPlayerSerial(targetPlayer)
        banPlayer(targetPlayer, false, false, true, player, reason or "Banned by admin.", duration or 0)
        outputChatBox("Player " .. targetNick .. " has been banned.", player)
        logAdminAction(getPlayerName(player), "Banned " .. targetNick .. " for " .. (reason or "No reason given"))
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("ban", banPlayerCommand)

function mutePlayerCommand(player, cmd, targetNick, duration)
    if getAdminLevel(player) < 2 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        setPlayerMuted(targetPlayer, true)
        setTimer(setPlayerMuted, (duration or 60) * 1000, 1, targetPlayer, false)
        outputChatBox("Player " .. targetNick .. " has been muted for " .. (duration or 60) .. " seconds.", player)
        logAdminAction(getPlayerName(player), "Muted " .. targetNick .. " for " .. (duration or 60) .. " seconds")
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("mute", mutePlayerCommand)

function unmutePlayerCommand(player, cmd, targetNick)
    if getAdminLevel(player) < 2 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        setPlayerMuted(targetPlayer, false)
        outputChatBox("Player " .. targetNick .. " has been unmuted.", player)
        logAdminAction(getPlayerName(player), "Unmuted " .. targetNick)
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("unmute", unmutePlayerCommand)

function giveMoneyCommand(player, cmd, targetNick, amount)
    if getAdminLevel(player) < 3 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        givePlayerMoney(targetPlayer, tonumber(amount))
        outputChatBox("Gave " .. amount .. " to " .. targetNick .. ".", player)
        logAdminAction(getPlayerName(player), "Gave " .. amount .. " to " .. targetNick)
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("givemoney", giveMoneyCommand)

function giveSRPCommand(player, cmd, targetNick, amount)
    if getAdminLevel(player) < 3 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        -- Zakładamy, że SRP jest przechowywane jako element danych
        local currentSRP = getElementData(targetPlayer, "srp") or 0
        setElementData(targetPlayer, "srp", currentSRP + tonumber(amount))
        outputChatBox("Gave " .. amount .. " SRP to " .. targetNick .. ".", player)
        logAdminAction(getPlayerName(player), "Gave " .. amount .. " SRP to " .. targetNick)
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("givesrp", giveSRPCommand)

function giveKeyCommand(player, cmd, targetNick, keyType)
    if getAdminLevel(player) < 3 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    local targetPlayer = getPlayerFromName(targetNick)
    if targetPlayer then
        -- Zakładamy, że klucze są przechowywane jako tablica elementów danych
        local keys = getElementData(targetPlayer, "keys") or {}
        table.insert(keys, keyType)
        setElementData(targetPlayer, "keys", keys)
        outputChatBox("Gave " .. keyType .. " key to " .. targetNick .. ".", player)
        logAdminAction(getPlayerName(player), "Gave " .. keyType .. " key to " .. targetNick)
    else
        outputChatBox("Player not found.", player)
    end
end
addCommandHandler("givekey", giveKeyCommand)

-- Komendy unban
function unbanPlayerCommand(player, cmd, serial)
    if getAdminLevel(player) < 5 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    for _, ban in ipairs(getBans()) do
        if getBanSerial(ban) == serial then
            removeBan(ban)
            outputChatBox("Player with serial " .. serial .. " has been unbanned.", player)
            logAdminAction(getPlayerName(player), "Unbanned serial " .. serial)
            return
        end
    end
    outputChatBox("No ban found for the given serial.", player)
end
addCommandHandler("unban", unbanPlayerCommand)

function unPermBanPlayerCommand(player, cmd, serial)
    if getAdminLevel(player) < 6 then
        outputChatBox("You do not have permission to use this command.", player)
        return
    end

    for _, ban in ipairs(getBans()) do
        if getBanSerial(ban) == serial then
            removeBan(ban)
            outputChatBox("Player with serial " .. serial .. " has been permanently unbanned.", player)
            logAdminAction(getPlayerName(player), "Permanently unbanned serial " .. serial)
            return
        end
    end
    outputChatBox("No permanent ban found for the given serial.", player)
end
addCommandHandler("unpermban", unPermBanPlayerCommand)

