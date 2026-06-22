if not IsDuplicityVersion() then return end

function Bridge.Log(level, category, message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = ("[%s] [%s] [%s]: %s"):format(timestamp, level:upper(), category:upper(), message)

    -- Console Log
    print(logMessage)

    -- Discord Log
    local webhook = Webhooks[category] or Webhooks['default']
    if webhook and webhook ~= "" then
        local connect = {
            {
                ["color"] = 3447003,
                ["title"] = "Ultimate Bridge Log",
                ["description"] = logMessage,
                ["footer"] = {
                    ["text"] = "Ultimate Bridge",
                },
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Bridge Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end

exports('Log', Bridge.Log)
