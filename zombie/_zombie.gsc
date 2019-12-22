init_zombie()
{
    level.zombie_freeze = false;
    
    
    
    level.zombie_types           = ["default","sprinter","exploder","crawler","jugger"];
    level.zombie_animation_types = ["idle","walk","run","sprint","death","melee"];
    level.zombie_model_types     = ["body","head","fullbody"];
    
    
    level.pix_zombies      = [];
    level.pix_zombie_count = 0;
    
    
    level waittill("aiz_loaded");
    
    
    //Body Models & Head Models are added/sorted in map\_map_edits.gsc
    
    
    //Animations
    //default/sprinter/exploder zombies
    addZombieAnimation("default","idle","pb_stand_alert");
    addZombieAnimation("default","walk","pb_walk_forward_shield");
    addZombieAnimation("default","walk","pb_combatwalk_forward_loop_pistol");
    addZombieAnimation("default","walk","pb_walk_forward_mg");
    addZombieAnimation("default","walk","pb_walk_forward_akimbo");
    addZombieAnimation("default","run","pb_run_fast");
    addZombieAnimation("default","run","pb_pistol_run_fast");
    addZombieAnimation("default","sprint","pb_sprint_akimbo");
    addZombieAnimation("default","sprint","pb_sprint_pistol");
    addZombieAnimation("default","death","pb_stand_death_leg_kickup");
    addZombieAnimation("default","death","pb_stand_death_shoulderback");
    addZombieAnimation("default","death","pb_death_run_stumble");
    addZombieAnimation("default","melee","pt_melee_pistol_1",0.5);
    addZombieAnimation("default","melee","pt_melee_pistol_2",1);
    addZombieAnimation("default","melee","pt_melee_pistol_3",0.6);
    addZombieAnimation("default","melee","pt_melee_pistol_4",0.5);
    
    //crawlers
    addZombieAnimation("crawler","idle","pb_prone_hold");
    addZombieAnimation("crawler","walk","pb_prone_crawl_akimbo");
    addZombieAnimation("crawler","death","pb_prone_death_quickdeath");
    
    //juggers
    addZombieAnimation("jugger","idle","pb_stand_alert");
    addZombieAnimation("jugger","walk","pb_walk_forward_mg");
    addZombieAnimation("jugger","death","pb_stand_death_leg_kickup");
    addZombieAnimation("jugger","death","pb_stand_death_shoulderback");
    addZombieAnimation("jugger","death","pb_death_run_stumble");
    addZombieAnimation("jugger","melee","pt_melee_pistol_1",0.5);
    addZombieAnimation("jugger","melee","pt_melee_pistol_2",1);
    addZombieAnimation("jugger","melee","pt_melee_pistol_3",0.6);
    addZombieAnimation("jugger","melee","pt_melee_pistol_4",0.5);
}




//Animation List Functions
addZombieAnimation(zombie_type,anim_type,anim_id,anim_time)
{
    if(!isValidZombieType(zombie_type)||!isValidZombieAnimationType(anim_type))
    {
        return;
    }
    if(!isDefined(level.zombie_animation))
    {
        level.zombie_animation = [];
    }
    if(!isDefined(level.zombie_animation[zombie_type]))
    {
        level.zombie_animation[zombie_type] = [];
    }
    if(!isDefined(level.zombie_animation[zombie_type][anim_type]))
    {
        level.zombie_animation[zombie_type][anim_type] = [];
    }
    i = level.zombie_animation[zombie_type][anim_type].size;
    level.zombie_animation[zombie_type][anim_type][i] = spawnStruct();
    level.zombie_animation[zombie_type][anim_type][i].id = anim_id;
    if(isDefined(anim_time))
    {
        level.zombie_animation[zombie_type][anim_type][i].time = anim_time;
    }
    else
    {
        level.zombie_animation[zombie_type][anim_type][i].time = undefined;
    }
}
getRandomZombieAnimation(zombie_type,anim_type)
{
    if(!isValidZombieType(zombie_type)||!isValidZombieAnimationType(anim_type))
    {
        return;
    }
    if(zombie_type=="default"||zombie_type=="sprinter"||zombie_type=="exploder")
    {
        zombie_type = "default";
    }
    return level.zombie_animation[zombie_type][anim_type][randomInt(level.zombie_animation[zombie_type][anim_type].size)];
}


//add Zombie Model--- only use in map\_map_edits.gsc
addZombieModel(zombie_type,model_type,model_id)
{
    if(!isValidZombieType(zombie_type)||!isValidZombieModelType(model_type))
    {
        return;
    }
    if(!isDefined(level.zombie_model))
    {
        level.zombie_model = [];
    }
    if(!isDefined(level.zombie_model[zombie_type]))
    {
        level.zombie_model[zombie_type] = [];
    }
    if(!isDefined(level.zombie_model[zombie_type][model_type]))
    {
        level.zombie_model[zombie_type][model_type] = [];
    }
    i = level.zombie_model[zombie_type][model_type].size;
    level.zombie_model[zombie_type][model_type][i] = spawnStruct();
    level.zombie_model[zombie_type][model_type][i].id = model_id;
}
getRandomZombieModel(zombie_type,model_type)
{
    if(!isValidZombieType(zombie_type)||!isValidZombieModelType(model_type))
    {
        return;
    }
    if(zombie_type=="default"||zombie_type=="sprinter"||zombie_type=="exploder")
    {
        zombie_type = "default";
    }
    return level.zombie_model[zombie_type][model_type][randomInt(level.zombie_model[zombie_type][model_type].size)];
}


//Zombie Spawnpoints
addZombieSpawnpoint(zombie_type,origin,angles)
{
    if(!isValidZombieType(zombie_type))
    {
        return;
    }
    if(!isDefined(level.zombie_spawnpoint))
    {
        level.zombie_spawnpoint = [];
    }
    if(!isDefined(level.zombie_spawnpoint[zombie_type]))
    {
        level.zombie_spawnpoint[zombie_type] = [];
    }
    i = level.zombie_spawnpoint[zombie_type].size;
    level.zombie_spawnpoint[zombie_type][i] = spawnStruct();
    level.zombie_spawnpoint[zombie_type][i].origin = origin;
    level.zombie_spawnpoint[zombie_type][i].angles = angles;
}
isZombieSpawnpointTypeDefined(zombie_type)
{
    if(!isValidZombieType(zombie_type))
    {
        return false;
    }
    if(level.zombie_spawnpoint[zombie_type].size>=1)
    {
        return true;
    }
    return false;
}
getRandomZombieSpawnpoint(zombie_type="default")
{
    if(!isValidZombieType(zombie_type))
    {
        return;
    }
    if(!isZombieSpawnpointTypeDefined(zombie_type))
    {
        zombie_type = "default";
    }
    return level.zombie_spawnpoint[zombie_type][randomInt(level.zombie_spawnpoint[zombie_type].size)];
}





//create and return zombie base
createZombieBase(type,spawnpoint,health,damage)
{
    if(!isValidZombieType(type))
    {
        iprintln("^1ERROR");
        return;
    }
    
    //Body
    base = spawn("script_model",spawnpoint);
    if(type!="jugger")
    {
        base setModel(getRandomZombieModel(type,"body").id);
    }
    else
    {
        base setModel(getRandomZombieModel(type,"fullbody").id);
    }
    
    //Hit Box
    base.hitbox = spawn("script_model",base getTagOrigin("j_spinelower")+(-5,0,0));
    base.hitbox setModel(level.aiz_asset["model"]["zombie_hitbox"]);
    base.hitbox.angles = (90,0,0);
    base.hitbox.team   = "axis";
    base.hitbox setCanDamage(true);
    base.hitbox.maxhealth = health;
    base.hitbox.health    = health;
    base.hitbox linkto(base,"j_spinelower");
    base.hitbox CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
    base.hitbox hide();
    
    //Head
    if(type!="jugger")
    {
        base.head = spawn("script_model",base getTagOrigin("j_spine4"));
        base.head setModel(getRandomZombieModel(type,"head").id);
        base.head.angles = (270,0,270);
        base.head.team   = "axis";
        base.head linkto(base,"j_spine4");
    }
    
    //Base Vars
    base.team           = "axis";
    base.type           = type;
    base.currentsurface = "default";
    base.pers["isAlive"] = true;
    base.targetname     = "zombie";
    base.classname      = "zombie";
    base.damage         = damage;
    base.current_target = undefined;
    base.speed          = 0;
    base.animMode       = "idle";
    base.anim_idle      = getRandomZombieAnimation(type,"idle").id;
    base.anim_walk      = getRandomZombieAnimation(type,"walk").id;
    if(type!="crawler"||type!="jugger")
    {
        base.anim_run = getRandomZombieAnimation(type,"run").id;
        if(type=="sprinter")
        {
            base.anim_sprint = getRandomZombieAnimation(type,"sprint").id;
        }
    }
    return base;
}


//Zombie set current anim mode
zombie_setAnimMode(mode="idle")
{
    if(mode=="idle")
    {
        self.animMode = "idle";
        self scriptModelPlayAnim(self.anim_idle);
        self.speed = 0;
    }
    else if(mode=="walk" && isDefined(self.anim_walk))
    {
        self.animMode = "walk";
        self scriptModelPlayAnim(self.anim_walk);
        self.speed = 5.0;
    }
    else if(mode=="run" && isDefined(self.anim_run))
    {
        self.animMode = "run";
        self scriptModelPlayAnim(self.anim_run);
        self.speed = 10.0;
    }
    else if(mode=="sprint" && isDefined(self.anim_sprint))
    {
        self.animMode = "sprint";
        self scriptModelPlayAnim(self.anim_sprint);
        self.speed = 15.0;
    }
    else
    {
        self.animMode = "idle";
        self scriptModelPlayAnim(self.anim_idle);
        self.speed = 0;
    }
}




addToZombieList(zombie)
{
    if(!isValidZombieType(zombie.type))
    {
        return;
    }
    i = level.pix_zombies.size;
    level.pix_zombies[i] = zombie;
    level.pix_zombie_count ++;
    level notify("update_active_zombies");
}
removeFromZombieList(zombie)
{
    if(!isValidZombieType(zombie.type))
    {
        return;
    }
    level.pix_zombie_count --;
    level notify("update_active_zombies");
}



isValidZombieType(type)
{
    for(i=0;i<level.zombie_types.size;i++)
    {
        if(level.zombie_types[i]==type)
        {
            return true;
        }
    }
    return false;
}
isValidZombieAnimationType(type)
{
    for(i=0;i<level.zombie_animation_types.size;i++)
    {
        if(level.zombie_animation_types[i]==type)
        {
            return true;
        }
    }
    return false;
}
isValidZombieModelType(type)
{
    for(i=0;i<level.zombie_model_types.size;i++)
    {
        if(level.zombie_model_types[i]==type)
        {
            return true;
        }
    }
    return false;
}