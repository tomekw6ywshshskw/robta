-- server.lua
addEventHandler("onResourceStart", resourceRoot, function()
    -- Include all modules
    dofile("vehicles.lua")
    dofile("jobs.lua")
    dofile("job_requirements.lua")
    dofile("multiplier.lua")
end)

local adminSerials = {
    "serial1",
    "serial2" -- Add the serials of admins here
}

function isAdmin(player)
    local serial = getPlayerSerial(player)
    for _, s in ipairs(adminSerials) do
        if s == serial then
            return true
        end
    end
    return false
end

function getPlayerSRP(player)
    return getElementData(player, "srp") or 0
end

function getPlayerCategory(player)
    return getElementData(player, "license_category") or nil
end

function setPlayerMoney(player, amount)
    setElementData(player, "money", amount)
end

function setPlayerSRP(player, amount)
    setElementData(player, "srp", amount)
end

function calculatePay(jobCode, basePay)
    local multiplier = getMultiplier(jobCode)
    return basePay * multiplier
end

function payPlayerForJob(player, jobCode)
    local jobPay = getJobPay(jobCode, "pln")
    local jobSRP = getJobPay(jobCode, "srp")
    
    local newMoney = (getElementData(player, "money") or 0) + calculatePay(jobCode, jobPay)
    local newSRP = (getElementData(player, "srp") or 0) + jobSRP

    setPlayerMoney(player, newMoney)
    setPlayerSRP(player, newSRP)
    
    triggerClientEvent(player, "onJobPayNotification", resourceRoot, "You have been paid " .. calculatePay(jobCode, jobPay) .. " PLN and earned " .. jobSRP .. " SRP for your job.")
end

addEvent("onPlayerRequestStartJob", true)
addEventHandler("onPlayerRequestStartJob", resourceRoot, function(jobCode)
    local player = client
    if canStartJob(player, jobCode) then
        -- Simulate job completion and pay the player
        payPlayerForJob(player, jobCode)
    else
        triggerClientEvent(player, "onJobPayNotification", resourceRoot, "You do not meet the requirements for this job.")
    end
end)

addCommandHandler("mnoznik", function(player, cmd, multiplier, duration, jobCode)
    if not isAdmin(player) then return end
    setMultiplier(player, tonumber(multiplier), tonumber(duration), jobCode)
end)
