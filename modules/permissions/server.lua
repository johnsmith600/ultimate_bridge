if not IsDuplicityVersion() then return end

function Bridge.IsAdmin(source)
    Bridge.IsReady()
    if Bridge.Framework == 'esx' then
        local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(source)
        local group = xPlayer.getGroup()
        return group == 'admin' or group == 'superadmin'
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return exports['qb-core']:GetCoreObject().Functions.HasPermission(source, 'admin') or exports['qb-core']:GetCoreObject().Functions.HasPermission(source, 'god')
    end
    return IsPlayerAceAllowed(source, "admin")
end

function Bridge.HasPermission(source, permission)
    Bridge.IsReady()
    -- Check Config mapping first
    local mapping = Config.Permissions[permission]
    if mapping then
        local frameworkMapping = mapping[Bridge.Framework]
        if type(frameworkMapping) == 'table' then
            -- Job/Grade check
            local player = Bridge.GetPlayer(source)
            if player and player.job == frameworkMapping.job and player.grade >= (frameworkMapping.grade or 0) then
                return true
            end
        elseif type(frameworkMapping) == 'string' then
            -- Internal framework permission check
            if Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
                return exports['qb-core']:GetCoreObject().Functions.HasPermission(source, frameworkMapping)
            end
        end
    end

    -- Default to Ace
    if Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        if exports['qb-core']:GetCoreObject().Functions.HasPermission(source, permission) then
            return true
        end
    end
    return IsPlayerAceAllowed(source, permission)
end

function Bridge.IsJob(source, job)
    Bridge.IsReady()
    local player = Bridge.GetPlayer(source)
    if player then
        return player.job == job
    end
    return false
end

function Bridge.GetPlayersByJob(job)
    Bridge.IsReady()
    local players = {}
    if Bridge.Framework == 'esx' then
        local xPlayers = exports['es_extended']:getSharedObject().GetExtendedPlayers('job', job)
        for _, xPlayer in ipairs(xPlayers) do
            table.insert(players, xPlayer.source)
        end
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        local allPlayers = exports['qb-core']:GetCoreObject().Functions.GetQBPlayers()
        for _, v in pairs(allPlayers) do
            if v.PlayerData.job.name == job then
                table.insert(players, v.PlayerData.source)
            end
        end
    end
    return players
end

exports('IsAdmin', Bridge.IsAdmin)
exports('HasPermission', Bridge.HasPermission)
exports('IsJob', Bridge.IsJob)
exports('GetPlayersByJob', Bridge.GetPlayersByJob)
