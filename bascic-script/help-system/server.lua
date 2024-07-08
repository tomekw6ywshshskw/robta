function submitSupportRequest(reportText)
    local playerName = getPlayerName(client)
    local reportMessage = playerName .. ": " .. reportText

    for _, admin in ipairs(getElementsByType("player")) do
        if getElementData(admin, "adminLvl") and getElementData(admin, "adminLvl") >= adminLevelRequired then
            outputChatBox("[WSPIERANIE] " .. reportMessage, admin, 255, 165, 0)
        end
    end

    outputChatBox("Twoje zgłoszenie zostało wysłane do administracji.", client, 0, 255, 0)
    logSupportRequest(playerName, reportText)
end
addEvent("submitSupportRequest", true)
addEventHandler("submitSupportRequest", resourceRoot, submitSupportRequest)

function logSupportRequest(playerName, reportText)
    local file = fileOpen("support_logs.txt", true)
    if file then
        local timestamp = getRealTime().timestamp
        fileWrite(file, "[" .. timestamp .. "] " .. playerName .. ": " .. reportText .. "\n")
        fileClose(file)
    else
        file = fileCreate("support_logs.txt")
        local timestamp = getRealTime().timestamp
        fileWrite(file, "[" .. timestamp .. "] " .. playerName .. ": " .. reportText .. "\n")
        fileClose(file)
    end
end
