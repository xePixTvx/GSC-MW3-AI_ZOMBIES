init_player()
{
    level thread PLAYER_Connect();
}
PLAYER_Connect()
{
    for(;;)
    {
        level waittill("connected",player);
        player thread PLAYER_Spawned();
        player thread PLAYER_force_join_and_spawn();
    }
}
PLAYER_Spawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self thread PLAYER_doSpawn();
    }
}





PLAYER_doSpawn()
{
    if(!isDefined(self.player_isResetSpawn)||self.player_isResetSpawn)//actual spawn
    {
        self.isWaitingForNextWave = false;
        
        //spawnpoint
        spawnPoint = getRandomPlayerSpawnPoint();
        self setOrigin(spawnPoint.origin);
        self setPlayerAngles(spawnPoint.angles);
        
        //take all weapons
        self takeAllWeapons();
        
        //unset all perks
        self.perks = [];
        self clearPerks();
        
        //set max health
        self.maxHealth = 100;
        self.health    = self.maxHealth;
        
        //Start Flying Intro
        self thread PLAYER_doFlyingIntro();
        
        //Wait for Flying Intro to be finished
        self waittill("flying_intro_done");
        
        //give starting weapon
        self giveWeaponFromList(level.AIZ_SETTINGS["player"]["starting_weapon"]);
        
        //set money
        self setMoney(level.AIZ_SETTINGS["player"]["starting_money"]);
        
        //set armor
        self setArmor(level.AIZ_SETTINGS["player"]["starting_armor"]);
        self thread PLAYER_armor_monitor();
        
        wait .6;
        //create hud
        self PLAYER_createHud();
        
        
        self.player_isResetSpawn = false;
    }
    else//player died spectator spawn
    {
        self.isWaitingForNextWave = true;
        self notify("menuresponse",game["menu_team"],"spectator");
        self PLAYER_destroyHud();
        self thread PLAYER_wait_for_nextWave();
        level thread SERVER_check_for_endGame();
    }
}




























//wait for next wave and respawn player
PLAYER_wait_for_nextWave()
{
    level waittill("next_wave");
    self.player_isResetSpawn = true;
    self notify("menuresponse",game["menu_team"],"allies");
    self.pers["class"] = undefined;
    self.class = undefined;
    self notify("end_respawn");
    wait .2;
    self maps\mp\gametypes\_menus::bypassClassChoice();
}


//player force join team and spawn
PLAYER_force_join_and_spawn()
{
    self closeMenus();
    self maps\mp\gametypes\_menus::addToTeam("allies");
    self.pers["class"] = undefined;
    self.class = undefined;
    self notify("end_respawn");
    wait .2;
    self maps\mp\gametypes\_menus::bypassClassChoice();
    wait 0.05;
    self AllowSpectateTeam("allies",true);
    self AllowSpectateTeam("axis",false);
    self AllowSpectateTeam("freelook",false);
}

//Flying Intro(stolen from mw2 singleplayer)
PLAYER_doFlyingIntro()
{
    self freezeControls(true);
    zoomHeight  = 2000;
    origin      = self.origin;
    self.origin = origin+(0,0,zoomHeight);
    ent         = spawn("script_model",(69,69,69));
    ent.origin  = self.origin;
    ent setModel("tag_origin");
    ent.angles = self.angles;
    self playerLinkTo(ent,undefined,1,0,0,0,0);
    ent.angles = (ent.angles[0]+89,ent.angles[1],0);
    ent moveTo(origin+(0,0,0),2,0,2);
    wait 1.5;
    ent rotateTo((ent.angles[0]-89,ent.angles[1],0),0.5,0.3,0.2);
    wait 0.7;
    self unlink();
    self freezeControls(false);
    ent delete();
    self notify("flying_intro_done");
}


//Add a player spawnpoint
addPlayerSpawnPoint(pos,angle)
{
    if(!isDefined(level.PLAYER_SPAWNPOINTS))
    {
        level.PLAYER_SPAWNPOINTS = [];
    }
    i = level.PLAYER_SPAWNPOINTS.size;
    level.PLAYER_SPAWNPOINTS[i] = spawnStruct();
    level.PLAYER_SPAWNPOINTS[i].origin = pos;
    level.PLAYER_SPAWNPOINTS[i].angles = angle;
}
getRandomPlayerSpawnPoint()
{
    if(!isDefined(level.PLAYER_SPAWNPOINTS))
    {
        iprintln("^1NO PLAYERSPAWNPOINTS DEFINED!!!!");
        return level.spawnpoints[randomInt(level.spawnpoints.size)];//return iw5 spawnpoint
    }
    return level.PLAYER_SPAWNPOINTS[randomInt(level.PLAYER_SPAWNPOINTS.size)];
}