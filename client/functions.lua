function LegacyLib.Functions.Notify(message, type, duration)
    local notifSystem = LegacyConfig.General_Customization.Notification_System
    duration = duration or 5000

    if notifSystem == 1 and QBCore then
        QBCore.Functions.Notify(message, type, duration)
    elseif notifSystem == 2 and ESX then
        ESX.ShowNotification(message, type, false, duration)
    elseif notifSystem == 3 and OX then
        exports.ox_lib:notify({ description = message, type = type, duration = duration })
    elseif notifSystem == 4 then
        -- Custom notification system
        print("[LegacyLib] Custom Notify: " .. message)
    else
        print("[LegacyLib] Notify: " .. message)
    end
end