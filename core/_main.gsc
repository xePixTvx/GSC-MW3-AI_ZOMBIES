init_zombie_mode()
{
    level.ai_zombies_version = 1.1;
    
    //load Main Settings
    level thread loadSettings();
    
    //precache Assets
    level thread precacheAssets();
    
    
    
    //Check for gametype
    if(!SERVER_canStart_AIZ())
    {
        level thread SERVER_print_single_error_msg("GAMETYPE NEEDS TO BE: ^1TEAM-DEATHMATCH");
        return false;
    }
    
    //Init Zombie System
    level thread init_zombie();
    
    //Load Map
    if(loadMap())
    {
        level thread init_server();
        level thread init_weapon();
        level thread init_player();
        level thread init_shops();
    }
    else
    {
        level thread SERVER_print_single_error_msg("^1MAP NOT SUPPORTED!");
        return false;
    }
    
    
    
    //Start DEV Mode if enabled
    if(level.DEV_SETTINGS["Use_Developer_Mode"] && !isConsole())
    {
        level thread init_developer_mode();
    }
    
    
    level notify("aiz_loaded");
    
    
    
    
    return true;
}