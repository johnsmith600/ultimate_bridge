local callbacks = {}
local requestId = 0

if IsDuplicityVersion() then
    function Bridge.RegisterCallback(name, cb)
        Bridge.IsReady()
        if Bridge.NotifySystem == 'ox' or GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:callback_register(name, function(source, ...)
                return cb(source, ...)
            end)
        else
            callbacks[name] = cb
        end
    end

    RegisterNetEvent('ultimate_bridge:server:triggerCallback', function(name, id, ...)
        local src = source
        if callbacks[name] then
            callbacks[name](src, function(...)
                TriggerClientEvent('ultimate_bridge:client:callbackResponse', src, id, ...)
            end, ...)
        end
    end)

    exports('RegisterCallback', Bridge.RegisterCallback)
else
    local pendingCallbacks = {}

    function Bridge.TriggerCallback(name, cb, ...)
        Bridge.IsReady()
        if Bridge.NotifySystem == 'ox' or GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:callback(name, false, cb, ...)
        else
            requestId = requestId + 1
            pendingCallbacks[requestId] = cb
            TriggerServerEvent('ultimate_bridge:server:triggerCallback', name, requestId, ...)
        end
    end

    RegisterNetEvent('ultimate_bridge:client:callbackResponse', function(id, ...)
        if pendingCallbacks[id] then
            pendingCallbacks[id](...)
            pendingCallbacks[id] = nil
        end
    end)

    exports('TriggerCallback', Bridge.TriggerCallback)
end
