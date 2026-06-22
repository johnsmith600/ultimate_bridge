function Bridge.PhoneNotify(source, data)
    if GetResourceState('17movement_phone') == 'started' then
        if IsDuplicityVersion() then
            exports['17movement_phone']:SendNotification(source, data)
        else
            exports['17movement_phone']:SendNotification(data)
        end
    elseif GetResourceState('lb-phone') == 'started' then
        exports['lb-phone']:SendNotification(source, data)
    elseif GetResourceState('qs-smartphone') == 'started' then
        exports['qs-smartphone']:SendNotification(source, data)
    end
end

exports('PhoneNotify', Bridge.PhoneNotify)
