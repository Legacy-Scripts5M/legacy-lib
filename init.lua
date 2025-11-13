-- legacy-lib/init.lua
-- Public API for all Legacy resources (no callbacks here; use ox_lib).

Legacy = Legacy or {}
Legacy.Compat = Legacy.Compat or require('compat.init')

-- Framework bridge is server-only
Legacy.Framework = Legacy.Framework or (IsDuplicityVersion() and require('compat.framework') or {})

-- Shared helpers
require('compat.notify')
require('compat.fuel')
require('compat.keys')
require('compat.target')

local function resolveTheme()
    local preset = (LegacyConfig.Brand.themePreset or 'legacy'):lower()
    local dict = LegacyConfig.Brand.themes or {}
    if preset == 'custom' then
        return LegacyConfig.Brand.customTheme or {}
    end
    return dict[preset] or dict['legacy'] or {
        accent = '#00a6ff',
        bgCard = 'rgba(10,10,25,1)',
        textPrimary = '#f5f5f5',
        textDim = '#b3e5ff',
        danger = '#ff6b6b'
    }
end

Legacy.API = {
    -- Branding / theme
    GetTheme      = function() return resolveTheme() end,
    GetServerName = function() return LegacyConfig.Brand.serverName or 'Legacy' end,
    GetFramework  = function() return Legacy.Compat.__detected.framework end,

    -- Identifier (license vs character) — used server-side
    Identifier    = function(src)
        if (LegacyConfig.IdentifierMode or 'character') == 'license' then
            return GetPlayerIdentifier(src, 0)
        else
            return (Legacy.Framework.Identifier and Legacy.Framework.Identifier(src)) or tostring(src)
        end
    end,

    -- Server wrappers (implemented on server in compat/framework.lua)
    AddItem        = function(...) return Legacy.Framework.AddItem and Legacy.Framework.AddItem(...) end
    ,
    RemoveItem     = function(...) return Legacy.Framework.RemoveItem and Legacy.Framework.RemoveItem(...) end
    ,
    HasItem        = function(...) return Legacy.Framework.HasItem and Legacy.Framework.HasItem(...) end
    ,
    AddMoney       = function(...) return Legacy.Framework.AddMoney and Legacy.Framework.AddMoney(...) end
    ,
    RegisterUsable = function(...) return Legacy.Framework.RegisterUsableItem and Legacy.Framework.RegisterUsableItem(...) end
    ,

    -- Notify (available both sides; routes internally to compat/notify.lua)
    Notify         = function(...) return Legacy.Notify:Send(...) end,

    -- Client wrappers
    FuelGet        = function(...) return Legacy.Fuel:Get(...) end,
    FuelSet        = function(...) return Legacy.Fuel:Set(...) end,
    TargetAddZone  = function(...) return Legacy.Target:AddZone(...) end,
}

-- CLIENT-ONLY vehicle spawn abstraction (no framework calls in your client scripts)
Legacy.API.SpawnVehicle = function(model, coords, opts, done)
    opts = opts or {}
    local fw = Legacy.Compat.__detected.framework

    local function _finish(veh)
        if not veh or not DoesEntityExist(veh) then
            if done then done(nil, nil) end
            return
        end
        local plate = opts.plate or (tostring(math.random(1000, 9999)) .. tostring(math.random(100, 999)))
        SetVehicleNumberPlateText(veh, plate)
        Legacy.Fuel:Set(veh, (opts.fuel ~= nil) and opts.fuel or (LegacyConfig.Fuel.defaultSpawnLevel or 100))
        if opts.engineOn ~= false then SetVehicleEngineOn(veh, true, true) end
        if opts.warp ~= false then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
        if done then done(veh, plate) end
    end

    if fw == 'qb-core' or fw == 'qbox' then
        local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject() or exports['qbx_core']:GetCoreObject()
        return QBCore.Functions.SpawnVehicle(model, _finish, coords, true)
    end

    if fw == 'esx' and ESX and ESX.Game and ESX.Game.SpawnVehicle then
        return ESX.Game.SpawnVehicle(model, vector3(coords.x, coords.y, coords.z), coords.w, _finish)
    end

    local hash = joaat(model)
    RequestModel(hash); while not HasModelLoaded(hash) do Wait(0) end
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, true, false)
    SetModelAsNoLongerNeeded(hash)
    _finish(veh)
end

-- ===== Exports =====
-- Shared exports
exports('GetTheme',       Legacy.API.GetTheme)
exports('GetServerName',  Legacy.API.GetServerName)
exports('GetFramework',   Legacy.API.GetFramework)
exports('Identifier',     Legacy.API.Identifier)
exports('Notify',         Legacy.API.Notify)

-- Client exports
if not IsDuplicityVersion() then
    exports('FuelGet',        Legacy.API.FuelGet)
    exports('FuelSet',        Legacy.API.FuelSet)
    exports('TargetAddZone',  Legacy.API.TargetAddZone)
    exports('SpawnVehicle',   Legacy.API.SpawnVehicle)
end

-- Server-only exports
if IsDuplicityVersion() then
    exports('AddItem',        Legacy.API.AddItem)
    exports('RemoveItem',     Legacy.API.RemoveItem)
    exports('HasItem',        Legacy.API.HasItem)
    exports('AddMoney',       Legacy.API.AddMoney)
    exports('RegisterUsable', Legacy.API.RegisterUsable)

    -- Optional: server notify mirror event
    RegisterNetEvent('legacy-lib:notify', function(msg, type, duration)
        Legacy.Notify:Send(source, msg, type, duration)
    end)
end
