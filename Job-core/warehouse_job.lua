-- warehouse_job.lua
local warehouseMarkers = {
    start = createMarker(1000, 2000, 13, "cylinder", 1.5, 255, 0, 0, 150), -- Example coordinates
    pickup = {
        createMarker(1010, 2020, 13, "cylinder", 1.5, 0, 255, 0, 150),
        createMarker(1020, 2030, 13, "cylinder", 1.5, 0, 255, 0, 150)
    },
    dropoff = {
        createMarker(1030, 2040, 13, "cylinder", 1.5, 0, 0, 255, 150),
        createMarker(1040, 2050, 13, "cylinder", 1.5, 0, 0, 255, 150)
    }
}

setElementData(warehouseMarkers.start, "warehouseMarker", true)

function onMarkerHit(hitElement, matchingDimension)
    if getElementType(hitElement) == "player" and matchingDimension then
        if source == warehouseMarkers.start then
            local isOnJob = getElementData(hitElement, "onJob") or false
            triggerClientEvent(hitElement, "updateJobUI", resourceRoot, isOnJob)
        elseif getElementData(source,
