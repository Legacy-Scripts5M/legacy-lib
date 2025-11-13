function LegacyLib.Functions.GetTheme()
    local theme = {
        name = LegacyConfig.Brand.serverName or 'Legacy Scripts',
        preset = LegacyConfig.Brand.themePreset or 'legacy',
        theme = LegacyConfig.Brand.themes[LegacyConfig.Brand.themePreset] or LegacyConfig.Brand.themes['legacy'] or {
            accent = '#00a6ff',
            bgCard = 'rgba(10, 10, 25, 1)',
            textPrimary = '#f5f5f5',
            textDim = '#b3e5ff',
            danger = '#ff6b6b',
        },
    }

    if LegacyConfig.Brand.themePreset == 'custom' then
        theme.theme = LegacyConfig.Brand.customTheme or theme.theme
    end

    return theme
end