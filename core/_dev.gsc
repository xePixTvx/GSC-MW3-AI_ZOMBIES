init_developer_mode()
{
    precacheModel(level.DEV_SETTINGS["TEST_MODEL"]);
    level thread DEVELOPER_Connect();
}
DEVELOPER_Connect()
{
    for(;;)
    {
        level waittill("connected",player);
        if(player isHost())
        {
            player thread DEVELOPER_initButtons();
            player thread DEVELOPER_Spawned();
        }
    }
}
DEVELOPER_Spawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if(self isHost())
        {
            self iprintln("^1DEVELOPER MODE: ^2ACTIVE");
            if(!isDefined(self.dev_action_monitor_started)||!self.dev_action_monitor_started)
            {
                self thread DEVELOPER_monitorActions();
            }
            if(isDefined(level.DEV_SETTINGS["GIVE_WEAPON"]))
            {
                self giveWeapon(level.DEV_SETTINGS["GIVE_WEAPON"]);
            }
        }
    }
}
DEVELOPER_initButtons()
{
    buttons = strTok("ufo|+actionslot 3;unlimited_ammo|+actionslot 4;god|+actionslot 5;locPrint|+actionslot 6;modelPrint|+actionslot 7;spawnTestModel|+activate;entPrint|+scores;zombie_test|+gostand;clear_prints|+back",";");
    foreach(buttonAction in buttons)
    {
        button = strTok(buttonAction,"|");
        self thread DEVELOPER_monitorButtons(button[0],button[1]);
    }
}
DEVELOPER_monitorButtons(action,button)
{
    self notifyOnPlayerCommand(action,button);
    for(;;)
    {
        self waittill(action);
        self notify("dev_action",action);
    }
}
DEVELOPER_monitorActions()
{
    self.dev_action_monitor_started = true;
    self.dev_info_hud               = [];
    dev_info                        = [];
    dev_info[0] = "^3--------------^1 DEV BINDS ^3--------------";
    dev_info[1] = "^3[{+speed_throw}]^7 + ^3[{+actionslot 3}]^7 - Ufo Mode";
    dev_info[2] = "^3[{+speed_throw}]^7 + ^3[{+actionslot 4}]^7 - Unlimited Ammo";
    dev_info[3] = "^3[{+speed_throw}]^7 + ^3[{+actionslot 5}]^7 - Godmode";
    dev_info[4] = "^3[{+speed_throw}]^7 + ^3[{+actionslot 6}]^7 - Print: Origin + Angles";
    dev_info[5] = "^3[{+speed_throw}]^7 + ^3[{+actionslot 7}]^7 - Print: Player Models";
    dev_info[6] = "^3[{+speed_throw}]^7 + ^3[{+scores}]^7 - Print: Model Entities";
    dev_info[7] = "^3[{+speed_throw}]^7 + ^3[{+activate}]^7 - Spawn Test Model";
    dev_info[8] = "^3[{+speed_throw}]^7 + ^3[{+gostand}]^7 - Test Function";
    dev_info[9] = "^3[{+speed_throw}]^7 + ^3[{+back}]^7 - Clear Prints";
    for(i=0;i<dev_info.size;i++)
    {
        self.dev_info_hud[i] = createText("console",1.0,"TOPLEFT","TOPLEFT",-55,100+(12*i),(1,1,1),1,(0,0,0),0,dev_info[i]);
        self.dev_info_hud[i] elemSetSort(115);
    }
    self.dev_print_hud      = createText("default",1.5,"CENTER","CENTER",0,0,(1,1,1),1,(0,0,0),0,"");
    self.dev_ufo            = false;
    self.dev_unlimited_ammo = false;
    self.dev_god            = false;
    self.dev_testModel      = spawn("script_model",self.origin);
    self.dev_entCycle       = -1;
    self.dev_entArray       = [];
    ents                    = getEntArray();
    for(i=0;i<ents.size;i++)
    {
        if(isDefined(ents[i].model) && ents[i].model!="")
        {
            s = self.dev_entArray.size;
            self.dev_entArray[s] = ents[i];
            self.dev_entArray[s].id = i;
        }
    }
    self thread DEVELOPER_monitorFunctions();
    self endon("disconnect");
    for(;;)
    {
        self waittill("dev_action",action);
        if(action=="ufo" && self AdsButtonPressed())
        {
            if(!self.dev_ufo)
            {
                self.dev_ufo_ent = spawn("script_origin",self.origin);
                self playerLinkTo(self.dev_ufo_ent);
                self.dev_ufo = true;
                self iprintln("UFO MODE: ^2ON");
            }
            else
            {
                self.dev_ufo = false;
                self unLink();
                self.dev_ufo_ent delete();
                self iprintln("UFO MODE: ^1OFF");
            }
        }
        else if(action=="unlimited_ammo" && self AdsButtonPressed())
        {
            if(!self.dev_unlimited_ammo)
            {
                self.dev_unlimited_ammo = true;
                self iprintln("UNLIMITED AMMO: ^2ON");
            }
            else
            {
                self.dev_unlimited_ammo = false;
                self iprintln("UNLIMITED AMMO: ^1OFF");
            }
        }
        else if(action=="god" && self AdsButtonPressed())
        {
            if(!self.dev_god)
            {
                self.dev_god = true;
                self iprintln("GODMODE: ^2ON");
            }
            else
            {
                self.dev_god   = false;
                self.maxHealth = 100;
                self.health    = self.maxHealth;
                self iprintln("GODMODE: ^1OFF");
            }
        }
        else if(action=="locPrint" && self AdsButtonPressed())
        {
            self.dev_print_hud _setText("Origin: ^1" + self.origin  + "\n^7Angles: ^1" + self getPlayerAngles());
        }
        else if(action=="modelPrint" && self AdsButtonPressed())
        {
            self.dev_print_hud _setText("Body: ^1" + self.model + "\n^7Head: ^1"+self getAttachModelName(0));
        }
        else if(action=="spawnTestModel" && self AdsButtonPressed())
        {
            self.dev_testModel.origin = self.origin;
            self.dev_testModel.angles = self getPlayerAngles();
            self.dev_testModel setModel(level.DEV_SETTINGS["TEST_MODEL"]);
            self iprintln("Spawned Model: ^1"+level.DEV_SETTINGS["TEST_MODEL"]);
        }
        else if(action=="entPrint" && self AdsButtonPressed())
        {
            self.dev_entCycle ++;
            if(self.dev_entCycle>self.dev_entArray.size)
            {
                self.dev_entCycle = 0;
            }
            self.dev_print_hud _setText("Entity: " + self.dev_entCycle + "/" + self.dev_entArray.size+ "\nid: " + self.dev_entArray[self.dev_entCycle].id + " ----- classname: " + self.dev_entArray[self.dev_entCycle].classname + "\nid: " + self.dev_entArray[self.dev_entCycle].id + " ----- targetname: " + self.dev_entArray[self.dev_entCycle].targetname + "\nid: " + self.dev_entArray[self.dev_entCycle].id + " ----- model: " + self.dev_entArray[self.dev_entCycle].model);
            self iprintln("Entity: ^1" + self.dev_entCycle + "/" + self.dev_entArray.size);
        }
        else if(action=="zombie_test" && self AdsButtonPressed())
        {
            self thread [[level.DEV_SETTINGS["TEST_FUNCTION"]]]();
        }
        else if(action=="clear_prints" && self AdsButtonPressed())
        {
            self.dev_print_hud _setText("");
            self iprintln("^1CLEARED");
        }
    }
}
DEVELOPER_monitorFunctions()
{
    while(self.dev_action_monitor_started)
    {
        playerAnglesForward = AnglesToForward(self getPlayerAngles());
        
        //Ufo Mode
        if(self.dev_ufo && self FragButtonPressed())
        {
            if(isDefined(self.dev_ufo_ent))
            {
                self.dev_ufo_ent.origin = self.dev_ufo_ent.origin+(playerAnglesForward[0]*50,playerAnglesForward[1]*50,playerAnglesForward[2]*50);
            }
        }
        
        //Unlimited Ammo
        if(self.dev_unlimited_ammo)
        {
            currentWeapon = self getCurrentWeapon();
            if(currentWeapon!="none")
            {
                if(isSubStr(self getCurrentWeapon(),"_akimbo"))
                {
                    self setWeaponAmmoClip(currentweapon,9999,"left");
                    self setWeaponAmmoClip(currentweapon,9999,"right");
                }
                else
                {
                    self setWeaponAmmoClip(currentWeapon,9999);
                }
                self GiveMaxAmmo(currentWeapon);
            }
            currentoffhand = self GetCurrentOffhand();
            if(currentoffhand!="none")
            {
                self setWeaponAmmoClip(currentoffhand,9999);
                self GiveMaxAmmo(currentoffhand);
            }
        }
        
        //Godmode
        if(self.dev_god)
        {
            self.maxHealth = 99999;
            if(self.health<self.maxHealth)
            {
                self.health = self.maxHealth;
            }
        }
        wait 0.05;
    }
}




DEVELOPER_TEST_FUNCTION()
{
    //self currentWeapon_unInstallCurrentAttachment();
    //self currentWeapon_installAttachment("vzscope");
    /*for(i=0;i<level.aiz_weapon_attachments.size;i++)
    {
        self.Hud["weapon_attachment_name"] _setText(getAttachmentNameString(level.aiz_weapon_attachments[i].id));
        wait .6;
    }*/
    //level thread SERVER_simpleNotifyMessage("Test Text YAY",4);
    //test = getRandomZombieModel("default","body");
    //iprintln(test.id);
    
    
    
    /*thread spawnDefaultZombie(100,20);
    wait .2;
    iprintln(level.pix_zombie_count);*/
}