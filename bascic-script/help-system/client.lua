local screenWidth, screenHeight = guiGetScreenSize()
local supportWindow = false
local reportMemo = false
local submitButton = false

function toggleSupportPanel()
    if not supportWindow then
        supportWindow = true
        showCursor(true)

        reportMemo = guiCreateMemo(0.35, 0.25, 0.3, 0.3, "", true)
        submitButton = guiCreateButton(0.45, 0.6, 0.1, 0.05, "Wyślij", true)
        
        addEventHandler("onClientGUIClick", submitButton, submitSupportRequest, false)
    else
        supportWindow = false
        showCursor(false)

        if isElement(reportMemo) then
            destroyElement(reportMemo)
        end

        if isElement(submitButton) then
            destroyElement(submitButton)
        end
    end
end
bindKey("F2", "down", toggleSupportPanel)

function submitSupportRequest()
    local reportText = guiGetText(reportMemo)
    if reportText and reportText ~= "" then
        triggerServerEvent("submitSupportRequest", resourceRoot, reportText)
        toggleSupportPanel()
    else
        outputChatBox("Proszę wpisać treść zgłoszenia.", 255, 0, 0)
    end
end

function dxDrawSupportPanel()
    if supportWindow then
        dxDrawRectangle(screenWidth * 0.3, screenHeight * 0.2, screenWidth * 0.4, screenHeight * 0.6, tocolor(0, 0, 0, 150))
        dxDrawText("Zgłoszenie wsparcia", screenWidth * 0.35, screenHeight * 0.22, 0, 0, tocolor(255, 255, 255), 1.2, "default-bold")
        dxDrawText("Treść zgłoszenia:", screenWidth * 0.32, screenHeight * 0.3, 0, 0, tocolor(255, 255, 255), 1, "default-bold")
    end
end
addEventHandler("onClientRender", root, dxDrawSupportPanel)
