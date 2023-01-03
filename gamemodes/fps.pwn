// Textdraw Time, Date, and FPS For SAMP Server.
// Build by Agus "KillerMachine" Purwantoro.

#include <a_samp>

new Text:TimeDate[2];

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Textdraw Time, Date, and FPS Loaded.");
	print(" Build by KillerMachine.");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	TimeDate[0] = TextDrawCreate(576.963073, 24.533348, "01:40");
	TextDrawLetterSize(TimeDate[0], 0.487145, 1.582499);
	TextDrawAlignment(TimeDate[0], 2);
	TextDrawColor(TimeDate[0], -1);
	TextDrawSetShadow(TimeDate[0], 0);
	TextDrawSetOutline(TimeDate[0], 2);
	TextDrawBackgroundColor(TimeDate[0], 255);
	TextDrawFont(TimeDate[0], 3);
	TextDrawSetProportional(TimeDate[0], 1);
	TextDrawSetShadow(TimeDate[0], 0);
	
	TimeDate[1] = TextDrawCreate(552.576782, 4.566683, "13/08/2017");
	TextDrawLetterSize(TimeDate[1], 0.487145, 1.582499);
	TextDrawAlignment(TimeDate[1], 2);
	TextDrawColor(TimeDate[1], -1);
	TextDrawSetShadow(TimeDate[1], 0);
	TextDrawSetOutline(TimeDate[1], 2);
	TextDrawBackgroundColor(TimeDate[1], 255);
	TextDrawFont(TimeDate[1], 3);
	TextDrawSetProportional(TimeDate[1], 1);
	TextDrawSetShadow(TimeDate[1], 0);
  
  SetTimer("TimeDateTextdraw",1000,true);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
  TextDrawShowForPlayer(playerid, TimeDate[0]);
  TextDrawShowForPlayer(playerid, TimeDate[1]);
	return 1;
}

forward TimeDateTextdraw(playerid);
public TimeDateTextdraw(playerid)
{
        new string[256],year,month,day,hours,minutes,seconds;
        getdate(year, month, day), gettime(hours, minutes, seconds);
        format(string, sizeof string, "~~%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
        TextDrawSetString(TDDate, string);
        format(string, sizeof string, "~b~%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
        TextDrawSetString(TDTime, string);
}

public OnPlayerDisconnect(playerid, reason)
{
  TextDrawHideForPlayer(playerid, TimeDate[0]);
  TextDrawHideForPlayer(playerid, TimeDate[1]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
