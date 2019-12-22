init_weapon()
{
    //Create List with base weapon ids
    level.aiz_weapons = [];
    for(i=0;i<=149;i++)
    {
        weaponId    = tableLookup("mp/statsTable.csv",0,i,4);
        weaponClass = tableLookup("mp/statsTable.csv",0,i,2);
        
        //if weaponId exists + is in a weapon class
        if((weaponId!="") && isSubStr(weaponClass,"weapon_"))
        {
            //Weapon Id's and Classes to ignore
            if(weaponClass!="weapon_riot"&&
               weaponClass!="weapon_projectile"&&
               weaponClass!="weapon_explosive"&&
               weaponClass!="weapon_other"&&
               weaponClass!="weapon_grenade"&&
               weaponId!="uav_strike_marker"&&
               weaponId!="iw5_usp45jugg"&&
               weaponId!="iw5_mp412jugg"&&
               weaponId!="iw5_m60jugg")
            {
                addWeaponToList(weaponId);
            }
        }
    }
    
    //Create Attachment List
    level.aiz_weapon_attachments = [];
    for(i=1;i<=25;i++)
    {
        attachmentId = tableLookup("mp/attachmentTable.csv",0,i,4);
        
        //Attachment Id's to ignore
        if(attachmentId!="thermal"&&
           attachmentId!="heartbeat"&&
           attachmentId!="lockair"&&
           attachmentId!="boom"&&
           attachmentId!="zoomscope"&&
           attachmentId!="silencer"&&
           attachmentId!="silencer02"&&
           attachmentId!="silencer03")
        {
            addAttachmentToList(attachmentId);
        }
    }
    
    
    
}


//AIZ Weapon/Attachment List Functions
addWeaponToList(weaponId)
{
    i = level.aiz_weapons.size;
    level.aiz_weapons[i] = spawnStruct();
    level.aiz_weapons[i].id = weaponId;
}
addAttachmentToList(attachmentId)
{
    i = level.aiz_weapon_attachments.size;
    level.aiz_weapon_attachments[i] = spawnStruct();
    level.aiz_weapon_attachments[i].id = attachmentId;
}
isWeaponInList(weaponId)
{
    for(i=0;i<level.aiz_weapons.size;i++)
    {
        if(level.aiz_weapons[i].id==weaponId)
        {
            return true;
        }
    }
    return false;
}
getRandomWeaponFromList(ignore_weapon)
{
    if(isDefined(ignore_weapon))
    {
        random_weapon = ignore_weapon;
        while(random_weapon==ignore_weapon)
        {
            random_weapon = level.aiz_weapons[randomInt(level.aiz_weapons.size)].id;
        }
        return random_weapon;
    }
    else
    {
        return level.aiz_weapons[randomInt(level.aiz_weapons.size)].id;
    }
}
isAttachmentAvailable(weaponId,attachmentId)
{
    list = getAttachmentList(weaponId);
    if(list.size<1)
    {
        return false;
    }
    for(i=0;i<list.size;i++)
    {
        if(list[i]==attachmentId)
        {
            return true;
        }
    }
    return false;
}


//TableLookUp Functions
getWeaponNameString(base_weapon)
{
    tableRow         = tableLookup("mp/statstable.csv",4,base_weapon,0);
    weaponNameString = tableLookupIString("mp/statstable.csv",0,tableRow,3);
    return weaponNameString;
}
getAttachmentNameString(attachmentId)
{
    tableRow             = tableLookup("mp/attachmentTable.csv",4,attachmentId,0);
    attachmentNameString = tableLookupIString("mp/attachmentTable.csv",0,tableRow,3);
    return attachmentNameString;
}
getAttachmentList(base_weapon)
{
    list     = [];
    tableRow = tableLookup("mp/statstable.csv",4,base_weapon,0);
    for(i=0;i<10;i++)
    {
        attachment = tableLookup("mp/statsTable.csv",0,tableRow,11+i);
        for(l=0;l<level.aiz_weapon_attachments.size;l++)
        {
            if((attachment!="") && (attachment==level.aiz_weapon_attachments[l].id))
            {
                size = list.size;
                list[size] = attachment;
            }
        }
    }
    return list;
}


//Check if currentweapon has a attachment installed
currentWeapon_HasAttachmentInstalled()
{
    currentWeapon    = self getCurrentWeapon();
    baseWeaponName   = self getBaseWeaponName(currentWeapon);
    attachmentList   = getAttachmentList(baseWeaponName);
    weaponSingleName = strTok(baseWeaponName,"_")[1];
    if(attachmentList.size<1)
    {
        //self iprintln("^1NO ATTACHMENTS AVAILABLE!");
        return false;
    }
    for(i=0;i<attachmentList.size;i++)
    {
        if(attachmentList[i]!="none" && attachmentList[i]!=weaponSingleName+"scope")
        {
            if(attachmentList[i]=="vzscope")
            {
                if(isSubStr(currentWeapon,"_"+weaponSingleName+"scopevz"))
                {
                    return true;
                }
            }
            else
            {
                if(isSubStr(currentWeapon,"_"+attachmentList[i]))
                {
                    return true;
                }
            }
        }
    }
    return false;
}

//Get current installed attachment
currentWeapon_getCurrentInstalledAttachment()
{
    if(!self currentWeapon_HasAttachmentInstalled())
    {
        return "none";
    }
    currentWeapon    = self getCurrentWeapon();
    baseWeaponName   = self getBaseWeaponName(currentWeapon);
    attachmentList   = getAttachmentList(baseWeaponName);
    weaponSingleName = strTok(baseWeaponName,"_")[1];
    for(i=0;i<attachmentList.size;i++)
    {
        if(attachmentList[i]!="none" && attachmentList[i]!=weaponSingleName+"scope")
        {
            if(attachmentList[i]=="vzscope")
            {
                if(isSubStr(currentWeapon,"_"+weaponSingleName+"scopevz"))
                {
                    return attachmentList[i];
                }
            }
            else
            {
                if(isSubStr(currentWeapon,"_"+attachmentList[i]))
                {
                    return attachmentList[i];
                }
            }
        }
    }
    return "none";
}

//UnInstall Current Attachment
currentWeapon_unInstallCurrentAttachment()
{
    if(!self currentWeapon_HasAttachmentInstalled())
    {
        return;
    }
    currentWeapon  = self getCurrentWeapon();
    baseWeaponName = self getBaseWeaponName(currentWeapon);
    self takeWeapon(currentWeapon);
    self giveWeaponFromList(baseWeaponName);
}

//Install attachment to currentWeapon
currentWeapon_installAttachment(attachmentId,maxAmmo=true)
{
    currentWeapon    = self getCurrentWeapon();
    baseWeaponName   = self getBaseWeaponName(currentWeapon);
    attachmentList   = getAttachmentList(baseWeaponName);
    weaponSingleName = strTok(baseWeaponName,"_")[1];
    weaponString     = "none";
    if(!isAttachmentAvailable(baseWeaponName,attachmentId))
    {
        return;
    }
    if(self currentWeapon_getCurrentInstalledAttachment()==attachmentId)
    {
        return;
    }
    if(getWeaponClass(baseWeaponName)=="weapon_sniper")
    {
        if(attachmentId=="vzscope")
        {
            weaponString = baseWeaponName + "_mp_" + weaponSingleName + "scopevz";
        }
        else if(attachmentId=="xmags")
        {
            weaponString = baseWeaponName + "_mp_" + weaponSingleName + "scope_xmags";
        }
        else
        {
            weaponString = baseWeaponName + "_mp_" + attachmentId;
        }
    }
    else if(getWeaponClass(baseWeaponName)=="weapon_smg"||getWeaponClass(baseWeaponName)=="weapon_machine_pistol")
    {
        if(attachmentId=="reflex"||attachmentId=="eotech"||attachmentId=="acog")
        {
            weaponString = baseWeaponName + "_mp_" + attachmentId + "smg";
        }
        else
        {
            weaponString = baseWeaponName + "_mp_" + attachmentId;
        }
    }
    else if(getWeaponClass(baseWeaponName)=="weapon_lmg")
    {
        if(attachmentId=="reflex"||attachmentId=="eotech")
        {
            weaponString = baseWeaponName + "_mp_" + attachmentId + "lmg";
        }
        else
        {
            weaponString = baseWeaponName + "_mp_" + attachmentId;
        }
    }
    else
    {
        weaponString = baseWeaponName + "_mp_" + attachmentId;
    }
    self takeWeapon(currentWeapon);
    if(attachmentId=="akimbo")
    {
        self giveWeapon(weaponString,0,true);
    }
    else
    {
        self giveWeapon(weaponString);
    }
    if(maxAmmo)
    {
        self giveMaxAmmo(weaponString);
    }
    self switchToWeapon(weaponString);
}



//Give weapon from AIZ Weapon List
giveWeaponFromList(weaponId,switchTo=true)
{
    //check if weapon is in list
    if(!isWeaponInList(weaponId))
    {
        return;
    }
    
    //if weapon is a sniper rifle add scope to it
    if(getWeaponClass(weaponId)=="weapon_sniper")
    {
        weapon = strTok(weaponId,"_");
        id     = weaponId + "_mp_" + weapon[1] + "scope";
    }
    else
    {
        id = weaponId + "_mp";
    }
    
    //Max weapons check
    list = self getWeaponsListPrimaries();
    if(list.size>1)
    {
        self takeWeapon(self getCurrentWeapon());
    }
    
    //Give Weapon
    self giveWeapon(id);
    self giveMaxAmmo(id);
    if(switchTo)
    {
        self SwitchToWeapon(id);
    }
}