-- System komend
function handleMuteCommand(player, commandName, targetPlayer, duration, ...)
    local reason = table.concat({...}, " ")
    local target = getPlayerFromName(targetPlayer)
    if not target then
        outputChatBox("Nie można znaleźć gracza o takim nicku.", player, 255, 0, 0)
        return
    end
    mutePlayer(target, reason, duration)
    outputChatBox(getPlayerName(target) .. " został wyciszony przez " .. getPlayerName(player) .. ". Powód: " .. reason, root)
end

function handleUnmuteCommand(player, commandName, targetPlayer)
    local target = getPlayerFromName(targetPlayer)
    if not target then
        outputChatBox("Nie można znaleźć gracza o takim nicku.", player, 255, 0, 0)
        return
    end
    unmutePlayer(target)
    outputChatBox(getPlayerName(target) .. " został odciszony przez " .. getPlayerName(player), root)
end

addCommandHandler("mute", handleMuteCommand)
addCommandHandler("unmute", handleUnmuteCommand)
