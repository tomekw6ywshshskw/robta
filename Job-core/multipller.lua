-- multiplier.lua
local activeMultipliers = {}

function setMultiplier(admin, multiplier, duration, jobCode)
    if not isAdmin(admin) then return end
    if not jobs[jobCode] then return end

    activeMultipliers[jobCode] = multiplier
    outputChatBox("Zarobki na pracy " .. jobCode .. " przez najbliższe " .. duration .. " minut są mnożone razy " .. multiplier, root, 255, 255, 0)

    setTimer(function()
        activeMultipliers[jobCode] = nil
        outputChatBox("Mnożnik zarobków na pracy " .. jobCode .. " zakończył się.", root, 255, 0, 0)
    end, duration * 60000, 1)
end

function getMultiplier(jobCode)
    return activeMultipliers[jobCode] or 1
end
