local gui = nil

function showWorkGUI()
    if gui then
        destroyElement(gui)
    end
    
    gui = guiCreateWindow(screenW * 0.3, screenH * 0.3, screenW * 0.4, screenH * 0.4, "Praca Kosiarkarza", false)
    
    -- Zakładki GUI
    local tabPanel = guiCreateTabPanel(0, 0.1, 1, 0.9, true, gui)
    
    -- Zakładka Praca
    local tabWork = guiCreateTab("Praca", tabPanel)
    local label = guiCreateLabel(0.05, 0.1, 0.9, 0.2, "Wybierz opcję:", true, tabWork)
    
    local startButton
    if isWorkInProgress() then
        startButton = guiCreateButton(0.3, 0.4, 0.4, 0.2, "Zakończ pracę", true, tabWork)
    else
        startButton = guiCreateButton(0.3, 0.4, 0.4, 0.2, "Rozpocznij pracę", true, tabWork)
    end
    addEventHandler("onClientGUIClick", startButton, handleStartButtonClick, false)
    
    -- Zakładka Ulepszenia
    local tabUpgrades = guiCreateTab("Ulepszenia", tabPanel)
    local upgradeList = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, tabUpgrades)
    guiGridListAddColumn(upgradeList, "Nazwa", 0.5)
    guiGridListAddColumn(upgradeList, "Koszt (punkty pracy)", 0.4)
    
    for upgradeCode, upgrade in pairs(upgrades) do
        local row = guiGridListAddRow(upgradeList)
        guiGridListSetItemText(upgradeList, row, 1, upgrade.name, false, false)
        guiGridListSetItemText(upgradeList, row, 2, tostring(upgrade.jobPointsCost), false, false)
    end
    
    local buyButton = guiCreateButton(0.3, 0.85, 0.4, 0.1, "Kup Ulepszenie", true, tabUpgrades)
    addEventHandler("onClientGUIClick", buyButton, handleBuyUpgradeClick, false)
    
    -- Zakładka Statystyki
    local tabStats = guiCreateTab("Statystyki", tabPanel)
    local jobPointsLabel = guiCreateLabel(0.05, 0.1, 0.9, 0.2, "Punkty Pracy: " .. jobPoints["player:jobPoints"], true, tabStats)
    
    local closeButton = guiCreateButton(0.3, 0.85, 0.4, 0.1, "Zamknij", true, gui)
    addEventHandler("onClientGUIClick", closeButton, destroyWorkGUI, false)
    
    guiSetVisible(gui, true)
end

function handleBuyUpgradeClick()
    local selectedRow = guiGridListGetSelectedItem(upgradeList)
    if selectedRow and selectedRow ~= -1 then
        local upgradeCode = guiGridListGetItemText(upgradeList, selectedRow, 1)
        buyUpgrade(localPlayer, upgradeCode)
    else
        outputChatBox("Wybierz ulepszenie do kupienia!", localPlayer, 255, 0, 0)
    end
end
