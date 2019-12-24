loadMap()
{
    level.map_list     = ["mp_underground"];
    level.map_function = [::map_mp_underground];
    currentMap         = getDvar("mapname");
    
    
    for(i=0;i<level.map_list.size;i++)
    {
        if(level.map_list[i]==currentMap)
        {
            if(isDefined(level.map_function[i]))
            {
                level thread [[level.map_function[i]]]();
                return true;
            }
        }
    }
    return false;
}



map_mp_underground()
{
    //Shops
    addRefillAmmoShop((388.547,-207.125,8.125),(0,0,0));
    addRandomWeaponShop((-382.833,-874.631,0.125),(0,-53,0));
    addRandomWeaponShopPos((457.093,-665.992,0.124998),(0,-120,0));
    
    
    //Player Spawnpoints
    addPlayerSpawnPoint((-60.6804,-865.126,0.125),(0,90.0767,0));
    
    //Sort Zombie Models
    addZombieModel("default","body","mp_body_russian_military_assault_a_airborne");
    addZombieModel("default","body","mp_body_russian_military_smg_a_airborne");
    addZombieModel("default","body","mp_body_russian_military_lmg_a_airborne");
    addZombieModel("default","body","mp_body_opforce_ghillie_urban_sniper");
    addZombieModel("default","body","mp_body_russian_military_shotgun_a_airborne");
    addZombieModel("default","head","head_opforce_russian_air_sniper");
    addZombieModel("default","head","head_sas_a");
    addZombieModel("default","head","head_sas_b");
    addZombieModel("default","head","head_sas_c");
    addZombieModel("jugger","fullbody","mp_fullbody_opforce_juggernaut");
    addZombieModel("crawler","body","mp_body_opforce_ghillie_urban_sniper");
    addZombieModel("crawler","head","head_opforce_russian_air_sniper");
    
    //Zombie Spawnpoints
    addZombieSpawnpoint("default",(-803.612,-228.368,8.125),(0,-35,0));
    addZombieSpawnpoint("default",(-661.063,-197.455,8.125),(0,-53,0));
    addZombieSpawnpoint("default",(-651.958,-395.846,8.125),(0,-32,0));
    addZombieSpawnpoint("default",(757.584,-147.398,8.125),(0,-127,0));
    addZombieSpawnpoint("default",(735.48,-319.414,8.125),(0,-139,0));
    addZombieSpawnpoint("default",(659.436,-310.947,8.125),(0,-131,0));
}

















