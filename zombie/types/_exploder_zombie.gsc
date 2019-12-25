spawnExploderZombie(health,damage,kill_reward=50,hit_reward=5,headshot_reward=20)
{
    //Create Base Zombie
    spawnPoint             = getRandomZombieSpawnpoint("exploder");
    zombie                 = createZombieBase("exploder",spawnPoint.origin,health,damage);
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
    
    //Add C4
    zombie.c4        = spawn("script_model",zombie getTagOrigin("j_spinelower")+(8,0,3));
    zombie.c4.angles = (90,0,0);
    zombie.c4 setModel(getWeaponModel("c4_mp"));
    zombie.c4 linkto(zombie,"j_spinelower");
    wait .2;//min wait should be atleast 1 frame
    zombie.effect_c4_blink = playFxOnTag(level.aiz_asset["effect"]["zombie_c4_blink"],zombie.c4,"tag_fx");
    
    //set anim mode to idle
    zombie zombie_setAnimMode("idle");
    
    //Start Zombie Logic
    zombie thread zombie_logic_health_think();
    zombie thread zombie_logic_attack_think();
    zombie thread zombie_logic_move_think();
    wait .2;
}