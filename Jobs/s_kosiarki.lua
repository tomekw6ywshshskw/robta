addEvent("onMowingJobFinish", true)
addEventHandler("onMowingJobFinish", resourceRoot, function(progress)
    local player = client
    local basePay = 50 -- bazowa stawka za skoszenie trawnika
    local bonus = (progress / 100) * basePay
    local totalPay = basePay + bonus
    local jobPoints = math.floor(bonus / 10)
    
    setElementData(player, "player:money", getElementData(player, "player:money") + totalPay)
    setElementData(player, "player:jobPoints", getElementData(player, "player:jobPoints") + jobPoints)
    
    outputChatBox("Skosiłeś trawnik i zarobiłeś " .. totalPay .. " PLN!", player, 0, 255)
end)
