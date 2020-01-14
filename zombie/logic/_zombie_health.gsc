zombie_logic_health_think()
{
    addToZombieList(self);
    self.hasHead = true;
    self endon("zombie_died");
    for(;;)
    {
        //wait for any damage
        self.hitbox waittill("damage",iDamage,attacker,iDFlags,vPoint,type,victim,vDir,sHitLoc,psOffsetTime,sWeapon);
        
        //ADD OWNER CHECK HERE
        
        //hitmarker + blood effect
        attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback("zombie");
        self thread zombie_blood_effect_at_hitpoint(vPoint,true);
        
        
        //check for headshot
        if(self zombie_isHeadShot(vPoint) && self.type!="crawler")//if it was a headshot(not for crawlers)
        {
            attacker thread giveMoney(self.hit_reward,self.headshot_reward);//give hit + headshot reward to attacker
            //attacker thread addStat("headshots",1);//add 1 headshot to the bonus system
            self.hitbox.health -= 150;
        }
        else//if it wasnt a headshot
        {
            attacker thread giveMoney(self.hit_reward);//give hit reward to attacker
        }
        
        
        //check if zombie is dead
        if(self zombie_getHealth()<=0 && self zombie_isAlive())
        {
            attacker thread giveMoney(self.kill_reward);//give kill reward to attacker
            //attacker thread addStat("kills",1);//add 1 kill to the bonus system
            
            if(self.type!="jugger")
            {
                //if killed by headshot zombie loses head
                randomHeadLostWalking = randomIntRange(1,6);//get a random number(1-6)
                if(self.hasHead && self zombie_isHeadShot(vPoint) && (self.type=="default"||self.type=="exploder"||self.type=="sprinter"))
                {
                    if(self.isAggressive)//if it is in aggressive mode set it to normal
                    {
                        self.isAggressive = false;
                    }
                    self thread zombie_lose_head();
                    wait 0.05;
                    if(randomHeadLostWalking==4)//some zombies continue walking after losing head but dont attack anymore
                    {
                        self zombie_noHead_blood_fountain(randomIntRange(2,6));
                    }
                }
            }
            self thread zombie_doDeath();
        }
        
        
        //check for aggressive mode
        if(isDefined(self.canGetAggressive) && isDefined(self.isAggressive))
        {
            if(self.canGetAggressive && self.hasHead)
            {
                if(!self.isAggressive)
                {
                    self.isAggressive = true;
                }
            }
        }
        
        
    }
}




zombie_doDeath()
{
    self notify("zombie_died");
    if(self.type!="jugger")
    {
        //self thread _zombie_do_drop();
    }
    self.pers["isAlive"] = false;
    wait .1;
    if(isDefined(self.hitbox))
    {
        self.hitbox delete();//delete hitbox so players dont get blocked by it
    }
    self zombie_stop_moving();
    self scriptModelPlayAnim(getRandomZombieAnimation(self.type,"death").id);
    if(self.type=="crawler")//crawlers go to heaven
    {
        wait 2;
        self MoveTo(self.origin+(0,0,3000),4);
    }
    if(self.type=="exploder")
    {
        wait 0.05;
        self zombie_do_c4_explosion();
    }
    wait 5;
    removeFromZombieList(self);
    if(self.type=="exploder")
    {
        self.effect_c4_blink delete();
        self.c4 delete();
    }
    if(isDefined(self.head))
    {
        self.head delete();//delete head
    }
    self delete();//delete the rest
}

//Zombie Lose Head
zombie_lose_head()
{
    self.hasHead = false;
    self.head unlink();
    x = randomintrange(50,150);
    y = randomintrange(50,150);
    z = randomintrange(50,150);
    if(cointoss())
    {
        x *= -1;
    }
    else
    {
        y *= -1;
    }
    self.head MoveGravity((x,y,z),2);
    self.hitbox delete();//headless zombies dont have a collision + cant attack anymore --- removing collision so they dont block the player
    self.pers["isAlive"] = false;//also set them as dead here cause helis,sentrys.... will still look for the hitbox(collision)
    //self.head PhysicsLaunchServer((x,y,z),(x,y,z));
}

zombie_isHeadShot(vPoint)
{
    if(vPoint[2]>=self getTagOrigin("j_spine4")[2])
    {
        return true;
    }
    return false;
}
zombie_getHealth()
{
    return self.hitbox.health;
}
zombie_isAlive()
{
    if(self.pers["isAlive"])
    {
        return true;
    }
    return false;
}
zombie_blood_effect_at_hitpoint(vPoint)
{
    playFx(level.aiz_asset["effect"]["zombie_blood_default"],vPoint);
    playFx(level.aiz_asset["effect"]["zombie_blood_default"],vPoint);
    playFx(level.aiz_asset["effect"]["zombie_blood_default"],vPoint);
    playFx(level.aiz_asset["effect"]["zombie_blood_default"],vPoint);
}
zombie_noHead_blood_fountain(times)
{
    for(i=0;i<times;i++)
    {
        playFx(level.aiz_asset["effect"]["zombie_blood_no_head"],self getTagOrigin("j_spine4"));
        playFx(level.aiz_asset["effect"]["zombie_blood_no_head"],self getTagOrigin("j_spine4"));
        wait 0.8;
    }
}
zombie_do_c4_explosion()
{
    self.c4 playSound("semtex_warning");
    wait 2;
    self.c4 playSound("detpack_explo_default");
    playFx(level.aiz_asset["effect"]["zombie_explode"],self.c4 getTagOrigin("tag_fx"));
    RadiusDamage(self.c4 getTagOrigin("tag_fx"),200,180,50,self);
    PlayRumbleOnPosition("grenade_rumble",self.c4 getTagOrigin("tag_fx"));
    earthquake(0.4,0.75,self.c4 getTagOrigin("tag_fx"),512);
}