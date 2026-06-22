function Bridge.RegisterNetEvent(name, cb)
    RegisterNetEvent(name, cb)
end

function Bridge.TriggerClient(name, target, ...)
    TriggerClientEvent(name, target, ...)
end

function Bridge.TriggerServer(name, ...)
    TriggerServerEvent(name, ...)
end

function Bridge.TriggerAll(name, ...)
    TriggerClientEvent(name, -1, ...)
end

exports('RegisterNetEvent', Bridge.RegisterNetEvent)
exports('TriggerClient', Bridge.TriggerClient)
exports('TriggerServer', Bridge.TriggerServer)
exports('TriggerAll', Bridge.TriggerAll)
