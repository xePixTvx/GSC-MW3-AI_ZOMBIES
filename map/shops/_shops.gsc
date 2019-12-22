init_shops()
{
    level.shop_types = ["refill_ammo","random_weapon"];
    level.shop_crate = [];
    
    
    level waittill("aiz_loaded");
    wait .2;
    foreach(type in level.shop_types)
    {
        if(isDefined(level.shop_info[type]))
        {
            if(type=="random_weapon")
            {
                posInt = getRandomWeaponShopPosNumber();
                level.shop_crate[type] = thread spawnShopCrate(level.shop_info[type].pos[posInt],level.shop_info[type].angle[posInt],level.shop_info[type].headIcon);
            }
            else
            {
                level.shop_crate[type] = thread spawnShopCrate(level.shop_info[type].pos,level.shop_info[type].angle,level.shop_info[type].headIcon);
            }
        }
    }
    wait 0.05;
    level thread shop_monitor();
}

shop_monitor()
{
    level endon("game_ended");
    for(;;)
    {
        foreach(player in level.players)
        {
            foreach(type in level.shop_types)
            {
                if(isDefined(level.shop_crate[type]) && isDefined(level.shop_info[type].mainFunction))
                {
                    if(distance(level.shop_crate[type].origin,player.origin)<=100)
                    {
                        if(player thread [[level.shop_info[type].mainFunction]](type,level.shop_crate[type],level.shop_info[type].lowMsg))
                        {
                            wait .6;
                        }
                    }
                    else
                    {
                        player clearLowerMessage(type + "_shop_lowMsg",1);
                    }
                }
            }
        }
        wait 0.05;
    }
}

spawnShopCrate(pos,angle,headicon)
{
    crate        = spawn("script_model",pos+(0,0,16));
    crate.angles = angle;
    crate setModel(level.aiz_asset["model"]["shop_crate_model"]);
    crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
    if(isDefined(headicon))
    {
        crate SetEntHeadIcon((0,0,50),headicon,true);
    }
    return crate;
}
spawnGunModel(pos,angle,weap)
{
    gun = spawn("script_model",pos);
    gun.angles = angle;
    gun setModel(getWeaponModel(weap));
    return gun;
}