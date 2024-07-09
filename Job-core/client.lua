-- client.lua
local browser = nil

function createJobUI(isOnJob)
    if not browser then
        browser = createBrowser(800, 600, true, true)
        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, "http://mta/local/ui/index.html")
            showCursor(true)
            guiSetInputEnabled(true)
            triggerBrowserEvent(browser, "updateJobUI", isOnJob)
        end)
    end
end

function removeJobUI()
    if browser then
        destroyElement(browser)
        browser = nil
        showCursor(false)
        guiSetInputEnabled(false)
    end
end

addEventHandler("onClientMarkerHit", root, function(marker)
    if getElementData(marker, "warehouseMarker") then
        local isOnJob = getElementData(localPlayer, "onJob") or false
        createJobUI(isOnJob)
    end
end)

addEvent("closeWarehouseJobUI", true)
addEventHandler("closeWarehouseJobUI", root, function()
    removeJobUI()
end)

addEvent("startWarehouseJob", true)
addEventHandler("startWarehouseJob", root, function()
    triggerServerEvent("startWarehouseJob", resourceRoot)
end)

addEvent("endWarehouseJob", true)
addEventHandler("endWarehouseJob", root, function()
    triggerServerEvent("endWarehouseJob", resourceRoot)
end)

addEvent("onWarehouseJobStart", true)
addEventHandler("onWarehouseJobStart", resourceRoot, function()
    setElementData(localPlayer, "onJob", true)
    removeJobUI()
end)

addEvent("onWarehouseJobEnd", true)
addEventHandler("onWarehouseJobEnd", resourceRoot, function()
    setElementData(localPlayer, "onJob", false)
    removeJobUI()
end)
