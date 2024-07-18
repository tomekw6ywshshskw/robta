-- Zarobki
local zarobki = {
    { kod = "Warehouse_PLN", wartosc = 5 },
    { kod = "Warehouse_SRP", wartosc = 3 }
}

-- Kody pracy
local kodyPracy = {
    { nazwa = "Warehouse", kod = "Warehouse" },
}

-- Wymagania pracy
local jobRequirements = {
    { job = "Warehouse", srpRequired = 0, categoryRequired = nil }
}

-- Ulepszenia
local upgrades = {
    { name = "Lepsza kasa", cost = 10, description = "Zarabiasz więcej o 10%", effect = function(player) 
        -- Kod zwiększający zarobek o 10%
    end },
    { name = "Szybsza praca", cost = 15, description = "Pracujesz szybciej o 20%", effect = function(player)
        -- Kod zwiększający szybkość pracy o 20%
    end }
}

-- Expose data
function getJobData()
    return { zarobki = zarobki, kodyPracy = kodyPracy, jobRequirements = jobRequirements, upgrades = upgrades }
end
