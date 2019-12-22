setArmor(value)
{
    if(value>level.AIZ_SETTINGS["player"]["max_armor"])
    {
        value = level.AIZ_SETTINGS["player"]["max_armor"];
    }
    self.Armor = value;
    self notify("armor_update");
}

giveArmor(value)
{
    total = self.Armor + value;
    if(total>level.AIZ_SETTINGS["player"]["max_armor"])
    {
        self setArmor(level.AIZ_SETTINGS["player"]["max_armor"]);
        self iprintlnBold("^4Max Armor");
        return;
    }
    self thread mainHudArmorNotify(value,&"Armor +",(0,0,1));
    self.Armor += value;
    self notify("armor_update");
}

PLAYER_armor_monitor()
{
    self endon("disconnect");
    self endon("death");
    for(;;)
    {
        self waittill("damage",damage);
        if(self.Armor>0)
        {
            remaining_armor = self.Armor - damage;
            self.health     = self.maxHealth;
            if(remaining_armor>0)
            {
                self.Armor -= damage;
            }
            else
            {
                self.Armor = 0;
            }
        }
        self notify("armor_update");
    }
}