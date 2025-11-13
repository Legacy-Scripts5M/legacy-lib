LegacyConfig = {}

-- Framework: 'auto' | 'qb-core' | 'qbox' | 'esx' | 'ox' | 'none'
LegacyConfig.Framework = 'auto'

LegacyConfig.AdminGroups = {
  qbcore = { 'god', 'admin' },
  qbox = { 'god', 'admin' },
  esx = { 'admin', 'superadmin' },
  ox = { 'admin' },
}

LegacyConfig.General_Customization = {
  Notification_System = 2,
    -- 1 = QBCore Notification
    -- 2 = ESX Notification
    -- 3 = ox_lib Notification
    -- 4 = Custom Notification
    -- If you are using a custom notification system, you will need to edit the client\functions.lua file.
}

-- Branding / Theme
LegacyConfig.Brand = {
  serverName = 'Legacy Scripts', -- Server name to use in all of our ui branding
  themePreset = 'legacy',  -- 'legacy' | 'red' | 'blue' | 'green' | 'yellow' | 'custom', uses customTheme below if 'custom'
  customTheme = {
    accent = '#ffffff',
    bgCard = 'rgba(15, 15, 15, 1)',
    textPrimary = '#ffffff',
    textDim = '#d0d0d0',
    danger = '#ff4444',
  },
  themes = {
    legacy = { accent = '#00a6ff', bgCard = 'rgba(10,10,25,1)', textPrimary = '#f5f5f5', textDim = '#b3e5ff', danger = '#ff6b6b' },
    red    = { accent = '#ff3b3b', bgCard = 'rgba(25,0,0,1)',  textPrimary = '#fff5f5', textDim = '#ff9b9b', danger = '#ff3b3b' },
    blue   = { accent = '#3ba8ff', bgCard = 'rgba(5,10,30,1)', textPrimary = '#e8f3ff', textDim = '#9bd1ff', danger = '#ff6b6b' },
    green  = { accent = '#2ecc71', bgCard = 'rgba(5,20,10,1)', textPrimary = '#eaffef', textDim = '#9bffbe', danger = '#ff6b6b' },
    yellow = { accent = '#ffdd4a', bgCard = 'rgba(30,25,0,1)', textPrimary = '#fffbe0', textDim = '#fff199', danger = '#ff6b6b' },
  }
}

-- OBS: Change logo by replacing 'logo.png' with your own image. Make sure it's named logo.png and has similar dimensions.

-- Identifier mode
LegacyConfig.IdentifierMode = 'character' -- 'character' or 'license'