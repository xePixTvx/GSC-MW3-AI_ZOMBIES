zombie_logic_move_think()
{
    self.max_search_checks = 40;
    self.search_checks     = 0;
    self endon("zombie_died");
    for(;;)
    {
        self.current_target = self getBestTarget();
        
        
        //if target is not visible retry finding a new one 40 times if still not found respawn at a random spawnpoint --- thats mostly to fix the "player cannot find zombie bug" xD
        if(self.search_checks<self.max_search_checks && !level.zombie_freeze && !self zombie_canSee_Target(self.current_target))
        {
            self.search_checks ++;
        }
        if(self.search_checks>=self.max_search_checks)
        {
            //get random cause getting the best seems to be to much for 65+ zombies at the same time
            self.origin        = getRandomZombieSpawnpoint(self.type).origin;//getBestSpawnPoint(self);
            self.search_checks = 0;
            //go into search mode ---- ADD HERE
        }
        
        
        if(isDefined(self.current_target) && !level.zombie_freeze)
        {
            if(self zombie_canSee_Target(self.current_target))
            {
                self.search_checks = 0;//if target found and visible reset the check to 0
                self updateZombieMoveState("moving");
                
                //Move & Rotate
                self zombie_move(self.current_target.origin);
            }
            else
            {
                self updateZombieMoveState("idle");
            }
        }
        else
        {
            self updateZombieMoveState("idle");
        }
        wait 0.01;
    }
}








// -----------------------  Zombie Move  -----------------------
zombie_move(targetPos)
{
    self notify("zombie_move_done");
    self endon("zombie_move_done");
    self zombie_PushOutOfZombies();
    self zombie_ClampToGround();
    pos          = self.origin;
    target_pos   = targetPos;
    vec3_normal  = VectorNormalize(target_pos - self.origin);
    vec3_angles  = VectorToAngles(target_pos - self getTagOrigin("j_head"));
    moveToLoc    = pos + (vec3_normal*self.speed);
    rotate_angle = VectorToAngles(target_pos - self getTagOrigin("j_head"));
    self.origin  = moveToLoc;
    self RotateTo((0,rotate_angle[1],0),0.1);
    self notify("zombie_move_done");
}

zombie_ClampToGround()
{
    trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,self);
    if(isdefined(trace["entity"])&&isDefined(trace["entity"].targetname)&&trace["entity"].targetname=="zombie")
    {
        trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,trace["entity"]);
    }
    self.currentsurface = trace["surfacetype"];
    if(self.currentsurface=="none")
    {
        self.currentsurface = "default";
    }
    if((trace["position"][2]-(self.origin[2]-40))>0&&((self.origin[2]+50)-trace["position"][2])>0)
    {
        self.origin = trace["position"];
        return true;
    }
    return false;
}

//Stop Moving used for death,attack,hit... anims
//so they dont slide around while doing a death,attack,hit anim
zombie_stop_moving()
{
    self notify("zombie_move_done");
    self.speed  = 0;
    self.origin = self.origin;
}

updateZombieMoveState(state_type)
{
    if(state_type=="moving")
    {
        if(isDefined(self.canGetAggressive) && isDefined(self.isAggressive) && self.isAggressive)
        {
            if(self.animMode!="run")
            {
                self zombie_setAnimMode("run");
            }
        }
        else
        {
            if(self.type!="sprinter")
            {
                if(self.animMode!="walk")
                {
                    self zombie_setAnimMode("walk");
                }
            }
            else
            {
                if(self.animMode!="sprint")
                {
                    self zombie_setAnimMode("sprint");
                }
            }
        }
    }
    else if(state_type!="moving")
    {
        if(self.animMode!="idle")
        {
            self zombie_stop_moving();
            self zombie_setAnimMode("idle");
        }
    }
    else
    {
        if(self.animMode!="idle")
        {
            self zombie_stop_moving();
            self zombie_setAnimMode("idle");
        }
    }
}





// -----------------------  Zombie Target  -----------------------

//check if zombie can see a target
zombie_canSee_Target(target)
{
    start              = self getTagOrigin("j_head");
    target_head        = target getTagOrigin("j_head");
    target_neck        = target getTagOrigin("j_spine4");
    target_lower_spine = target getTagOrigin("j_spinelower");
    if(isSightCheck(start,target_head,self)||isSightCheck(start,target_neck,self)||isSightCheck(start,target_lower_spine,self))
    {
        return true;
    }
    return false;
}

//get best target ----- maybe do some last attacker checks????
getBestTarget()
{
    _target       = undefined;
    nearestPlayer = getNearestPlayer(self.origin);
    if(!nearestPlayer.isWaitingForNextWave)
    {
        _target = nearestPlayer;
    }
    return _target;
}

//get nearest player
getNearestPlayer(pos)
{
    nearestPlayer = -1;
    nearestDistance = 9999999999.0;
    for(i=0;i<level.players.size;i++)
    {
        distance = distance(pos,level.players[i].origin);
        if(distance<nearestDistance)
        {
            nearestDistance = distance;
            nearestPlayer   = level.players[i];
        }
    }
    return nearestPlayer;
}





// -----------------------  Common Functions  -----------------------
isSightCheck(start_origin,end_origin,ignore_ent=self)
{
    if(bulletTracePassed(start_origin,end_origin,false,ignore_ent))
    {
        return true;
    }
    return false;
}

//Push zombie away from player
zombie_PushOutOfPlayers()
{
    foreach(player in level.players)
    {
        if(!isReallyAlive(player) && player.isWaitingForNextWave)
        {
            continue;
        }
        _distance = distance(player.origin,self.origin);    
        if(_distance<=60)
        {
            pushOutDir = VectorNormalize((self.origin[0],self.origin[1],0)-(player.origin[0],player.origin[1],0));
            trace      = bulletTrace(self.origin+(0,0,20),(self.origin+(0,0,20))+(pushOutDir*((60-_distance)+10)),false,self);
            if(trace["fraction"]==1)
            {
                pushoutPos  = self.origin+(pushOutDir*(80-_distance));
                self.origin = (pushoutPos[0],pushoutPos[1],self.origin[2]); 
            }
        }
    }
}

//Push zombie away from other zombies
zombie_PushOutOfZombies()
{
    foreach(zombie in level.pix_zombies)
    {
        if(zombie zombie_getHealth()<=0||!zombie zombie_isAlive())
        {
            continue;
        }
        _distance = distance(zombie.origin,self.origin);    
        if(_distance<=50)
        {
            pushOutDir = VectorNormalize((self.origin[0],self.origin[1],0)-(zombie.origin[0],zombie.origin[1],0));
            trace      = bulletTrace(self.origin+(0,0,20),(self.origin+(0,0,20))+(pushOutDir*((50-_distance)+10)),false,self);
            if(trace["fraction"]==1)
            {
                pushoutPos  = self.origin+(pushOutDir*(50-_distance));
                self.origin = (pushoutPos[0],pushoutPos[1],self.origin[2]); 
            }
        }
    }
}