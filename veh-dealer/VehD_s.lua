-- Funkcja do zapisu pojazdu do bazy danych
function saveVehicleToDatabase(player, vehicle, price)
    -- Pobierz ID właściciela pojazdu (gracza)
    local playerID = exports['Vehicles']:getPlayerVehicleID(player)

    -- Pobierz model pojazdu
    local vehicleModel = getElementModel(vehicle)

    -- Pobierz pozycję i rotację pojazdu
    local x, y, z = getElementPosition(vehicle)
    local rx, ry, rz = getElementRotation(vehicle)

    -- Zapisz pojazd do bazy danych
    -- Tutaj używamy Twojego systemu bazodanowego, na przykład MySQL

    -- Przykładowe zapytanie do bazy danych (zależy od używanego systemu baz danych)
    local query = dbQuery(db, "INSERT INTO vehicles (owner_id, model, position_x, position_y, position_z, rotation_x, rotation_y, rotation_z, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        playerID, vehicleModel, x, y, z, rx, ry, rz, price)
    local _, _, insertedID = dbPoll(query, -1)

    if insertedID then
        -- Dodaj informacje o zakupie do chatboxa
        outputChatBox("Zakupiono pojazd " .. getVehicleNameFromModel(vehicleModel) .. " za $" .. price .. ". ID pojazdu: " .. insertedID, player, 0, 255, 0)
    else
        outputChatBox("Błąd podczas zapisywania pojazdu do bazy danych.", player, 255, 0, 0)
    end
end
