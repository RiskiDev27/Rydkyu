Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        bcrypt_hash(inputtext, BCRYPT_COST, "OnPasswordHashed", "d", playerid);
    }
    else
        Kick(playerid);
    return 1;
}