/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : iw5_ai_zombies_mp_new
*    Author : P!X
*    Game : MW3
*    Description : Starts Multiplayer code execution!
*    Date : 06.12.2019 23:09:26
*
*/



/*
    TODO:
    Zombie System --- no player found -- respawn+search
*/


/* 
    LAST WORKED ON:
                    WAVE SYSTEM
*/



#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

init()
{
    level thread onPlayerConnect();
    if(!level thread init_zombie_mode())
    {
        if(level.DEV_SETTINGS["Ignore_Checks"] && level.DEV_SETTINGS["Use_Developer_Mode"])
        {
            level thread init_developer_mode();
        }
    }
}
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected",player);
        player thread onPlayerSpawned();
    }
}
onPlayerSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if((!isDefined(level.overFlowFix_Started)||!level.overFlowFix_Started) && self isHost())
        {
            level thread init_overFlowFix();
        }
    }
}