if not IsDuplicityVersion() then return end

function Bridge.RegisterCommand(data)
    if Bridge.Framework == 'esx' then
        exports['es_extended']:getSharedObject().RegisterCommand(data.name, data.permission or 'user', function(xPlayer, args, showError)
            data.callback(xPlayer.source, args)
        end, true, {help = data.help, arguments = data.arguments})
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        exports['qb-core']:GetCoreObject().Commands.Add(data.name, data.help, data.arguments or {}, false, function(source, args)
            data.callback(source, args)
        end, data.permission or 'user')
    else
        RegisterCommand(data.name, function(source, args)
            data.callback(source, args)
        end, data.permission == 'admin')
    end
end

exports('RegisterCommand', Bridge.RegisterCommand)
