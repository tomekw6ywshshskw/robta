local screenW, screenH = guiGetScreenSize()
local showUI = false
local jobActive = false
local jobData = {}
local currentTab = "main"

-- Pobierz dane pracy
addEvent("receiveJobData", true)
addEventHandler("receiveJobData", root, function(data)
    jobData = data
end)

function drawWarehouseUI()
    if showUI then
        dxDrawRectangle(screenW * 0.3, screenH * 0.2, screenW * 0.4, screenH * 0.6, tocolor(0, 0, 0, 200))
        dxDrawText("Praca Magazyniera", screenW * 0.3, screenH * 0.2, screenW * 0.7, screenH * 0.3, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center")

        -- Zakładki
        dxDrawRectangle(screenW * 0.3, screenH * 0.3, screenW * 0.1, screenH * 0.05, tocolor(60, 60, 60, 200))
        dxDrawText("Strona Główna", screenW * 0.3, screenH * 0.3, screenW * 0.4, screenH * 0.35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

        dxDrawRectangle(screenW * 0.4, screenH * 0.3, screenW * 0.1, screenH * 0.05, tocolor(60, 60, 60, 200))
        dxDrawText("Informacje", screenW * 0.4, screenH * 0.3, screenW * 0.5, screenH * 0.35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

        dxDrawRectangle(screenW * 0.5, screenH * 0.3, screenW * 0.1, screenH * 0.05, tocolor(60, 60, 60, 200))
        dxDrawText("Ulepszenia", screenW * 0.5, screenH * 0.3, screenW * 0.6, screenH * 0.35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

        dxDrawRectangle(screenW * 0.6, screenH * 0.3, screenW * 0.1, screenH * 0.05, tocolor(60, 60, 60, 200))
        dxDrawText("Statystyki", screenW * 0.6, screenH * 0.3, screenW * 0.7, screenH * 0.35, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

        if currentTab == "main" then
            local buttonText = jobActive and "Zakończ Pracę" or "Rozpocznij Pracę"
            dxDrawRectangle(screenW * 0.4, screenH * 0.4, screenW * 0.2, screenH * 0.05, tocolor(60, 60, 60, 200))
            dxDrawText(buttonText, screenW * 0.4, screenH * 0.4, screenW * 0.6, screenH * 0.45, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
        elseif currentTab == "info" then
            dxDrawText(jobData.description, screenW * 0.3, screenH * 0.4, screenW * 0.7, screenH * 0.7, tocolor(255, 255, 255, 255), 1, "default", "center", "center", true)

            local requirementsY = screenH * 0.4 + 40
            for _, requirement in ipairs(jobData.jobRequirements) do
                if requirement.job == "Warehouse" then
                    local srpText = requirement.srpRequired == 0 and "Brak" or tostring(requirement.srpRequired)
                    local categoryText = requirement.categoryRequired or "Brak"
                    dxDrawText("Wymagania:", screenW * 0.3, requirementsY, screenW * 0.7, requirementsY + 20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
                    dxDrawText("SRP: " .. srpText, screenW * 0.3, requirementsY + 20, screenW * 0.7, requirementsY + 40, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
                    dxDrawText("Kategoria Prawa Jazdy: " .. categoryText, screenW * 0.3, requirementsY + 40, screenW * 0.7, requirementsY + 60, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
                    break
                end
            end
        elseif currentTab == "upgrades" then
            dxDrawText("Ulepszenia", screenW * 0.3, screenH * 0.4, screenW * 0.7, screenH * 0.7, tocolor(255, 255, 255, 255), 1, "default", "center", "center", true)
            for i, upgrade in ipairs(jobData.upgrades) do
                local y = screenH * 0.4 + i * 30
                dxDrawText(upgrade.name .. " - Koszt: " .. upgrade.cost .. " punktów pracy", screenW * 0.3, y, screenW * 0.7, y + 30, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
            end
        elseif currentTab == "stats" then
            dxDrawText("Punkty Pracy: " .. jobData.points, screenW * 0.3, screenH * 0.4, screenW * 0.7, screenH * 0.45, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
            dxDrawText("Oczekujące Wypłaty: " .. jobData.pendingCash .. " PLN, " .. jobData.pendingSRP .. " SRP", screenW * 0.3, screenH * 0.45, screenW * 0.7, screenH * 0.5, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
            dxDrawRectangle(screenW * 0.4, screenH * 0.5, screenW * 0.2, screenH * 0.05, tocolor(60, 60, 60, 200))
            dxDrawText("Odbierz Wypłatę", screenW * 0.4, screenH * 0.5, screenW * 0.6, screenH * 0.55, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
        end

        -- Mini interface na dole
        dxDrawRectangle(screenW * 0.3, screenH * 0.85, screenW * 0.4, screenH * 0.1, tocolor(0, 0, 0, 200))
        dxDrawText("Aktualna praca: " .. (jobActive and "Magazynier" or "Brak"), screenW * 0.3, screenH * 0.85, screenW * 0.7, screenH * 0.9, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
    end
end
addEventHandler("onClientRender", root, drawWarehouseUI)

function toggleUI()
    showUI = not showUI
    if showUI then
        triggerServerEvent("requestJobData", resourceRoot)
    end
end

function onJobMarkerHit(hitPlayer)
    if hitPlayer == localPlayer then
        toggleUI()
    end
end
addEventHandler("onClientMarkerHit", root, onJobMarkerHit)

function handleButtonClick(button, state)
    if button == "left" and state == "up" then
        if currentTab == "main" then
            if isInBox(screenW * 0.4, screenH * 0.4, screenW * 0.6, screenH * 0.45) then
                if jobActive then
                    triggerServerEvent("stopWarehouseJob", localPlayer)
                else
                    triggerServerEvent("startWarehouseJob", localPlayer)
                end
            end
        elseif currentTab == "stats" then
            if isInBox(screenW * 0.4, screenH * 0.5, screenW * 0.6, screenH * 0.55) then
                triggerServerEvent("collectWages", localPlayer)
            end
        end
    end
end
addEventHandler("onClientClick", root, handleButtonClick)

function isInBox(x, y, width, height)
    local cx, cy = getCursorPosition()
    cx, cy = cx * screenW, cy * screenH
    return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

-- Obsługa zmiany zakładek
function handleTabClick(button, state, x, y)
    if button == "left" and state == "up" then
        if isInBox(screenW * 0.3, screenH * 0.3, screenW * 0.1, screenH * 0.05) then
            currentTab = "main"
        elseif isInBox(screenW * 0.4, screenH * 0.3, screenW * 0.1, screenH * 0.05) then
            currentTab = "info"
        elseif isInBox(screenW * 0.5, screenH * 0.3, screenW * 0.1, screenH * 0.05) then
            currentTab = "upgrades"
        elseif isInBox(screenW * 0.6, screenH * 0.3, screenW * 0.1, screenH * 0.05) then
            currentTab = "stats"
        end
    end
end
addEventHandler("onClientClick", root, handleTabClick)

-- Obsługa rozpoczęcia/zakończenia pracy
addEvent("startWarehouseJobClient", true)
addEventHandler("startWarehouseJobClient", root, function()
    jobActive = true
end)

addEvent("stopWarehouseJobClient", true)
addEventHandler("stopWarehouseJobClient", root, function()
    jobActive = false
end)

-- Obsługa wypłat
addEvent("updatePendingWagesClient", true)
addEventHandler("updatePendingWagesClient", root, function(cash, srp)
    jobData.pendingCash = cash
    jobData.pendingSRP = srp
end)
