-- client.lua
local browser = nil

function createJobUI()
    if not browser then
        browser = createBrowser(800, 600, true, true)
        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, "http://mta/local/ui/index.html")
            showCursor(true)
            guiSetInputEnabled(true)
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

addEventHandler("onClientMarkerHit", resourceRoot, function(marker)
    if getElementData(marker, "warehouseMarker") == true then
        if not getElementData(localPlayer, "onJob") then
            createJobUI()
            executeBrowserJavascript(browser, "document.getElementById('start-job').style.display = 'block';")
            executeBrowserJavascript(browser, "document.getElementById('end-job').style.display = 'none';")
        else
            createJobUI()
            executeBrowserJavascript(browser, "document.getElementById('start-job').style.display = 'none';")
            executeBrowserJavascript(browser, "document.getElementById('end-job').style.display = 'block';")
        end
    end
end)

-- Event from CEF to client
addEvent("startWarehouseJob", true)
addEventHandler("startWarehouseJob", root, function()
    triggerServerEvent("startWarehouseJob", resourceRoot)
end)

addEvent("endWarehouseJob", true)
addEventHandler("endWarehouseJob", root, function()
    triggerServerEvent("endWarehouseJob", resourceRoot)
end)

addEvent("closeWarehouseJobUI", true)
addEventHandler("closeWarehouseJobUI", root, function()
    removeJobUI()
end)

addEvent("onWarehouseJobStart", true)
addEventHandler("onWarehouseJobStart", resourceRoot, function()
    removeJobUI()
end)

addEvent("onWarehouseJobEnd", true)
addEventHandler("onWarehouseJobEnd", resourceRoot, function()
    removeJobUI()
end)
