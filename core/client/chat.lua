-- Example client/chat.lua
addEvent("onReceiveChatMessage", true)
addEventHandler("onReceiveChatMessage", root, function(message)
    -- Obsługa otrzymanych wiadomości czatu po stronie klienta
    outputChatBox("Received message: " .. message)
end)
