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