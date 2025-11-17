print("Loading server/functions.lua")

function LegacyLib.Functions.IsAdmin(playerId)
    local isAdmin = false

    if LegacyConfig.Framework:lower() == 'qb-core' and QBCore then
        local player = QBCore.Functions.GetPlayer(playerId)
        if player then
            for _, group in ipairs(LegacyConfig.AdminGroups.qbcore) do
                if QBCore.Functions.HasPermission(playerId, group) then
                    isAdmin = true
                    break
                end
            end
        end
    elseif LegacyConfig.Framework:lower() == 'qbox' and QBOX then
        local player = QBOX.Functions.GetPlayer(playerId)
        if player then
            for _, group in ipairs(LegacyConfig.AdminGroups.qbox) do
                if QBOX.Functions.HasPermission(playerId, group) then
                    isAdmin = true
                    break
                end
            end
        end
    elseif LegacyConfig.Framework:lower() == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            for _, group in ipairs(LegacyConfig.AdminGroups.esx) do
                if xPlayer.getGroup() == group then
                    isAdmin = true
                    break
                end
            end
        end
    elseif LegacyConfig.Framework:lower() == 'ox' and OX then
        local player = OX.GetPlayer(playerId)
        if player then
            for _, group in ipairs(LegacyConfig.AdminGroups.ox) do
                if player:hasGroup(group) then
                    isAdmin = true
                    break
                end
            end
        end
    end

    return isAdmin
end

-- New functions for legacy-reports compatibility
function LegacyLib.Functions.GetPlayer(source)
    if LegacyConfig.Framework:lower() == 'qb-core' and QBCore then
        return QBCore.Functions.GetPlayer(source)
    elseif LegacyConfig.Framework:lower() == 'qbox' and QBOX then
        return QBOX.Functions.GetPlayer(source)
    elseif LegacyConfig.Framework:lower() == 'esx' and ESX then
        return ESX.GetPlayerFromId(source)
    elseif LegacyConfig.Framework:lower() == 'ox' and OX then
        return OX.GetPlayer(source)
    end
    return nil
end

function LegacyLib.Functions.GetPlayerName(source)
    local player = LegacyLib.Functions.GetPlayer(source)
    if not player then return 'Unknown' end
    
    if LegacyConfig.Framework:lower() == 'qb-core' then
        return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
    elseif LegacyConfig.Framework:lower() == 'qbox' then
        return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
    elseif LegacyConfig.Framework:lower() == 'esx' then
        return player.getName()
    elseif LegacyConfig.Framework:lower() == 'ox' then
        return player.name or 'Unknown'
    end
    
    return 'Unknown'
end

function LegacyLib.Functions.GetPlayerIdentifier(source)
    local player = LegacyLib.Functions.GetPlayer(source)
    if not player then return nil end
    
    if LegacyConfig.Framework:lower() == 'qb-core' then
        return player.PlayerData.citizenid
    elseif LegacyConfig.Framework:lower() == 'qbox' then
        return player.PlayerData.citizenid
    elseif LegacyConfig.Framework:lower() == 'esx' then
        return player.identifier
    elseif LegacyConfig.Framework:lower() == 'ox' then
        return player.charId
    end
    
    return nil
end

function LegacyLib.Functions.GetPlayers()
    if LegacyConfig.Framework:lower() == 'qb-core' and QBCore then
        return QBCore.Functions.GetQBPlayers()
    elseif LegacyConfig.Framework:lower() == 'qbox' and QBOX then
        return QBOX.Functions.GetPlayers()
    elseif LegacyConfig.Framework:lower() == 'esx' and ESX then
        return ESX.GetPlayers()
    elseif LegacyConfig.Framework:lower() == 'ox' and OX then
        return OX.GetPlayers()
    end
    return {}
end

function LegacyLib.Functions.GetPlayerByCitizenId(citizenid)
    if LegacyConfig.Framework:lower() == 'qb-core' and QBCore then
        return QBCore.Functions.GetPlayerByCitizenId(citizenid)
    elseif LegacyConfig.Framework:lower() == 'qbox' and QBOX then
        return QBOX.Functions.GetPlayerByCitizenId(citizenid)
    elseif LegacyConfig.Framework:lower() == 'esx' and ESX then
        -- ESX doesn't have direct citizenid lookup, need to implement differently
        local players = ESX.GetPlayers()
        for i=1, #players do
            local xPlayer = ESX.GetPlayerFromId(players[i])
            if xPlayer and xPlayer.identifier == citizenid then
                return xPlayer
            end
        end
    elseif LegacyConfig.Framework:lower() == 'ox' and OX then
        return OX.GetPlayerByFilter({ charId = citizenid })
    end
    return nil
end

function LegacyLib.Functions.BanPlayer(source, targetId, reason, duration, bannerSrc)
    if LegacyConfig.Framework:lower() == 'qb-core' and QBCore and QBCore.Functions.BanPlayer then
        QBCore.Functions.BanPlayer(targetId, reason, duration, bannerSrc)
    else
        -- Fallback ban implementation
        DropPlayer(targetId, 'Banned: ' .. reason)
    end
end

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