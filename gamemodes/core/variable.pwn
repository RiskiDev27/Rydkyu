new 
    MySQL: db,
    bool: LoggedIn[MAX_PLAYERS]
;

enum playerdata
{
    pID,
    pCash,
    pKills,
    pDeaths,
    pName[MAX_PLAYER_NAME]
};

new pData[MAX_PLAYERS][playerdata];