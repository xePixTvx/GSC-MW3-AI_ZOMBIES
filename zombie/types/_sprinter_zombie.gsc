spawnSprinterZombie(health,damage,kill_reward=50,hit_reward=5,headshot_reward=20)
{
    //Create Base Zombie
    spawnPoint             = getRandomZombieSpawnpoint("sprinter");
    zombie                 = createZombieBase("sprinter",spawnPoint.origin,health,damage);
    zombie.kill_reward     = kill_reward;
    zombie.hit_reward      = hit_reward;
    zombie.headshot_reward = headshot_reward;
    
    //Start Zombie Logic
    zombie thread zombie_logic_health_think();
    zombie thread zombie_logic_attack_think();
    zombie thread zombie_logic_move_think();
    
    //set anim mode to idle
    zombie zombie_setAnimMode("idle");
    
    //add to list
    thread addToZombieList(zombie);
}