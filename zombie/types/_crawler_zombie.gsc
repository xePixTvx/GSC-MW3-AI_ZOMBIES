spawnCrawlerZombie(health,damage,kill_reward=50,hit_reward=5)
{
    //Create Base Zombie
    spawnPoint         = getRandomZombieSpawnpoint("crawler");
    zombie             = createZombieBase("crawler",spawnPoint.origin,health,damage);
    zombie.kill_reward = kill_reward;
    zombie.hit_reward  = hit_reward;
    
    //set anim mode to idle
    zombie zombie_setAnimMode("idle");
    
    //Start Zombie Logic
    zombie thread zombie_logic_health_think();
    zombie thread zombie_logic_attack_think();
    zombie thread zombie_logic_move_think();
    wait .2;
}