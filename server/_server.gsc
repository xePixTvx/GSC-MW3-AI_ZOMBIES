init_server()
{
    level.Power            = false;
    level.Wave             = 0;
    level.IntermissionTime = 40;
    
    
    
    level thread SERVER_init_dvars();
    level thread SERVER_reCreate_original_hud_for_all_players_on_gameEnd();
    level thread SERVER_Connect();
    level thread init_server_hud();
    level thread init_wave();
}

SERVER_Connect()
{
    for(;;)
    {
        level waittill("connected",player);
        if(!level.DEV_SETTINGS["Enable_Team_Class_Menus"])
        {
            player thread SERVER_disable_team_class_menus();
        }
        player thread SERVER_destroy_original_hud_for_player();
    }
}




//Set server dvars
SERVER_init_dvars()
{
    setDvar("scr_war_timelimit",0);
    setDvar("scr_war_scorelimit",0);
    setDvar("scr_game_hardpoints",0);
    setDvar("scr_game_allowkillcam",0);
    setDvar("g_hardcore",1);
    maps\mp\gametypes\_gamelogic::pauseTimer();
}

//Disable Team & Class Change
SERVER_disable_team_class_menus()
{
    self notify("end_SERVER_disableTeamClassMenus");
    self endon("disconnect");
    self endon("end_SERVER_disableTeamClassMenus");
    for(;;)
    {
        self waittill("menuresponse",menu,response);
        if(menu==("class"||"team_marinesopfor"))
        {
            if(response==("changeteam"||"changeclass_marines"||"changeclass_opfor"||"axis"||"allies"||"spectator"||"autoassign"))
            {
                wait 0.05;
                self closepopupMenu();
                self closeInGameMenu();
            }
        }
        wait 0.05;
    }
}

//Destroy some default iw5 huds
SERVER_destroy_original_hud_for_player()
{
    self.lowerTimer destroy();
    self.notifyTitle destroy();
    self.notifyText destroy();
    self.notifyText2 destroy();
    self.notifyIcon destroy();
    self.notifyOverlay destroy();
}
//ReCreate default iw5 huds for all players(otherwise we have game ending bugs)
SERVER_reCreate_original_hud_for_all_players_on_gameEnd()
{
    level waittill("game_ended");
    foreach(player in level.players)
    {
        player thread initNotifyMessage();
        player thread lowerMessageThink();
    }
}

//Gametype check
SERVER_canStart_AIZ()
{
    if(getDvar("g_gametype")=="war")
    {
        return true;
    }
    return false;
}


//Check for game end
SERVER_check_for_endGame()
{
    deads = [];
    foreach(player in level.players)
    {
        if(player.isWaitingForNextWave)
        {
            deads[deads.size] = player;
        }
    }
    if(deads.size==level.players.size)
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();//do end game stuff
    }
}


//Server notify after some time
SERVER_notify_after_time_period(waitTime,notification,end)
{
    if(isDefined(end))
    {
        level endon(end);
    }
    level endon(notification);
    wait waitTime;
    level notify(notification);
}


//draw a simple error msg
SERVER_print_single_error_msg(msg)
{
    if(!isDefined(level.svr_single_error_mgs))
    {
        level.svr_single_error_mgs = createServerText("default",1.5,"CENTER","CENTER",0,0,(1,1,1),1,(0,0,0),0,msg);
    }
    else
    {
        level.svr_single_error_mgs _setText(msg);
    }
    if(level.DEV_SETTINGS["Ignore_Checks"] && level.DEV_SETTINGS["Use_Developer_Mode"])
    {
        wait 4;
        level.svr_single_error_mgs destroy();
    }
}