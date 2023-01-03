#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <foreach>

#define TEMPO_EFEITO 10000 //10s O tempo durante o qual o jogador atingido está sob o efeito do taser.
#define TEMPO_RECARREGAR 2000 //2s O tempo após o qual o taser será dado novamente.
#define ARMA_TASER WEAPON_SILENCED // A arma que funcionará como um taser.
#define ARMA_SLOTS 2 // O slot da arma escolhida.
#define OBJETO_TASER 347 // O ID do objeto da arma escolhida.

new bool:taser[MAX_PLAYERS];
new GiveTaserAgainTimer[MAX_PLAYERS];
new lastWeapon[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
 taser[playerid] = false;
 GiveTaserAgainTimer[playerid] = 0;
 lastWeapon[playerid] = 0;

 // Pré-carregue as bibliotecas de animação usadas.
 ApplyAnimation(playerid, "SWORD", "null", 0.0, 0, 0, 0, 0, 0);
 ApplyAnimation(playerid, "CRACK", "null", 0.0, 0, 0, 0, 0, 0);
    SendClientMessage(playerid, -1, "Esse Servidor Usa Sistema De Taser De {00FF80} Rosascripter");
 return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
 taser[playerid] = false;
 GiveTaserAgainTimer[playerid] = 0;
 lastWeapon[playerid] = 0;
    return 1;
}

public OnPlayerUpdate(playerid)
{
 new w = GetPlayerWeapon(playerid);
 if (w != lastWeapon[playerid]) OnPlayerChangeWeapon(playerid, w, lastWeapon[playerid]);
 lastWeapon[playerid] = w;
 return 1;
}

forward OnPlayerChangeWeapon(playerid, newWeap, oldWeap);
public OnPlayerChangeWeapon(playerid, newWeap, oldWeap)
{
 if (IsPlayerAttachedObjectSlotUsed(playerid, 0) && taser[playerid]) SetPlayerArmedWeapon(playerid, 0);
 return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
 if (weaponid == ARMA_TASER)
 {
  if (taser[issuerid])
  {
   new Float:health;
   GetPlayerHealth(playerid, health);
   SetPlayerHealth(playerid, health+amount);
  }
 }
 return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
 if (weaponid == ARMA_TASER)
 {
  if (taser[playerid])
  {
   GiveTaserAgainTimer[playerid] = SetTimerEx("GiveTaserAgain", TEMPO_RECARREGAR, 0, "i", playerid);
   ApplyAnimation(playerid, "SWORD", "sword_block", 50.0, 0, 1, 0, 1, 1, 1);
   SetPlayerAttachedObject(playerid, 0, OBJETO_TASER, 6);
   SetPlayerArmedWeapon(playerid, 0);

   if (hittype == BULLET_HIT_TYPE_PLAYER) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(hitid, x, y, z);
    foreach(Player, i) if(IsPlayerInRangeOfPoint(i, 30.0, x, y, z)) PlayAudioStreamForPlayer(i, "https://a.clyp.it/b0w3dcsr.mp3", x, y, z, 30.0, 1);
    ApplyAnimation(hitid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, TEMPO_EFEITO, 1);
    SetPlayerDrunkLevel(hitid, 5000);
    SetTimerEx("EndTaserEffect", TEMPO_EFEITO, 0, "i", hitid);
   }
  }
 }
 return 1;
}

forward EndTaserEffect(playerid);
public EndTaserEffect(playerid)
{
 new skin = GetPlayerSkin(playerid);
 SetPlayerSkin(playerid, skin);
 ClearAnimations(playerid, 1);
 SetPlayerDrunkLevel(playerid, 0);
 return 1;
}

forward GiveTaserAgain(playerid);
public GiveTaserAgain(playerid)
{
 RemovePlayerAttachedObject(playerid, 0);
 GivePlayerWeapon(playerid, ARMA_TASER, 1);

 new skin = GetPlayerSkin(playerid);
 SetPlayerSkin(playerid, skin);
 ClearAnimations(playerid, 1);
 return 1;
}

CMD:taser(playerid, params[])
{
 new weapon, ammo;
 GetPlayerWeaponData(playerid, ARMA_SLOTS, weapon, ammo);
 GivePlayerWeapon(playerid, weapon, -ammo);

 if (taser[playerid])
 {
  taser[playerid] = false;
  if (GiveTaserAgainTimer[playerid]) KillTimer(GiveTaserAgainTimer[playerid]);
  if (IsPlayerAttachedObjectSlotUsed(playerid, 0)) {
   new skin = GetPlayerSkin(playerid);
   SetPlayerSkin(playerid, skin);
   ClearAnimations(playerid, 1);
   RemovePlayerAttachedObject(playerid, 0);
  }
 }
 else
 {
  taser[playerid] = true;
  GivePlayerWeapon(playerid, ARMA_TASER, 1);
 }
 return 1;
}