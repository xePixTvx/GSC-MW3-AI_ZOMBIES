/*
    not sure about the max zombies that are active at the same time(30-70) --- probably 40-45
*/

init_wave()
{
    level.max_zombies_active = 30;
    
    
    level.wave_zombie_amount = [];
    level.wave_zombie_amount["default"] = 3;
    level.wave_zombie_amount["sprinter"] = 0;
    level.wave_zombie_amount["exploder"] = 0;
    level.wave_zombie_amount["crawler"] = 0;
    level.wave_zombie_amount["jugger"] = 0;
    
    setupWaveZombieSettings("default",100,20,50,5,20);
    setupWaveZombieSettings("sprinter",100,20,50,5,20);
    setupWaveZombieSettings("exploder",100,20,50,5,20);
    setupWaveZombieSettings("crawler",100,20,50,5,20);
    setupWaveZombieSettings("jugger",100,20,50,5,20);
    
    level thread WAVE_Start_First_Wave();
    
    
    level waittill("aiz_loaded");
    level thread WAVE_monitor();
    level thread WAVE_watch_zombie_count();
}

WAVE_Start_First_Wave()
{
    level waittill("prematch_over");
    level notify("next_wave");
}

WAVE_monitor()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("next_wave");
        level thread SERVER_set_vision_for_all_players();
        level thread SERVER_intermission_players_skip();
        level thread SERVER_doIntermission();
        level waittill("intermission_done");
        level.Wave ++;
        level thread SERVER_updateWaveCounter();
        wait .4;
        level thread WAVE_do_wave_setup();
    }
}

WAVE_watch_zombie_count()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("update_active_zombies");
        if(level.pix_zombie_count<=0)//&& level.dev_settings["Allow_Wave_Start"]
        {
            level notify("next_wave");
            level.pix_zombies      = [];
            level.pix_zombie_count = 0;
            //iprintlnBold("^1NEXT WAVE CALLED!");
            //level thread doBonus();
            wait 0.05;
        }
        if(level.pix_zombie_count>=level.max_zombies_active)
        {
            level.canSpawnZombies = false;
        }
    }
}






WAVE_do_wave_setup()
{
    if(level.Wave<5)
    {
        level.wave_zombie_amount["default"] += 2;
        level.wave_zombie_amount["sprinter"] = 0;
        level.wave_zombie_amount["exploder"] = 0;
        level.wave_zombie_amount["crawler"] = 0;
        level.wave_zombie_amount["jugger"] = 0;
        
        setupWaveZombieSettings("default",100,20,50,5,20);
    }
    else
    {
        level.wave_zombie_amount["default"] = 200;
        level.wave_zombie_amount["sprinter"] = 50;
        level.wave_zombie_amount["exploder"] = 20;
        level.wave_zombie_amount["crawler"] = 40;
        level.wave_zombie_amount["jugger"] = 4;
        
        
        setupWaveZombieSettings("default",200,50,100,60,50);
        setupWaveZombieSettings("sprinter",200,50,100,60,50);
        setupWaveZombieSettings("exploder",200,50,100,60,50);
        setupWaveZombieSettings("crawler",200,50,100,60,50);
        setupWaveZombieSettings("jugger",6500,60,200,50,50);
    }
    level thread WAVE_spawnZombies();
}



WAVE_spawnZombies(delay)
{
    if(!isDefined(delay))
    {
        spawn_delay = .2;
    }
    else
    {
        spawn_delay = delay;
    }
    
    level.canSpawnZombies = true;
    if(!isDefined(level.max_zombies_active)||level.max_zombies_active<=0)//if max is not defined or 0 just set it to 20
    {
        level.max_zombies_active = 20;
    }
    allowSpawnAgain = randomIntRange(int(level.max_zombies_active/2),int(level.max_zombies_active-5));
    
    
    
    default_zombies  = level.wave_zombie_amount["default"];
    sprinter_zombies = level.wave_zombie_amount["sprinter"];
    crawler_zombies  = level.wave_zombie_amount["crawler"];
    exploder_zombies = level.wave_zombie_amount["exploder"];
    jugger_zombies   = level.wave_zombie_amount["jugger"];
    
    total = default_zombies + sprinter_zombies + crawler_zombies + exploder_zombies + jugger_zombies;
    
    //level endon("zombies_nuked");//stop spawning after nuke
    while(total>0)
    {
        if(level.canSpawnZombies)
        {
            if(default_zombies>0)
            {
                thread spawnDefaultZombie(level.wave_zombie_settings["default"].health,level.wave_zombie_settings["default"].damage,level.wave_zombie_settings["default"].kill_reward,level.wave_zombie_settings["default"].hit_reward,level.wave_zombie_settings["default"].headshot_reward);
                default_zombies --;
                total --;
            }
            if(sprinter_zombies>0)
            {
                thread spawnSprinterZombie(level.wave_zombie_settings["sprinter"].health,level.wave_zombie_settings["sprinter"].damage,level.wave_zombie_settings["sprinter"].kill_reward,level.wave_zombie_settings["sprinter"].hit_reward,level.wave_zombie_settings["sprinter"].headshot_reward);
                sprinter_zombies --;
                total --;
            }
            if(crawler_zombies>0)
            {
                thread spawnCrawlerZombie(level.wave_zombie_settings["crawler"].health,level.wave_zombie_settings["crawler"].damage,level.wave_zombie_settings["crawler"].kill_reward,level.wave_zombie_settings["crawler"].hit_reward);
                crawler_zombies --;
                total --;
            }
            if(exploder_zombies>0)
            {
                thread spawnExploderZombie(level.wave_zombie_settings["exploder"].health,level.wave_zombie_settings["exploder"].damage,level.wave_zombie_settings["exploder"].kill_reward,level.wave_zombie_settings["exploder"].hit_reward,level.wave_zombie_settings["exploder"].headshot_reward);
                exploder_zombies --;
                total --;
            }
            if(jugger_zombies>0)
            {
                thread spawnJuggerZombie(level.wave_zombie_settings["jugger"].health,level.wave_zombie_settings["jugger"].damage,level.wave_zombie_settings["jugger"].kill_reward,level.wave_zombie_settings["jugger"].hit_reward,level.wave_zombie_settings["jugger"].headshot_reward);
                jugger_zombies --;
                total --;
            }
        }
        else
        {
            if(level.pix_zombies_count<=allowSpawnAgain)
            {
                level.canSpawnZombies = true;
            }
        }
        wait spawn_delay;
    } 
}


setupWaveZombieSettings(zombie_type,health,damage,kill_reward,hit_reward,headshot_reward)
{
    if(!isValidZombieType(zombie_type))
    {
        return;
    }
    if(!isDefined(level.wave_zombie_settings))
    {
        level.wave_zombie_settings = [];
    }
    level.wave_zombie_settings[zombie_type] = spawnStruct();
    level.wave_zombie_settings[zombie_type].health = health;
    level.wave_zombie_settings[zombie_type].damage = damage;
    level.wave_zombie_settings[zombie_type].kill_reward = kill_reward;
    level.wave_zombie_settings[zombie_type].hit_reward = hit_reward;
    level.wave_zombie_settings[zombie_type].headshot_reward = headshot_reward;
}