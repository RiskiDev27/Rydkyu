stock SendClientMessageEx(playerid, color, const text[], {Float, _} :...)
{
    static args,
           str[144];

    if ((args = numargs()) == 3)
    {
        SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

// forward CheckAccount(playerid);
// public CheckAccount(playerid)
// {
//     // cek apakah data username ada didatabase
//     new rows = cache_num_rows() > 1;
    
//     if (!rows)
//     {
//         cache_get_value_int(0, "id", pData[playerid][pID]);
//         cache_get_value_name(0, "username", pData[playerid][pName]);
//         cache_get_value_name(0, "password", pData[playerid][pPass], 68);

//         ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "REGISTER", "INPUT PASSWORD", "INPUT", "CANCELL");
//     }
//     else
//     {
//         ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "LOGIN", "INPUT PASSWORD", "LOGIN", "CANCELL");
//     }
// }


// forward PlayerRegister(playerid);
// public PlayerRegister(playerid)
// {
//     pData[playerid][pID] = cache_insert_id();
//     pData[playerid][IsLoggedIn] = true;
//     SendClientMessage(playerid, -1, "[Account] Pendaftaran telah berhasil.");
//     PlayerPlaySound(playerid, 1057 , 0.0, 0.0, 0.0);

//     SetSpawnInfo(playerid, 0, 98, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
//     SpawnPlayer(playerid);
//     return 1;
// }


stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}


forward CheckAccount(playerid);
public CheckAccount(playerid)
{
    new string[300];
    if ( cache_num_rows())
    {
        format(string, sizeof(string), "{FFFFFF}Welcome back to {AFAFAF}Server{FFFFFF}%s. Please input your password below to log-in.", GetName(playerid));
        Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login to the server", string, "Login", "Dip");

    }
    else
    {
        format(string, sizeof(string), "{FFFFFF}Welcome to our server, %s. Please type a strong password below to continue.", GetName(playerid));
        Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register to the server", string, "Register", "DIP");
    }
    return 1;
}

forward OnPasswordHashed(playerid);
public OnPasswordHashed(playerid)
{
    new hash[BCRYPT_HASH_LENGTH], query[300];
    bcrypt_get_hash(hash);
    mysql_format(db, query, sizeof(query), "INSERT INTO `account` (username, password) VALUES ('%e', '%e')", GetName(playerid), hash);
    mysql_tquery(db, query, "OnPlayerRegister", "d", playerid);
    return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    SpawnPlayer(playerid);
    SendClientMessage(playerid, -1, "You have been successfully registered in our server.");
    return 1;
}