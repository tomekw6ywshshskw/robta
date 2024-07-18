local lawnMarkers = {
    { x = 1000, y = 2000, z = 20 },
    { x = 1050, y = 2050, z = 20 },
    -- dodaj więcej markerów trawnika
}

local currentLawn = nil
local lawnProgress = 0
local maxProgress = 100
local isMowing = false
local pickupVehicle = nil
local mowerLoaded = false

function startMowingJob()
    if not hasMower() then
        outputChatBox("Musisz posiadać kosiarkę, aby rozpocząć pracę!")
        return
    end
    
    if currentLawn then
        local x, y, z = lawnMarkers[currentLawn].x, lawnMarkers[currentLawn].y, lawnMarkers[currentLawn].z
        setElementPosition(localPlayer, x, y, z)
        lawnProgress = 0
        isMowing = true
        addEventHandler("onClientRender", root, drawMowingUI)
    end
end

function hasMower()
    -- funkcja sprawdzająca, czy gracz posiada kosiarkę
    return getElementData(localPlayer, "player:hasMower") == true
end

function loadMowerOnPickup()
    local x, y, z = getElementPosition(localPlayer)
    local pickupX, pickupY, pickupZ = x + 3, y, z -- przykładowa pozycja za pickupem

    if pickupVehicle then
        if not mowerLoaded then
            -- sprawdź, czy gracz jest blisko pickupa
            if getDistanceBetweenPoints3D(x, y, z, pickupX, pickupY, pickupZ) < 3 then
                -- załaduj kosiarkę na pickup
                mowerLoaded = true
                outputChatBox("Kosiarka załadowana na pickup!")
            else
                outputChatBox("Musisz być blisko pickupa, aby załadować kosiarkę!")
            end
        else
            outputChatBox("Kosiarka już jest załadowana na pickupie!")
        end
    else
        outputChatBox("Musisz mieć pickupa, aby załadować kosiarkę!")
    end
end

function unloadMowerOnLawn()
    local x, y, z = getElementPosition(localPlayer)
    local lawnX, lawnY, lawnZ = x + 5, y, z -- przykładowa pozycja trawnika
    
    if pickupVehicle then
        if mowerLoaded then
            -- sprawdź, czy gracz jest blisko trawnika
            if getDistanceBetweenPoints3D(x, y, z, lawnX, lawnY, lawnZ) < 5 then
                -- rozładuj kosiarkę na trawniku
                mowerLoaded = false
                outputChatBox("Kosiarka rozładowana na trawniku!")
            else
                outputChatBox("Musisz być blisko trawnika, aby rozładować kosiarkę!")
            end
        else
            outputChatBox("Nie masz załadowanej kosiarki na pickupie!")
        end
    else
        outputChatBox("Musisz mieć pickupa, aby rozładować kosiarkę!")
    end
end

function finishMowingJob()
    isMowing = false
    removeEventHandler("onClientRender", root, drawMowingUI)
    triggerServerEvent("onMowingJobFinish", resourceRoot, lawnProgress)
end

function drawMowingUI()
    dxDrawRectangle(screenW * 0.3, screenH * 0.85, screenW * 0.4, screenH * 0.1, tocolor(0, 0, 0, 200))
    dxDrawText("Koszenie trawnika: " .. math.floor(lawnProgress) .. "%", screenW * 0.3, screenH * 0.85, screenW * 0.7, screenH * 0.9, tocolor(255, 255, 255, 255), 1, "default", "center", "center")
    
    if lawnProgress >= maxProgress then
        finishMowingJob()
    end
end

function onLawnMarkerHit(hitPlayer)
    if hitPlayer == localPlayer then
        startMowingJob()
    end
end
addEventHandler("onClientMarkerHit", root, onLawnMarkerHit)

function onPlayerVehicleEnter(vehicle)
    if vehicle and getVehicleType(vehicle) == "Pickup" then
        pickupVehicle = vehicle
    end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, onPlayerVehicleEnter)

function onPlayerVehicleExit(vehicle)
    if vehicle and vehicle == pickupVehicle then
        pickupVehicle = nil
    end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, onPlayerVehicleExit)
