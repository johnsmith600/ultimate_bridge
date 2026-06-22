Config = {}

Config.Debug = true
Config.Framework = "auto" -- "auto", "esx", "qb", "qbox", "standalone"
Config.Inventory = "auto" -- "auto", "ox", "qb", "qs", "codem", "esx"
Config.Notify = "auto" -- "auto", "ox", "okok", "mythic", "qb", "esx"
Config.Database = "auto" -- "auto", "oxmysql", "mysql-async", "ghmattimysql"
Config.Target = "auto" -- "auto", "ox_target", "qb-target", "qtarget"
Config.Menu = "auto" -- "auto", "ox_lib", "qb-menu", "esx_menu"
Config.ProgressBar = "auto" -- "auto", "ox_lib", "qb", "esx"
Config.Banking = "auto" -- "auto", "renewed", "qb", "esx"
Config.Society = "auto" -- "auto", "esx_society", "qb-management", "renewed"

-- Permission Mapping
Config.Permissions = {
    ['police.manage'] = {
        ['esx'] = { job = 'police', grade = 4 },
        ['qb'] = 'admin',
        ['qbox'] = 'admin'
    }
}
