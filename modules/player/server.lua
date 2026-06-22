if not IsDuplicityVersion() then return end

local ESX = nil
local QBCore = nil
local Qbox = nil

local function initializeFramework()
    if Bridge.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    elseif Bridge.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Bridge.Framework == 'qbox' then
        Qbox = exports['qbx_core']
    end
end

-- Initialize Framework Objects before IsReady resolves
local initPromise = promise.new()
Citizen.CreateThread(function()
    Bridge.IsReady() -- Wait for detection in init.lua
    initializeFramework()
    initPromise:resolve(true)
end)

function Bridge.GetPlayer(source)
    if not initPromise.value then Citizen.Await(initPromise) end

    if Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return nil end

        local player = {}
        player.source = xPlayer.source
        player.identifier = xPlayer.identifier
        player.firstname = xPlayer.get('firstName') or ""
        player.lastname = xPlayer.get('lastName') or ""
        player.name = xPlayer.getName()
        player.job = xPlayer.job.name
        player.grade = xPlayer.job.grade
        player.money = xPlayer.getAccount('money').money
        player.bank = xPlayer.getAccount('bank').money
        player.crypto = xPlayer.getAccount('crypto') and xPlayer.getAccount('crypto').money or 0
        player.metadata = {}

        if xPlayer.getMeta then
            player.metadata = xPlayer.getMeta() or {}
        end

        return player

    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        local core = (Bridge.Framework == 'qbox') and exports['qbx_core'] or QBCore
        local qPlayer = core:GetPlayer(source)
        if not qPlayer then return nil end

        local player = {}
        player.source = qPlayer.PlayerData.source
        player.identifier = qPlayer.PlayerData.citizenid
        player.firstname = qPlayer.PlayerData.charinfo.firstname
        player.lastname = qPlayer.PlayerData.charinfo.lastname
        player.name = player.firstname .. " " .. player.lastname
        player.job = qPlayer.PlayerData.job.name
        player.grade = qPlayer.PlayerData.job.grade.level
        player.money = qPlayer.PlayerData.money['cash']
        player.bank = qPlayer.PlayerData.money['bank']
        player.crypto = qPlayer.PlayerData.money['crypto'] or 0
        player.metadata = qPlayer.PlayerData.metadata

        return player
    end

    return nil
end

function Bridge.GetJob(source)
    local player = Bridge.GetPlayer(source)
    return player and player.job or nil
end

function Bridge.SetJob(source, job, grade)
    Bridge.IsReady()
    if Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then xPlayer.setJob(job, grade) return true end
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        local core = (Bridge.Framework == 'qbox') and exports['qbx_core'] or QBCore
        local qPlayer = core:GetPlayer(source)
        if qPlayer then qPlayer.Functions.SetJob(job, grade) return true end
    end
    return false
end

exports('GetPlayer', Bridge.GetPlayer)
exports('GetJob', Bridge.GetJob)
exports('SetJob', Bridge.SetJob)
