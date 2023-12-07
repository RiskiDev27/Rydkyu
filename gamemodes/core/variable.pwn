new MySQL:db;

enum
{
    DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER
};

enum playerku
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPass[68],
    pSalt[16],
    pLevel,
    bool:IsLoggedIn,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    Float:pHealth,
    Float:pArmour
};
new pData[MAX_PLAYERS][playerku];