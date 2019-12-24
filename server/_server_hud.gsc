init_server_hud()
{
    level.Hud = [];
    
    
    level.Hud["Wave"] = createServerText("hudBig",1.5,"TOPLEFT","TOPLEFT",-48,-20,(0.41,0,0),0,(1,0,0),0);
    level.Hud["Wave"].hideWhenInMenu = true;
    level.Hud["Wave"] setValue(level.Wave);
    
    
    
    level waittill("aiz_loaded");
    wait .4;
    level.Hud["Wave"] elemFadeOverTime(.4,1);
}







//Simple Notify Msg for all players
SERVER_simpleNotifyMessage(msg,show_time)
{
    if(isDefined(level.Hud["simple_notify"]))
    {
        level.Hud["simple_notify"] destroy();
    }
    level notify("new_simple_notify_msg");
    level endon("new_simple_notify_msg");
    if(cointoss())
    {
        x_start = -800;
        x_end   = 800;
    }
    else
    {
        x_start = 800;
        x_end   = -800;
    }
    level.Hud["simple_notify"] = createServerText("hudBig",1.0,"CENTER","TOP",x_start,50,(1,1,1),1,(0.3,0.6,0.3),1,msg);
    level.Hud["simple_notify"] elemMoveOverTimeX(.7,0);
    wait show_time + .7;
    level.Hud["simple_notify"] elemMoveOverTimeX(.7,x_end);
    wait .8;
    level.Hud["simple_notify"] destroy();
}

//Update Wave/Power Huds
SERVER_updateWaveCounter(value)
{
    if(!isDefined(value))
    {
        value = level.Wave;
    }
    level.Hud["Wave"] elemFadeOverTime(.7,0);
    wait .8;
    level.Hud["Wave"] setValue(value);
    level.Hud["Wave"] elemFadeOverTime(.7,1);
}



//Intermission
SERVER_intermission_players_skip()
{
    level endon("intermission_done");
    if(isDefined(level.Hud["intermission_skip_info"]))
    {
        level.Hud["intermission_skip_info"] destroy();
    }
    level.Hud["intermission_skip_info"] = createServerText("objective",1.3,"CENTER","BOTTOM",0,-10,(1,1,1),0,(0,1,0),0,"Press ^3[{+frag}]^7 + ^3[{+melee}]^7 to Skip!(0/"+level.players.size+")");
    level.Hud["intermission_skip_info"].hideWhenInMenu = true;
    level.intermissionSkipped_count = 0;
    foreach(player in level.players)
    {
        player.hasIntermissionSkipped = false;
    }
    level.Hud["intermission_skip_info"] elemFadeOverTime(.4,1);
    for(;;)
    {
        foreach(player in level.players)
        {
            if(player FragButtonPressed() && player MeleeButtonPressed())
            {
                if(!player.hasIntermissionSkipped)
                {
                    level.intermissionSkipped_count ++;
                    player.hasIntermissionSkipped = true;
                }
                wait .4;
            }
        }
        level.Hud["intermission_skip_info"] _setText("Press ^3[{+frag}]^7 + ^3[{+melee}]^7 to Skip!("+level.intermissionSkipped_count+"/"+level.players.size+")");
        wait 0.05;
    }
}
SERVER_doIntermission()
{
    level.doing_intermission = true;
    level.Hud["intermission"] = createServerText("objective",1.3,"CENTER","BOTTOM",0,-30,0,(1,1,1),0,(0.3,0.6,0.3),1);
    level.Hud["intermission"].label = &"Next Wave in: ";
    level.Hud["intermission"] setValue(level.IntermissionTime);
    level.Hud["intermission"] elemFadeOverTime(.4,1);
    wait .4;
    for(i=level.IntermissionTime;i>-1;i--)
    {
        if(everyPlayerHasSkippedIntermission())
        {
            continue;
        }
        level.Hud["intermission"] setValue(i);
        foreach(player in level.players)
        {
            if(i>5)
            {
                player playLocalSound("match_countdown_tick");
            }
            else
            {
                player playLocalSound("ui_mp_timer_countdown");
            }
        }
        wait 1;
    }
    level notify("intermission_done");
    level.Hud["intermission_skip_info"] elemFadeOverTime(.4,0);
    level.Hud["intermission"] elemFadeOverTime(.4,0);
    wait .4;
    level.Hud["intermission"] destroy();
    level.Hud["intermission_skip_info"] destroy();
    level.doing_intermission = false;
}
everyPlayerHasSkippedIntermission()
{
    list = [];
    foreach(player in level.players)
    {
        if(player.hasIntermissionSkipped)
        {
            list[list.size] = player;
        }
    }
    if(list.size==level.players.size)
    {
        return true;
    }
    return false;
}


//Vision
SERVER_set_vision_for_all_players()
{
    foreach(player in level.players)
    {
        player visionSetNakedForPlayer(level.AIZ_SETTINGS["server"]["player_vision"],4.5);//cobra_sunset3
    }
}