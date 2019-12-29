spawnDefaultZombie(health,damage,kill_reward=50,hit_reward=5,headshot_reward=20)
{
    //Create Base Zombie
    spawnPoint             = getRandomZombieSpawnpoint("default");
    zombie                 = createZombieBase("default",spawnPoint.origin,health,damage);
    zombie.kill_reward     = kill_reward;
    zombie.hit_reward      = hit_reward;
    zombie.headshot_reward = headshot_reward;
    if(cointoss())
    {
        zombie.canGetAggressive = true;
        zombie.isAggressive     = cointoss();
    }
    else
    {
        zombie.canGetAggressive = false;
        zombie.isAggressive     = false;
    }
    
    
    wait .2;
    //zombie.eye_left = playFxOnTag(level._effect["ac130_light_red"],zombie,"j_head");
    /*zombie.eye_left        = spawn("script_model",zombie getTagOrigin("tag_eye_left"));
    zombie.eye_left.angles = (90,0,0);
    zombie.eye_left setModel(getWeaponModel("c4_mp"));
    zombie.eye_left linkto(zombie ,"tag_eye_left");*/
    wait .2;//min wait should be atleast 1 frame
    //zombie.effect_eye_left = playFxOnTag(level.aiz_asset["effect"]["zombie_c4_blink"],zombie.c4,"tag_fx");
    
    //set anim mode to idle
    zombie zombie_setAnimMode("idle");
    
    //Start Zombie Logic
    zombie thread zombie_logic_health_think();
    zombie thread zombie_logic_attack_think();
    zombie thread zombie_logic_move_think();
    wait .2;
}