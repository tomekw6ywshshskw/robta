-- Tabela silników zawierająca ich parametry
local engines = {
    ["benzyna_small"] = {hp = 100, nm = 150, capacity = 1.2, cylinders = 4, pistons = 4, camshafts = 1, type = "benzyna"},
    ["benzyna_medium"] = {hp = 200, nm = 300, capacity = 2.0, cylinders = 6, pistons = 6, camshafts = 2, type = "benzyna"},
    ["benzyna_large"] = {hp = 400, nm = 600, capacity = 3.5, cylinders = 8, pistons = 8, camshafts = 4, type = "benzyna"},
    ["benzyna_sport"] = {hp = 600, nm = 800, capacity = 4.0, cylinders = 10, pistons = 10, camshafts = 4, type = "benzyna"},
    ["benzyna_max"] = {hp = 1000, nm = 1200, capacity = 5.0, cylinders = 12, pistons = 12, camshafts = 4, type = "benzyna"},
    ["diesel_small"] = {hp = 90, nm = 200, capacity = 1.5, cylinders = 4, pistons = 4, camshafts = 1, type = "diesel"},
    ["diesel_1_9_tdi"] = {hp = 110, nm = 250, capacity = 1.9, cylinders = 4, pistons = 4, camshafts = 2, type = "diesel"},
    ["diesel_large"] = {hp = 300, nm = 500, capacity = 3.0, cylinders = 6, pistons = 6, camshafts = 3, type = "diesel"},
    ["electric_standard"] = {hp = 150, nm = 400, capacity = 0.0, cylinders = 0, pistons = 0, camshafts = 0, type = "electric"},
    ["electric_performance"] = {hp = 300, nm = 700, capacity = 0.0, cylinders = 0, pistons = 0, camshafts = 0, type = "electric"},
}

-- Funkcja do obliczania maksymalnej prędkości na podstawie parametrów silnika
local function calculateVMax(engine)
    local vMax
    if engine.type == "benzyna" then
        vMax = engine.hp * 0.3 + engine.nm * 0.2
    elseif engine.type == "diesel" then
        vMax = engine.hp * 0.25 + engine.nm * 0.25
    elseif engine.type == "electric" then
        vMax = engine.hp * 0.35 + engine.nm * 0.15
    end
    return vMax
end

-- Funkcja do zapisywania pojazdu do bazy danych
local function saveVehicleToDatabase(player, vehicle, price)
    -- Pobranie danych o pojeździe
    local engineType = getElementData(vehicle, "engineType")
    local hp = getElementData(vehicle, "hp")
    local nm = getElementData(vehicle, "nm")
    local capacity = getElementData(vehicle, "capacity")
    local cylinders = getElementData(vehicle, "cylinders")
    local pistons = getElementData(vehicle, "pistons")
    local camshafts = getElementData(vehicle, "camshafts")
    local vMax = getElementData(vehicle, "vMax")
    local engineTypeDetail = getElementData(vehicle, "engineTypeDetail")
    local nitro = getElementData(vehicle, "nitro")
    local stereo = getElementData(vehicle, "stereo")
    local mk = getElementData(vehicle, "mk")
    local chipTuning = getElementData(vehicle, "chipTuning")
    local neons = getElementData(vehicle, "neons")
    local lampColor = getElementData(vehicle, "lampColor")
    local windowTint = getElementData(vehicle, "windowTint")
    local lampType = getElementData(vehicle, "lampType")
    local brakes = getElementData(vehicle, "brakes")
    local suspension = getElementData(vehicle, "suspension")
    local bulletproofWindows = getElementData(vehicle, "bulletproofWindows")
    local bulletproofTires = getElementData(vehicle, "bulletproofTires")
    local armor = getElementData(vehicle, "armor")
    local gearbox = getElementData(vehicle, "gearbox")
    local turbo = getElementData(vehicle, "turbo")
    local offroad = getElementData(vehicle, "offroad")
    local handbrakeAdjustment = getElementData(vehicle, "handbrakeAdjustment")
    local rustProtection = getElementData(vehicle, "rustProtection")
    local exhaustSystem = getElementData(vehicle, "exhaustSystem")
    local brakeTrailColor = getElementData(vehicle, "brakeTrailColor")
    local safetyCage = getElementData(vehicle, "safetyCage")
    local hoodScoops = getElementData(vehicle, "hoodScoops")
    local roofScoops = getElementData(vehicle, "roofScoops")
    local wheelCamber = getElementData(vehicle, "wheelCamber")
    local rimSize = getElementData(vehicle, "rimSize")
    local windowColor = getElementData(vehicle, "windowColor")
    local spoiler = getElementData(vehicle, "spoiler")

    -- Przygotowanie zapytania SQL
    local query = "INSERT INTO vehicles (owner, model, engine_type, hp, nm, capacity, cylinders, pistons, camshafts, vMax, engine_type_detail, nitro, stereo, mk, chip_tuning, neons, lamp_color, window_tint, lamp_type, brakes, suspension, bulletproof_windows, bulletproof_tires, armor, gearbox, turbo, offroad, handbrake_adjustment, rust_protection, exhaust_system, brake_trail_color, safety_cage, hood_scoops, roof_scoops, wheel_camber, rim_size, window_color, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

    -- Wykonanie zapytania z danymi gracza i pojazdu
    dbQuery(db, query, getPlayerName(player), getVehicleName(vehicle), engineType, hp, nm, capacity, cylinders, pistons, camshafts, vMax, engineTypeDetail, nitro, stereo, mk, chipTuning, neons, lampColor, windowTint, lampType, brakes, suspension, bulletproofWindows, bulletproofTires, armor, gearbox, turbo, offroad, handbrakeAdjustment, rustProtection, exhaustSystem, brakeTrailColor, safetyCage, hoodScoops, roofScoops, wheelCamber, rimSize, windowColor, price)

    -- Zamykanie zapytania
    dbPoll(dbQuery(db, "SELECT * FROM vehicles"), -1)
end

-- Funkcja do tworzenia pojazdu z dodatkowymi parametrami
function createCustomVehicle(player, command, vehicleModel, engineType, color1, color2, registration, nitro, stereo, mk, chipTuning, neons, lampColor, windowTint, lampType, brakes, suspension, bulletproofWindows, bulletproofTires, armor, gearbox, turbo, offroad, handbrakeAdjustment, rustProtection, exhaustSystem, brakeTrailColor, camshafts, safetyCage, hoodScoops, roofScoops, wheelCamber, rimSize, windowColor, price)
    if not engines[engineType] then
        outputChatBox("Nieznany typ silnika!", player)
        return
    end

    local x, y, z = getElementPosition(player)
    local vehicle = createVehicle(tonumber(vehicleModel), x + 5, y, z)

    if vehicle then
        local engine = engines[engineType]
        local vMax = calculateVMax(engine)
        
        -- Ustawienie parametrów pojazdu
        setVehicleColor(vehicle, tonumber(color1), tonumber(color2))
        setElementData(vehicle, "registration", registration)
        setElementData(vehicle, "engineType", engineType)
        setElementData(vehicle, "hp", engine.hp)
        setElementData(vehicle, "nm", engine.nm)
        setElementData(vehicle, "capacity", engine.capacity)
        setElementData(vehicle, "cylinders", engine.cylinders)
        setElementData(vehicle, "pistons", engine.pistons)
        setElementData(vehicle, "camshafts", camshafts or engine.camshafts)
        setElementData(vehicle, "vMax", vMax)
        setElementData(vehicle, "engineTypeDetail", engine.type)
        setElementData(vehicle, "nitro", nitro)
        setElementData(vehicle, "stereo", stereo)
        setElementData(vehicle, "mk", mk)
        setElementData(vehicle, "chipTuning", chipTuning)
        setElementData(vehicle, "neons", neons)
        setElementData(vehicle, "lampColor", lampColor)
        setElementData(vehicle, "windowTint", windowTint)
        setElementData(vehicle, "lampType", lampType)
        setElementData(vehicle, "brakes", brakes)
        setElementData(vehicle, "suspension", suspension)
        setElementData(vehicle, "bulletproofWindows", bulletproofWindows)
        setElementData(vehicle, "bulletproofTires", bulletproofTires)
        setElementData(vehicle, "armor", armor)
        setElementData(vehicle, "gearbox", gearbox)
        setElementData(vehicle, "turbo", turbo)
        setElementData(vehicle, "offroad", offroad)
        setElementData(vehicle, "handbrakeAdjustment", handbrakeAdjustment)
        setElementData(vehicle, "rustProtection", rustProtection)
        setElementData(vehicle, "exhaustSystem", exhaustSystem)
        setElementData(vehicle, "brakeTrailColor", brakeTrailColor)
        setElementData(vehicle, "safetyCage", safetyCage)
        setElementData(vehicle, "hoodScoops", hoodScoops)
        setElementData(vehicle, "roofScoops", roofScoops)
        setElementData(vehicle, "wheelCamber", wheelCamber)
        setElementData(vehicle, "rimSize", rimSize)
        setElementData(vehicle, "windowColor", windowColor)
        setElementData(vehicle, "price", price)
        setElementData(vehicle, "spoiler", spoiler)

        -- Zapisz pojazd do bazy danych
        saveVehicleToDatabase(player, vehicle, price)

        -- Komunikat potwierdzający tworzenie pojazdu
        outputChatBox("Pojazd został stworzony! V-Max: " .. vMax .. " km/h", player)
    else
        outputChatBox("Nie udało się stworzyć pojazdu.", player)
    end
end

addCommandHandler("createcustomvehicle", createCustomVehicle)
