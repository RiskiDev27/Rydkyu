public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_REGISTER)
    {
        if (!response) return Kick(playerid);

        if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "REGISTER INFO", "harus 5 karakter", "OK", "");

        new hashed_pass[68];
        for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(99) + 13;
        SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPass], 68);
        new query[300];
        mysql_format(db, query, sizeof(query), "INSERT INTO `account` (username, password, salt) VALUES ('%e', '%s', '%e')", pData[playerid][pName], pData[playerid][pPass], pData[playerid][pSalt]);
        mysql_pquery(db, query, "RegisterPlayer", "d", playerid);
    }

    else if (dialogid == DIALOG_LOGIN)
    {
        if (!response) return Kick(playerid);

        new hashed_pass[68];
        SHA256_PassHash(inputtext, pData[playerid][pSalt], hashed_pass, 68);

        if (strcmp(hashed_pass, pData[playerid][pPass]) == 0)
        {
            new query[512];
            mysql_format(db, query, sizeof(query), "SELECT * FROM `account` WHERE `username` = '%e' LIMIT 1", GetName(playerid));
            mysql_tquery(db, query, "AssignPlayer", "d", playerid);
            printf("[LOGIN] %s(%d) has successfully login with password(%s)", pData[playerid][pName], playerid, inputtext);

        }
        return 1;
    }
    return 1;
}