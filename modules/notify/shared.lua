function Bridge.Notify(source, text, type, duration)
    Bridge.IsReady()
    if IsDuplicityVersion() then
        if Bridge.NotifySystem == 'ox' then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Notification', description = text, type = type})
        elseif Bridge.NotifySystem == 'okok' then
            TriggerClientEvent('okokNotify:Alert', source, 'Notification', text, duration or 5000, type)
        elseif Bridge.NotifySystem == 'mythic' then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = type, text = text, length = duration})
        elseif Bridge.NotifySystem == 'qb' then
            TriggerClientEvent('QBCore:Notify', source, text, type, duration)
        elseif Bridge.NotifySystem == 'esx' then
            TriggerClientEvent('esx:showNotification', source, text)
        else
            -- Fallback
            TriggerClientEvent('ultimate_bridge:client:Notify', source, text, type, duration)
        end
    else
        -- Client side
        if Bridge.NotifySystem == 'ox' then
            exports.ox_lib:notify({title = 'Notification', description = text, type = type})
        elseif Bridge.NotifySystem == 'okok' then
            exports.okokNotify:Alert('Notification', text, duration or 5000, type)
        elseif Bridge.NotifySystem == 'mythic' then
            exports.mythic_notify:SendAlert({type = type, text = text, length = duration})
        elseif Bridge.NotifySystem == 'qb' then
            exports['qb-core']:GetCoreObject().Functions.Notify(text, type, duration)
        elseif Bridge.NotifySystem == 'esx' then
            exports['es_extended']:getSharedObject().ShowNotification(text)
        else
            -- Custom Fallback
            SetNotificationTextEntry("STRING")
            AddTextComponentString(text)
            DrawNotification(false, false)
        end
    end
end

if not IsDuplicityVersion() then
    RegisterNetEvent('ultimate_bridge:client:Notify', function(text, type, duration)
        Bridge.Notify(nil, text, type, duration)
    end)
end

exports('Notify', Bridge.Notify)
