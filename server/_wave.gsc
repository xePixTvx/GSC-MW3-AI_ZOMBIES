/*
    not sure about the max zombies that are active at the same time(30-70) --- probably 40-45
*/

init_wave()
{
    level thread WAVE_SYSTEM_start_after_aiz_is_loaded();
}



WAVE_SYSTEM_start_after_aiz_is_loaded()
{
    level waittill("aiz_loaded");
}

WAVE_set_vision_for_all_players()
{
    /*if(level.Wave<=0)
    {
        level waittill("prematch_over");
    }
    foreach(player in level.players)
    {
        player visionSetNakedForPlayer(level.AIZ_SETTINGS["server"]["player_vision"],4.5);//cobra_sunset3
    }*/
}