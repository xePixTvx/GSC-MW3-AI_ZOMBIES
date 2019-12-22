precacheAssets()
{
    level.aiz_asset = [];
    level.aiz_asset["shader"] = [];
    level.aiz_asset["model"] = [];
    level.aiz_asset["effect"] = [];
    
    
    //Shaders
    level.aiz_asset["shader"]["player_weapon_hud_divider"] = "hud_iw5_divider";//Player Weapon Hud Line/Divider
    level.aiz_asset["shader"]["shop_headicon_refill_ammo"] = "waypoint_ammo_friendly";//Shop Headicon --- Refill Ammo ---- no precache needed
    level.aiz_asset["shader"]["shop_headicon_random_weapon"] = "iw5_cardicon_gunstar";//Shop Headicon --- Random Weapon
    level.aiz_asset["shader"]["shop_headicon_power"] = "map_nuke_selector";//Shop Headicon --- Power
    level.aiz_asset["shader"]["shop_headicon_misc"] = "iw5_cardicon_bomb";//Shop Headicon --- Misc
    level.aiz_asset["shader"]["shop_headicon_pap"] = "specialty_c4death";//Shop Headicon --- PAP
    
    
    //Models
    level.aiz_asset["model"]["shop_crate_model"] = "com_plasticcase_trap_friendly";//---- no precache needed
    level.aiz_asset["model"]["zombie_hitbox"] = "com_plasticcase_beige_big";
    
    
    //Zombie Animations(just precache here, sorting/using in zombie\_zombie.gsc) ---- the same for all maps
    zombie_anims = [];
    zombie_anims[0] = "pb_stand_alert";//idle stand
    zombie_anims[1] = "pb_walk_forward_shield";//walk
    zombie_anims[2] = "pb_combatwalk_forward_loop_pistol";//walk
    zombie_anims[3] = "pb_walk_forward_mg";//walk
    zombie_anims[4] = "pb_walk_forward_akimbo";//walk
    zombie_anims[5] = "pb_run_fast";//run
    zombie_anims[6] = "pb_pistol_run_fast";//run
    zombie_anims[7] = "pb_sprint_akimbo";//sprint
    zombie_anims[8] = "pb_sprint_pistol";//sprint
    zombie_anims[9] = "pt_melee_pistol_1";//melee
    zombie_anims[10] = "pt_melee_pistol_2";//melee
    zombie_anims[11] = "pt_melee_pistol_3";//melee
    zombie_anims[12] = "pt_melee_pistol_4";//melee
    zombie_anims[13] = "pb_stumble_walk_back";//pain
    zombie_anims[14] = "pb_stand_death_leg_kickup";//death
    zombie_anims[15] = "pb_stand_death_shoulderback";//death
    zombie_anims[16] = "pb_death_run_stumble";//death
    zombie_anims[17] = "pb_prone_hold";//idle crawl
    zombie_anims[18] = "pb_prone_crawl_akimbo";//move crawl
    zombie_anims[19] = "pb_prone_death_quickdeath";//death crawl
    //cant find any good crawl melee anims
    //zombie_anims[20] = "pt_melee_prone_pistol";//melee crawl --- needs testing
    //zombie_anims[21] = "pt_melee_prone";//melee crawl --- needs testing
    
    
    //Zombie Effects
    level.aiz_asset["effect"]["zombie_blood_default"] = loadFx("impacts/flesh_hit_body_fatal_exit");
    level.aiz_asset["effect"]["zombie_blood_no_head"] = loadFx("impacts/flesh_hit_head_fatal_exit");
    level.aiz_asset["effect"]["zombie_c4_blink"] = loadFx("misc/light_c4_blink");
    level.aiz_asset["effect"]["zombie_explode"] = loadFx("explosions/artilleryExp_dirt_brown");
    
    
    
    if(!level.DEV_SETTINGS["Disable_precache"])
    {
        precacheShaderArray(level.aiz_asset["shader"]);
        precacheModelArray(level.aiz_asset["model"]);
        precacheAnimArray(zombie_anims);
    }
}

precacheModelArray(array)
{
    foreach(asset in array)
    {
        precacheModel(asset);
    }
}
precacheAnimArray(array)
{
    foreach(asset in array)
    {
        precacheMpAnim(asset);
    }
}
precacheShaderArray(array)
{
    foreach(asset in array)
    {
        precacheShader(asset);
    }
}