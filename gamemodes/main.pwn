#include <a_samp>
#include <a_mysql>


#include "core/define.pwn"
#include "core/variable.pwn"

main()
{
    print("==========================\n");
    print("CITY HAPINNES ROLEPLAY");
    print("============================");
}

#include "core/dialog.pwn"
#include "core/stock.pwn"

public OnGameModeInit()
{
    // Don't use these lines if it's a filterscript
    SetGameModeText("CHRP:v.0.1|Beta");
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
    // CEK KONEKSI
    new MySQLOpt:option_id = mysql_init_options();

    mysql_set_option(option_id, AUTO_RECONNECT, true);

    db = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);

    if (db == MYSQL_INVALID_HANDLE || mysql_errno(db) != 0)
    {
        print("Connection to Database Failed!");
        SendRconCommand("exit");
        return 1;
    }
    print("Connection Established!");
    return 1;
}

public OnGameModeExit()
{
    SendClientMessageToAll(-1, "[SERVER]: SERVER SEDANG ADA MAINTENANCE!!!");
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    InterpolateCameraPos(playerid, 244.116943, -1844.963256, 41.799915, 821.013366, -1641.763793, 29.977857, 15000);
    InterpolateCameraLookAt(playerid, 247.605590, -1841.989990, 39.802570, 817.645996, -1645.395751, 29.292520, 15000);
    return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
    new query[300];
    mysql_format(db, query, sizeof(query), "SELECT * FROM `account` WHERE `username` = '%e'", pData[playerid][pName]);
    mysql_tquery(db, query, "CheckAccount", "d", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (pData[playerid][IsLoggedIn] == true)
    {
        SavePlayers(playerid);
    }

    pData[playerid][IsLoggedIn] = false;
    return 1;
}