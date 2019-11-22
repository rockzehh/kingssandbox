 //King's Sandbox by King Nothing (RockZehh).

#pragma semicolon 1

#include <kingssandbox>

#pragma newdecls required

bool g_bEntity[MAXENTS + 1];
bool g_bFrozen[MAXENTS + 1];
bool g_bLate;
bool g_bNoKill[MAXPLAYERS + 1];
bool g_bSolid[MAXENTS + 1];

char g_sAuthID[MAXPLAYERS + 1][32];
char g_sColorDB[PLATFORM_MAX_PATH];
char g_sInternetURL[MAXENTS + 1][PLATFORM_MAX_PATH];
char g_sMap[PLATFORM_MAX_PATH];
char g_sPropName[MAXENTS + 1][64];
char g_sSpawnDB[PLATFORM_MAX_PATH];

ConVar g_cvCelLimit;
ConVar g_cvPropLimit;

float g_fZero[3] =  { 0.0, 0.0, 0.0 };

Handle g_hOnCelSpawn;
Handle g_hOnEntityRemove;
Handle g_hOnPropSpawn;

int g_iBeam;
int g_iCelCount[MAXPLAYERS + 1];
int g_iCelLimit;
int g_iColor[MAXENTS + 1][4];
int g_iEntityDissolve;
int g_iHalo;
int g_iLand;
int g_iOwner[MAXENTS + 1];
int g_iPhys;
int g_iPropCount[MAXPLAYERS + 1];
int g_iPropLimit;

//Colors:
int g_iBlue[4] =  { 0, 0, 255, 175 };
int g_iGray[4] =  { 255, 255, 255, 300 };
int g_iGreen[4] =  { 0, 255, 0, 175 };
int g_iOrange[4] =  { 255, 128, 0, 175 };
int g_iRed[4] =  { 255, 0, 0, 175 };
int g_iWhite[4] =  { 255, 255, 255, 175 };
int g_iYellow[4] =  { 255, 255, 0, 175 };

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max)
{
	CreateNative("KS_AddToCelCount", Native_AddToCelCount);
	CreateNative("KS_AddToPropCount", Native_AddToPropCount);
	CreateNative("KS_ChangeBeam", Native_ChangeBeam);
	CreateNative("KS_CheckCelCount", Native_CheckCelCount);
	CreateNative("KS_CheckColorDB", Native_CheckColorDB);
	CreateNative("KS_CheckOwner", Native_CheckOwner);
	CreateNative("KS_CheckPropCount", Native_CheckPropCount);
	CreateNative("KS_CheckPropType", Native_CheckPropType);
	CreateNative("KS_CheckSpawnDB", Native_CheckSpawnDB);
	CreateNative("KS_DissolveEntity", Native_DissolveEntity);
	CreateNative("KS_GetAuthID", Native_GetAuthID);
	CreateNative("KS_GetClientAimTarget", Native_GetClientAimTarget);
	CreateNative("KS_GetCelCount", Native_GetCelCount);
	CreateNative("KS_GetCelLimit", Native_GetCelLimit);
	CreateNative("KS_GetColor", Native_GetColor);
	CreateNative("KS_GetCrosshairHitOrigin", Native_GetCrosshairHitOrigin);
	CreateNative("KS_GetInternetURL", Native_GetInternetURL);
	CreateNative("KS_GetNoKill", Native_GetNoKill);
	CreateNative("KS_GetOwner", Native_GetOwner);
	CreateNative("KS_GetPropCount", Native_GetPropCount);
	CreateNative("KS_GetPropLimit", Native_GetPropLimit);
	CreateNative("KS_GetPropName", Native_GetPropName);
	CreateNative("KS_GetPropType", Native_GetPropType);
	CreateNative("KS_GetPropTypeFromName", Native_GetPropTypeFromName);
	CreateNative("KS_GetPropTypeName", Native_GetPropTypeName);
	CreateNative("KS_IsEntity", Native_IsEntity);
	CreateNative("KS_IsFrozen", Native_IsFrozen);
	CreateNative("KS_IsSolid", Native_IsSolid);
	CreateNative("KS_NotLooking", Native_NotLooking);
	CreateNative("KS_NotYours", Native_NotYours);
	CreateNative("KS_PlayChatMessageSound", Native_PlayChatMessageSound);
	CreateNative("KS_PrintToChat", Native_PrintToChat);
	CreateNative("KS_PrintToChatAll", Native_PrintToChatAll);
	CreateNative("KS_RemovalBeam", Native_RemovalBeam);
	CreateNative("KS_ReplyToCommand", Native_ReplyToCommand);
	CreateNative("KS_SetAuthID", Native_SetAuthID);
	CreateNative("KS_SetCelCount", Native_SetCelCount);
	CreateNative("KS_SetCelLimit", Native_SetCelLimit);
	CreateNative("KS_SetColor", Native_SetColor);
	CreateNative("KS_SetEntity", Native_SetEntity);
	CreateNative("KS_SetFrozen", Native_SetFrozen);
	CreateNative("KS_SetInternetURL", Native_SetInternetURL);
	CreateNative("KS_SetNoKill", Native_SetNoKill);
	CreateNative("KS_SetOwner", Native_SetOwner);
	CreateNative("KS_SetPropCount", Native_SetPropCount);
	CreateNative("KS_SetPropLimit", Native_SetPropLimit);
	CreateNative("KS_SetPropName", Native_SetPropName);
	CreateNative("KS_SetSolid", Native_SetSolid);
	CreateNative("KS_SpawnDoor", Native_SpawnDoor);
	CreateNative("KS_SpawnInternet", Native_SpawnInternet);
	CreateNative("KS_SpawnProp", Native_SpawnProp);
	CreateNative("KS_SubFromCelCount", Native_SubFromCelCount);
	CreateNative("KS_SubFromPropCount", Native_SubFromPropCount);
	
	g_bLate = bLate;
	
	return APLRes_Success;
}

public Plugin myinfo = 
{
	name = "King's Sandbox", 
	author = "King Nothing", 
	description = "A fully customized building experience with roleplay, and extra features to enhance the standard gameplay.", 
	version = GLOBALVERSION, 
	url = "https://github.com/rockzehh/kingssandbox"
};

public void OnPluginStart()
{
	char sPath[PLATFORM_MAX_PATH];
	
	if (g_bLate)
	{
		for (int i = 1; i < MaxClients; i++)
		{
			if (IsClientAuthorized(i))
			{
				KS_SetAuthID(i);
				
				OnClientPutInServer(i);
			}
		}
	}
	
	BuildPath(Path_SM, sPath, sizeof(sPath), "data/kingssandbox");
	if(!DirExists(sPath))
	{
		CreateDirectory(sPath, 511);
	}
	BuildPath(Path_SM, sPath, sizeof(sPath), "data/kingssandbox/users");
	if(!DirExists(sPath))
	{
		CreateDirectory(sPath, 511);
	}
	BuildPath(Path_SM, g_sColorDB, sizeof(g_sColorDB), "data/kingssandbox/colors.txt");
	if(!FileExists(g_sColorDB))
	{
		ThrowError("King's Sandbox: Cannot find '%s'. Plugin cannot run!", g_sColorDB);
	}
	BuildPath(Path_SM, g_sSpawnDB, sizeof(g_sSpawnDB), "data/kingssandbox/spawns.txt");
	if(!FileExists(g_sSpawnDB))
	{
		ThrowError("King's Sandbox: Cannot find '%s'. Plugin cannot run!", g_sSpawnDB);
	}
	
	g_hOnCelSpawn = CreateGlobalForward("KS_OnCelSpawn", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	g_hOnEntityRemove = CreateGlobalForward("KS_OnEntityRemove", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	g_hOnPropSpawn = CreateGlobalForward("KS_OnPropSpawn", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	
	RegAdminCmd("sm_setowner", Command_SetOwner, ADMFLAG_SLAY, "King's Sandbox: Sets the owner of the prop you are looking at.");
	RegConsoleCmd("sm_alpha", Command_Alpha, "King's Sandbox: Changes the transparency on the prop you are looking at.");
	RegConsoleCmd("sm_amt", Command_Alpha, "King's Sandbox: Changes the transparency on the prop you are looking at.");
	RegConsoleCmd("sm_axis", Command_Axis, "King's Sandbox: Creates a marker to the player showing every axis.");
	//RegConsoleCmd("sm_clearland", Command_ClearLand, "King's Sandbox: Clears your own land.");
	RegConsoleCmd("sm_color", Command_Color, "King's Sandbox: Colors the prop you are looking at.");
	RegConsoleCmd("sm_del", Command_Delete, "King's Sandbox: Removes the prop you are looking at.");
	RegConsoleCmd("sm_delete", Command_Delete, "King's Sandbox: Removes the prop you are looking at.");
	RegConsoleCmd("sm_door", Command_Door, "King's Sandbox: Spawns a working door cel.");
	RegConsoleCmd("sm_freeze", Command_FreezeIt, "King's Sandbox: Freezes the prop you are looking at.");
	RegConsoleCmd("sm_freezeit", Command_FreezeIt, "King's Sandbox: Freezes the prop you are looking at.");
	RegConsoleCmd("sm_internet", Command_Internet, "King's Sandbox: Creates a working internet cel.");
	//RegConsoleCmd("sm_land", Command_Land, "King's Sandbox: Creates a building zone.");
	RegConsoleCmd("sm_mark", Command_Axis, "King's Sandbox: Creates a marker to the player showing every axis.");
	RegConsoleCmd("sm_marker", Command_Axis, "King's Sandbox: Creates a marker to the player showing every axis.");
	RegConsoleCmd("sm_nokill", Command_NoKill, "King's Sandbox: Enables/disables godmode on the player.");
	RegConsoleCmd("sm_p", Command_Spawn, "King's Sandbox: Spawns a prop by name.");
	RegConsoleCmd("sm_paint", Command_Color, "King's Sandbox: Colors the prop you are looking at.");
	RegConsoleCmd("sm_remove", Command_Delete, "King's Sandbox: Removes the prop you are looking at.");
	RegConsoleCmd("sm_rotate", Command_Rotate, "King's Sandbox: Rotates the prop you are looking at.");
	RegConsoleCmd("sm_s", Command_Spawn, "King's Sandbox: Spawns a prop by name.");
	RegConsoleCmd("sm_seturl", Command_SetURL, "King's Sandbox: Sets the url of the internet cel you are looking at.");
	RegConsoleCmd("sm_solid", Command_Solid, "King's Sandbox: Enables/disables solidicity on the prop you are looking at.");
	RegConsoleCmd("sm_spawn", Command_Spawn, "King's Sandbox: Spawns a prop by name.");
	RegConsoleCmd("sm_stand", Command_Stand, "King's Sandbox: Resets the angles on the prop you are looking at.");
	RegConsoleCmd("sm_straight", Command_Stand, "King's Sandbox: Resets the angles on the prop you are looking at.");
	RegConsoleCmd("sm_straighten", Command_Stand, "King's Sandbox: Resets the angles on the prop you are looking at.");
	RegConsoleCmd("sm_unfreeze", Command_UnfreezeIt, "King's Sandbox: Unfreezes the prop you are looking at.");
	RegConsoleCmd("sm_unfreezeit", Command_UnfreezeIt, "King's Sandbox: Unfreezes the prop you are looking at.");
	
	CreateConVar("kingssandbox", "1", "Notifies the server that the plugin is running.");
	CreateConVar("ks_version", GLOBALVERSION, "The version of the plugin the server is running.");
	g_cvCelLimit = CreateConVar("cm_max_player_cels", "20", "Maxiumum number of cel entities a client is allowed.");
	g_cvPropLimit = CreateConVar("cm_max_player_props", "130", "Maxiumum number of props a player is allowed to spawn.");
	
	g_cvCelLimit.AddChangeHook(KS_OnConVarChanged);
	g_cvPropLimit.AddChangeHook(KS_OnConVarChanged);
	
	KS_SetCelLimit(g_cvCelLimit.IntValue);
	KS_SetPropLimit(g_cvPropLimit.IntValue);
	
	AutoExecConfig(true, "ks-main", "sourcemod");
}

public void OnClientAuthorized(int iClient, const char[] sAuthID)
{
	KS_SetAuthID(iClient);
}

public void OnClientPutInServer(int iClient)
{
	char sAuthID[64], sPath[PLATFORM_MAX_PATH];
	
	KS_GetAuthID(iClient, sAuthID, sizeof(sAuthID));
	
	BuildPath(Path_SM, sPath, sizeof(sPath), "data/kingssandbox/users/%s", sAuthID);
	if(!DirExists(sPath))
	{
		CreateDirectory(sPath, 511);
	}
	
	KS_SetCelCount(iClient, 0);
	KS_SetNoKill(iClient, false);
	KS_SetPropCount(iClient, 0);
}

public void OnClientDisconnect(int iClient)
{
	KS_SetCelCount(iClient, 0);
	KS_SetNoKill(iClient, false);
	KS_SetPropCount(iClient, 0);
	
	for (int i = 0; i < GetMaxEntities(); i++)
	{
		if (KS_CheckOwner(iClient, i) && KS_IsEntity(i) && IsValidEdict(i))
		{
			AcceptEntityInput(i, "kill");
		}
	}
}

public void OnMapStart()
{
	g_iBeam = PrecacheModel("materials/sprites/laserbeam.vmt", true);
	g_iEntityDissolve = CreateEntityByName("env_entity_dissolver");
	g_iHalo = PrecacheModel("materials/sprites/halo01.vmt", true);
	g_iLand = PrecacheModel("materials/sprites/spotlight.vmt", false);
	g_iPhys = PrecacheModel("materials/sprites/physbeam.vmt", true);
	
	//g_hInLand = CreateTimer(0.1, Timer_InLand, _, TIMER_REPEAT);
	//g_hLandDrawing = CreateTimer(0.1, Timer_DrawLand, _, TIMER_REPEAT);
	//g_hPositions = CreateTimer(0.1, Timer_Positions, _, TIMER_REPEAT);
	
	DispatchKeyValue(g_iEntityDissolve, "target", "deleted");
	DispatchKeyValue(g_iEntityDissolve, "magnitude", "50");
	DispatchKeyValue(g_iEntityDissolve, "dissolvetype", "3");
	
	DispatchSpawn(g_iEntityDissolve);
	
	DispatchKeyValue(g_iEntityDissolve, "classname", "cel_entity_dissolver");
}

public void OnMapEnd()
{
	g_iBeam = -1;
	g_iEntityDissolve = -1;
	g_iHalo = -1;
	g_iLand = -1;
	g_iPhys = -1;
	
	//CloseHandle(g_hInLand);
	//CloseHandle(g_hLandDrawing);
	//CloseHandle(g_hPositions);
}

public void KS_OnConVarChanged(ConVar cvConVar, const char[] sOldValue, const char[] sNewValue)
{
	if (cvConVar == g_cvCelLimit)
	{
		KS_SetCelLimit(StringToInt(sNewValue));
		PrintToServer("King's Sandbox: Cel limit updated to %i.", StringToInt(sNewValue));
	} else if (cvConVar == g_cvPropLimit) {
		KS_SetPropLimit(StringToInt(sNewValue));
		PrintToServer("King's Sandbox: Prop limit updated to %i.", StringToInt(sNewValue));
	}
}

//Plugin Commands:
public Action Command_Alpha(int iClient, int iArgs)
{
	char sAlpha[16], sPropType[32];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]alpha{default} <transparency value>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sAlpha, sizeof(sAlpha));
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		int iAlpha = StringToInt(sAlpha) < 50 ? 255 : StringToInt(sAlpha);
		
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		KS_SetColor(iProp, -1, -1, -1, iAlpha);
		if(KS_CheckPropType(iProp, "emitter"))
			KS_SetColor(KS_GetEmitterAttachment(iProp), -1, -1, -1, iAlpha);
		
		KS_ChangeBeam(iClient, iProp);
		
		KS_ReplyToCommand(iClient, "Set transparency on %s to {green}%i{default}.", sPropType, iAlpha);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Axis(int iClient, int iArgs)
{
	float fClientOrigin[4][3];
	
	GetClientAbsOrigin(iClient, fClientOrigin[0]);
	GetClientAbsOrigin(iClient, fClientOrigin[1]);
	GetClientAbsOrigin(iClient, fClientOrigin[2]);
	GetClientAbsOrigin(iClient, fClientOrigin[3]);
	
	fClientOrigin[1][0] += 50;
	fClientOrigin[2][1] += 50;
	fClientOrigin[3][2] += 50;
	
	TE_SetupBeamPoints(fClientOrigin[0], fClientOrigin[1], g_iBeam, g_iHalo, 0, 15, 60.0, 3.0, 3.0, 1, 0.0, g_iRed, 10); TE_SendToClient(iClient);
	TE_SetupBeamPoints(fClientOrigin[0], fClientOrigin[2], g_iBeam, g_iHalo, 0, 15, 60.0, 3.0, 3.0, 1, 0.0, g_iGreen, 10); TE_SendToClient(iClient);
	TE_SetupBeamPoints(fClientOrigin[0], fClientOrigin[3], g_iBeam, g_iHalo, 0, 15, 60.0, 3.0, 3.0, 1, 0.0, g_iBlue, 10); TE_SendToClient(iClient);
	
	KS_ReplyToCommand(iClient, "Created {red}X{default}, {green}Y{default}, and {blue}Z{default} axis markers.");
	
	return Plugin_Handled;
}

public Action Command_Color(int iClient, int iArgs)
{
	char sColor[64], sColorBuffer[3][6], sColorString[16], sPropType[32];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]color{default} <color name>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sColor, sizeof(sColor));
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		if (KS_CheckColorDB(sColor, sColorString, sizeof(sColorString)))
		{
			ExplodeString(sColorString, "^", sColorBuffer, 3, sizeof(sColorBuffer[]));
			
			KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
			
			KS_SetColor(iProp, StringToInt(sColorBuffer[0]), StringToInt(sColorBuffer[1]), StringToInt(sColorBuffer[2]), -1);
			if(KS_CheckPropType(iProp, "emitter"))
				KS_SetColor(KS_GetEmitterAttachment(iProp), StringToInt(sColorBuffer[0]), StringToInt(sColorBuffer[1]), StringToInt(sColorBuffer[2]), -1);
		
			KS_ChangeBeam(iClient, iProp);
			
			KS_ReplyToCommand(iClient, "Set color on %s to {green}%s{default}.", sPropType, sColor);
		} else {
			KS_ReplyToCommand(iClient, "Color {green}%s{default} not found.", sColor);
			return Plugin_Handled;
		}
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Delete(int iClient, int iArgs)
{
	char sPropType[32];
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		(KS_CheckPropType(iProp, "prop")) ? KS_SubFromPropCount(iClient) : KS_SubFromCelCount(iClient);
		
		Call_StartForward(g_hOnEntityRemove);
	
		Call_PushCell(iProp);
		Call_PushCell(iClient);
		Call_PushCell(view_as<int>(!KS_CheckPropType(iProp, "prop")));
		
		Call_Finish();
		
		if(KS_CheckPropType(iProp, "emitter"))
			AcceptEntityInput(KS_GetEmitterAttachment(iProp), "TurnOff");
		
		KS_RemovalBeam(iClient, iProp);
		
		KS_DissolveEntity(iProp);
		
		KS_ReplyToCommand(iClient, "Removed %s.", sPropType);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Door(int iClient, int iArgs)
{
	char sSkin[32];
	float fAngles[3], fOrigin[3];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]door{default} <skin number>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sSkin, sizeof(sSkin));
	
	if (!KS_CheckCelCount(iClient))
	{
		KS_ReplyToCommand(iClient, "You have reached the max cel limit. ({green}%i{default})", KS_GetCelCount(iClient));
		return Plugin_Handled;
	}
	
	GetClientAbsAngles(iClient, fAngles);
	KS_GetCrosshairHitOrigin(iClient, fOrigin);
	
	int iDoor = KS_SpawnDoor(iClient, sSkin, fAngles, fOrigin, 255, 255, 255, 255);
	
	Call_StartForward(g_hOnCelSpawn);
	
	Call_PushCell(iDoor);
	Call_PushCell(iClient);
	Call_PushCell(PROPTYPE_DOOR);
	
	Call_Finish();
	
	KS_ReplyToCommand(iClient, "Spawned {green}door{default} cel.");
	
	return Plugin_Handled;
}

public Action Command_FreezeIt(int iClient, int iArgs)
{
	char sPropType[32];
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		if (KS_CheckPropType(iProp, "door"))
		{
			KS_ReplyToCommand(iClient, "Door has been locked.");
			
			AcceptEntityInput(iProp, "lock");
		} else {
			KS_ReplyToCommand(iClient, "Disabled motion on %s.", sPropType);
			
			KS_SetFrozen(iProp, true);
		}
		
		KS_ChangeBeam(iClient, iProp);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Internet(int iClient, int iArgs)
{
	float fAngles[3], fOrigin[3];
	
	if (!KS_CheckCelCount(iClient))
	{
		KS_ReplyToCommand(iClient, "You have reached the max cel limit. ({green}%i{default})", KS_GetCelCount(iClient));
		return Plugin_Handled;
	}
	
	GetClientAbsAngles(iClient, fAngles);
	KS_GetCrosshairHitOrigin(iClient, fOrigin);
	
	int iInternet = KS_SpawnInternet(iClient, "https://github.com/rockzehh/kingssandbox", fAngles, fOrigin, 255, 255, 255, 255);
	
	Call_StartForward(g_hOnCelSpawn);
	
	Call_PushCell(iInternet);
	Call_PushCell(iClient);
	Call_PushCell(PROPTYPE_INTERNET);
	
	Call_Finish();
	
	KS_ReplyToCommand(iClient, "Spawned {green}internet{default} cel.");
	
	return Plugin_Handled;
}

/*public Action Command_Land(int iClient, int iArgs)
{
	bool bDidHitTop = false;
	float fOrigin[3];
	
	if (g_bStartedLand[iClient])
	{
		if(Cel_IsCrosshairInsideLand(iClient) != -1)
		{
			if(Cel_IsCrosshairInsideLand(iClient) == iClient)
			{}else{
				Cel_ReplyCommand(iClient, "You cannot finish your land inside another land.");
				return Plugin_Handled;
			}
		}else{
			Cel_GetEndPoint(iClient, fOrigin);
			
			g_bStartedLand[iClient] = false;
			g_bGettingPositions[iClient] = false;
			
			for (int i = 0; i < 16384; i++)
			{
				if (bDidHitTop)
				{
					g_fLandOrigin[iClient][1] = fOrigin;
				} else {
					fOrigin[2] += 1;
					
					if (TR_PointOutsideWorld(fOrigin))
					{
						fOrigin[2] -= 2;
						
						bDidHitTop = true;
						
						g_fLandOrigin[iClient][1] = fOrigin;
					}
				}
			}
			
			g_fLandOrigin[iClient][1] = fOrigin;
			
			Cel_ReplyCommand(iClient, "Land completed.");
			
			return Plugin_Handled;
		}
	} else {
		if(Cel_IsCrosshairInsideLand(iClient) != -1)
		{
			if(Cel_IsCrosshairInsideLand(iClient) == iClient)
			{}else{
				Cel_ReplyCommand(iClient, "You cannot start your land inside another land.");
				return Plugin_Handled;
			}
		}else{
			g_bStartedLand[iClient] = true;
			g_bLandDrawing[iClient] = true;
			g_bGettingPositions[iClient] = true;
			
			Cel_GetEndPoint(iClient, fOrigin);
			
			g_fLandOrigin[iClient][0] = fOrigin;
			
			Cel_ReplyCommand(iClient, "Type {green}[tag]land{default} again to complete the land.");
			
			return Plugin_Handled;	
		}
	}
	
	return Plugin_Handled;
}*/

public Action Command_NoKill(int iClient, int iArgs)
{
	KS_SetNoKill(iClient, !KS_GetNoKill(iClient));
	
	KS_ReplyToCommand(iClient, "Turned nokill %s.", KS_GetNoKill(iClient) ? "on" : "off");
	
	return Plugin_Handled;
}

public Action Command_Rotate(int iClient, int iArgs)
{
	char sX[32], sY[32], sZ[32];
	float fAngles[3], fOrigin[3], fPropAngles[3];
	
	if (iArgs < 3)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]rotate{default} <x> <y> <z>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sX, sizeof(sX));
	GetCmdArg(2, sY, sizeof(sY));
	GetCmdArg(3, sZ, sizeof(sZ));
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		KS_GetEntityOrigin(iProp, fOrigin);
		KS_GetEntityAngles(iProp, fPropAngles);
		
		fAngles[0] = fPropAngles[0] += StringToFloat(sX);
		fAngles[1] = fPropAngles[1] += StringToFloat(sY);
		fAngles[2] = fPropAngles[2] += StringToFloat(sZ);
		
		if(KS_CheckPropType(iProp, "door"))
		{
			DispatchKeyValueVector(iProp, "angles", fAngles);
		}else{
			TeleportEntity(iProp, NULL_VECTOR, fAngles, NULL_VECTOR);
		}
		
		TE_SetupBeamRingPoint(fOrigin, 0.0, 15.0, g_iBeam, g_iHalo, 0, 15, 0.5, 3.0, 0.0, g_iOrange, 10, 0); TE_SendToAll();
		
		PrecacheSound("buttons/lever7.wav");
		
		EmitSoundToAll("buttons/lever7.wav", iProp, 2, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_SetOwner(int iClient, int iArgs)
{
	if(KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	char sPropType[64], sTarget[PLATFORM_MAX_PATH];
	int iProp = KS_GetClientAimTarget(iClient);
	
	GetCmdArg(1, sTarget, sizeof(sTarget));
	
	if(StrEqual(sTarget, ""))
	{
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		KS_SetOwner(iClient, iProp);
		
		KS_ChangeBeam(iClient, iProp);
		
		KS_ReplyToCommand(iClient, "Set ownership of {green}%s{default} to {green}%N{default}.", sPropType, iClient);
	
		return Plugin_Handled;
	}
	
	int iTarget = FindTarget(iClient, sTarget, true, false);
	
	if(iTarget == -1)
	{
		KS_ReplyToCommand(iClient, "Cannot find specified target.");
		return Plugin_Handled;
	}
	
	KS_SetOwner(iTarget, iProp);
		
	KS_ChangeBeam(iClient, iProp);
		
	KS_ReplyToCommand(iClient, "Set ownership of {green}%s{default} to {green}%N{default}.", sPropType, iTarget);
	KS_ReplyToCommand(iTarget, "{green}%N{default} set ownership of {green}%s{default} to {green}%N{default}.", iClient, sPropType, iTarget);

	return Plugin_Handled;
}

public Action Command_SetURL(int iClient, int iArgs)
{
	char sURL[PLATFORM_MAX_PATH];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]seturl{default} <url>");
		return Plugin_Handled;
	}
	
	GetCmdArgString(sURL, sizeof(sURL));
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		if(KS_GetPropType(iProp) == PROPTYPE_INTERNET)
		{
			if (StrContains(sURL, "http://", false) != -1 || StrContains(sURL, "https://", false) != -1)
			{  } else {
				Format(sURL, sizeof(sURL), "http://%s", sURL);
			}
			
			KS_SetInternetURL(iProp, sURL);
			
			KS_ChangeBeam(iClient, iProp);
			
			KS_ReplyToCommand(iClient, "Updated url on internet cel.");
			
			return Plugin_Handled;
		}else{
			KS_ReplyToCommand(iClient, "You can only use this command on internet cels.");
			return Plugin_Handled;
		}
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
}

public Action Command_Spawn(int iClient, int iArgs)
{
	char sAlias[64], sSpawnBuffer[2][128], sSpawnString[256];
	float fAngles[3], fOrigin[3];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]spawn{default} <prop name>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sAlias, sizeof(sAlias));
	
	if (!KS_CheckPropCount(iClient))
	{
		KS_ReplyToCommand(iClient, "You have reached the max prop limit. ({green}%i{default})", KS_GetPropCount(iClient));
		return Plugin_Handled;
	}
	
	if (KS_CheckSpawnDB(sAlias, sSpawnString, sizeof(sSpawnString)))
	{
		ExplodeString(sSpawnString, "^", sSpawnBuffer, 2, sizeof(sSpawnBuffer[]));
		
		GetClientAbsAngles(iClient, fAngles);
		KS_GetCrosshairHitOrigin(iClient, fOrigin);
		
		int iProp = KS_SpawnProp(iClient, sAlias, sSpawnBuffer[0], sSpawnBuffer[1], fAngles, fOrigin, 255, 255, 255, 255);
		
		Call_StartForward(g_hOnPropSpawn);
	
		Call_PushCell(iProp);
		Call_PushCell(iClient);
		Call_PushCell(KS_GetPropType(iProp));
		
		Call_Finish();
		
		KS_ReplyToCommand(iClient, "Spawned prop {green}%s{default}.", sAlias);
	} else {
		KS_ReplyToCommand(iClient, "Prop {green}%s{default} not found.", sAlias);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Solid(int iClient, int iArgs)
{
	char sPropType[128];
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		if (KS_CheckPropType(iProp, "cycler"))
		{
			KS_ReplyToCommand(iClient, "You cannot use this command on this prop.");
			return Plugin_Handled;
		}
		
		KS_SetSolid(iProp, !KS_IsSolid(iProp));
		
		KS_ReplyToCommand(iClient, "Turned solidicity %s on %s.", KS_IsSolid(iProp) ? "on" : "off", sPropType);
		
		KS_ChangeBeam(iClient, iProp);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_Stand(int iClient, int iArgs)
{
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		TeleportEntity(iProp, NULL_VECTOR, g_fZero, NULL_VECTOR);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_UnfreezeIt(int iClient, int iArgs)
{
	char sPropType[32];
	
	if (KS_GetClientAimTarget(iClient) == -1)
	{
		KS_NotLooking(iClient);
		return Plugin_Handled;
	}
	
	int iProp = KS_GetClientAimTarget(iClient);
	
	if (KS_CheckOwner(iClient, iProp))
	{
		KS_GetPropTypeName(KS_GetPropType(iProp), sPropType, sizeof(sPropType));
		
		if (KS_CheckPropType(iProp, "door"))
		{
			KS_ReplyToCommand(iClient, "Door has been unlocked.");
			
			AcceptEntityInput(iProp, "unlock");
		} else {
			KS_ReplyToCommand(iClient, "Enabled motion on %s.", sPropType);
			
			KS_SetFrozen(iProp, false);
		}
		
		KS_ChangeBeam(iClient, iProp);
	} else {
		KS_NotYours(iClient, iProp);
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

//Plugin Natives:
public int Native_AddToCelCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	int iCount = KS_GetCelCount(iClient), iFinalCount = iCount++;
	
	KS_SetCelCount(iClient, iFinalCount);
}

public int Native_AddToPropCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	int iCount = KS_GetPropCount(iClient), iFinalCount = iCount++;
	
	KS_SetPropCount(iClient, iFinalCount);
}

public int Native_ChangeBeam(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iEntity = GetNativeCell(2);
	
	char sSound[96];
	
	float fClientOrigin[3], fHitOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	KS_GetCrosshairHitOrigin(iClient, fHitOrigin);
	
	TE_SetupBeamPoints(fClientOrigin, fHitOrigin, g_iPhys, g_iHalo, 0, 15, 0.25, 5.0, 5.0, 1, 0.0, g_iWhite, 10); TE_SendToAll();
	TE_SetupSparks(fHitOrigin, NULL_VECTOR, 2, 5); TE_SendToAll();
	
	Format(sSound, sizeof(sSound), "weapons/airboat/airboat_gun_lastshot%i.wav", GetRandomInt(1, 2));
	
	PrecacheSound(sSound);
	
	EmitSoundToAll(sSound, iEntity, 2, 100, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
}

public int Native_CheckCelCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	return (KS_GetCelCount(iClient) >= KS_GetCelLimit()) ? false : true;
}

public int Native_CheckColorDB(Handle hPlugin, int iNumParams)
{
	int iMaxLength = GetNativeCell(3);
	
	char sColor[64], sColorLine[32];
	
	GetNativeString(1, sColor, sizeof(sColor));
	
	KeyValues kvColors = new KeyValues("Colors");
	
	kvColors.ImportFromFile(g_sColorDB);
	
	kvColors.JumpToKey("RGB", false);
	
	kvColors.GetString(sColor, sColorLine, iMaxLength, "null");
	
	kvColors.Rewind();
	
	delete kvColors;
	
	SetNativeString(2, sColorLine, iMaxLength);
	
	return (StrEqual(sColorLine, "null")) ? false : true;
}

public int Native_CheckOwner(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iEntity = GetNativeCell(2);
	
	return (KS_GetOwner(iEntity) == iClient) ? true : false;
}

public int Native_CheckPropCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	return (KS_GetPropCount(iClient) >= KS_GetPropLimit()) ? false : true;
}

public int Native_CheckPropType(Handle hPlugin, int iNumParams)
{
	char sPropCheck[PLATFORM_MAX_PATH];
	
	int iEntity = GetNativeCell(1);
	
	GetNativeString(2, sPropCheck, sizeof(sPropCheck));
	
	return (KS_GetPropType(iEntity) == KS_GetPropTypeFromName(sPropCheck)) ? true : false;
}

public int Native_CheckSpawnDB(Handle hPlugin, int iNumParams)
{
	int iMaxLength = GetNativeCell(3);
	
	char sAlias[64], sSpawnString[128];
	
	GetNativeString(1, sAlias, sizeof(sAlias));
	
	KeyValues kvProps = new KeyValues("Props");
	
	kvProps.ImportFromFile(g_sSpawnDB);
	
	kvProps.JumpToKey("Default", false);
	
	kvProps.GetString(sAlias, sSpawnString, iMaxLength, "null");
	
	kvProps.Rewind();
	
	delete kvProps;
	
	SetNativeString(2, sSpawnString, iMaxLength);
	
	return (StrEqual(sSpawnString, "null")) ? false : true;
}

public int Native_DissolveEntity(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	DispatchKeyValue(iEntity, "classname", "deleted");
	
	AcceptEntityInput(g_iEntityDissolve, "dissolve");
}

public int Native_GetAuthID(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1), iMaxLength = GetNativeCell(3);
	
	SetNativeString(2, g_sAuthID[iClient], iMaxLength);
}

public int Native_GetClientAimTarget(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	if (GetClientAimTarget(iClient, false) == -1)
	{
		return -1;
	}
	
	int iTarget = GetClientAimTarget(iClient, false);
	
	return (KS_IsEntity(iTarget)) ? iTarget : -1;
}

public int Native_GetCelCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	return g_iCelCount[iClient];
}

public int Native_GetCelLimit(Handle hPlugin, int iNumParams)
{
	return g_iCelLimit;
}

public int Native_GetColor(Handle hPlugin, int iNumParams)
{
	int iColor[4];
	int iEntity = GetNativeCell(1);
	
	if(g_iColor[iEntity][0] == 0 && g_iColor[iEntity][1] == 0 && g_iColor[iEntity][2] == 0 && g_iColor[iEntity][3] == 0)
	{
		GetEntityRenderColor(iEntity, iColor[0], iColor[1], iColor[2], iColor[3]);
		KS_SetColor(iEntity, iColor[0], iColor[1], iColor[2], iColor[3]);
	}
	
	iColor = g_iColor[iEntity];
	
	SetNativeArray(2, iColor, 4);
}

public int Native_GetCrosshairHitOrigin(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	float fCrosshairOrigin[3], fEyeAngles[3], fEyeOrigin[3];
	
	GetClientEyeAngles(iClient, fEyeAngles);
	GetClientEyePosition(iClient, fEyeOrigin);
	
	Handle hTraceRay = TR_TraceRayFilterEx(fEyeOrigin, fEyeAngles, MASK_ALL, RayType_Infinite, KS_FilterPlayer);
	
	if (TR_DidHit(hTraceRay))
	{
		TR_GetEndPosition(fCrosshairOrigin, hTraceRay);
		
		CloseHandle(hTraceRay);
	}
	
	SetNativeArray(2, fCrosshairOrigin, 3);
}

public int Native_GetInternetURL(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1), iMaxLength = GetNativeCell(3);
	
	SetNativeString(2, g_sInternetURL[iEntity], iMaxLength);
}

public int Native_GetNoKill(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	return g_bNoKill[iClient];
}

public int Native_GetOwner(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return GetClientFromSerial(g_iOwner[iEntity]);
}

public int Native_GetPropCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	return g_iPropCount[iClient];
}

public int Native_GetPropLimit(Handle hPlugin, int iNumParams)
{
	return g_iPropLimit;
}

public int Native_GetPropName(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	int iMaxLength = GetNativeCell(3);
	
	SetNativeString(2, g_sPropName[iEntity], iMaxLength);
}

public int Native_GetPropType(Handle hPlugin, int iNumParams)
{
	char sClassname[64];
	
	int iEntity = GetNativeCell(1);
	
	GetEntityClassname(iEntity, sClassname, sizeof(sClassname));
	
	if (StrEqual(sClassname, "cycler", false))
	{
		return view_as<int>(PROPTYPE_CYCLER);
	} else if (StrEqual(sClassname, "cel_door", false))
	{
		return view_as<int>(PROPTYPE_DOOR);
	} else if (StrEqual(sClassname, "cel_internet", false))
	{
		return view_as<int>(PROPTYPE_INTERNET);
	} else if (StrContains(sClassname, "emitter_", false) != -1)
	{
		return view_as<int>(PROPTYPE_EMITTER);
	} else if (StrContains(sClassname, "prop_dynamic", false) != -1)
	{
		return view_as<int>(PROPTYPE_DYNAMIC);
	} else if (StrContains(sClassname, "prop_physics", false) != -1)
	{
		return view_as<int>(PROPTYPE_PHYSICS);
	} else {
		return view_as<int>(PROPTYPE_UNKNOWN);
	}
}

public int Native_GetPropTypeFromName(Handle hPlugin, int iNumParams)
{
	char sPropType[PLATFORM_MAX_PATH];
	
	GetNativeString(1, sPropType, sizeof(sPropType));
	
	if(StrEqual(sPropType, "cycler", false))
	{
		return view_as<int>(PROPTYPE_CYCLER);
	}else if(StrEqual(sPropType, "door", false))
	{
		return view_as<int>(PROPTYPE_DOOR);
	}else if(StrEqual(sPropType, "dynamic", false))
	{
		return view_as<int>(PROPTYPE_DYNAMIC);
	}else if(StrEqual(sPropType, "emitter", false))
	{
		return view_as<int>(PROPTYPE_EMITTER);
	}else if(StrEqual(sPropType, "internet", false))
	{
		return view_as<int>(PROPTYPE_INTERNET);
	}else if(StrEqual(sPropType, "physics", false))
	{
		return view_as<int>(PROPTYPE_PHYSICS);
	}else{
		return view_as<int>(PROPTYPE_UNKNOWN);
	}
}

public int Native_GetPropTypeName(Handle hPlugin, int iNumParams)
{
	char sPropType[PLATFORM_MAX_PATH];
	int iMaxLength = GetNativeCell(3);
	
	switch(view_as<CelPropType>(GetNativeCell(1)))
	{
		case PROPTYPE_CYCLER:
		{
			Format(sPropType, sizeof(sPropType), "cycler prop");
		}
		case PROPTYPE_DOOR:
		{
			Format(sPropType, sizeof(sPropType), "door cel");
		}
		case PROPTYPE_DYNAMIC:
		{
			Format(sPropType, sizeof(sPropType), "dynamic prop");
		}
		case PROPTYPE_EMITTER:
		{
			Format(sPropType, sizeof(sPropType), "emitter cel");
		}
		case PROPTYPE_INTERNET:
		{
			Format(sPropType, sizeof(sPropType), "internet cel");
		}
		case PROPTYPE_PHYSICS:
		{
			Format(sPropType, sizeof(sPropType), "physics prop");
		}
		case PROPTYPE_UNKNOWN:
		{
			Format(sPropType, sizeof(sPropType), "unknown prop type");
		}
	}
	
	SetNativeString(2, sPropType, iMaxLength);
}

public int Native_IsEntity(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return g_bEntity[iEntity];
}

public int Native_IsFrozen(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return g_bFrozen[iEntity];
}

public int Native_IsSolid(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return g_bSolid[iEntity];
}

public int Native_NotLooking(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	KS_ReplyToCommand(iClient, "You are not looking at anything.");
}

public int Native_NotYours(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iEntity = GetNativeCell(2);
	
	char sPropType[32];
	
	KS_GetPropTypeName(KS_GetPropType(iEntity), sPropType, sizeof(sPropType));
	
	KS_ReplyToCommand(iClient, "This %s does not belong to you.", sPropType);
}

public int Native_PlayChatMessageSound(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	ClientCommand(iClient, "play npc/stalker/stalker_footstep_%s1", GetRandomInt(0, 1) ? "left" : "right");
}

public int Native_PrintToChat(Handle hPlugin, int iNumParams)
{
	char sBuffer[MAX_MESSAGE_LENGTH];
	
	int iPlayer = GetNativeCell(1), iWritten;
	
	FormatNativeString(0, 2, 3, sizeof(sBuffer), iWritten, sBuffer);
	
	CPrintToChat(iPlayer, "{green}King's Sandbox{default}: %s", sBuffer);
	
	KS_PlayChatMessageSound(iPlayer);
}

public int Native_PrintToChatAll(Handle hPlugin, int iNumParams)
{
	char sBuffer[MAX_MESSAGE_LENGTH];
	
	int iWritten;
	
	FormatNativeString(0, 1, 2, sizeof(sBuffer), iWritten, sBuffer);
	
	CPrintToChatAll("{green}King's Sandbox{default}: %s", sBuffer);
}

public int Native_RemovalBeam(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iEntity = GetNativeCell(2);
	
	char sSound[96];
	
	float fClientOrigin[3], fEntityOrigin[3];
	
	GetClientAbsOrigin(iClient, fClientOrigin);
	
	KS_GetEntityOrigin(iEntity, fEntityOrigin);
	
	TE_SetupBeamPoints(fClientOrigin, fEntityOrigin, g_iBeam, g_iHalo, 0, 15, 0.25, 5.0, 5.0, 1, 0.0, g_iGray, 10); TE_SendToAll();
	
	TE_SetupBeamRingPoint(fEntityOrigin, 0.0, 15.0, g_iBeam, g_iHalo, 0, 15, 0.5, 5.0, 0.0, g_iGray, 10, 0); TE_SendToAll();
	
	Format(sSound, sizeof(sSound), "ambient/levels/citadel/weapon_disintegrate%i.wav", GetRandomInt(1, 4));
	
	PrecacheSound(sSound);
	
	EmitAmbientSound(sSound, fEntityOrigin, iEntity, 100, 0, 1.0, 100, 0.0);
}

public int Native_ReplyToCommand(Handle hPlugin, int iNumParams)
{
	char sBuffer[MAX_MESSAGE_LENGTH];
	
	int iPlayer = GetNativeCell(1), iWritten;
	
	FormatNativeString(0, 2, 3, sizeof(sBuffer), iWritten, sBuffer);
	
	ReplaceString(sBuffer, sizeof(sBuffer), "[tag]", GetCmdReplySource() == SM_REPLY_TO_CONSOLE ? "sm_" : "!", true);
	
	if (GetCmdReplySource() == SM_REPLY_TO_CONSOLE)
	{
		CRemoveTags(sBuffer, sizeof(sBuffer));
		
		PrintToConsole(iPlayer, "King's Sandbox: %s", sBuffer);
	} else {
		CPrintToChat(iPlayer, "{green}King's Sandbox{default}: %s", sBuffer);
		
		KS_PlayChatMessageSound(iPlayer);
	}
}

public int Native_SetAuthID(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	GetClientAuthId(iClient, AuthId_SteamID64, g_sAuthID[iClient], sizeof(g_sAuthID));
}

public int Native_SetCelCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iCount = GetNativeCell(2);
	
	g_iCelCount[iClient] = iCount;
}

public int Native_SetCelLimit(Handle hPlugin, int iNumParams)
{
	int iLimit = GetNativeCell(1);
	
	g_iCelLimit = iLimit;
}

public int Native_SetColor(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	int iR = GetNativeCell(2), iG = GetNativeCell(3), iB = GetNativeCell(4), iA = GetNativeCell(5);
	
	SetEntityRenderColor(iEntity, iR == -1 ? g_iColor[iEntity][0] : iR, iG == -1 ? g_iColor[iEntity][1] : iG, iB == -1 ? g_iColor[iEntity][2] : iB, iA == -1 ? g_iColor[iEntity][3] : iA);
	SetEntityRenderMode(iEntity, RENDER_TRANSALPHA);
	
	g_iColor[iEntity][0] = iR == -1 ? g_iColor[iEntity][0] : iR, g_iColor[iEntity][1] = iG == -1 ? g_iColor[iEntity][1] : iG, g_iColor[iEntity][2] = iB == -1 ? g_iColor[iEntity][2] : iB, g_iColor[iEntity][3] = iA == -1 ? g_iColor[iEntity][3] : iA;
}

public int Native_SetEntity(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	bool bEntity = view_as<bool>(GetNativeCell(2));
	
	g_bEntity[iEntity] = bEntity;
}

public int Native_SetFrozen(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	bool bFrozen = view_as<bool>(GetNativeCell(2));
	
	bFrozen ? AcceptEntityInput(iEntity, "disablemotion") : AcceptEntityInput(iEntity, "enablemotion");
	
	g_bFrozen[iEntity] = bFrozen;
}

public int Native_SetInternetURL(Handle hPlugin, int iNumParams)
{
	char sURL[PLATFORM_MAX_PATH];
	
	int iEntity = GetNativeCell(1);
	
	GetNativeString(2, sURL, sizeof(sURL));
	
	Format(g_sInternetURL[iEntity], sizeof(g_sInternetURL[]), sURL);
}

public int Native_SetNoKill(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	bool bNoKill = view_as<bool>(GetNativeCell(2));
	
	bNoKill ? SetEntProp(iClient, Prop_Data, "m_takedamage", 0, 1) : SetEntProp(iClient, Prop_Data, "m_takedamage", 2, 1);
	
	g_bNoKill[iClient] = bNoKill;
}

public int Native_SetOwner(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iEntity = GetNativeCell(2);
	
	g_iOwner[iEntity] = GetClientSerial(iClient);
}

public int Native_SetPropCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	int iCount = GetNativeCell(2);
	
	g_iPropCount[iClient] = iCount;
}

public int Native_SetPropLimit(Handle hPlugin, int iNumParams)
{
	int iLimit = GetNativeCell(1);
	
	g_iPropLimit = iLimit;
}

public int Native_SetPropName(Handle hPlugin, int iNumParams)
{
	char sPropName[64];
	
	int iEntity = GetNativeCell(1);
	
	GetNativeString(2, sPropName, sizeof(sPropName));
	
	Format(g_sPropName[iEntity], sizeof(g_sPropName), sPropName);
}

public int Native_SetSolid(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	bool bSolid = view_as<bool>(GetNativeCell(2));
	
	bSolid ? DispatchKeyValue(iEntity, "solid", "6") : DispatchKeyValue(iEntity, "solid", "4");
	
	g_bSolid[iEntity] = bSolid;
}

public int Native_SpawnDoor(Handle hPlugin, int iNumParams)
{
	char sSkin[16];
	float fAngles[3], fOrigin[3];
	int iClient = GetNativeCell(1), iColor[4];
	
	GetNativeString(2, sSkin, sizeof(sSkin));
	
	GetNativeArray(3, fAngles, 3);
	GetNativeArray(4, fOrigin, 3);
	
	iColor[0] = GetNativeCell(5);
	iColor[1] = GetNativeCell(6);
	iColor[2] = GetNativeCell(7);
	iColor[3] = GetNativeCell(8);
	
	int iDoor = CreateEntityByName("prop_door_rotating");
	
	if (iDoor == -1)
		return -1;
	
	PrecacheModel("models/props_c17/door01_left.mdl");
	
	DispatchKeyValue(iDoor, "model", "models/props_c17/door01_left.mdl");
	DispatchKeyValue(iDoor, "classname", "cel_door");
	DispatchKeyValue(iDoor, "skin", sSkin);
	DispatchKeyValue(iDoor, "distance", "90");
	DispatchKeyValue(iDoor, "speed", "100");
	DispatchKeyValue(iDoor, "returndelay", "-1");
	DispatchKeyValue(iDoor, "dmg", "-20");
	DispatchKeyValue(iDoor, "opendir", "0");
	DispatchKeyValue(iDoor, "spawnflags", "8192");
	DispatchKeyValue(iDoor, "OnFullyOpen", "!caller,close,,3,-1");
	DispatchKeyValue(iDoor, "hardware", "1");
	
	DispatchSpawn(iDoor);
	
	fOrigin[2] += 52;
	
	TeleportEntity(iDoor, fOrigin, fAngles, NULL_VECTOR);
	
	KS_AddToCelCount(iClient);
	
	KS_SetColor(iDoor, iColor[0], iColor[1], iColor[2], iColor[3]);
	
	KS_SetEntity(iDoor, true);
	
	KS_SetFrozen(iDoor, true);
	
	KS_SetOwner(iClient, iDoor);
	
	KS_SetSolid(iDoor, true);
	
	return iDoor;
}

public int Native_SpawnInternet(Handle hPlugin, int iNumParams)
{
	char sURL[PLATFORM_MAX_PATH];
	float fAngles[3], fOrigin[3];
	int iClient = GetNativeCell(1), iColor[4];
	
	GetNativeString(2, sURL, sizeof(sURL));
	
	GetNativeArray(3, fAngles, 3);
	GetNativeArray(4, fOrigin, 3);
	
	iColor[0] = GetNativeCell(5);
	iColor[1] = GetNativeCell(6);
	iColor[2] = GetNativeCell(7);
	iColor[3] = GetNativeCell(8);
	
	int iInternet = CreateEntityByName("prop_physics_override");
	
	if (iInternet == -1)
		return -1;
	
	PrecacheModel("models/props_lab/monitor02.mdl");
	
	DispatchKeyValue(iInternet, "model", "models/props_lab/monitor02.mdl");
	DispatchKeyValue(iInternet, "classname", "cel_internet");
	DispatchKeyValue(iInternet, "skin", "1");
	
	DispatchSpawn(iInternet);
	
	TeleportEntity(iInternet, fOrigin, fAngles, NULL_VECTOR);
	
	KS_AddToCelCount(iClient);
	
	KS_SetColor(iInternet, iColor[0], iColor[1], iColor[2], iColor[3]);
	
	KS_SetEntity(iInternet, true);
	
	KS_SetFrozen(iInternet, true);
	
	KS_SetInternetURL(iInternet, sURL);
	
	KS_SetOwner(iClient, iInternet);
	
	KS_SetSolid(iInternet, true);
	
	SDKHook(iInternet, SDKHook_UsePost, Hook_InternetUse);
	
	return iInternet;
}

public int Native_SpawnProp(Handle hPlugin, int iNumParams)
{
	char sAlias[64], sModel[64], sPropType[64];
	float fAngles[3], fOrigin[3];
	int iClient = GetNativeCell(1), iColor[4];
	
	GetNativeString(2, sAlias, sizeof(sAlias));
	GetNativeString(3, sPropType, sizeof(sPropType));
	GetNativeString(4, sModel, sizeof(sModel));
	
	GetNativeArray(5, fAngles, 3);
	GetNativeArray(6, fOrigin, 3);
	
	iColor[0] = GetNativeCell(7);
	iColor[1] = GetNativeCell(8);
	iColor[2] = GetNativeCell(9);
	iColor[3] = GetNativeCell(10);
	
	int iProp = CreateEntityByName(sPropType);
	
	if (iProp == -1)
		return -1;
	
	PrecacheModel(sModel);
	
	DispatchKeyValue(iProp, "model", sModel);
	
	DispatchSpawn(iProp);
	
	TeleportEntity(iProp, fOrigin, fAngles, NULL_VECTOR);
	
	KS_AddToPropCount(iClient);
	
	KS_SetColor(iProp, iColor[0], iColor[1], iColor[2], iColor[3]);
	
	KS_SetEntity(iProp, true);
	
	KS_SetFrozen(iProp, true);
	
	KS_SetOwner(iClient, iProp);
	
	KS_SetPropName(iProp, sAlias);
	
	if (!StrEqual(sPropType, "cycler"))
		KS_SetSolid(iProp, true);
	
	return iProp;
}

public int Native_SubFromCelCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	int iCount = KS_GetCelCount(iClient), iFinalCount = iCount--;
	
	KS_SetCelCount(iClient, iFinalCount);
}

public int Native_SubFromPropCount(Handle hPlugin, int iNumParams)
{
	int iClient = GetNativeCell(1);
	
	int iCount = KS_GetPropCount(iClient), iFinalCount = iCount--;
	
	KS_SetPropCount(iClient, iFinalCount);
}

//Plugin Stocks:
stock bool KS_FilterPlayer(int iEntity, any iContentsMask)
{
	return iEntity > MaxClients;
}
