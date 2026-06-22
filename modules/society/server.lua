if not IsDuplicityVersion() then return end

function Bridge.GetSocietyMoney(job)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:GetSocietyMoney(job)
    elseif GetResourceState('renewed_banking') == 'started' then
        return exports.renewed_banking:getAccountMoney(job)
    elseif GetResourceState('qb-management') == 'started' then
        return exports['qb-management']:GetAccount(job)
    elseif Bridge.Framework == 'esx' then
        local p = promise.new()
        TriggerEvent('esx_society:getSocietyMoney', job, function(money)
            p:resolve(money)
        end)
        return Citizen.Await(p)
    end
    return 0
end

function Bridge.AddSocietyMoney(job, amount)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:AddSocietyMoney(job, amount)
    elseif GetResourceState('renewed_banking') == 'started' then
        return exports.renewed_banking:addAccountMoney(job, amount)
    elseif GetResourceState('qb-management') == 'started' then
        return exports['qb-management']:AddMoney(job, amount)
    elseif Bridge.Framework == 'esx' then
        TriggerEvent('esx_society:addMoney', job, amount)
        return true
    end
    return false
end

function Bridge.RemoveSocietyMoney(job, amount)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:RemoveSocietyMoney(job, amount)
    elseif GetResourceState('renewed_banking') == 'started' then
        return exports.renewed_banking:removeAccountMoney(job, amount)
    elseif GetResourceState('qb-management') == 'started' then
        return exports['qb-management']:RemoveMoney(job, amount)
    elseif Bridge.Framework == 'esx' then
        TriggerEvent('esx_society:removeMoney', job, amount)
        return true
    end
    return false
end

exports('GetSocietyMoney', Bridge.GetSocietyMoney)
exports('AddSocietyMoney', Bridge.AddSocietyMoney)
exports('RemoveSocietyMoney', Bridge.RemoveSocietyMoney)
