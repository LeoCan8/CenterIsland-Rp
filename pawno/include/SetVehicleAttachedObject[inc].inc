#include <a_samp>
/*Facilitador de Attach para vehiculos*/
/*CREADO POR romerorodriges para pawnoscripting.com*/
/*No Quitar cREDITOS...*/

/*------------------------------------
native SetVehicleAttachedObject(vehicleid,slot,model,Float:Vcordx,Float:Vcordy,Float:Vcordz,Float:Vrotx,Float:Vroty,Float:Vrotz);
native IsVehicleAttachedObjectSlotUsed(vehicleid,slot);
native RemoVehicleAttachedObject(vehicleid,slot);
------------------------------------*/
/*se puede cambiar el numero de slots (seran el numero de objetos que se
pueden poner en attach a cada vehiculo) POR DEFECTO 6*/

#define Max_Slots 7



new objetosV[MAX_VEHICLES][Max_Slots];


stock SetVehicleAttachedObject(vehicleid,slot,model,Float:Vcordx,Float:Vcordy,Float:Vcordz,Float:Vrotx,Float:Vroty,Float:Vrotz)
{
if(objetosV[vehicleid][slot]){DestroyObject(objetosV[vehicleid][slot]);}
objetosV[vehicleid][slot] = CreateObject(model,0,0,0,0,0,0);
AttachObjectToVehicle(objetosV[vehicleid][slot],vehicleid,Vcordx,Vcordy,Vcordz,Vrotx,Vroty,Vrotz);
return 0;
}


stock IsVehicleAttachedObjectSlotUsed(vehicleid,slot)
{
if(objetosV[vehicleid][slot])//{return 1;}
return 1;

return 0;
}

stock RemoVehicleAttachedObject(vehicleid,slot)
{
if(objetosV[vehicleid][slot])
{
DestroyObject(objetosV[vehicleid][slot]);
objetosV[vehicleid][slot] =0;
}
return 0;
}