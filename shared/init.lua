Bridge = {}
Bridge.Framework = nil
Bridge.Inventory = nil
Bridge.NotifySystem = nil -- Renamed to avoid collision
Bridge.Database = nil

local initialized = false
local p = promise.new()

local function debugLog(message)
    if Config.Debug then
        print(("^4[Ultimate Bridge] ^7%s"):format(message))
    end
end

-- Detection functions
local function detectFramework()
    if Config.Framework ~= "auto" then
        Bridge.Framework = Config.Framework
    elseif GetResourceState('qbox') == 'started' or GetResourceState('qbx_core') == 'started' then
        Bridge.Framework = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        Bridge.Framework = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        Bridge.Framework = 'esx'
    else
        Bridge.Framework = 'standalone'
    end
    debugLog("Detected Framework: " .. Bridge.Framework)
end

local function detectInventory()
    if Config.Inventory ~= "auto" then
        Bridge.Inventory = Config.Inventory
    elseif GetResourceState('ox_inventory') == 'started' then
        Bridge.Inventory = 'ox'
    elseif GetResourceState('qb-inventory') == 'started' then
        Bridge.Inventory = 'qb'
    elseif GetResourceState('qs-inventory') == 'started' then
        Bridge.Inventory = 'qs'
    elseif GetResourceState('codem-inventory') == 'started' then
        Bridge.Inventory = 'codem'
    elseif Bridge.Framework == 'esx' then
        Bridge.Inventory = 'esx'
    else
        Bridge.Inventory = 'standalone'
    end
    debugLog("Detected Inventory: " .. Bridge.Inventory)
end

local function detectNotify()
    if Config.Notify ~= "auto" then
        Bridge.NotifySystem = Config.Notify
    elseif GetResourceState('ox_lib') == 'started' then
        Bridge.NotifySystem = 'ox'
    elseif GetResourceState('okokNotify') == 'started' then
        Bridge.NotifySystem = 'okok'
    elseif GetResourceState('mythic_notify') == 'started' then
        Bridge.NotifySystem = 'mythic'
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        Bridge.NotifySystem = 'qb'
    elseif Bridge.Framework == 'esx' then
        Bridge.NotifySystem = 'esx'
    else
        Bridge.NotifySystem = 'standalone'
    end
    debugLog("Detected Notify: " .. Bridge.NotifySystem)
end

local function detectDatabase()
    if IsDuplicityVersion() then
        if Config.Database ~= "auto" then
            Bridge.Database = Config.Database
        elseif GetResourceState('oxmysql') == 'started' then
            Bridge.Database = 'oxmysql'
        elseif GetResourceState('mysql-async') == 'started' then
            Bridge.Database = 'mysql-async'
        elseif GetResourceState('ghmattimysql') == 'started' then
            Bridge.Database = 'ghmattimysql'
        end
        debugLog("Detected Database: " .. (Bridge.Database or "none"))
    end
end

function Bridge.IsReady()
    if not initialized then
        Citizen.Await(p)
    end
    return true
end

-- Initialize
Citizen.CreateThread(function()
    detectFramework()
    detectInventory()
    detectNotify()
    detectDatabase()
    initialized = true
    p:resolve(true)
end)

-- Helper for exports
exports('GetFramework', function()
    Bridge.IsReady()
    return Bridge.Framework
end)
exports('GetInventory', function()
    Bridge.IsReady()
    return Bridge.Inventory
end)
exports('GetNotify', function()
    Bridge.IsReady()
    return Bridge.NotifySystem
end)
