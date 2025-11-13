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