-- vehicles.lua
local vehicleCategories = {
    ["category_a"] = {468, 521, 586}, -- Example vehicle IDs for motorcycles
    ["category_b"] = {402, 411, 415}, -- Example vehicle IDs for cars
    ["category_c"] = {414, 431, 437}, -- Example vehicle IDs for delivery vehicles and buses
    ["category_c+e"] = {403, 406, 407} -- Example vehicle IDs for trucks
}

function getVehicleCategory(vehicleID)
    for category, vehicles in pairs(vehicleCategories) do
        for _, id in ipairs(vehicles) do
            if id == vehicleID then
                return category
            end
        end
    end
    return nil
end
