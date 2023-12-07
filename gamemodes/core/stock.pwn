forward CheckAccount(playerid);
public CheckAccount(playerid)
{
    if (cache_num_rows() > 0)
    {
        cache_get_value_name_int(0, "id", pData[playerid][pID]);
        cache_get_value_name(0, "username", pData[playerid][pName], MAX_PLAYER_NAME);
        cache_get_value_name(0, "password", pData[playerid][pPass], 68);
        // cache_get_value_name(0, "salt", pData[playerid][pSalt], 16);
        SendClientMessage(playerid, -1, "[info]: database player tersedia!");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login to Server", "lorem", "ok", "batal");
    }
    else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register to Server", "LOREM", "OK", "CANCELL");
}

forward RegisterPlayer(playerid);
public RegisterPlayer(playerid)
{
    if (pData[playerid][IsLoggedIn] == true)
        return SendClientMessage(playerid, -1, "You already logged in!");
    
    pData[playerid][pID] = cache_insert_id();
    pData[playerid][IsLoggedIn] = true;


    new name[MAX_PLAYER_NAME];
    format(name, sizeof(name), pData[playerid][pName]);

    pData[playerid][pLevel] = 1;
    pData[playerid][pHealth] = 100.0;
    pData[playerid][pArmour] = 0.0;
    SendClientMessage(playerid, -1, "data saved!");
    SetSpawnInfo(playerid, 0, 0, 2033.4019, 1341.6188, 10.8203, 274.4066, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
}

stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

forward AssignPlayer(playerid);
public AssignPlayer(playerid)
{
    new name[MAX_PLAYER_NAME];

    cache_get_value_name_int(0, "id", pData[playerid][pID]);
    cache_get_value_name(0, "username", name);
    format(pData[playerid][pName], MAX_PLAYER_NAME, "%s", name);
    cache_get_value_name_int(0, "level", pData[playerid][pLevel]);
    cache_get_value_name_float(0, "posx", pData[playerid][pPosX]);
    cache_get_value_name_float(0, "posy", pData[playerid][pPosY]);
    cache_get_value_name_float(0, "posz", pData[playerid][pPosZ]);
    cache_get_value_name_float(0, "posa", pData[playerid][pPosA]);

    pData[playerid][IsLoggedIn] = true;

    SetSpawnInfo(playerid, NO_TEAM, 0, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
    return 1;
}


SavePlayers(playerid)
{
    if (pData[playerid][IsLoggedIn] == false) return 0;
    
    GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
    GetPlayerHealth(playerid, pData[playerid][pHealth]);
    GetPlayerArmour(playerid, pData[playerid][pArmour]);

    new query[300];

    mysql_format(db, query, sizeof(query), "UPDATE `account` SET ");
    mysql_format(db, query, sizeof(query), "%s `username` = '%e',", query, pData[playerid][pName]);
    mysql_format(db, query, sizeof(query), "%s `level` = '%d',", query, pData[playerid][pLevel]);
    mysql_format(db, query, sizeof(query), "%s `health` = '%f',", query, pData[playerid][pHealth]);
    mysql_format(db, query, sizeof(query), "%s `armour` = '%f',", query, pData[playerid][pArmour]);

    mysql_format(db, query, sizeof(query), "%s `posx` = '%f',", query, pData[playerid][pPosX]);
    mysql_format(db, query, sizeof(query), "%s `posy` = '%f',", query, pData[playerid][pPosY]);
    mysql_format(db, query, sizeof(query), "%s `posz` = '%f',", query, pData[playerid][pPosZ]);
    mysql_format(db, query, sizeof(query), "%s `posa` = '%f' WHERE 'id` = '%d'", query, pData[playerid][pPosA], pData[playerid][pID]);

    // mysql_format()
    mysql_tquery(db, query);
    printf("[username]: %s datasaved to database", pData[playerid][pName]);
    return 1;
}