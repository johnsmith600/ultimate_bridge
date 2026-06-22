if not IsDuplicityVersion() then return end

function Bridge.AddItem(source, item, amount, metadata)
    Bridge.IsReady()
    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:AddItem(source, item, amount, metadata)
    elseif Bridge.Inventory == 'qb' then
        local Player = exports['qb-core']:GetPlayer(source)
        return Player.Functions.AddItem(item, amount, false, metadata)
    elseif Bridge.Inventory == 'qs' then
        return exports['qs-inventory']:AddItem(source, item, amount, metadata)
    elseif Bridge.Inventory == 'codem' then
        return exports['codem-inventory']:AddItem(source, item, amount, metadata)
    elseif Bridge.Inventory == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, amount)
        return true
    end
    return false
end

function Bridge.RemoveItem(source, item, amount, metadata)
    Bridge.IsReady()
    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:RemoveItem(source, item, amount, metadata)
    elseif Bridge.Inventory == 'qb' then
        local Player = exports['qb-core']:GetPlayer(source)
        return Player.Functions.RemoveItem(item, amount)
    elseif Bridge.Inventory == 'qs' then
        return exports['qs-inventory']:RemoveItem(source, item, amount)
    elseif Bridge.Inventory == 'codem' then
        return exports['codem-inventory']:RemoveItem(source, item, amount)
    elseif Bridge.Inventory == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, amount)
        return true
    end
    return false
end

function Bridge.HasItem(source, item, amount)
    Bridge.IsReady()
    amount = amount or 1
    if Bridge.Inventory == 'ox' then
        local count = exports.ox_inventory:GetItemCount(source, item)
        return count >= amount
    elseif Bridge.Inventory == 'qb' then
        local Player = exports['qb-core']:GetPlayer(source)
        local itemData = Player.Functions.GetItemByName(item)
        return itemData and itemData.amount >= amount
    elseif Bridge.Inventory == 'qs' then
        return exports['qs-inventory']:GetItemTotalAmount(source, item) >= amount
    elseif Bridge.Inventory == 'codem' then
        -- Codem usually has a similar check
        return true
    elseif Bridge.Inventory == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        local xItem = xPlayer.getInventoryItem(item)
        return xItem and xItem.count >= amount
    end
    return false
end

function Bridge.GetItem(source, item)
    Bridge.IsReady()
    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:GetItem(source, item, nil, false)
    elseif Bridge.Inventory == 'qb' then
        local Player = exports['qb-core']:GetPlayer(source)
        return Player.Functions.GetItemByName(item)
    elseif Bridge.Inventory == 'qs' then
        return exports['qs-inventory']:GetItem(source, item)
    elseif Bridge.Inventory == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item)
    end
    return nil
end

function Bridge.CanCarryItem(source, item, amount)
    Bridge.IsReady()
    if Bridge.Inventory == 'ox' then
        return exports.ox_inventory:CanCarryItem(source, item, amount)
    elseif Bridge.Inventory == 'qb' then
        local Player = exports['qb-core']:GetPlayer(source)
        local itemData = exports['qb-core']:GetCoreObject().Shared.Items[item]
        if not itemData then return true end
        local totalWeight = exports['qb-inventory']:GetTotalWeight(Player.PlayerData.items)
        local maxWeight = Player.PlayerData.maxweight or 120000
        return (totalWeight + (itemData.weight * amount)) <= maxWeight
    elseif Bridge.Inventory == 'qs' then
        return exports['qs-inventory']:CanCarryItem(source, item, amount)
    elseif Bridge.Inventory == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        return xPlayer.canCarryItem(item, amount)
    end
    return true
end

exports('AddItem', Bridge.AddItem)
exports('RemoveItem', Bridge.RemoveItem)
exports('HasItem', Bridge.HasItem)
exports('GetItem', Bridge.GetItem)
exports('CanCarryItem', Bridge.CanCarryItem)
