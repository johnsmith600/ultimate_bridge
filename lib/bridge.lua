Bridge = {}
local ResourceName = GetCurrentResourceName()

if ResourceName == "ultimate_bridge" then
    -- Internal Bridge Logic (will be defined in other files)
else
    -- Client/Server Library for other resources
    local isServer = IsDuplicityVersion()

    function Bridge.GetPlayer(source)
        local player = exports['ultimate_bridge']:GetPlayer(source)
        if not player then return nil end

        -- Re-attach methods because they can't be serialized across exports
        player.AddMoney = function(account, amount, reason)
            return exports['ultimate_bridge']:AddMoney(player.source, account, amount, reason)
        end
        player.RemoveMoney = function(account, amount, reason)
            return exports['ultimate_bridge']:RemoveMoney(player.source, account, amount, reason)
        end
        player.SetMoney = function(account, amount)
            return exports['ultimate_bridge']:SetMoney(player.source, account, amount)
        end
        player.SetJob = function(job, grade)
            return exports['ultimate_bridge']:SetJob(player.source, job, grade)
        end

        return player
    end

    -- Universal Callbacks
    local requestId = 0
    local pendingCallbacks = {}

    if isServer then
        local callbacks = {}
        function Bridge.RegisterCallback(name, cb)
            if GetResourceState('ox_lib') == 'started' then
                exports.ox_lib:callback_register(name, function(source, ...)
                    return cb(source, ...)
                end)
            else
                callbacks[name] = cb
            end
        end

        RegisterNetEvent('ultimate_bridge:server:triggerCallback:' .. ResourceName, function(name, id, ...)
            local src = source
            if callbacks[name] then
                callbacks[name](src, function(...)
                    TriggerClientEvent('ultimate_bridge:client:callbackResponse:' .. ResourceName, src, id, ...)
                end, ...)
            end
        end)
    else
        function Bridge.TriggerCallback(name, cb, ...)
            if GetResourceState('ox_lib') == 'started' then
                exports.ox_lib:callback(name, false, cb, ...)
            else
                requestId = requestId + 1
                pendingCallbacks[requestId] = cb
                TriggerServerEvent('ultimate_bridge:server:triggerCallback:' .. ResourceName, name, requestId, ...)
            end
        end

        RegisterNetEvent('ultimate_bridge:client:callbackResponse:' .. ResourceName, function(id, ...)
            if pendingCallbacks[id] then
                pendingCallbacks[id](...)
                pendingCallbacks[id] = nil
            end
        end)
    end

    -- Universal Commands
    if isServer then
        function Bridge.RegisterCommand(data)
            local framework = exports['ultimate_bridge']:GetFramework()
            if framework == 'esx' then
                exports['es_extended']:getSharedObject().RegisterCommand(data.name, data.permission or 'user', function(xPlayer, args, showError)
                    data.callback(xPlayer.source, args)
                end, true, {help = data.help, arguments = data.arguments})
            elseif framework == 'qb' or framework == 'qbox' then
                exports['qb-core']:GetCoreObject().Commands.Add(data.name, data.help, data.arguments or {}, false, function(source, args)
                    data.callback(source, args)
                end, data.permission or 'user')
            else
                RegisterCommand(data.name, function(source, args)
                    data.callback(source, args)
                end, data.permission == 'admin')
            end
        end
    end

    -- Proxy all other exports
    setmetatable(Bridge, {
        __index = function(t, k)
            return function(...)
                return exports['ultimate_bridge'][k](...)
            end
        end
    })
end
