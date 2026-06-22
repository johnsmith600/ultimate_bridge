if not IsDuplicityVersion() then return end

function Bridge.GetIdentifier(source)
    return GetPlayerIdentifier(source, 0)
end

function Bridge.GetCitizenId(source)
    local player = Bridge.GetPlayer(source)
    if player then
        return player.identifier
    end
    return nil
end

function Bridge.GetLicense(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, string.len("license:")) == "license:" then
            return id
        end
    end
    return nil
end

function Bridge.GetDiscord(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, string.len("discord:")) == "discord:" then
            return id
        end
    end
    return nil
end

function Bridge.GetSteam(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            return id
        end
    end
    return nil
end

exports('GetIdentifier', Bridge.GetIdentifier)
exports('GetCitizenId', Bridge.GetCitizenId)
exports('GetLicense', Bridge.GetLicense)
exports('GetDiscord', Bridge.GetDiscord)
exports('GetSteam', Bridge.GetSteam)
