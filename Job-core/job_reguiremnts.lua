-- job_requirements.lua
local jobRequirements = {
    ["Warehouse"] = {srp = 0, category = nil}
}

function canStartJob(player, jobCode)
    local requirements = jobRequirements[jobCode]
    if requirements then
        local playerSRP = getPlayerSRP(player)
        local playerCategory = getPlayerCategory(player)
        if playerSRP >= requirements.srp and (not requirements.category or requirements.category == playerCategory) then
            return true
        end
    end
    return false
end
