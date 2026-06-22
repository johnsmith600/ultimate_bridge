if IsDuplicityVersion() then return end

local function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function Bridge.ProgressBar(label, duration, options)
    if GetResourceState('ox_lib') == 'started' then
        return exports.ox_lib:progressBar({
            duration = duration,
            label = label,
            useWhileDead = options and options.useWhileDead or false,
            canCancel = options and options.canCancel or true,
            disable = options and options.disable or {},
            anim = options and options.anim or {},
            prop = options and options.prop or {},
        })
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        local p = promise.new()
        exports['progressbar']:Progress({
            name = "bridge_progress",
            duration = duration,
            label = label,
            useWhileDead = options and options.useWhileDead or false,
            canCancel = options and options.canCancel or true,
            controlDisables = options and options.disable or {},
            animation = options and options.anim or {},
            prop = options and options.prop or {},
        }, function(cancelled)
            p:resolve(not cancelled)
        end)
        return Citizen.Await(p)
    else
        -- Native Fallback UI
        local start = GetGameTimer()
        local finished = false
        Citizen.CreateThread(function()
            while GetGameTimer() - start < duration do
                Citizen.Wait(0)
                DrawRect(0.5, 0.9, 0.2, 0.05, 0, 0, 0, 150)
                local progress = (GetGameTimer() - start) / duration
                DrawRect(0.5 - (0.2 * (1 - progress) / 2), 0.9, 0.2 * progress, 0.05, 0, 200, 0, 200)

                SetTextFont(0)
                SetTextScale(0.35, 0.35)
                SetTextColour(255, 255, 255, 255)
                SetTextCentre(true)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName(label)
                EndTextCommandDisplayText(0.5, 0.88)

                if IsControlJustPressed(0, 73) and options and options.canCancel then -- X to cancel
                    finished = "cancelled"
                    break
                end
            end
            finished = finished or true
        end)
        while finished == false do Citizen.Wait(0) end
        return finished == true
    end
end

function Bridge.InputDialog(header, inputs)
    if GetResourceState('ox_lib') == 'started' then
        return exports.ox_lib:inputDialog(header, inputs)
    end

    -- Native Fallback (Simple one input for now)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        return { GetOnscreenKeyboardResult() }
    end
    return nil
end

function Bridge.ContextMenu(data)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:registerContext(data)
        exports.ox_lib:showContext(data.id)
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        exports['qb-menu']:openMenu(data)
    end
end

function Bridge.TextUI(text, type)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:showTextUI(text, {type = type})
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        exports['qb-core']:DrawText(text, 'left')
    else
        Citizen.CreateThread(function()
            Bridge.TextUIActive = true
            while Bridge.TextUIActive do
                Citizen.Wait(0)
                ShowHelpNotification(text)
            end
        end)
    end
end

function Bridge.HideTextUI()
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:hideTextUI()
    elseif Bridge.Framework == 'qb' or Bridge.Framework == 'qbox' then
        exports['qb-core']:HideText()
    else
        Bridge.TextUIActive = false
    end
end

function Bridge.Alert(title, content, type)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:alertDialog({header = title, content = content})
    else
        Bridge.Notify(nil, content, type)
    end
end

-- Animation, Vehicle, etc helpers
function Bridge.PlayAnimation(dict, name, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    TaskPlayAnim(PlayerPedId(), dict, name, 8.0, -8.0, -1, flag or 49, 0, false, false, false)
end

function Bridge.LoadModel(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    return true
end

function Bridge.SpawnVehicle(model, coords, networked)
    if Bridge.LoadModel(model) then
        local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w or 0.0, networked ~= nil and networked or true, false)
        SetEntityAsMissionEntity(veh, true, true)
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehRadioStation(veh, 'OFF')
        return veh
    end
    return nil
end

function Bridge.DeleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, false, true)
    DeleteVehicle(vehicle)
end

function Bridge.Teleport(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    if coords.w then
        SetEntityHeading(ped, coords.w)
    end
end

function Bridge.RequestControl(entity)
    local timeout = 1000
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and timeout > 0 do
        Citizen.Wait(10)
        timeout = timeout - 10
    end
    return NetworkHasControlOfEntity(entity)
end

exports('ProgressBar', Bridge.ProgressBar)
exports('InputDialog', Bridge.InputDialog)
exports('ContextMenu', Bridge.ContextMenu)
exports('Alert', Bridge.Alert)
exports('TextUI', Bridge.TextUI)
exports('HideTextUI', Bridge.HideTextUI)
exports('PlayAnimation', Bridge.PlayAnimation)
exports('LoadModel', Bridge.LoadModel)
exports('SpawnVehicle', Bridge.SpawnVehicle)
exports('DeleteVehicle', Bridge.DeleteVehicle)
exports('Teleport', Bridge.Teleport)
exports('RequestControl', Bridge.RequestControl)
