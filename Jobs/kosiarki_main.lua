-- Definicje ulepszeń
local upgrades = {
    ["MowerSpeedBoost"] = { name = "Silniejszy Silnik", description = "Zwiększa prędkość kosiarki o 20%.", jobPointsCost = 50 },
    ["MowerFuelTank"] = { name = "Większy Zbiornik na Paliwo", description = "Zwiększa pojemność zbiornika na paliwo.", jobPointsCost = 30 }
}

-- Dodatkowe punkty pracy (job points)
local jobPoints = {
    ["player:jobPoints"] = 0,  -- Inicjalizacja punktów pracy dla gracza
}

-- Funkcja dodająca punkty pracy
function addJobPoints(player, amount)
    local currentPoints = getElementData(player, "player:jobPoints") or 0
    setElementData(player, "player:jobPoints", currentPoints + amount)
end

-- Funkcja kupująca ulepszenie
function buyUpgrade(player, upgradeCode)
    local upgrade = upgrades[upgradeCode]
    if upgrade then
        local cost = upgrade.jobPointsCost
        if jobPoints["player:jobPoints"] >= cost then
            jobPoints["player:jobPoints"] = jobPoints["player:jobPoints"] - cost
            -- Dodaj efekt ulepszenia do kosiarki
            applyUpgradeToMower(player, upgradeCode)
            outputChatBox("Zakupiono ulepszenie: " .. upgrade.name, player, 0, 255, 0)
        else
            outputChatBox("Nie masz wystarczająco punktów pracy, aby kupić to ulepszenie!", player, 255, 0, 0)
        end
    else
        outputChatBox("Nieprawidłowy kod ulepszenia!", player, 255, 0, 0)
    end
end

-- Funkcja aplikująca efekt ulepszenia do kosiarki
function applyUpgradeToMower(player, upgradeCode)
    -- Tutaj dodaj logikę aplikacji ulepszenia do kosiarki
end

-- Event odbierania wypłaty z pracy
addEvent("onMowingJobFinish", true)
addEventHandler("onMowingJobFinish", resourceRoot, function(progress)
    local player = client
    local basePay = 50 -- bazowa stawka za skoszenie trawnika
    local bonus = (progress / 100) * basePay
    local totalPay = basePay + bonus
    local jobPointsEarned = math.floor(bonus / 10)
    
    setElementData(player, "player:money", getElementData(player, "player:money") + totalPay)
    addJobPoints(player, jobPointsEarned)
    
    outputChatBox("Skosiłeś trawnik i zarobiłeś " .. totalPay .. " PLN oraz " .. jobPointsEarned .. " punktów pracy!", player, 0, 255)
end)
