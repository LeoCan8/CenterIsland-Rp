//CALLSIGN FILTERSCRIPT
//#define FILTERSCRIPT
 
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#define COLOR_ORANGE 0xFF9500FF
 
#if defined FILTERSCRIPT
 
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" CALLSIGN SCRIPT DAVMAN");
	print("--------------------------------------\n");
	return 1;
}
 
public OnFilterScriptExit()
{
    new veh = GetPlayerVehicleID(playerid);
    Delete3DTextLabel(veicolo_callsign_testo[veh]);
	veicolo_callsign_status[veh] = 0;
	return 1;
}
 
#else
 
main()
{
	print("\n----------------------------------");
	print(" CALLSIGN SCRIPT DAVMAN");
	print("----------------------------------\n");
}
 
#endif
 
//******VARIABILI******//
new Text3D:veicolo_callsign_testo[MAX_VEHICLES];
new veicolo_callsign_status[MAX_VEHICLES];
 
public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
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
	SendClientMessage(playerid,COLOR_ORANGE,"INFO: {FFFFFF}This server use Callsign Filterscript Davman");
	return 1;
}
 
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}
 
public OnPlayerSpawn(playerid)
{
	return 1;
}
 
public OnPlayerDeath(playerid, killerid, reason)
{
    new veh = GetPlayerVehicleID(playerid);
    Delete3DTextLabel(veicolo_callsign_testo[veh]);
	veicolo_callsign_status[veh] = 0;
	return 1;
}
 
public OnVehicleSpawn(vehicleid)
{
	return 1;
}
 
public OnVehicleDeath(vehicleid, killerid)
{
    new veh = GetPlayerVehicleID(vehicleid);
    Delete3DTextLabel(veicolo_callsign_testo[veh]);
	veicolo_callsign_status[veh] = 0;
	return 1;
}
 
public OnPlayerText(playerid, text[])
{
	return 1;
}
#pragma tabsize 0
COMMAND:callsign(playerid,params[])
{
    new veh = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid))
    {
  		if(isnull(params)) return SendClientMessage(playerid,COLOR_ORANGE,"INFO: {FFFFFF}/callsign [text]");
		if(!veicolo_callsign_status[veh])
        {
        new string[128];
        format(string,sizeof(string), "%s",params);
       	veicolo_callsign_testo[veh] = Create3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, 1);
       	Attach3DTextLabelToVehicle( veicolo_callsign_testo[veh], veh, -0.7, -1.9, -0.3);
       	veicolo_callsign_status[veh] = 1;
  		}
  		else
  		{
  		Delete3DTextLabel(veicolo_callsign_testo[veh]);
		veicolo_callsign_status[veh] = 0;
		return 1;
			}
		}
		else
		{
        SendClientMessage(playerid,COLOR_ORANGE,"ERROR: {FFFFFF}You are not in a vehicle");
        return 1;
		}
	return 1;
}
COMMAND:deletecallsign(playerid,params[])
{
	new veh = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid))
    {
    	Delete3DTextLabel(veicolo_callsign_testo[veh]);
		veicolo_callsign_status[veh] = 0;
    }
    else
    {
    SendClientMessage(playerid,COLOR_ORANGE,"ERROR: {FFFFFF}You are not in a vehicle");
    }
	return 1;
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