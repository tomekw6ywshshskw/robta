addEventHandler("onVehicleEnter", root, function(player, seat)
    if seat == 0 then
        if getElementData(source, "vehicle:fuel") == nil then
            setElementData(source, "vehicle:fuel", 100) -- Set initial fuel level to 100
        end
    end
end)
