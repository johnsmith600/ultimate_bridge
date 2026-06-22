fx_version 'cerulean'
game 'gta5'

author 'johnsmith600'
description 'Ultimate Framework Bridge (ESX / QBCore / Qbox)'
version '1.0.0'

lua54 'yes'

shared_scripts {
    'config.lua',
    'lib/bridge.lua',
    'shared/types.lua',
    'shared/init.lua',
    'shared/events.lua',
    'callbacks/shared.lua',
    'modules/notify/shared.lua',
    'integrations/phone.lua',
}

client_scripts {
    'modules/ui/client.lua',
}

server_scripts {
    'server/secrets.lua',
    'server/webhook.lua',
    'database/server.lua',
    'commands/server.lua',
    'modules/player/server.lua',
    'modules/identity/server.lua',
    'modules/money/server.lua',
    'modules/society/server.lua',
    'modules/inventory/server.lua',
    'modules/vehicles/server.lua',
    'modules/permissions/server.lua',
}

exports {
    'GetFramework',
    'GetPlayer',
    'AddMoney',
    'RemoveMoney',
    'SetMoney',
    'GetMoney',
    'AddItem',
    'RemoveItem',
    'HasItem',
    'GetItem',
    'CanCarryItem',
    'GetJob',
    'SetJob',
    'IsJob',
    'GetPlayersByJob',
    'Notify',
    'IsAdmin',
    'HasPermission',
    'GetIdentifier',
    'GetCitizenId',
    'GetLicense',
    'GetDiscord',
    'GetSteam',
    'GetOwnedVehicles',
    'GiveVehicle',
    'RemoveVehicle',
    'PlayerOwnsVehicle',
    'AddBankMoney',
    'RemoveBankMoney',
    'TransferMoney',
    'CreateTransaction',
    'GetTransactions',
    'GetSocietyMoney',
    'AddSocietyMoney',
    'RemoveSocietyMoney',
    'RegisterCallback',
    'TriggerCallback',
    'RegisterCommand',
    'RegisterNetEvent',
    'TriggerClient',
    'TriggerServer',
    'TriggerAll',
    'Query',
    'Single',
    'Insert',
    'Update',
    'Execute',
    'Transaction',
    'Log',
    'ProgressBar',
    'InputDialog',
    'ContextMenu',
    'Alert',
    'TextUI',
    'HideTextUI',
    'PlayAnimation',
    'LoadModel',
    'SpawnVehicle',
    'DeleteVehicle',
    'Teleport',
    'RequestControl',
    'PhoneNotify'
}
