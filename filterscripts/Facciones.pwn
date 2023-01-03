/*
	----FS de Facciones totalmente IG----
	    ----Creditos solo para----
	         ----Tusso4----
             ----No robar----
	  ----Ni eliminar los creditos porfavor----
*/

#include <a_samp>
#include <zcmd>
#include <streamer>
#include <dini>

#define function%0(%1) forward %0 (%1); public %0(%1)
#define AND &&
#define OR ||
#define commandopen "ap" //Para editar el comando de abrir la puerta edita el texto que esta entre " " (Comillas)
#define MAX_FACCIONES 100
#define MAX_VEHICLEFACC 200
#define MAX_CONTRATOS 100
#define MAX_HQ MAX_FACCIONES
#define MAX_REJAS 100

new FVehicles[MAX_VEHICLEFACC];

new FaccionJugador[MAX_PLAYERS];
new RangoJugador[MAX_PLAYERS];
new SpawnFase[MAX_PLAYERS];
new PickupHQ[MAX_HQ], Text3D:LabelHQ[MAX_HQ];
new ObjectReja[MAX_REJAS];

enum RejasI
{
	rFaccion,
	rCreado,
	rModo, //1 - Comando, 2- Tecla 'H'
	rModelo,
	Float:rPos[6],
	Float:rPos2[6],
	Float:rRango,
	Float:rSpeed,
	rAbierta,
	rTiempo //En segundos
}
new RI[MAX_REJAS][RejasI];

enum FaccI
{
	fNombre[24],
	fLider[25],
	fMiembros,
	fAutos,
	fHQ,
	fCreada,
}
new FI[MAX_FACCIONES][FaccI];
enum ContratoI
{
	cFaccion,
	cJugador[MAX_PLAYER_NAME],
	cCreado,
	cContratante[MAX_PLAYER_NAME],
	cID
}
new fContrato[MAX_CONTRATOS][ContratoI];
new FRangos[MAX_FACCIONES][7][100];
enum FaccV
{
	vModelo,
	vFaccion,
	Float: vPos_x,
	Float: vPos_y,
	Float: vPos_z,
	Float: vPos_a,
	vColor1,
	vColor2,
	vCreado
}
new FV[MAX_VEHICLEFACC][FaccV];

enum HQInfo
{
	hFaccion,
	Float: hPos_x,
	Float: hPos_y,
	Float: hPos_z,
	Float: hPos_a,
	Float: hPos_x2,
	Float: hPos_y2,
	Float: hPos_z2,
	Float: hPos_a2,
	hCreada,
	hVW,
	hInterior,
	hiInterior,
	hAbierta
}
new HI[MAX_HQ][HQInfo];

new VehicleNames[][] =
{
  "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
  "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
  "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
  "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
  "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
  "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
  "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
  "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
  "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
  "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
  "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
  "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
  "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
  "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
  "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
  "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
  "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
  "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
  "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
  "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car", "Police Car", "Police Car",
  "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
  "Boxville", "Tiller", "Utility Trailer"
};

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	CargarFacciones();
	CargarContratos();
	CargarVehiculosF();
	CargarHQs();
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new file[256];
			format(file, 256, "Facciones/Jugadores/%s.ini", NJ(i));
			FaccionJugador[i] = dini_Int(file, "Faccion");
			RangoJugador[i] = dini_Int(file, "Rango");
			SpawnFase[i] = 1;
		}
	}
	CargarRejas();
	return 1;
}

public OnFilterScriptExit()
{
	for(new i; i < MAX_REJAS; i++)
	{
	    if(RI[i][rCreado])
	    {
			GuardarReja(i);
			DestroyObject(ObjectReja[i]);
		}
	}
	for(new i; i < MAX_HQ; i++)
	{
	    if(HI[i][hCreada])
	    {
			GuardarHQ(i);
			DestroyPickup(PickupHQ[i]);
			Delete3DTextLabel(LabelHQ[i]);
		}
	}
	for(new i; i < MAX_VEHICLEFACC; i++)
	{
	    if(FV[i][vCreado])
	    {
			GuardarVehiculoF(i);
			DestroyVehicle(FVehicles[i]);
		}
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			new file[256];
			format(file, 256, "Facciones/Jugadores/%s.ini", NJ(i));
			if(!fexist(file))
			{
			    dini_Create(file);
			}
			dini_IntSet(file, "Faccion", FaccionJugador[i]);
			dini_IntSet(file, "Rango", RangoJugador[i]);
		}
	}
	for(new id = 1; id < MAX_FACCIONES; id++)
	{
		if(FI[id][fCreada])
		{
		    GuardarFaccion(id);
		}
	}
	for(new i; i < MAX_CONTRATOS; i++)
	{
		if(fContrato[i][cCreado])
		{
		    GuardarContrato(i);
		}
	}
	return 1;
}
public OnObjectMoved(objectid)
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i) AND GetPVarInt(i, "PuertaID") == objectid)
		{
		    for(new i2; i2 < MAX_REJAS; i2++)
		    {
				if(RI[i2][rCreado] AND ObjectReja[i2] == objectid)
				{
				    SetTimerEx("CerrarReja", RI[i2][rTiempo]*1000, false, "i", i2);
				    return 1;
				}
		    }
		}
	}
    return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	for(new i; i < MAX_VEHICLEFACC; i++)
	{
	    if(FVehicles[i] == vehicleid)
	    {
	        if(FaccionJugador[playerid] != FV[i][vFaccion])
	        {
	            if(IsPlayerAdmin(playerid)){return 1;}
	            ClearAnimations(playerid);
	            new Float:p[4];
	            GetPlayerPos(playerid, p[0], p[1], p[2]);
	            GetPlayerFacingAngle(playerid, p[3]);
	            SetPlayerPos(playerid,  p[0], p[1], p[2]);
				SetPlayerFacingAngle(playerid, p[3]);
				new s[100];
				format(s, 100, "No perteneces a '%s'", FI[FV[i][vFaccion]][fNombre]);
				SendClientMessage(playerid, -1, s);
	        }
	    }
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(SpawnFase[playerid] == 0)
	{
		new file[256];
		format(file, 256, "Facciones/Jugadores/%s.ini", NJ(playerid));
		FaccionJugador[playerid] = dini_Int(file, "Faccion");
		RangoJugador[playerid] = dini_Int(file, "Rango");
		SpawnFase[playerid] = 1;
	}
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	new file[256];
	format(file, 256, "Facciones/Jugadores/%s.ini", NJ(playerid));
	dini_IntSet(file, "Faccion", FaccionJugador[playerid]);
	dini_IntSet(file, "Rango", RangoJugador[playerid]);
	FaccionJugador[playerid] = 0;
	RangoJugador[playerid] = 0;
	SpawnFase[playerid] = 0;
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 102)
	{
	    if(!response OR !strlen(inputtext))
	    {
	        new s[100];
	        format(s, 100, "Comando '/%s'", commandopen);
	    	ShowPlayerDialog(playerid, 101, DIALOG_STYLE_MSGBOX, "Rejas", "¿Como quieres que se active?", s, "Tecla 'H'");
	    }else{
	        DeletePVar(playerid, "RID");
	        SendClientMessage(playerid, -1, "Reja creada sastifactoriamente, usa /feditarreja para editarla");
	    }
	}
	if(dialogid == 101)
	{
		new i = GetPVarInt(playerid, "RID");
		if(response)
		{
	        new s[100];
	        format(s, 100, "Elegiste modo 'Comando (/%s)'", commandopen);
			SendClientMessage(playerid, -1, s);
			RI[i][rModo] = 1;
			ShowPlayerDialog(playerid, 102, DIALOG_STYLE_MSGBOX, "Rejas", "Has terminado todos los pasos", "Terminar", "Atras");
		}
		if(!response) //19313
		{
			SendClientMessage(playerid, -1, "Elegiste modo 'Tecla (H)'");
			RI[i][rModo] = 2;
		}
	}
	if(dialogid == 100)
	{
		if(response)
		{
			if(!strlen(inputtext) OR !Numerico(inputtext))
			{
			    ShowPlayerDialog(playerid, 100, DIALOG_STYLE_INPUT, "Rejas", "Elige el modelo del objeto para la reja", "Seleccionar", "Salir");
			}else{
				if(GetPVarInt(playerid, "Editando") == 3)
				{
				    new rid = GetPVarInt(playerid, "EditandoID");
				    RI[rid][rModelo] = strval(inputtext);
				    GuardarReja(rid);
				    DestroyObject(ObjectReja[rid]);
				    ObjectReja[rid] = CreateObject(RI[rid][rModelo], RI[rid][rPos][0], RI[rid][rPos][1], RI[rid][rPos][2], RI[rid][rPos][3], RI[rid][rPos][4], RI[rid][rPos][5], 250.0);
					return 1;
				}
			    RI[GetPVarInt(playerid, "RID")][rModelo] = strval(inputtext);
			    new i = GetPVarInt(playerid, "RID");
				ObjectReja[GetPVarInt(playerid, "RID")] = CreateObject(strval(inputtext), RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2], RI[i][rPos][3], RI[i][rPos][4], RI[i][rPos][5]);
				SendClientMessage(playerid, -1, "Usa /feditarreja para editar la reja");
		        new s[100];
		        format(s, 100, "Comando '/%s'", commandopen);
			    ShowPlayerDialog(playerid, 101, DIALOG_STYLE_MSGBOX, "Rejas", "¿Como quieres que se active?", s, "Tecla 'H'");
			}
		}else{
		    DeletePVar(playerid, "RID");
		}
	}
	if(dialogid == 94)
	{
	    if(response)
	    {
			new s[100];
	        new idex = GetPVarInt(playerid, "EditandoRangoID");
			format(s, 100, "Cambiaste el rango (%d) - %s por %s", idex, FRangos[FaccionJugador[playerid]][idex], inputtext);
			format(FRangos[FaccionJugador[playerid]][idex], 64, inputtext);
			GuardarFaccion(idex);
			SendClientMessage(playerid, -1, s);
			DeletePVar(playerid, "EditandoRangoID");
		}
	}
	if(dialogid == 93)
	{
		if(response)
		{
		    if(listitem == 0)
			{
				new s[100];
				for(new i = 1; i < 7; i++)
				{
					format(s, 100, "%s\n%d - %s", s, i, FRangos[FaccionJugador[playerid]][i]);
				}
				new s2[110];
				format(s2, 110, "Numero - Nombre\n%s", s);
				ShowPlayerDialog(playerid, 93, DIALOG_STYLE_LIST, "Rango", s2, "Editar", "Cancelar");
		    }
		    ShowPlayerDialog(playerid, 94, DIALOG_STYLE_INPUT, "Rango", "Inserta el nuevo nombre para el rango", "Aceptar", "Cancelar");
		    SetPVarInt(playerid, "EditandoRangoID", listitem);
		}
	}
	if(dialogid == 92)
	{
		if(response)
		{
			VaciarVehiculo(GetPVarInt(playerid, "IDC"), playerid);
		}
	}
	if(dialogid == 91)
	{
		if(!response)
		{
			VaciarContrato(GetPVarInt(playerid, "IDC"), playerid, 0);
		}
		if(response)
		{
			VaciarContrato(GetPVarInt(playerid, "IDC"), playerid, 1);
		}
	}
	if(dialogid == 90)
	{
		if(!response){return 1;}
		new s[300];
		if(listitem == 0){
		for(new i; i<MAX_CONTRATOS; i++)
		{
			if(fContrato[i][cCreado] AND !strcmp(fContrato[i][cJugador], NJ(playerid), true))
			{
				format(s, 300, "%s\t\t%s\n%s", fContrato[i][cJugador], FI[fContrato[i][cFaccion]][fNombre], s);
			}
		}
		new e[400];
		format(e, 400, "Faccion\t\tContratante\n%s", s);
		ShowPlayerDialog(playerid, 90, DIALOG_STYLE_LIST, "Contratos", e, "Seleccionar", "Salir");
		return 1;
		}
	    for(new i; i<MAX_CONTRATOS; i++)
	    {
	        if(!strcmp(fContrato[i][cJugador], NJ(playerid), true) AND listitem == fContrato[i][cID])
	        {
	            SetPVarInt(playerid, "IDC", fContrato[i][cID]);
			    format(s, 100, "El jugador '%s' te invitó a formar parte de '%s'", fContrato[i][cContratante], FI[fContrato[i][cFaccion]][fNombre]);
			    ShowPlayerDialog(playerid, 91, DIALOG_STYLE_MSGBOX, FI[fContrato[i][cFaccion]][fNombre], s, "Ingresar", "Rechazar");
	        }
	    }
	}
	return 1;
}
zcmd(fabrir, playerid, params[])
{
	for(new i; i<MAX_HQ; i++)
	{
	    if((HI[i][hCreada] AND IsPlayerInRangeOfPoint(playerid, 7, HI[i][hPos_x2], HI[i][hPos_y2], HI[i][hPos_z2])) OR (HI[i][hCreada] AND IsPlayerInRangeOfPoint(playerid, 7, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z])))
	    {
			if(HI[i][hFaccion] == FaccionJugador[playerid])
			{
			    if(HI[i][hAbierta] == 1)
			    {
					SendClientMessage(playerid, -1, "Esta puerta ya está abierta para cerrarla usa '/fcerrar'");
			    }
				else
				{
				    HI[i][hAbierta] = 1;
        			SendClientMessage(playerid, -1, "Abriste la puerta, para cerrarla usa '/fcerrar'");
			    }
			}
	    }
	}
	return 1;
}
zcmd(fcerrar, playerid, params[])
{
	for(new i; i<MAX_HQ; i++)
	{
	    if((HI[i][hCreada] AND IsPlayerInRangeOfPoint(playerid, 7, HI[i][hPos_x2], HI[i][hPos_y2], HI[i][hPos_z2])) OR (HI[i][hCreada] AND IsPlayerInRangeOfPoint(playerid, 7, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z])))
	    {
			if(HI[i][hFaccion] == FaccionJugador[playerid])
			{
			    if(HI[i][hAbierta] == 0)
			    {
					SendClientMessage(playerid, -1, "Esta puerta ya está cerrada para abrirla usa '/fabrir'");
			    }
				else
				{
				    HI[i][hAbierta] = 0;
        			SendClientMessage(playerid, -1, "Cerraste la puerta, para abrirla usa '/fabrir'");
			    }
			}
	    }
	}
	return 1;
}
zcmd(commandopen, playerid, params[])
{
	for(new i = 1; i < MAX_REJAS; i++)
	{
		if((RI[i][rCreado]) AND (RI[i][rModo] == 1))
		{
			new Float:p[3];
			GetObjectPos(ObjectReja[i], p[0], p[1], p[2]);
			if(IsPlayerInRangeOfPoint(playerid, RI[i][rRango], p[0], p[1], p[2]))
			{
				if(FaccionJugador[playerid] != RI[i][rFaccion])
				{
					SendClientMessage(playerid, -1, "No tienes el mando para esta reja");
					return 1;
				}
				if(!RI[i][rAbierta])
				{
				    MoveObject(ObjectReja[i], RI[i][rPos2][0], RI[i][rPos2][1], RI[i][rPos2][2], RI[i][rSpeed], RI[i][rPos2][3], RI[i][rPos2][4], RI[i][rPos2][5]);
					RI[i][rAbierta] = 1;
					SetPVarInt(playerid, "PuertaID", ObjectReja[i]);
				}
			}
		}
	}
	return 1;
}
//-------------COMANDOS---------------//
zcmd(feditarveh, playerid, params[])
{
        if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
		new itemx[2], functionx[2];
		sscanf(params, "ss", itemx, functionx);
	    if(!strlen(itemx))
		{
			SendClientMessage(playerid, -1, "1. Faccion 2.Color1 3.Color2 4.Eliminar 5.Posición");
			SendClientMessage(playerid, -1, "Uso /feditarveh <Opcion>");
			return 1;
		}
		switch(strval(itemx))
		{
		    case 1:
		    {
		        if(!strlen(functionx))
		        {
					SendClientMessage(playerid, -1, "1. Faccion 2.Color1 3.Color2 4.Eliminar 5.Posición");
					SendClientMessage(playerid, -1, "Uso /feditarveh <Opcion>");
					return 1;
		        }
				for(new i; i < MAX_VEHICLEFACC; i++)
				{
				    if(FVehicles[i] == GetPlayerVehicleID(playerid))
				    {
						FV[i][vFaccion] = strval(functionx);
						new s[100];
						format(s, 100, "Cambiaste la faccion de este vehiculo a '%s(%d)'", FI[strval(functionx)][fNombre], strval(functionx));
						SendClientMessage(playerid, -1, s);
						return 1;
					}
				}
		    }
		    case 2:
		    {
				new id2 = GetVehicleID(GetPlayerVehicleID(playerid));
		        if(!strlen(functionx))
		        {
					SendClientMessage(playerid, -1, "1. Faccion 2.Color1 3.Color2 4.Eliminar 5.Posición");
					SendClientMessage(playerid, -1, "Uso /fveheditar <Opcion> <Cantidad>");
					return 1;
		        }
		        FV[id2][vColor1] = strval(functionx);
		        ChangeVehicleColor(GetPlayerVehicleID(playerid), strval(functionx), FV[id2][vColor2]);
				new s[100];
				format(s, 100, "Cambiaste el color1 de este vehiculo a '(%d)'", strval(functionx));
				SendClientMessage(playerid, -1, s);
				return 1;
		    }
		    case 3:
		    {
				new id2 = GetVehicleID(GetPlayerVehicleID(playerid));
		        if(!strlen(functionx))
		        {
					SendClientMessage(playerid, -1, "1. Faccion 2.Color1 3.Color2 4.Eliminar 5.Posición");
					SendClientMessage(playerid, -1, "Uso /fveheditar <Opcion> <Cantidad>");
					return 1;
		        }
		        FV[id2][vColor2] = strval(functionx);
		        ChangeVehicleColor(GetPlayerVehicleID(playerid), FV[id2][vColor1], FV[id2][vColor2]);
				new s[100];
				format(s, 100, "Cambiaste el color2 de este vehiculo a '(%d)'", strval(functionx));
				SendClientMessage(playerid, -1, s);
				return 1;
		    }
		    case 4:
		    {
				new id2 = GetVehicleID(GetPlayerVehicleID(playerid));
				if(!FV[id2][vCreado]){return 1;}
				SetPVarInt(playerid, "IDC", id2);
				new s[100];
				format(s, 100, "¿Estás intentando eliminar este '%s' estás seguro de ello?", VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
				ShowPlayerDialog(playerid, 92, DIALOG_STYLE_MSGBOX, "Eliminar vehículo", s, "Eliminar", "Cancelar");
		    }
		}
		return 1;
}
zcmd(fcrearveh, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
	for(new i; i < MAX_VEHICLEFACC; i++)
	{
 		if(!FV[i][vCreado])
 		{
 		    new faccionx, modelox, color1x, color2x;
 		    if(!sscanf(params, "dddd", faccionx, modelox, color1x, color2x))
 		    {
 		        new Float:x, Float:y, Float:z, Float:a;
 		        GetPlayerPos(playerid, x, y, z);
 		        GetPlayerFacingAngle(playerid, a);
                SetPlayerPos(playerid, x, y, z+1);
                FVehicles[i] = CreateVehicle(modelox, x, y, z, a, color1x, color2x, 60000*10);
                FV[i][vModelo] = modelox;
                FV[i][vFaccion] = faccionx;
                FV[i][vPos_x] = x;
                FV[i][vPos_y] = y;
                FV[i][vPos_z] = z;
                FV[i][vPos_a] = a;
                FV[i][vColor1] = color1x;
                FV[i][vColor2] = color2x;
                FV[i][vCreado] = 1;
				new file[256];
				format(file, 256, "Facciones/Vehiculos/%d.ini", i);
                dini_Create(file);
                GuardarVehiculoF(i);
 		    	return 1;
 		    }else SendClientMessage(playerid, -1, "Uso /fcrearveh <Faccion> <Modelo> <Color1> <Color2>");
 		    return 1;
 		}
	}
	return 1;
}
zcmd(crearfaccion, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
	if(strlen(params) > 1)
	{
		for(new i = 1; i<MAX_FACCIONES; i++)
		{
		    if(!FI[i][fCreada])
		    {
		        FI[i][fCreada] = 1;
				format(FI[i][fNombre], 24, params);
                SendClientMessage(playerid, -1, "Faccion creada sastifactoriamente, usa /fdarlider para hacerte el lider y empezar a editarla.");
				new file[256];
				format(file, 256, "Facciones/%d.ini", i);
				if(!fexist(file))
				{
					dini_Create(file);
					GuardarFaccion(i);
				}
                FaccionJugador[playerid] = i;
                RangoJugador[playerid] = 6;
		        return 1;
		    }
		}
	}else SendClientMessage(playerid, -1, "Uso: /crearfaccion <Nombre>");
	return 1;
}

zcmd(facciones, playerid, params[])
{
	new nombresx[100];
	for(new i = 1; i<MAX_FACCIONES; i++)
	{
		if(FI[i][fCreada])
		{
			format(nombresx, 100, "%s(%d) || %d || L - %s", FI[i][fNombre], i, FI[i][fMiembros], FI[i][fLider]);
			SendClientMessage(playerid, -1, nombresx);
		}
	}
	return 1;
}

zcmd(fdarlider, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
	new idx, idx2;
	if(!sscanf(params, "dd", idx, idx2))
	{
		if(FI[idx2][fCreada])
		{
		    if(FaccionJugador[idx])
		    {
		        FI[FaccionJugador[idx]][fMiembros]--;
		        if(!strcmp(FI[FaccionJugador[idx]][fLider], NJ(idx), true))
		        {
		            format(FI[FaccionJugador[idx]][fLider], 25 ,"Nadie");
					GuardarFaccion(FaccionJugador[idx]);
		        }
		    }
			format(FI[idx2][fLider], 25, NJ(idx));
			FaccionJugador[idx] = idx2;
			new s[100];
			format(s, 100, "Le diste lider de la faccion '%s' a %s (%d)", FI[idx2][fNombre], NJ(idx), idx);
			SendClientMessage(playerid, -1, s);
			format(s, 100, "El administrador %s(%d) %s ", NJ(playerid), playerid, FI[idx2][fNombre]);
			SendClientMessage(idx, -1, s);
			FI[idx2][fMiembros]++;
			GuardarFaccion(idx2);
		}else SendClientMessage(playerid, -1, "Esa faccion no existe");
	}else SendClientMessage(playerid, -1, "Uso: /darlider <JugadorID> <FaccionID>");
	return 1;
}

zcmd(fcontratar, playerid, params[])
{
        if(!FaccionJugador[playerid]){return SendClientMessage(playerid, -1, "No tienes faccion a la cual invitar a ese jugador");}
		new idx, e;
		if(!sscanf(params, "d", idx))
		{//Añadir si la otra persona no tiene faccion
			for(new i; i < MAX_CONTRATOS; i++)
			{
			    if(!strcmp(fContrato[i][cJugador], NJ(idx), true))
			    {
			        e++;
			    }
			}
			if(e == 5)
			{
				SendClientMessage(playerid, -1, "Ese jugador ya tiene el maximo de invitaciones por jugador");
			}else{
				CrearContrato(playerid, idx);
				SendClientMessage(idx, -1, "Te a llegado una invitacion a faccion");
				SendClientMessage(playerid, -1, "Invitaste a un jugador a tu faccion");
			}
		}else SendClientMessage(playerid, -1, "Uso /fcontratar <JugadorID>");
		return 1;
}

zcmd(fcontratos, playerid, params[])
{
	new s[300];
	for(new i; i<MAX_CONTRATOS; i++)
	{
		if(fContrato[i][cCreado] AND !strcmp(fContrato[i][cJugador], NJ(playerid), true))
		{
			format(s, 300, "%s\t\t%s\n%s", fContrato[i][cJugador], FI[fContrato[i][cFaccion]][fNombre], s);
		}
	}
	new e[400];
	format(e, 400, "Faccion\t\tContratante\n%s", s);
	ShowPlayerDialog(playerid, 90, DIALOG_STYLE_LIST, "Contratos", e, "Seleccionar", "Salir");
	return 1;
}
zcmd(fexpulsar, playerid, params[])
{
    if(!FaccionJugador[playerid]){return SendClientMessage(playerid, -1, "No tienes faccion de la cual expulsar a ese jugador");}
	new idx;
	if(!sscanf(params, "d", idx))
	{
	    if(FaccionJugador[idx] == FaccionJugador[playerid])
	    {
			FaccionJugador[idx] = 0;
			new s[100];
			format(s, 100, "El lider '%s' te expulsó de '%s'", NJ(playerid), FI[FaccionJugador[playerid]][fNombre]);
			SendClientMessage(idx, -1, s);
			format(s, 100, "Expulsaste a '%s' de '%s'", NJ(idx), FI[FaccionJugador[playerid]][fNombre]);
			SendClientMessage(playerid, -1, s);
	    }else SendClientMessage(playerid, -1, "Ese jugador no está en tu faccion");
	}
	return 1;
}

zcmd(fdarrango, playerid, params[])
{
    if(!FaccionJugador[playerid]){return SendClientMessage(playerid, -1, "No tienes faccion para cambiar a un jugador de rango");}
	new idx, rangox;
	if(!sscanf(params, "dd", idx, rangox))
	{
	    if(FaccionJugador[idx] == FaccionJugador[playerid])
	    {
			FaccionJugador[idx] = 0;
			new s[100];
			format(s, 100, "El lider '%s' te cambio el rango a '%s(%d)'", NJ(playerid), FRangos[FaccionJugador[playerid]][rangox], rangox);
			SendClientMessage(idx, -1, s);
			format(s, 100, "Le cambiaste el rango a '%s - %s(%d)' por '%s(%d)'", NJ(playerid), FRangos[FaccionJugador[playerid]][RangoJugador[playerid]], FRangos[FaccionJugador[playerid]][rangox], rangox);
			SendClientMessage(playerid, -1, s);
	    }else SendClientMessage(playerid, -1, "Ese jugador no está en tu faccion");
	}
	return 1;
}
zcmd(fayuda, playerid, params[])
{
	SendClientMessage(playerid, -1, "/crearfaccion, /feditarhq, /fcrearhq, /fcrearveh, /fcrearreja, /frangos, /feditarreja, /fdarrango");
	SendClientMessage(playerid, -1, "/fexpulsar, /fcontratar, /fdarlider, /fveheditar, /facciones");
	return 1;
}
zcmd(fnombre, playerid, params[])
{
	if(strlen(params) < 7)
	{
	    if(strlen(params) == 0)
	    {
	        SendClientMessage(playerid, -1, "Uso /fnombre <Nuevo Nombre>");
	        return 1;
	    }else{
	    	SendClientMessage(playerid, -1, "El nombre necesita 7 caracteres minimo");
	    	return 1;
		}
	}else{
		new s[100];
		format(s, 100, "Cambiaste el nombre de tu faccion '%s' por '%s'", FI[FaccionJugador[playerid]][fNombre], params);
		SendClientMessage(playerid, -1, s);
	    format(FI[FaccionJugador[playerid]][fNombre], 64, params);
	    GuardarFaccion(FaccionJugador[playerid]);
	}
	return 1;
}

zcmd(frangos, playerid, params[])
{
	new s[100];
	for(new i = 1; i < 7; i++)
	{
		format(s, 100, "%s\n%d - %s", s, i, FRangos[FaccionJugador[playerid]][i]);
	}
	new s2[110];
	format(s2, 110, "Numero - Nombre\n%s", s);
	ShowPlayerDialog(playerid, 93, DIALOG_STYLE_LIST, "Rango", s2, "Editar", "Cancelar");
	return 1;
}

zcmd(fcrearreja, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
    new faccionx;
	if(!sscanf(params, "d", faccionx))
	{
		for(new i = 1; i < MAX_REJAS; i++)
		{
		    if(!RI[i][rCreado])
		    {
				new file[200];
				format(file, 200, "Facciones/Rejas/%d.ini", i);
				if(!fexist(file))
				{
					dini_Create(file);
				}
				RI[i][rFaccion] = faccionx;
				RI[i][rCreado] = 1;
				RI[i][rModo] = 0;
				new Float: p[4];
				GetPlayerPos(playerid, p[0], p[1], p[2]);
				GetPlayerFacingAngle(playerid, p[3]);
				RI[i][rPos][0] = p[0];
				RI[i][rPos][1] = p[1]+2;
				RI[i][rPos][2] = p[2]+1;
				RI[i][rPos][3] = 0;
				RI[i][rPos][4] = p[3];
				RI[i][rPos][5] = 0;
				RI[i][rPos2][0] = p[0];
				RI[i][rPos2][1] = p[1]+2;
				RI[i][rPos2][2] = p[2]+5;
				RI[i][rPos2][3] = 0;
				RI[i][rPos2][4] = p[3];
				RI[i][rPos2][5] = 0;
				RI[i][rRango] = 10.0;
				RI[i][rSpeed] = 0.6;
				RI[i][rTiempo] = 5; //5 segundos
				GuardarReja(i);
				ShowPlayerDialog(playerid, 100, DIALOG_STYLE_INPUT, "Rejas", "Elige el modelo del objeto para la reja", "Seleccionar", "Salir");
				SetPVarInt(playerid, "RID", i);
				return 1;
			}
		}
	}else SendClientMessage(playerid, -1, "Uso /fcrearreja <IDFaccion>");
	return 1;
}
zcmd(idreja, playerid, params[])
{
	for(new i = 1; i<MAX_REJAS; i++)
	{
		if(RI[i][rCreado])
		{
		    if(IsPlayerInRangeOfPoint(playerid, 6, RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2]))
		    {
		        new s[100];
		        format(s, 100, "Esta reja es la ID = '%d'", i);
		        SendClientMessage(playerid, -1, s);
		        return 1;
		    }
		}
	}
	return 1;
}
zcmd(idhq, playerid, params[])
{
	for(new i = 1; i<MAX_HQ; i++)
	{
		if(HI[i][hCreada])
		{
		    if(IsPlayerInRangeOfPoint(playerid, 6, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]))
		    {
		        new s[100];
		        format(s, 100, "Este HQ es la ID = '%d'", i);
		        SendClientMessage(playerid, -1, s);
		        return 1;
		    }
		}
	}
	return 1;
}
zcmd(feditarreja, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
    new itemx[64], e, idex[64], opcionx[64];
	sscanf(params, "sss", itemx, idex, opcionx);
	for(new i = 1; i<MAX_REJAS; i++)
	{
		if(RI[i][rCreado] AND e == 0)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 15, RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2]))
		    {
		        e = i;
		    }
		}
	}
	if(!e){return SendClientMessage(playerid, -1, "No tienes rejas cerca para editar");}
	if(!strlen(itemx))
	{
	    SendClientMessage(playerid, -1, "Uso /feditarreja <Item>");
	    SendClientMessage(playerid, -1, "Items: 1. Posición Abierta 2. Modelo 3. Modo de apertura 4. Posición Cerrada 5. Eliminar (La mas cercana)");
	    SendClientMessage(playerid, -1, "Items 2: 6. Tiempo abierta <ID> <Tiempo : Segundos> 7. Rango de funcion <ID> <Rango> 8. Velocidad de apertura <ID> <Velocidad>");
	    return 1;
	}
	switch(strval(itemx))
	{
		case 1:
		{
		    SetPVarInt(playerid, "Editando", 1);
		    SetPVarInt(playerid, "EditandoID", e);
			EditObject(playerid, ObjectReja[e]);
		}
		case 2:
		{
		    SetPVarInt(playerid, "Editando", 3);
		    SetPVarInt(playerid, "EditandoID", e);
		    ShowPlayerDialog(playerid, 100, DIALOG_STYLE_INPUT, "Rejas", "Elige el modelo del objeto para la reja", "Seleccionar", "Salir");
		}
		case 3:
		{
		    SetPVarInt(playerid, "Editando", 3);
		    SetPVarInt(playerid, "EditandoID", e);
		    ShowPlayerDialog(playerid, 101, DIALOG_STYLE_MSGBOX, "Rejas", "¿Como quieres que se active la puerta?", "Comando", "Tecla 'H'");
		}
		case 4:
		{
		    SetPVarInt(playerid, "Editando", 2);
		    SetPVarInt(playerid, "EditandoID", e);
			EditObject(playerid, ObjectReja[e]);
		}
		case 5:
		{
			RI[e][rFaccion] = 0;
			RI[e][rCreado] = 0;
			RI[e][rModo] = 0;
			RI[e][rModelo] = 0;
			for(new e2; e2 < 6; e2++)
			{
			 	new s[64];
			 	format(s, 64, "Pos_%d", e2);
				RI[e][rPos][e2] = 0.0;
			}
			for(new e2; e2 < 6; e2++)
			{
			 	new s[64];
			 	format(s, 64, "Pos2_%d", e2);
				RI[e][rPos2][e2] = 0.0;
			}
			DestroyObject(ObjectReja[e]);
		    SetPVarInt(playerid, "Editando", 2);
		    SetPVarInt(playerid, "EditandoID", e);
			EditObject(playerid, ObjectReja[e]);
		}
		case 6:
		{
			if(!strlen(idex))
			{
                SendClientMessage(playerid, -1, "Uso /feditarreja 6 <ID> <Tiempo : Segundos>");
			}
			else if(!strlen(opcionx))
			{
			    new s[100];
			    format(s, 100, "Uso /feditarreja 6 %d <Tiempo : Segundos>", strlen(idex));
                SendClientMessage(playerid, -1, s);
			}
			else{
			    new s[100];
			    format(s, 100, "Has cambiado el timpo de apertura de la puerta %d a %d segundos", strlen(idex), strlen(opcionx));
                SendClientMessage(playerid, -1, s);
			    RI[strlen(idex)][rTiempo] = strlen(opcionx);
			}
		}
		case 7:
		{
			if(!strlen(idex))
			{
                SendClientMessage(playerid, -1, "Uso /feditarreja 7 <ID> <Rango>");
			}
			else if(!strlen(opcionx))
			{
			    new s[100];
			    format(s, 100, "Uso /feditarreja 7 %d <Rango>", strlen(idex));
                SendClientMessage(playerid, -1, s);
			}
			else{
			    new s[100];
			    format(s, 100, "Has cambiado el rango de apertura de la puerta %d a %d", strlen(idex), strlen(opcionx));
                SendClientMessage(playerid, -1, s);
			    RI[strlen(idex)][rRango] = strlen(opcionx);
			}
		}
		case 8:
		{
			if(!strlen(idex))
			{
                SendClientMessage(playerid, -1, "Uso /feditarreja 8 <ID> <Velocidad>");
			}
			else if(!strlen(opcionx))
			{
			    new s[100];
			    format(s, 100, "Uso /feditarreja 8 %d <Velocidad>", strlen(idex));
                SendClientMessage(playerid, -1, s);
			}
			else{
			    new s[100];
			    format(s, 100, "Has cambiado la velocidad de apertura de la puerta %d a %f", strlen(idex), floatstr(opcionx));
                SendClientMessage(playerid, -1, s);
			    RI[strlen(idex)][rSpeed] = floatstr(opcionx);
			}
		}
	}
	return 1;
}

zcmd(fcrearhq, playerid, params[])
{
	new idx;
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
    if(sscanf(params, "d", idx)){return SendClientMessage(playerid, -1, "Uso /fcrearhq <FaccionID> (Para ver las facciones usa /facciones)");}
	for(new i = 1; i < MAX_HQ; i++)
	{
	    if(!HI[i][hCreada])
	    {
			new file[256];
			format(file, 256, "Facciones/HQs/%d.ini", i);
	        if(!fexist(file))
	        {
	            dini_Create(file);
	        }
		    HI[i][hFaccion] = idx;
			GetPlayerPos(playerid, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]);
			GetPlayerFacingAngle(playerid, HI[i][hPos_a]);
			HI[i][hCreada] = 1;
			SendClientMessage(playerid, -1, "Usa /feditarhq para editar el nuevo HQ");
			PickupHQ[i] = CreatePickup(1318, 0, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]);
			new s[100];
			format(s, 100, "%s\n\nPresiona 'F' para ingresar", FI[HI[i][hFaccion]][fNombre]);
			LabelHQ[i] = Create3DTextLabel(s, -1, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z], 16.0, 0, 0);
			GuardarHQ(i);
			return 1;
	    }
	}
	return 1;
}

zcmd(feditarhq, playerid, params[])
{
    if(!IsPlayerAdmin(playerid)){return SendClientMessage(playerid, -1, "No tienes permisos para esto");}
    new itemx[64], optionx[64], optionxextra[64];
	sscanf(params, "sss", itemx, optionx, optionxextra);
	if(!strlen(itemx))
	{
	    SendClientMessage(playerid, -1, "Uso /feditarhq <Item>");
	    SendClientMessage(playerid, -1, "1. Faccion 2. Posición 3. Eliminar 4. Interior(Posición) 5. VirtualWorld");
	    return 1;
	}
	new fixitemx = strval(itemx);
	new fixoptionx = strval(optionx);
	new fixoptionxextra = strval(optionxextra);
	switch(fixitemx)
	{
		case 1:
		{
		    if(!strlen(optionx))
		    {
			    SendClientMessage(playerid, -1, "Uso /feditarhq <Item> <Cantidad>");
			    SendClientMessage(playerid, -1, "1. Faccion 2. Posición 3. Eliminar");
			    return 1;
			}
			for(new i = 1; i < MAX_HQ; i++)
			{
			    if(HI[i][hCreada])
			    {
					if(IsPlayerInRangeOfPoint(playerid, 4, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]))
					{
					    HI[i][hFaccion] = fixoptionx;
						new s[100];
						format(s, 100, "Cambiaste la faccion de este HQ a '%s(%d)'", FI[fixoptionx][fNombre], fixoptionx);
						SendClientMessage(playerid, -1, s);
					    return 1;
					}
				}
			}
		}
		case 2:
		{
		    if(!strlen(optionx))
		    {
			    SendClientMessage(playerid, -1, "Uso /feditarhq 2 <HQID>");
			    return 1;
			}
            if(!HI[fixoptionx][hCreada] OR fixoptionx > MAX_HQ){return SendClientMessage(playerid, -1, "Esa faccion es inexistente");}
            GetPlayerPos(playerid, HI[fixoptionx][hPos_x], HI[fixoptionx][hPos_y], HI[fixoptionx][hPos_z]);
			new s[100];
			format(s, 100, "Cambiaste la posición al HQ '%d'", fixoptionx);
			SendClientMessage(playerid, -1, s);
			DestroyPickup(PickupHQ[fixoptionx]);
			PickupHQ[fixoptionx] = CreatePickup(1318, 0, HI[fixoptionx][hPos_x], HI[fixoptionx][hPos_y], HI[fixoptionx][hPos_z]);
			Delete3DTextLabel(LabelHQ[fixoptionx]);
			format(s, 100, "%s\n\nPresiona 'F' para ingresar", FI[HI[fixoptionx][hFaccion]][fNombre]);
			LabelHQ[fixoptionx] = Create3DTextLabel(s, -1, HI[fixoptionx][hPos_x], HI[fixoptionx][hPos_y], HI[fixoptionx][hPos_z], 16.0, 0, 0);
		}
		case 3:
		{
			for(new i = 1; i < MAX_HQ; i++)
			{
			    if(HI[i][hCreada])
			    {
					if(IsPlayerInRangeOfPoint(playerid, 4, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]))
					{
			            if(!HI[i][hCreada]){return SendClientMessage(playerid, -1, "Esa faccion es inexistente");}
						new s[100];
						format(s, 100, "Eliminaste el HQ '%d'", i);
						SendClientMessage(playerid, -1, s);
						VaciarHQ(i);
						DestroyPickup(PickupHQ[i]);
						Delete3DTextLabel(LabelHQ[i]);
						return 1;
					}
				}
			}
		}
		case 4:
		{
		    if(!strlen(optionx))
		    {
			    SendClientMessage(playerid, -1, "Uso /feditarhq 4 <HQID>");
			    return 1;
			}
            if(!HI[fixoptionx][hCreada] OR fixoptionx > MAX_HQ){return SendClientMessage(playerid, -1, "Esa faccion es inexistente");}
            GetPlayerPos(playerid, HI[fixoptionx][hPos_x2], HI[fixoptionx][hPos_y2], HI[fixoptionx][hPos_z2]);
            GetPlayerFacingAngle(playerid, HI[fixoptionx][hPos_a2]);
            HI[fixoptionx][hInterior] = GetPlayerInterior(playerid);
			HI[fixoptionx][hiInterior] = 1;
			new s[200];
			format(s, 200, "Cambiaste el interior al HQ '%d' (El ID del interior fué incluido, puedes editar el VirtualWorld para evitar bugs no deseados)", fixoptionx);
			SendClientMessage(playerid, -1, s);
		}
		case 5:
		{
		    if(!strlen(optionx) OR !strlen(optionxextra))
		    {
			    SendClientMessage(playerid, -1, "Uso /feditarhq 5 <HQID> <VirtualWorldID>");
			    return 1;
			}
            if(!HI[fixoptionx][hCreada] OR fixoptionx > MAX_HQ){return SendClientMessage(playerid, -1, "Esa faccion es inexistente");}
			new s[100];
			format(s, 100, "Cambiaste el VirtualWorld al HQ '%d - VW(%d)' por '%d'", fixoptionx, HI[fixoptionx][hVW], fixoptionxextra);
			SendClientMessage(playerid, -1, s);
            HI[fixoptionx][hVW] = fixoptionxextra;
		}
	}
	return 1;
}
//-----------------------------------//
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
		new i = GetPVarInt(playerid, "EditandoID");
		if(GetPVarInt(playerid, "Editando") == 1)
		{
	 		RI[i][rPos2][0] = fX;
			RI[i][rPos2][1] = fY;
			RI[i][rPos2][2] = fZ;
	  		RI[i][rPos2][3] = fRotX;
			RI[i][rPos2][4] = fRotY;
			RI[i][rPos2][5] = fRotZ;
			GuardarReja(i);
			DestroyObject(ObjectReja[i]);
			ObjectReja[i] = CreateObject(RI[i][rModelo], RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2], RI[i][rPos][3], RI[i][rPos][4], RI[i][rPos][5]);
			DeletePVar(playerid, "Editando");
			DeletePVar(playerid, "EditandoID");
		}
		if(GetPVarInt(playerid, "Editando") == 2)
   		{
		    RI[i][rPos][0] = fX;
			RI[i][rPos][1] = fY;
			RI[i][rPos][2] = fZ;
	  		RI[i][rPos][3] = fRotX;
			RI[i][rPos][4] = fRotY;
			RI[i][rPos][5] = fRotZ;
			GuardarReja(i);
			DestroyObject(i);
			ObjectReja[i] = CreateObject(RI[i][rModelo], RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2], RI[i][rPos][3], RI[i][rPos][4], RI[i][rPos][5]);
			DeletePVar(playerid, "Editando");
			DeletePVar(playerid, "EditandoID");
		}
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_SECONDARY_ATTACK)
    {
		for(new i = 1; i < MAX_HQ; i++)
		{
			if(HI[i][hCreada])
			{
				if(IsPlayerInRangeOfPoint(playerid, 4, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]))
				{
				    if(HI[i][hiInterior] == 0)
				    {
				        if(IsPlayerAdmin(playerid))
				        {
				            SendClientMessage(playerid, -1, "Ese HQ no tiene un interior definido usa /feditarhq");
				        }else SendClientMessage(playerid, -1, "Ese HQ no tiene un interior definido");
				        return 1;
				    }
			    	if(!(HI[i][hAbierta]) AND (FaccionJugador[playerid] != HI[i][hFaccion]))
			    	{
				        SendClientMessage(playerid, -1, "La puerta está cerrada pide que la abran");
				        return 1;
			    	}
					SetPlayerPos(playerid, HI[i][hPos_x2], HI[i][hPos_y2], HI[i][hPos_z2]);
					SetPlayerFacingAngle(playerid, HI[i][hPos_a2]);
					SetPlayerInterior(playerid, HI[i][hInterior]);
					SetPlayerVirtualWorld(playerid, HI[i][hVW]);
				}
				if(IsPlayerInRangeOfPoint(playerid, 4, HI[i][hPos_x2], HI[i][hPos_y2], HI[i][hPos_z2]) AND GetPlayerVirtualWorld(playerid) == HI[i][hVW] AND GetPlayerInterior(playerid) == HI[i][hInterior])
				{
					SetPlayerPos(playerid, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]);
					SetPlayerFacingAngle(playerid, HI[i][hPos_a]);
					SetPlayerInterior(playerid, GetPlayerInterior(playerid)-HI[i][hInterior]);
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid)-HI[i][hVW]);
				}
			}
		}
    }
    if(newkeys & KEY_CTRL_BACK)
    {
		for(new i = 1; i < MAX_REJAS; i++)
		{
			if((RI[i][rCreado]) AND (RI[i][rModo] == 2))
			{
				new Float:p[3];
				GetObjectPos(ObjectReja[i], p[0], p[1], p[2]);
				if(IsPlayerInRangeOfPoint(playerid, RI[i][rRango], p[0], p[1], p[2]))
				{
				    if(FaccionJugador[playerid] != RI[i][rFaccion])
				    {
				        SendClientMessage(playerid, -1, "No tienes el mando para esta reja");
				        return 1;
				    }
					if(!RI[i][rAbierta])
					{
					    MoveObject(ObjectReja[i], RI[i][rPos2][0], RI[i][rPos2][1], RI[i][rPos2][2], RI[i][rSpeed], RI[i][rPos2][3], RI[i][rPos2][4], RI[i][rPos2][5]);
						RI[i][rAbierta] = 1;
						SetPVarInt(playerid, "PuertaID", ObjectReja[i]);
					}
				}
			}
		}
    }
	return 1;
}

function VaciarHQ(i)
{
	HI[i][hFaccion] = 0;
	HI[i][hPos_x] = 0.0;
	HI[i][hPos_y] = 0.0;
	HI[i][hPos_z] = 0.0;
	HI[i][hPos_a] = 0.0;
	HI[i][hPos_x2] = 0.0;
	HI[i][hPos_y2] = 0.0;
	HI[i][hPos_z2] = 0.0;
	HI[i][hPos_a2] = 0.0;
	HI[i][hCreada] = 0;
	return 1;
}
stock NJ(playerid)
{
	new namex[MAX_PLAYER_NAME];
	GetPlayerName(playerid, namex, MAX_PLAYER_NAME);
	return namex;
}

function GuardarFaccion(id)
{
	new file[256];
	format(file, 256, "Facciones/%d.ini", id);
	if(fexist(file))
	{
	    dini_Set(file, "Nombre", FI[id][fNombre]);
	    dini_Set(file, "Lider", FI[id][fLider]);
	    dini_IntSet(file, "Miembros", FI[id][fMiembros]);
	    dini_IntSet(file, "Autos", FI[id][fAutos]);
	    dini_IntSet(file, "HQ", FI[id][fHQ]);
	    dini_IntSet(file, "Creada", FI[id][fCreada]);
	    new s[64];
	    for(new i = 1; i < 7; i++)
	    {
			format(s, 64, "Rango_%d", i);
	        dini_Set(file, s, FRangos[id][i]);
	    }
	}
	return 1;
}
function CargarFacciones()
{
	new file[256], e;
	for(new i = 1; i<MAX_FACCIONES; i++)
	{
		format(file, 256, "Facciones/%d.ini", i);
		if(fexist(file))
		{
	    strmid(FI[i][fNombre], dini_Get(file, "Nombre"), false, strlen(dini_Get(file, "Nombre")), 24);
	    strmid(FI[i][fLider], dini_Get(file, "Lider"), false, strlen(dini_Get(file, "Lider")), 25);
		FI[i][fMiembros] = dini_Int(file, "Miembros");
		FI[i][fAutos] = dini_Int(file, "Autos");
		FI[i][fHQ] = dini_Int(file, "HQ");
		FI[i][fCreada] = dini_Int(file, "Creada");
	    new s[64];
	    for(new p = 1; p < 7; p++)
	    {
			format(s, 64, "Rango_%d", p);
	    	strmid(FRangos[i][p], dini_Get(file, s), false, strlen(dini_Get(file, s)), 24);
	    }
		if(FI[i][fCreada]){e++;}
		}
	}
	printf("%d facciones cargadas", e);
}
function CrearContrato(playerid, idx)
{
	new fName[24], fID = FaccionJugador[playerid];
    format(fName, 24, FI[fID][fNombre]);
	new aName[24], bName[24];
	GetPlayerName(playerid, aName, 24);
	GetPlayerName(idx, bName, 24);
	new file[256];
	for(new i; i < MAX_CONTRATOS; i++)
	{
		if(!fContrato[i][cCreado])
		{
			format(file, 256, "Facciones/Contratos/%d.ini", i);
			if(!fexist(file))
			{
				dini_Create(file);
			}
            fContrato[i][cCreado] = 1;
            format(fContrato[i][cJugador], 24, bName);
            format(fContrato[i][cContratante], 24, aName);
            fContrato[i][cFaccion] = fID;
            GuardarContrato(i);
			printf("contrato %d creado", i);
            return 1;
		}
	}
	return 1;
}
function GuardarVehiculoF(id)
{
	new file[256];
	format(file, 256, "Facciones/Vehiculos/%d.ini", id);
	if(fexist(file))
	{
		dini_IntSet(file, "Modelo", FV[id][vModelo]);
		dini_IntSet(file, "Faccion", FV[id][vFaccion]);
		dini_FloatSet(file, "Pos_x", FV[id][vPos_x]);
		dini_FloatSet(file, "Pos_y", FV[id][vPos_y]);
		dini_FloatSet(file, "Pos_z", FV[id][vPos_z]);
		dini_FloatSet(file, "Pos_a", FV[id][vPos_a]);
		dini_IntSet(file, "Color1", FV[id][vColor1]);
		dini_IntSet(file, "Color2", FV[id][vColor2]);
		dini_IntSet(file, "Creado", FV[id][vCreado]);
	}
}
function CargarVehiculosF()
{
	new file[256], e;
	for(new i; i < MAX_VEHICLEFACC; i++)
	{
		format(file, 256, "Facciones/Vehiculos/%d.ini", i);
		if(fexist(file))
		{
			FV[i][vModelo] = dini_Int(file, "Modelo");
			FV[i][vFaccion] = dini_Int(file, "Faccion");
			FV[i][vPos_x] = dini_Float(file, "Pos_x");
			FV[i][vPos_y] = dini_Float(file, "Pos_y");
			FV[i][vPos_z] = dini_Float(file, "Pos_z");
			FV[i][vPos_a] = dini_Float(file, "Pos_a");
			FV[i][vColor1] = dini_Int(file, "Color1");
			FV[i][vColor2] = dini_Int(file, "Color2");
			FV[i][vCreado] = dini_Int(file, "Creado");
   			FVehicles[i] = CreateVehicle(FV[i][vModelo], FV[i][vPos_x], FV[i][vPos_y], FV[i][vPos_z], FV[i][vPos_a], FV[i][vColor1], FV[i][vColor2], 60000*10);
			if(FV[i][vCreado]){e++;}
		}
	}
	printf("%d vehiculos cargados", e);
}
function GuardarContrato(id)
{
	new file[256];
	format(file, 256, "Facciones/Contratos/%d.ini", id);
	if(fexist(file))
	{
		dini_IntSet(file, "Creado", fContrato[id][cCreado]);
		dini_Set(file, "Jugador", fContrato[id][cJugador]);
		dini_Set(file, "Contratante", fContrato[id][cContratante]);
		dini_IntSet(file, "Faccion", fContrato[id][cFaccion]);
		dini_IntSet(file, "ID", fContrato[id][cID]);
	}
}
function CargarContratos()
{
	new file[256], e;
	for(new i; i < MAX_CONTRATOS; i++)
	{
		format(file, 256, "Facciones/Contratos/%d.ini", i);
		if(fexist(file))
		{
			fContrato[i][cCreado] = dini_Int(file, "Creado");
		    strmid(fContrato[i][cJugador], dini_Get(file, "Jugador"), false, strlen(dini_Get(file, "Jugador")), 25);
		    strmid(fContrato[i][cContratante], dini_Get(file, "Contratante"), false, strlen(dini_Get(file, "Contratante")), 25);
			fContrato[i][cFaccion] = dini_Int(file, "Faccion");
			fContrato[i][cID] = dini_Int(file, "ID");
			if(fContrato[i][cCreado]){e++;}
		}
	}
	printf("%d contratos cargados", e);
}
stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
	if (isnull(string))
	#else
	if (string[0] == 0 OR (string[0] == 1 AND string[1] == 0))
	#endif
	{
		return format[0];
	}
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] AND string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount AND string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' AND ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' AND ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				new
					end = stringPos - 1,
					ch;
				while ((ch = string[++end]) AND ch != delim) {}
				string[end] = '\0';
				setarg(paramPos,0,_:floatstr(string[stringPos]));
				string[end] = ch;
				stringPos = end;
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) AND ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) AND ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num AND IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) AND ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] AND string[stringPos] != delim AND string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] AND (string[stringPos] == delim OR string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) AND delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

function VaciarVehiculo(id, playerid)
{
	if(!FV[id][vCreado]){return 1;}
	FV[id][vModelo] = 0;
	FV[id][vFaccion] = 0;
	FV[id][vPos_x] = 0.0;
	FV[id][vPos_y] = 0.0;
	FV[id][vPos_z] = 0.0;
	FV[id][vPos_a] = 0.0;
	FV[id][vColor1] = 0;
	FV[id][vColor2] = 0;
	FV[id][vCreado] = 0;
	DestroyVehicle(FVehicles[id]);
	DeletePVar(playerid, "IDC");
	GuardarVehiculoF(id);
	return 1;
}

function VaciarContrato(id, playerid, fasex)
{
	if(fContrato[id][cID] < 6)
	{
	    if(fContrato[id][cID] == 1)
	    {
			for(new i; i<MAX_CONTRATOS; i++)
			{
			    if(!strcmp(fContrato[id][cJugador], NJ(playerid), true))
			    {
				    if(fContrato[i][cID] == 2)
				    {
                        fContrato[i][cID] = 1;
				    }
				    if(fContrato[i][cID] == 3)
				    {
                        fContrato[i][cID] = 2;
				    }
				    if(fContrato[i][cID] == 4)
				    {
                        fContrato[i][cID] = 3;
				    }
				    if(fContrato[i][cID] == 5)
				    {
                        fContrato[i][cID] = 4;
				    }
			    }
			}
	    }
	    if(fContrato[id][cID] == 2)
	    {
			for(new i; i<MAX_CONTRATOS; i++)
			{
			    if(!strcmp(fContrato[id][cJugador], NJ(playerid), true))
			    {
				    if(fContrato[i][cID] == 3)
				    {
                        fContrato[i][cID] = 2;
				    }
				    if(fContrato[i][cID] == 4)
				    {
                        fContrato[i][cID] = 3;
				    }
				    if(fContrato[i][cID] == 5)
				    {
                        fContrato[i][cID] = 4;
				    }
			    }
			}
	    }
	    if(fContrato[id][cID] == 3)
	    {
			for(new i; i<MAX_CONTRATOS; i++)
			{
			    if(!strcmp(fContrato[id][cJugador], NJ(playerid), true))
			    {
				    if(fContrato[i][cID] == 4)
				    {
                        fContrato[i][cID] = 3;
				    }
				    if(fContrato[i][cID] == 5)
				    {
                        fContrato[i][cID] = 4;
				    }
			    }
			}
	    }
	    if(fContrato[id][cID] == 4)
	    {
			for(new i; i<MAX_CONTRATOS; i++)
			{
			    if(!strcmp(fContrato[id][cJugador], NJ(playerid), true))
			    {
				    if(fContrato[i][cID] == 5)
				    {
                        fContrato[i][cID] = 4;
				    }
			    }
			}
	    }
	}
	if(fasex == 1)
	{
	    if(FaccionJugador[playerid])
		{
		    SendClientMessage(playerid, -1, "Ya tienes faccion");
		    return 1;
	    }
		FaccionJugador[playerid] = fContrato[id][cFaccion];
		new str[100];
		format(str, 100, "Ingresaste a '%s' sastifactoriamente", FI[fContrato[id][cFaccion]][fNombre]);
		SendClientMessage(playerid, -1, str);
	}
	fContrato[id][cFaccion] = 0;
	fContrato[id][cCreado] = 0;
	fContrato[id][cID] = 0;
	format(fContrato[id][cJugador], 24, "Nadie");
	format(fContrato[id][cContratante], 24, "Nadie");
	DeletePVar(playerid, "IDC");
	for(new i; i<MAX_CONTRATOS; i++)
	{
		if(!strcmp(fContrato[id][cJugador], NJ(playerid), true))
		{
			GuardarContrato(i);
		}
	}
	GuardarContrato(id);
	return 1;
}

function GetVehicleID(vehicleid)
{
	for(new i; i < MAX_VEHICLEFACC; i++)
	{
		if(FVehicles[i] == vehicleid)
		{
			return i;
		}
	}
	return 1;
}

function CargarHQs()
{
	new file[256];
	for(new i = 1; i < MAX_HQ; i++)
	{
		format(file, 256, "Facciones/HQs/%d.ini", i);
		HI[i][hFaccion] = dini_Int(file, "Faccion");
		HI[i][hPos_x] = dini_Float(file, "Pos_X");
		HI[i][hPos_y] = dini_Float(file, "Pos_Y");
		HI[i][hPos_z] = dini_Float(file, "Pos_Z");
		HI[i][hPos_a] = dini_Float(file, "Pos_A");
		HI[i][hPos_x2] = dini_Float(file, "Pos_X2");
		HI[i][hPos_y2] = dini_Float(file, "Pos_Y2");
		HI[i][hPos_z2] = dini_Float(file, "Pos_Z2");
		HI[i][hPos_a2] = dini_Float(file, "Pos_A2");
		HI[i][hCreada] = dini_Int(file, "Creada");
		HI[i][hVW] = dini_Int(file, "VW");
		HI[i][hInterior] = dini_Int(file, "Interior");
		HI[i][hiInterior] = dini_Int(file, "iInterior");
		HI[i][hAbierta] = dini_Int(file, "Seguro");
		PickupHQ[i] = CreatePickup(1318, 0, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z]);
		new s[100];
		format(s, 100, "%s\n\nPresiona 'F' para ingresar", FI[HI[i][hFaccion]][fNombre]);
		LabelHQ[i] = Create3DTextLabel(s, -1, HI[i][hPos_x], HI[i][hPos_y], HI[i][hPos_z], 16.0, 0, 0);
	}
	return 1;
}

function GuardarHQ(id)
{
	new file[256];
	format(file, 256, "Facciones/HQs/%d.ini", id);
	dini_IntSet(file, "Faccion", HI[id][hFaccion]);
	dini_FloatSet(file, "Pos_X", HI[id][hPos_x]);
	dini_FloatSet(file, "Pos_Y", HI[id][hPos_y]);
	dini_FloatSet(file, "Pos_Z", HI[id][hPos_z]);
	dini_FloatSet(file, "Pos_A", HI[id][hPos_a]);
	dini_FloatSet(file, "Pos_X2", HI[id][hPos_x2]);
	dini_FloatSet(file, "Pos_Y2", HI[id][hPos_y2]);
	dini_FloatSet(file, "Pos_Z2", HI[id][hPos_z2]);
	dini_FloatSet(file, "Pos_A2", HI[id][hPos_a2]);
	dini_IntSet(file, "Creada", HI[id][hCreada]);
	dini_IntSet(file, "VW", HI[id][hVW]);
	dini_IntSet(file, "Interior", HI[id][hInterior]);
	dini_IntSet(file, "iInterior", HI[id][hiInterior]);
	dini_IntSet(file, "Seguro", HI[id][hAbierta]);
	return 1;
}

function GuardarReja(id)
{
	new file[200];
	format(file, 200, "Facciones/Rejas/%d.ini", id);
	if(!fexist(file)){return 1;}
	dini_IntSet(file, "Faccion", RI[id][rFaccion]);
	dini_IntSet(file, "Creado", RI[id][rCreado]);
	dini_IntSet(file, "Modo", RI[id][rModo]);
	dini_IntSet(file, "Modelo", RI[id][rModelo]);
	for(new i; i < 6; i++)
	{
	    new s[64];
	    format(s, 64, "Pos_%d", i);
		dini_FloatSet(file, s, RI[id][rPos][i]);
	}
	for(new i; i < 6; i++)
	{
	    new s[64];
	    format(s, 64, "Pos2_%d", i);
		dini_FloatSet(file, s, RI[id][rPos2][i]);
	}
	dini_FloatSet(file, "Rango", RI[id][rRango]);
	dini_FloatSet(file, "Velocidad", RI[id][rSpeed]);
	dini_IntSet(file, "Tiempo", RI[id][rTiempo]);
	return 1;
}

function CargarRejas()
{
	for(new i; i < MAX_REJAS; i++)
	{
		new file[200];
		format(file, 200, "Facciones/Rejas/%d.ini", i);
		if(fexist(file))
		{
			RI[i][rFaccion] = dini_Int(file, "Faccion");
			RI[i][rCreado] = dini_Int(file, "Creado");
			RI[i][rModo] = dini_Int(file, "Modo");
			RI[i][rModelo] = dini_Int(file, "Modelo");
			for(new e; e < 6; e++)
			{
			    new s[64];
			    format(s, 64, "Pos_%d", e);
				RI[i][rPos][e] = dini_Float(file, s);
			}
			for(new e; e < 6; e++)
			{
			    new s[64];
			    format(s, 64, "Pos2_%d", e);
				RI[i][rPos2][e] = dini_Float(file, s);
			}
			RI[i][rRango] = dini_Float(file, "Rango");
			RI[i][rSpeed] = dini_Float(file, "Velocidad");
			RI[i][rTiempo] = dini_Int(file, "Tiempo");
			ObjectReja[i] = CreateObject(RI[i][rModelo], RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2], RI[i][rPos][3], RI[i][rPos][4], RI[i][rPos][5]);
		}
	}
	return 1;
}

function Numerico(s[])
{
	for (new i = 0, j = strlen(s); i < j; i++)
	{
		if (s[i] > '9' OR s[i] < '0') return 0;
	}
	return 1;
}

function CerrarReja(i)
{
	MoveObject(ObjectReja[i], RI[i][rPos][0], RI[i][rPos][1], RI[i][rPos][2], RI[i][rSpeed], RI[i][rPos][3], RI[i][rPos][4], RI[i][rPos][5]);
	RI[i][rAbierta] = 0;
	return 1;
}
