if not IsDuplicityVersion() then return end

function Bridge.AddMoney(source, account, amount, reason)
    local player = Bridge.GetPlayer(source)
    if player then
        player.AddMoney(account, amount, reason)
        return true
    end
    return false
end

function Bridge.RemoveMoney(source, account, amount, reason)
    local player = Bridge.GetPlayer(source)
    if player then
        player.RemoveMoney(account, amount, reason)
        return true
    end
    return false
end

function Bridge.SetMoney(source, account, amount)
    local player = Bridge.GetPlayer(source)
    if player then
        player.SetMoney(account, amount)
        return true
    end
    return false
end

function Bridge.GetMoney(source, account)
    local player = Bridge.GetPlayer(source)
    if player then
        if account == 'cash' then return player.money end
        if account == 'bank' then return player.bank end
        if account == 'crypto' then return player.crypto end
    end
    return 0
end

exports('AddMoney', Bridge.AddMoney)
exports('RemoveMoney', Bridge.RemoveMoney)
exports('SetMoney', Bridge.SetMoney)
exports('GetMoney', Bridge.GetMoney)

-- Banking Wrappers
function Bridge.AddBankMoney(source, amount, reason)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:AddMoney(source, amount, reason)
    end
    return Bridge.AddMoney(source, 'bank', amount, reason)
end

function Bridge.RemoveBankMoney(source, amount, reason)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:RemoveMoney(source, amount, reason)
    end
    return Bridge.RemoveMoney(source, 'bank', amount, reason)
end

function Bridge.TransferMoney(source, target, amount)
    if GetResourceState('dhs-bankingsim') == 'started' then
        return exports['dhs-bankingsim']:TransferMoney(source, target, amount)
    end

    if Bridge.RemoveBankMoney(source, amount, "Transfer to " .. target) then
        if Bridge.AddBankMoney(target, amount, "Transfer from " .. source) then
            Bridge.CreateTransaction(source, amount, 'withdraw', "Transfer to " .. target)
            Bridge.CreateTransaction(target, amount, 'deposit', "Transfer from " .. source)
            return true
        else
            Bridge.AddBankMoney(source, amount, "Transfer Refund")
        end
    end
    return false
end

function Bridge.CreateTransaction(source, amount, type, reason)
    if GetResourceState('renewed_banking') == 'started' then
        -- exports.renewed_banking:handleTransaction(...)
    elseif GetResourceState('dhs-bankingsim') == 'started' then
        -- dhs handles its own logs usually
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        local cid = Bridge.GetCitizenId(source)
        Bridge.Insert("INSERT INTO bank_statements (citizenid, amount, type, reason) VALUES (?, ?, ?, ?)", {
            cid, amount, type, reason
        })
    end
    return true
end

function Bridge.GetTransactions(source)
    local cid = Bridge.GetCitizenId(source)
    if GetResourceState('renewed_banking') == 'started' then
        -- return exports.renewed_banking:getTransactions(source)
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return Bridge.Query("SELECT * FROM bank_statements WHERE citizenid = ? ORDER BY id DESC LIMIT 10", {cid})
    end
    return {}
end

exports('AddBankMoney', Bridge.AddBankMoney)
exports('RemoveBankMoney', Bridge.RemoveBankMoney)
exports('TransferMoney', Bridge.TransferMoney)
exports('CreateTransaction', Bridge.CreateTransaction)
exports('GetTransactions', Bridge.GetTransactions)
