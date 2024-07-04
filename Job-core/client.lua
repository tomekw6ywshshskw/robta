-- client.lua
addCommandHandler("startJob", function(cmd, jobCode)
    triggerServerEvent("onPlayerRequestStartJob", resourceRoot, jobCode)
end)

addEvent("onJobPayNotification", true)
addEventHandler("onJobPayNotification", resourceRoot, function(message)
    outputChatBox(message, 255, 255, 0)
end)
