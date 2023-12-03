#include <a_samp>
#include <a_mysql>
#include <bcrypt>
#include <easyDialog>

#include "core/define.pwn"
#include "core/variable.pwn"

main()
{
	print("Script Base");
}

#include "core/stock.pwn"
#include "core/dialog.pwn"

public OnGameModeInit()
{
	db = mysql_connect(SERVER_HOSTNAME, SERVER_USERNAME, SERVER_PASSWORD, SERVER_DATABASE);
	if ( db == MYSQL_INVALID_HANDLE || mysql_errno(db) != 0)
	{
		print("SERVER: MySQL Connection failed, shutting the server down!");
		SendRconCommand("exit");
		return 1;
	}

	SetGameModeText("willbedie");
	print("SERVER: MySQL Connection was successful.");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new query[300];
	mysql_format(db, query, sizeof(query), "SELECT * FROM `account` WHERE `username` = '%e'", GetName(playerid));
	mysql_tquery(db, query, "CheckAccount", "d", playerid);
}