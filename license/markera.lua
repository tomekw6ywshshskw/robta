-- Funkcja tworząca marker
function createDrivingSchoolMarker(x, y, z)
    local marker = createMarker(x, y, z, "cylinder", 1.5, 255, 0, 0, 150)
    addEventHandler("onMarkerHit", marker, function(hitPlayer)
        if getElementType(hitPlayer) == "player" then
            triggerClientEvent(hitPlayer, "showCategorySelection", hitPlayer)
        end
    end)
end

-- Tworzenie markerów
createDrivingSchoolMarker(1178.27, -1323.91, 14.18) -- Przykładowa lokalizacja
