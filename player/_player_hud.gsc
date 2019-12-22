PLAYER_createHud()
{
    if(!isDefined(self.Hud))
    {
        self.Hud = [];
    }
    
    self thread createWeaponHud();
    self thread createMainHud();
}

PLAYER_destroyHud()
{
    //Weapon Hud
    self.Hud["weapon_divider"] destroy();
    self.Hud["weapon_ammo"] destroy();
    self.Hud["weapon_clip1"] destroy();
    if(isDefined(self.Hud["weapon_clip2"]))
    {
        self.Hud["weapon_clip2"] destroy();
    }
    self.Hud["weapon_name"] destroy();
    self.Hud["weapon_attachment_name"] destroy();
    
    
    //Main Hud
    self.Hud["main_money"] destroy();
    self.Hud["main_armor"] destroy();
    self.Hud["main_money_notify"] destroy();
    self.Hud["main_headshot_notify"] destroy();
    self.Hud["main_armor_notify"] destroy();
    
    
    self notify("player_hud_destroyed");
}



//Player Main Hud
createMainHud()
{
    if(!isDefined(self.Hud["main_money"]))
    {
        self.Hud["main_money"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,28,(1,1,1),0,(0.3,0.6,0.3),1);
        self.Hud["main_money"].label = &"$";
        self.Hud["main_money"] setValue(self.Money);
        self.Hud["main_money"].hideWhenInMenu = true;
    }
    
    if(!isDefined(self.Hud["main_armor"]))
    {
        self.Hud["main_armor"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,8,(1,1,1),0,(0,0,1),1);
        self.Hud["main_armor"].label = &"Armor: ";
        self.Hud["main_armor"] setValue(self.Armor);
        self.Hud["main_armor"].hideWhenInMenu = true;
    }
    
    if(!isDefined(self.Hud["main_money_notify"]))
    {
        self.Hud["main_money_notify"] = createText("objective",1.5,"CENTER","CENTER",0,-20,(0,1,0),0,(0,1,0),0);
        self.Hud["main_money_notify"].label = &"MP_PLUS";
        self.Hud["main_money_notify"] setValue(0);
        self.Hud["main_money_notify"].hideWhenInMenu = true;
        self.money_update = 0;
    }
    
    if(!isDefined(self.Hud["main_headshot_notify"]))
    {
        self.Hud["main_headshot_notify"] = createText("objective",1.5,"CENTER","CENTER",0,-38,(1,1,1),0,(0,1,0),0);
        self.Hud["main_headshot_notify"].label = &"Headshot ^2+";
        self.Hud["main_headshot_notify"] setValue(0);
        self.Hud["main_headshot_notify"].hideWhenInMenu = true;
        self.headshot_update = 0;
    }
    
    if(!isDefined(self.Hud["main_armor_notify"]))
    {
        self.Hud["main_armor_notify"] = createText("objective",1.5,"CENTER","CENTER",0,40,(0,0,1),0,(0,1,0),0);
        self.Hud["main_armor_notify"].label = &"+";
        self.Hud["main_armor_notify"] setValue(0);
        self.Hud["main_armor_notify"].hideWhenInMenu = true;
        self.armor_update = 0;
    }
    
    
    
    self.Hud["main_money"] elemFadeOverTime(.4,1);
    self.Hud["main_armor"] elemFadeOverTime(.4,1);
    wait .5;
    
    self thread mainHud_armor_hud_monitor();
}

mainHud_armor_hud_monitor()
{
    self endon("disconnect");
    self endon("death");
    self endon("player_hud_destroyed");
    for(;;)
    {
        self waittill("armor_update");
        if(self.Hud["main_armor"].alpha==0)
        {
            if(self.Armor>0)
            {
                self.Hud["main_armor"] elemFadeOverTime(.4,1);
            }
        }
        else
        {
            if(self.Armor<=0)
            {
                self.Hud["main_armor"] elemFadeOverTime(.4,0);
            }
        }
        self.Hud["main_armor"] setValue(self.Armor);
    }
}
mainHudMoneyNotify(amount,label,color)
{
    self notify("money_notify");
    self endon("money_notify");
    self.money_update += amount;
    self.Hud["main_money_notify"].label = label;
    self.Hud["main_money_notify"].color = color;
    self.Hud["main_money_notify"] setValue(self.money_update);
    self.Hud["main_money_notify"].alpha = 1;
    wait .5;
    self.Hud["main_money_notify"] fadeOverTime(.4);
    self.Hud["main_money_notify"].alpha = 0;
    wait .4;
    self.money_update = 0;
}
mainHudHeadShotMoneyNotify(amount)
{
    self notify("headshot_notify");
    self endon("headshot_notify");
    self.headshot_update += amount;
    self.Hud["main_headshot_notify"].label = &"Headshot ^2+";
    self.Hud["main_headshot_notify"].color = (1,1,1);
    self.Hud["main_headshot_notify"] setValue(self.headshot_update);
    self.Hud["main_headshot_notify"].alpha = 1;
    wait .5;
    self.Hud["main_headshot_notify"] fadeOverTime(.4);
    self.Hud["main_headshot_notify"].alpha = 0;
    wait .4;
    self.headshot_update = 0;
}
mainHudArmorNotify(amount,label,color)
{
    self notify("armor_notify");
    self endon("armor_notify");
    self.armor_update += amount;
    self.Hud["main_armor_notify"].label = label;
    self.Hud["main_armor_notify"].color = color;
    self.Hud["main_armor_notify"] setValue(self.armor_update);
    self.Hud["main_armor_notify"].alpha = 1;
    wait .5;
    self.Hud["main_armor_notify"] fadeOverTime(.4);
    self.Hud["main_armor_notify"].alpha = 0;
    wait .4;
    self.armor_update = 0;
}










//Player Weapon Hud
createWeaponHud()
{
    if(!isDefined(self.Hud["weapon_divider"]))
    {
        self.Hud["weapon_divider"] = createRectangle("RIGHT","CENTER",370,208,300,30,(1,1,1),0,level.aiz_asset["shader"]["player_weapon_hud_divider"]);
        self.Hud["weapon_divider"].hideWhenInMenu = true;
    }
    
    if(!isDefined(self.Hud["weapon_ammo"]))
    {
        self.Hud["weapon_ammo"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",640,7,(1,1,1),0,(0,0,0),0);
        self.Hud["weapon_ammo"].label = &"/^7";
        self.Hud["weapon_ammo"] setValue(self getWeaponAmmoStock(self getCurrentWeapon()));
        self.Hud["weapon_ammo"].hideWhenInMenu = true;
    }
    
    if(isSubStr(self getCurrentWeapon(),"_akimbo"))
    {
        if(!isDefined(self.Hud["weapon_clip1"]))
        {
            self.Hud["weapon_clip1"] = createText("objective",1.0,"BOTTOMLEFT","BOTTOMLEFT",self.Hud["weapon_ammo"].x-8,7,(1,1,1),0,(0,0,0),0);
            self.Hud["weapon_clip1"].hideWhenInMenu = true;
            self setClipValueAndXPosition(self getWeaponAmmoClip(self getCurrentWeapon()),"right",true);
        }
        if(!isDefined(self.Hud["weapon_clip2"]))
        {
            self.Hud["weapon_clip2"] = createText("objective",1.0,"BOTTOMLEFT","BOTTOMLEFT",self.Hud["weapon_ammo"].x-8,-1,(1,1,1),0,(0,0,0),0);
            self.Hud["weapon_clip2"].hideWhenInMenu = true;
            self setClipValueAndXPosition(self getWeaponAmmoClip(self getCurrentWeapon(),"left"),"left",true);
        }
    }
    else
    {
        if(!isDefined(self.Hud["weapon_clip1"]))
        {
            self.Hud["weapon_clip1"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",self.Hud["weapon_ammo"].x-10,7,(1,1,1),0,(0,0,0),0);
            self.Hud["weapon_clip1"].hideWhenInMenu = true;
            self setClipValueAndXPosition(self getWeaponAmmoClip(self getCurrentWeapon()));
        }
    }
    
    if(!isDefined(self.Hud["weapon_name"]))
    {
        self.Hud["weapon_name"] = createText("objective",1.5,"BOTTOMRIGHT","BOTTOMRIGHT",-40,28,(1,1,1),0,(0,0,0),0,getWeaponNameString(self getBaseWeaponName(self getCurrentWeapon())));
        self.Hud["weapon_name"].hideWhenInMenu = true;
    }
    
    if(!isDefined(self.Hud["weapon_attachment_name"]))
    {
        self.Hud["weapon_attachment_name"] = createText("objective",1.0,"BOTTOMLEFT","BOTTOMLEFT",self.Hud["weapon_ammo"].x-200,7,(1,1,1),0,(0,0,0),0);
        self.Hud["weapon_attachment_name"].hideWhenInMenu = true;
        if(self currentWeapon_getCurrentInstalledAttachment()!="none")
        {
            self.Hud["weapon_attachment_name"] _setText(getAttachmentNameString(self currentWeapon_getCurrentInstalledAttachment()));
        }
    }
    
    self.Hud["weapon_divider"] elemFadeOverTime(.4,1);
    self.Hud["weapon_ammo"] elemFadeOverTime(.4,1);
    self.Hud["weapon_clip1"] elemFadeOverTime(.4,1);
    if(isDefined(self.Hud["weapon_clip2"]))
    {
        self.Hud["weapon_clip2"] elemFadeOverTime(.4,1);
    }
    self.Hud["weapon_name"] elemFadeOverTime(.4,1);
    self.Hud["weapon_attachment_name"] elemFadeOverTime(.4,1);
    wait .5;
    self thread weaponHudMonitor();
}

weaponHudMonitor()
{
    self thread weaponHudNameMonitor();
    self endon("disconnect");
    self endon("death");
    self endon("player_hud_destroyed");
    for(;;)
    {
        maxAmmo            = int(WeaponMaxAmmo(self getCurrentWeapon())/2);
        maxClip            = int(WeaponClipSize(self getCurrentWeapon())/2);
        current_clip_right = self getWeaponAmmoClip(self getCurrentWeapon());
        current_clip_left  = self getWeaponAmmoClip(self getCurrentWeapon(),"left");
        current_ammo       = self getWeaponAmmoStock(self getCurrentWeapon());
        
        //Update Low Ammo/Clip Colors
        if(current_ammo<maxAmmo)
        {
            self.Hud["weapon_ammo"].label = &"/^1";
        }
        else
        {
            self.Hud["weapon_ammo"].label = &"/^7";
        }
        if(current_clip_right<maxClip)
        {
            if(self.Hud["weapon_clip1"].color!=((253/255),(85/255),(95/255)))
            {
                self.Hud["weapon_clip1"].color = ((253/255),(85/255),(95/255));
            }
        }
        else
        {
            if(self.Hud["weapon_clip1"].color!=(1,1,1))
            {
                self.Hud["weapon_clip1"].color = (1,1,1);
            }
        }
        if(isDefined(self.Hud["weapon_clip2"]))
        {
            if(current_clip_left<maxClip)
            {
                if(self.Hud["weapon_clip2"].color!=((253/255),(85/255),(95/255)))
                {
                    self.Hud["weapon_clip2"].color = ((253/255),(85/255),(95/255));
                }
            }
            else
            {
                if(self.Hud["weapon_clip2"].color!=(1,1,1))
                {
                    self.Hud["weapon_clip2"].color = (1,1,1);
                }
            }
        }
        
        
        
        if(isDefined(self.Hud["weapon_clip2"]))
        {
            self setClipValueAndXPosition(current_clip_right,"right",true);
            self setClipValueAndXPosition(current_clip_left,"left",true);
        }
        else
        {
            self setClipValueAndXPosition(current_clip_right);
        }
        self.Hud["weapon_ammo"] setValue(current_ammo);
        wait 0.05;
    }
}
weaponHudNameMonitor()
{
    self endon("disconnect");
    self endon("death");
    self endon("player_hud_destroyed");
    for(;;)
    {
        self waittill("weapon_change",weapon);
        if(isSubStr(weapon,"_akimbo"))
        {
            if(!isDefined(self.Hud["weapon_clip2"]))
            {
                self.Hud["weapon_clip1"].fontscale = 1.0;
                self.Hud["weapon_clip2"] = createText("objective",1.0,"BOTTOMLEFT","BOTTOMLEFT",self.Hud["weapon_ammo"].x-8,-1,(1,1,1),1,(0,0,0),0);
                self.Hud["weapon_clip2"].hideWhenInMenu = true;
                self setClipValueAndXPosition(self getWeaponAmmoClip(self getCurrentWeapon(),"left"),"left",true);
            }
        }
        else
        {
            self.Hud["weapon_clip2"] destroy();
            self.Hud["weapon_clip1"].fontscale = 1.5;
        }
        if(self currentWeapon_getCurrentInstalledAttachment()!="none")
        {
            self.Hud["weapon_attachment_name"].alpha = 1;
            self.Hud["weapon_attachment_name"] _setText(getAttachmentNameString(self currentWeapon_getCurrentInstalledAttachment()));
            self thread weaponHudHideAttachmentNameAfterTime();
        }
        else
        {
            self.Hud["weapon_attachment_name"].alpha = 0;
            self.Hud["weapon_attachment_name"] _setText("");
        }
        self.Hud["weapon_name"] _setText(getWeaponNameString(self getBaseWeaponName(self getCurrentWeapon())));
    }
}
setClipValueAndXPosition(value,clip="right",akimbo=false)
{
    if(value<10)
    {
        if(!akimbo)
        {
            minusX = 10;
        }
        else
        {
            minusX = 8;
        }
    }
    else if(value>=10 && value<=99)
    {
        if(!akimbo)
        {
            minusX = 20;
        }
        else
        {
            minusX = 14;
        }
    }
    else if(value>99 && value<=999)
    {
        if(!akimbo)
        {
            minusX = 28;
        }
        else
        {
            minusX = 24;
        }
    }
    else
    {
        if(!akimbo)
        {
            minusX = 36;
        }
        else
        {
            minusX = 34;
        }
    }
    if(clip=="right")
    {
        self.Hud["weapon_clip1"] setValue(value);
        self.Hud["weapon_clip1"].x = self.Hud["weapon_ammo"].x-minusX;
    }
    else
    {
        self.Hud["weapon_clip2"] setValue(value);
        self.Hud["weapon_clip2"].x = self.Hud["weapon_ammo"].x-minusX;
    }
}
weaponHudHideAttachmentNameAfterTime()
{
    self endon("disconnect");
    self endon("death");
    self endon("player_hud_destroyed");
    self endon("weapon_change");
    wait 4;
    self.Hud["weapon_attachment_name"] elemFadeOverTime(.7,0);
    wait .8;
}