if not IsDuplicityVersion() then return end

function Bridge.GetOwnedVehicles(source)
    local identifier = Bridge.GetCitizenId(source)
    if Bridge.Framework == 'esx' then
        return Bridge.Query("SELECT * FROM owned_vehicles WHERE owner = ?", {identifier})
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return Bridge.Query("SELECT * FROM player_vehicles WHERE citizenid = ?", {identifier})
    end
    return {}
end

function Bridge.GiveVehicle(source, vehicle, plate)
    local identifier = Bridge.GetCitizenId(source)
    if Bridge.Framework == 'esx' then
        return Bridge.Insert("INSERT INTO owned_vehicles (owner, vehicle, plate, type, state) VALUES (?, ?, ?, ?, ?)", {
            identifier, json.encode({model = vehicle, plate = plate}), plate, 'car', 1
        })
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return Bridge.Insert("INSERT INTO player_vehicles (citizenid, vehicle, plate, state) VALUES (?, ?, ?, ?)", {
            identifier, vehicle, plate, 1
        })
    end
end

function Bridge.RemoveVehicle(plate)
    if Bridge.Framework == 'esx' then
        return Bridge.Execute("DELETE FROM owned_vehicles WHERE plate = ?", {plate})
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        return Bridge.Execute("DELETE FROM player_vehicles WHERE plate = ?", {plate})
    end
end

function Bridge.PlayerOwnsVehicle(source, plate)
    local identifier = Bridge.GetCitizenId(source)
    local result
    if Bridge.Framework == 'esx' then
        result = Bridge.Single("SELECT 1 FROM owned_vehicles WHERE owner = ? AND plate = ?", {identifier, plate})
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        result = Bridge.Single("SELECT 1 FROM player_vehicles WHERE citizenid = ? AND plate = ?", {identifier, plate})
    end
    return result ~= nil
end

exports('GetOwnedVehicles', Bridge.GetOwnedVehicles)
exports('GiveVehicle', Bridge.GiveVehicle)
exports('RemoveVehicle', Bridge.RemoveVehicle)
exports('PlayerOwnsVehicle', Bridge.PlayerOwnsVehicle)
