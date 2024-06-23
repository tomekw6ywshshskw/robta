-- System czatu
function onPlayerChat(player, message, messageType)
    if messageType == 0 then
        outputChatBox(getPlayerName(player) .. ": " .. message, root)
        cancelEvent()
    end
end

addEventHandler("onPlayerChat", root, onPlayerChat)
