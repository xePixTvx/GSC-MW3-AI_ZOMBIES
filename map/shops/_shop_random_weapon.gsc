addRandomWeaponShop(pos,angle)
{
    if(!isDefined(level.shop_info))
    {
        level.shop_info = [];
    }
    level.shop_info["random_weapon"] = spawnStruct();
    addRandomWeaponShopPos(pos,angle);
    level.shop_info["random_weapon"].headIcon = level.aiz_asset["shader"]["shop_headicon_random_weapon"];
    level.shop_info["random_weapon"].lowMsg = "Press ^3[{+activate}]^7 to buy a random Weapon[^2"+level.AIZ_SETTINGS["shop"]["price_random_weapon"]+"$^7]";
    level.shop_info["random_weapon"].mainFunction = ::shop_random_weapon_main;
    level.shop_info["random_weapon"].isWorking = false;
    level.shop_info["random_weapon"].selectedWeapon = undefined;
}
addRandomWeaponShopPos(pos,angle)
{
    if(!isDefined(level.shop_info["random_weapon"].pos))
    {
        level.shop_info["random_weapon"].pos = [];
    }
    if(!isDefined(level.shop_info["random_weapon"].angle))
    {
        level.shop_info["random_weapon"].angle = [];
    }
    i = level.shop_info["random_weapon"].pos.size;
    level.shop_info["random_weapon"].pos[i] = pos;
    level.shop_info["random_weapon"].angle[i] = angle;
}
getRandomWeaponShopPosNumber()
{
    return randomInt(level.shop_info["random_weapon"].pos.size);
}

shop_random_weapon_main(type,shop_crate,default_lowMsg)
{
    if(!level.shop_info["random_weapon"].isWorking && !isDefined(level.shop_info["random_weapon"].selectedWeapon))
    {
        self setLowerMessage(type + "_shop_lowMsg",default_lowMsg);
        if(self UseButtonPressed())
        {
            self thread shop_buy_random_weapon(shop_crate);
            return true;
        }
    }
    else if(level.shop_info["random_weapon"].isWorking && !isDefined(level.shop_info["random_weapon"].selectedWeapon))
    {
        self setLowerMessage(type + "_shop_lowMsg","^1Selecting Weapon please wait.....");
    }
    else if(level.shop_info["random_weapon"].isWorking && isDefined(level.shop_info["random_weapon"].selectedWeapon))
    {
        self setLowerMessage(type + "_shop_lowMsg","Press ^3[{+activate}]^7 to switch Weapons");
        if(self UseButtonPressed())
        {
            self giveWeaponFromList(level.shop_info["random_weapon"].selectedWeapon);
            level notify("random_weapon_shop_continue");
            return true;
        }
    }
    return false;
}

shop_buy_random_weapon(shop_crate)
{
    //Money Stuff
    if(!self hasEnoughMoney(level.AIZ_SETTINGS["shop"]["price_random_weapon"]))
    {
        self iprintlnBold("^1NOT ENOUGH MONEY!");
        return;
    }
    self takeMoney(level.AIZ_SETTINGS["shop"]["price_random_weapon"]);
    
    //set Shop is currently working
    level.shop_info["random_weapon"].isWorking = true;
    
    //buyers current weapon gets ignored
    ignore_weapon = self getBaseWeaponName(self getCurrentWeapon());
    
    //Get random weapon
    magic_gun = getRandomWeaponFromList(ignore_weapon);
    
    //Create model of random weapon(magic_gun)
    preview_gun = spawnGunModel(shop_crate.origin,shop_crate.angles,magic_gun+"_mp");
    
    //Move model out of crate(magic_gun)
    preview_gun MoveTo(preview_gun.origin+(0,0,30),3);
    wait 3;
    
    //get random number for selecting cycle
    random_cycle = randomIntRange(10,25);
    for(i=0;i<random_cycle;i++)
    {
        //every cycle = new random weapon + showing the weapon model
        magic_gun = getRandomWeaponFromList(ignore_weapon);
        preview_gun setModel(getWeaponModel(magic_gun+"_mp"));
        wait .2;
    }
    
    //Selected weapon
    level.shop_info["random_weapon"].selectedWeapon = magic_gun;
    
    //Start timer --- if nobody picked up weapon in 15 seconds just remove it
    level thread SERVER_notify_after_time_period(15,"random_weapon_shop_continue");
    
    //wait for timer to be over or weapon is takken
    level waittill("random_weapon_shop_continue");
    
    //set selected weapon to undefined
    level.shop_info["random_weapon"].selectedWeapon = undefined;
    
    //move weapon model into the crate + delete it
    preview_gun MoveTo(preview_gun.origin-(0,0,30),2);
    wait 2;
    preview_gun delete();
    
    //select new random position for the shop crate
    //if not found or it is the same position do nothing
    //if new position found move crate down,teleport it to new position and move it up
    rand      = getRandomWeaponShopPosNumber();
    new_pos   = level.shop_info["random_weapon"].pos[rand] + (0,0,16);
    new_angle = level.shop_info["random_weapon"].angle[rand];
    if(new_pos!=shop_crate.origin)
    {
        shop_crate.entityHeadIcon.alpha = 0;
        shop_crate MoveTo(shop_crate.origin-(0,0,100),4);
        wait 4;
        shop_crate.angles = new_angle;
        shop_crate.origin = new_pos-(0,0,100);
        wait 0.05;
        shop_crate MoveTo(new_pos,4);
        wait 4;
        shop_crate.entityHeadIcon.alpha = 1;
    }
    
    //set Shop is currently not working so it can be used again
    level.shop_info["random_weapon"].isWorking = false;
}