loadSettings()
{
    /* DEVELOPER STUFF */
    //DEVELOPER SETTINGS
    level.DEV_SETTINGS = [];//dont remove!!!!!!!!!!!!!!!
    level.DEV_SETTINGS["Use_Developer_Mode"] = true;//enable/disable dev mode
    level.DEV_SETTINGS["Ignore_Checks"] = false;//Start dev mode on unsupported maps/gametypes
    level.DEV_SETTINGS["TEST_MODEL"] = "SOME_MODEL";//dev mode test model
    level.DEV_SETTINGS["TEST_FUNCTION"] = ::DEVELOPER_TEST_FUNCTION;//dev mode test function
    level.DEV_SETTINGS["GIVE_WEAPON"] = "iw5_m4_mp_reflex";//give weapon if dev mode is true
    level.DEV_SETTINGS["Enable_Team_Class_Menus"] = false;//dont block team and class menus
    level.DEV_SETTINGS["Disable_precache"] = false;//disable precaching(cause of weird overflow errors in the past xD) -- instant string overflow = enable this ;) ------ and report that bug pls xD
    level.DEV_SETTINGS["Zombies_No_Damage"] = false;//zombies are not able to do any damage
    level.DEV_SETTINGS["Disable_Wave_Start"] = false;//no wave gets started
    level.DEV_SETTINGS["Zombies_Frozen"] = false;//all zombies are frozen
    /* DEVELOPER STUFF END*/
    
    
    
    
    
    
    
    
    level.AIZ_SETTINGS = [];//dont remove!!!!!!!!!!!!!!!
    
    //Server Settings
    level.AIZ_SETTINGS["server"] = [];//dont remove!!!!!!!!!!!!!!!
    level.AIZ_SETTINGS["server"]["player_vision"] = "icbm";//dont edit! ----- except you have a better vision :)
    
    //Player Settings
    level.AIZ_SETTINGS["player"] = [];//dont remove!!!!!!!!!!!!!!!
    level.AIZ_SETTINGS["player"]["starting_weapon"] = "iw5_usp45";//Starting Weapon(base weapon --- no attachments possible)
    level.AIZ_SETTINGS["player"]["starting_money"] = 500;//Starting Money
    level.AIZ_SETTINGS["player"]["starting_armor"] = 50;//Starting Armor
    level.AIZ_SETTINGS["player"]["max_armor"] = 250;//Max Armor
    
    
    //Shops
    level.AIZ_SETTINGS["shop"] = [];//dont remove!!!!!!!!!!!!!!!
    level.AIZ_SETTINGS["shop"]["price_refill_ammo"] = 50;//Ammo Refill Price
    level.AIZ_SETTINGS["shop"]["price_random_weapon"] = 50;//Random Weapon Price
}