-- jobs.lua
local jobs = {
    ["Warehouse"] = {pln = 5, srp = 3}
}

function getJobPay(jobCode, payType)
    if jobs[jobCode] and jobs[jobCode][payType] then
        return jobs[jobCode][payType]
    end
    return 0
end
