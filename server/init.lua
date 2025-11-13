LegacyLib = {}
LegacyLib.Functions = {}

exports('GetCoreObject', function()
    return LegacyLib
end)

QBCore, QBOX, ESX, OX = nil, nil, nil, nil

CreateThread(function()
    if LegacyConfig.Framework:lower() == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            LegacyConfig.Framework = 'qb-core'
            QBCore = exports['qb-core']:GetCoreObject()
            print('[Legacy Scripts] Detected QBCore framework.')
        elseif GetResourceState('qbox') == 'started' then
            LegacyConfig.Framework = 'qbox'
            QBOX = exports['qbox']:GetCoreObject()
            print('[Legacy Scripts] Detected QBOX framework.')
        elseif GetResourceState('es_extended') == 'started' then
            LegacyConfig.Framework = 'esx'
            ESX = exports["es_extended"]:getSharedObject()
            print('[Legacy Scripts] Detected ESX framework.')
        elseif GetResourceState('ox_core') == 'started' then
            LegacyConfig.Framework = 'ox'
            OX = exports['ox_core']:GetCoreObject()
            print('[Legacy Scripts] Detected OX framework.')
        else
            LegacyConfig.Framework = 'none'
            print('[Legacy Scripts] No supported framework detected.')
        end
    end
end)