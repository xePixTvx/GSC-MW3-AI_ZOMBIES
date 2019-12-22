zombie_logic_attack_think()
{
    while(self.pers["isAlive"])
    {
        foreach(target in level.players)
        {
            if(distance(target.origin,self.origin) <= 50 && self.hasHead && !target.isWaitingForNextWave && !level.zombie_freeze)
            {
                melee_anim = getRandomZombieAnimation(self.type,"melee");
                self zombie_stop_moving();
                if(isDefined(melee_anim.id))
                {
                    self scriptModelPlayAnim(melee_anim.id);
                }
                if(level.DEV_SETTINGS["Zombies_No_Damage"])
                {
                    target thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,self.damage,0,"MOD_MELEE","none",target.origin,target.origin,"none",0,0);
                }
                self zombie_PushOutOfPlayers();//before fight anim wait
                if(isDefined(melee_anim.time))
                {
                    wait melee_anim.time;
                }
                else
                {
                    wait 0.5;
                }
                self zombie_PushOutOfPlayers();//after fight anim wait
                self zombie_setAnimMode(self.animMode);
            }
        }
        wait 0.01;
    }
}