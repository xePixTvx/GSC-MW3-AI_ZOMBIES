addRefillAmmoShop(pos,angle)
{
    if(!isDefined(level.shop_info))
    {
        level.shop_info = [];
    }
    level.shop_info["refill_ammo"] = spawnStruct();
    level.shop_info["refill_ammo"].pos = pos;
    level.shop_info["refill_ammo"].angle = angle;
    level.shop_info["refill_ammo"].headIcon = level.aiz_asset["shader"]["shop_headicon_refill_ammo"];
    level.shop_info["refill_ammo"].lowMsg = "Press ^3[{+activate}]^7 to Refill Current Weapon's Ammo[^2"+level.AIZ_SETTINGS["shop"]["price_refill_ammo"]+"$^7]";
    level.shop_info["refill_ammo"].mainFunction = ::shop_refill_ammo_main;
}

shop_refill_ammo_main(type,shop_crate,default_lowMsg)
{
    self setLowerMessage(type + "_shop_lowMsg",default_lowMsg);
    if(self UseButtonPressed())
    {
        self thread shop_buy_refill_ammo();
        return true;
    }
    return false;
}


shop_buy_refill_ammo()
{
    //Money Stuff
    if(!self hasEnoughMoney(level.AIZ_SETTINGS["shop"]["price_refill_ammo"]))
    {
        self iprintlnBold("^1NOT ENOUGH MONEY!");
        return;
    }
    self takeMoney(level.AIZ_SETTINGS["shop"]["price_refill_ammo"]);
    
    
    //Get Weapon List
    weapons = self getWeaponsListPrimaries();
    
    //Refill Ammo for every weapon in players weapon list
    foreach(weapon in weapons)
    {
        if(weapon!="none")
        {
            if(isSubStr(weapon,"_akimbo"))
            {
                self setWeaponAmmoClip(weapon,9999,"left");
                self setWeaponAmmoClip(weapon,9999,"right");
            }
            else
            {
                self setWeaponAmmoClip(weapon,9999);
            }
            self GiveMaxAmmo(weapon);
        }
    }
    self iprintlnBold("^2AMMO REFILLED!");
}