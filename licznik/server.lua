addEventHandler("onVehicleEnter", root, function(player, seat)
    if seat == 0 then -- Tylko kierowca
        if not getElementData(source, "vehicle:fuel") then
            setElementData(source, "vehicle:fuel", 100) -- Początkowa ilość paliwa
        end
        if not getElementData(source, "vehicle:mileage") then
            setElementData(source, "vehicle:mileage", 0) -- Początkowy przebieg
        end
    end
end)
