---@diagnostic disable: duplicate-set-field
local function debugLog(message)
    if Config.Debug then
        print(("^4[Ultimate Bridge - Database] ^7%s"):format(message))
    end
end

local function getDBHandler()
    if Bridge.Database == "oxmysql" then
        return exports.oxmysql
    elseif Bridge.Database == "mysql-async" then
        return exports['mysql-async']
    elseif Bridge.Database == "ghmattimysql" then
        return exports.ghmattimysql
    end
    return nil
end

function Bridge.Query(query, params)
    Bridge.IsReady()
    local db = getDBHandler()
    if not db then return end

    if Bridge.Database == "oxmysql" then
        return exports.oxmysql:query_await(query, params)
    elseif Bridge.Database == "mysql-async" then
        local p = promise.new()
        db:mysql_fetch_all(query, params, function(result)
            p:resolve(result)
        end)
        return Citizen.Await(p)
    elseif Bridge.Database == "ghmattimysql" then
        local p = promise.new()
        db:execute(query, params, function(result)
            p:resolve(result)
        end)
        return Citizen.Await(p)
    end
end

function Bridge.Single(query, params)
    Bridge.IsReady()
    if Bridge.Database == "oxmysql" then
        return exports.oxmysql:single_await(query, params)
    else
        local result = Bridge.Query(query, params)
        return result and result[1] or nil
    end
end

function Bridge.Insert(query, params)
    Bridge.IsReady()
    local db = getDBHandler()
    if not db then return end

    if Bridge.Database == "oxmysql" then
        return exports.oxmysql:insert_await(query, params)
    elseif Bridge.Database == "mysql-async" then
        local p = promise.new()
        db:mysql_insert(query, params, function(id)
            p:resolve(id)
        end)
        return Citizen.Await(p)
    elseif Bridge.Database == "ghmattimysql" then
        local p = promise.new()
        db:execute(query, params, function(result)
            p:resolve(result.insertId)
        end)
        return Citizen.Await(p)
    end
end

function Bridge.Update(query, params)
    Bridge.IsReady()
    local db = getDBHandler()
    if not db then return end

    if Bridge.Database == "oxmysql" then
        return exports.oxmysql:update_await(query, params)
    elseif Bridge.Database == "mysql-async" then
        local p = promise.new()
        db:mysql_execute(query, params, function(affectedRows)
            p:resolve(affectedRows)
        end)
        return Citizen.Await(p)
    elseif Bridge.Database == "ghmattimysql" then
        local p = promise.new()
        db:execute(query, params, function(result)
            p:resolve(result.affectedRows)
        end)
        return Citizen.Await(p)
    end
end

function Bridge.Execute(query, params)
    return Bridge.Update(query, params)
end

function Bridge.Transaction(queries, params)
    Bridge.IsReady()
    if Bridge.Database == "oxmysql" then
        return exports.oxmysql:transaction_await(queries, params)
    end
    return false
end

-- Exports
exports('Query', Bridge.Query)
exports('Single', Bridge.Single)
exports('Insert', Bridge.Insert)
exports('Update', Bridge.Update)
exports('Execute', Bridge.Execute)
exports('Transaction', Bridge.Transaction)
