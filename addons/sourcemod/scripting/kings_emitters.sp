#pragma semicolon 1

#include <kingssandbox>

#pragma newdecls required

bool g_bEmitterActive[MAXENTS + 1];

EmitterType g_etEmitterType[MAXENTS + 1];

Handle g_hOnEmitterSpawn;

int g_iEmitterEntity[MAXENTS + 1];

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max)
{
	CreateNative("KS_CheckEmitterType", Native_CheckEmitterType);
	CreateNative("KS_GetEmitterAttachment", Native_GetEmitterAttachment);
	CreateNative("KS_GetEmitterType", Native_GetEmitterType);
	CreateNative("KS_GetEmitterTypeFromName", Native_GetEmitterTypeFromName);
	CreateNative("KS_GetEmitterTypeName", Native_GetEmitterTypeName);
	CreateNative("KS_IsEmitterActive", Native_IsEmitterActive);
	CreateNative("KS_SetEmitterActive", Native_SetEmitterActive);
	CreateNative("KS_SetEmitterAttachment", Native_SetEmitterAttachment);
	CreateNative("KS_SetEmitterType", Native_SetEmitterType);
	CreateNative("KS_SpawnEmitter", Native_SpawnEmitter);
	
	return APLRes_Success;
}

public Plugin myinfo = 
{
	name = "King's Sandbox: Emitters", 
	author = "King Nothing", 
	description = "Creates a effect emitter.", 
	version = SANDBOX_VERSION, 
	url = "https://github.com/rockzehh/kingssandbox"
};

public void OnPluginStart()
{
	g_hOnEmitterSpawn = CreateGlobalForward("KS_OnEmitterSpawn", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	
	RegConsoleCmd("sm_emitter", Command_Emitter, "King's Sandbox: Spawns a working emitter cel.");
}

//Plugin Commands:
public Action Command_Emitter(int iClient, int iArgs)
{
	char sEmitter[PLATFORM_MAX_PATH], sEmitterType[PLATFORM_MAX_PATH];
	float fOrigin[3];
	
	if (iArgs < 1)
	{
		KS_ReplyToCommand(iClient, "Usage: {green}[tag]emitter{default} <emitter type>");
		return Plugin_Handled;
	}
	
	GetCmdArg(1, sEmitter, sizeof(sEmitter));
	
	EmitterType etEmitterType = KS_GetEmitterTypeFromName(sEmitter);
	
	if (etEmitterType == EMITTER_UNKNOWN)
	{
		KS_ReplyToCommand(iClient, "Invalid emitter type.");
		return Plugin_Handled;
	}
	
	KS_GetCrosshairHitOrigin(iClient, fOrigin);
	
	int iEmitter = KS_SpawnEmitter(iClient, fOrigin, etEmitterType, true, 255, 255, 255, 255);
	
	Call_StartForward(g_hOnEmitterSpawn);
	
	Call_PushCell(iEmitter);
	Call_PushCell(iClient);
	Call_PushCell(etEmitterType);
	
	Call_Finish();
	
	KS_GetEmitterTypeName(etEmitterType, sEmitterType, sizeof(sEmitterType));
	
	KS_ReplyToCommand(iClient, "Spawned {green}%s{default} emitter cel.", sEmitterType);
	
	return Plugin_Handled;
}

//Plugin Natives:
public int Native_CheckEmitterType(Handle hPlugin, int iNumParams)
{
	char sCheck[PLATFORM_MAX_PATH], sType[PLATFORM_MAX_PATH];
	int iEmitter = GetNativeCell(1);
	
	GetNativeString(2, sCheck, sizeof(sCheck));
	
	KS_GetEmitterTypeName(KS_GetEmitterType(iEmitter), sType, sizeof(sType));
	
	return (StrContains(sType, sCheck, false) != -1);
}

public int Native_GetEmitterAttachment(Handle hPlugin, int iNumParams)
{
	int iEmitter = GetNativeCell(1);
	
	return EntRefToEntIndex(g_iEmitterEntity[iEmitter]);
}

public int Native_GetEmitterType(Handle hPlugin, int iNumParams)
{
	int iEmitter = GetNativeCell(1);
	
	return view_as<int>(g_etEmitterType[iEmitter]);
}

public int Native_GetEmitterTypeFromName(Handle hPlugin, int iNumParams)
{
	char sEmitterName[PLATFORM_MAX_PATH];
	
	GetNativeString(1, sEmitterName, sizeof(sEmitterName));
	
	if (StrContains("core", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_CORE);
		/*} else if (StrContains("explosion", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_EXPLOSION);*/
	} else if (StrContains("fire", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_FIRE);
	} else if (StrContains("shake", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_SHAKE);
	} else if (StrContains("smokestack", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_SMOKESTACK);
	/*} else if (StrContains("spotlight", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_SPOTLIGHT);*/
	} else if (StrContains("steam", sEmitterName, false) != -1)
	{
		return view_as<int>(EMITTER_STEAM);
	} else {
		return view_as<int>(EMITTER_UNKNOWN);
	}
}

public int Native_GetEmitterTypeName(Handle hPlugin, int iNumParams)
{
	char sEmitterName[PLATFORM_MAX_PATH];
	EmitterType etEmitter = view_as<EmitterType>(GetNativeCell(1));
	int iMaxLength = GetNativeCell(3);
	
	switch (etEmitter)
	{
		case EMITTER_CORE:
		{
			Format(sEmitterName, sizeof(sEmitterName), "core");
		}
		/*case EMITTER_EXPLOSION:
		{
			Format(sEmitterName, sizeof(sEmitterName), "explosion");
		}*/
		case EMITTER_FIRE:
		{
			Format(sEmitterName, sizeof(sEmitterName), "fire");
		}
		case EMITTER_SHAKE:
		{
			Format(sEmitterName, sizeof(sEmitterName), "shake");
		}
		case EMITTER_SMOKESTACK:
		{
			Format(sEmitterName, sizeof(sEmitterName), "smokestack");
		}
		/*case EMITTER_SPOTLIGHT:
		{
			Format(sEmitterName, sizeof(sEmitterName), "spotlight");
		}*/
		case EMITTER_STEAM:
		{
			Format(sEmitterName, sizeof(sEmitterName), "steam");
		}
		case EMITTER_UNKNOWN:
		{
			Format(sEmitterName, sizeof(sEmitterName), "unknown");
		}
	}
	
	SetNativeString(2, sEmitterName, iMaxLength);
}

public int Native_IsEmitterActive(Handle hPlugin, int iNumParams)
{
	int iEmitter = GetNativeCell(1);
	
	return g_bEmitterActive[iEmitter];
}

public int Native_SetEmitterActive(Handle hPlugin, int iNumParams)
{
	bool bActive = view_as<bool>(GetNativeCell(2));
	int iEmitter = GetNativeCell(1);
	
	g_bEmitterActive[iEmitter] = bActive;
}

public int Native_SetEmitterAttachment(Handle hPlugin, int iNumParams)
{
	int iAttachment = GetNativeCell(2), iEmitter = GetNativeCell(1);
	
	g_iEmitterEntity[iEmitter] = EntIndexToEntRef(iAttachment);
}

public int Native_SetEmitterType(Handle hPlugin, int iNumParams)
{
	EmitterType etType = view_as<EmitterType>(GetNativeCell(2));
	int iEmitter = GetNativeCell(1);
	
	g_etEmitterType[iEmitter] = etType;
}

public int Native_SpawnEmitter(Handle hPlugin, int iNumParams)
{
	bool bActivate;
	char sClassname[PLATFORM_MAX_PATH], sEmitter[PLATFORM_MAX_PATH];
	EmitterType etEmitter;
	float fAngles[3], fFinalOrigin[3], fOrigin[3];
	int iBase = CreateEntityByName("prop_physics_override"), iClient = GetNativeCell(1), iColor[4], iEmitter;
	
	GetNativeArray(2, fOrigin, 3);
	etEmitter = view_as<EmitterType>(GetNativeCell(3));
	bActivate = view_as<bool>(GetNativeCell(4));
	iColor[0] = GetNativeCell(5);
	iColor[1] = GetNativeCell(6);
	iColor[2] = GetNativeCell(7);
	iColor[3] = GetNativeCell(8);
	
	KS_GetEmitterTypeName(etEmitter, sEmitter, sizeof(sEmitter));
	
	Format(sClassname, sizeof(sClassname), "emitter_%s", sEmitter);
	
	PrecacheModel("models/props_lab/tpplug.mdl");
	
	DispatchKeyValue(iBase, "classname", sClassname);
	DispatchKeyValue(iBase, "model", "models/props_lab/tpplug.mdl");
	DispatchKeyValue(iBase, "spawnflags", "256");
	
	DispatchSpawn(iBase);
	
	fAngles[0] = -90.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
	fFinalOrigin = fOrigin;
	
	TeleportEntity(iBase, fFinalOrigin, fAngles, NULL_VECTOR);
	
	KS_AddToCelCount(iClient);
	KS_SetColor(iBase, iColor[0], iColor[1], iColor[2], iColor[3]);
	KS_SetEntity(iBase, true);
	KS_SetFrozen(iBase, true);
	KS_SetOwner(iClient, iBase);
	KS_SetSolid(iBase, true);
	
	switch (etEmitter)
	{
		case EMITTER_CORE:
		{
			iEmitter = CreateEntityByName("env_citadel_energy_core");
			
			fAngles[0] = 0.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 8.0;
			
			DispatchKeyValue(iEmitter, "scale", "2");
			DispatchKeyValue(iEmitter, "spawnflags", "0");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterActive(iBase, bActivate);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			SetVariantFloat(0.0);
			AcceptEntityInput(KS_GetEmitterAttachment(iBase), KS_IsEmitterActive(iBase) ? "StartDischarge" : "StartCharge");
			
			return iBase;
		}
		/*case EMITTER_EXPLOSION:
		{
			iEmitter = CreateEntityByName("env_explosion");
			
			fAngles[0] = 0.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 8.0;
			
			DispatchKeyValue(iEmitter, "fireballsprite", "sprites/zerogxplode.spr");
			DispatchKeyValue(iEmitter, "iMagnitude", "25");
			DispatchKeyValue(iEmitter, "rendermode", "5");
			DispatchKeyValue(iEmitter, "spawnflags", "16386");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			return iBase;
		}*/
		case EMITTER_FIRE:
		{
			iEmitter = CreateEntityByName("env_fire");
			
			fAngles[0] = 0.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 8.0;
			
			DispatchKeyValue(iEmitter, "damagescale", "1.0");
			DispatchKeyValue(iEmitter, "fireattack", "4");
			DispatchKeyValue(iEmitter, "firesize", "64");
			DispatchKeyValue(iEmitter, "firetype", "0");
			DispatchKeyValue(iEmitter, "health", "30");
			DispatchKeyValue(iEmitter, "ignitionpoint", "32");
			DispatchKeyValue(iEmitter, "spawnflags", "257");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterActive(iBase, bActivate);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			SetVariantFloat(0.0);
			AcceptEntityInput(KS_GetEmitterAttachment(iBase), KS_IsEmitterActive(iBase) ? "StartFire" : "ExtinguishTemporary");
			
			return iBase;
		}
		case EMITTER_SHAKE:
		{
			iEmitter = CreateEntityByName("env_shake");
			
			fAngles[0] = 0.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 8.0;
			
			DispatchKeyValue(iEmitter, "amplitude", "4");
			DispatchKeyValue(iEmitter, "duration", "5");
			DispatchKeyValue(iEmitter, "frequency", "5");
			DispatchKeyValue(iEmitter, "radius", "100");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			return iBase;
		}
		case EMITTER_SMOKESTACK:
		{
			iEmitter = CreateEntityByName("env_smokestack");
			
			fAngles[0] = 0.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 8.0;
			
			DispatchKeyValue(iEmitter, "BaseSpread", "5");
			DispatchKeyValue(iEmitter, "EndSize", "10");
			DispatchKeyValue(iEmitter, "JetLength", "180");
			DispatchKeyValue(iEmitter, "Rate", "200");
			DispatchKeyValue(iEmitter, "roll", "65");
			DispatchKeyValue(iEmitter, "SmokeMaterial", "particle/SmokeStack.vmt");
			DispatchKeyValue(iEmitter, "Speed", "150");
			DispatchKeyValue(iEmitter, "SpreadSpeed", "15");
			DispatchKeyValue(iEmitter, "StartSize", "5");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterActive(iBase, bActivate);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			AcceptEntityInput(KS_GetEmitterAttachment(iBase), KS_IsEmitterActive(iBase) ? "TurnOn" : "TurnOff");
			
			return iBase;
		}
		/*case EMITTER_SPOTLIGHT:
		{
			iEmitter = CreateEntityByName("point_spotlight");
			
			fAngles[0] = -90.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 12.0;
			
			DispatchKeyValue(iEmitter, "disablereceiveshadows", "1");
			DispatchKeyValue(iEmitter, "HDRColorScale", "1.0");
			DispatchKeyValue(iEmitter, "spawnflags", "2");
			DispatchKeyValue(iEmitter, "spotlightlength", "50");
			DispatchKeyValue(iEmitter, "spotlightwidth", "10");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterActive(iBase, bActivate);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			AcceptEntityInput(KS_GetEmitterAttachment(iBase), KS_IsEmitterActive(iBase) ? "LightOn" : "LightOff");
			
			return iBase;
		}*/
		case EMITTER_STEAM:
		{
			iEmitter = CreateEntityByName("env_steam");
			
			fAngles[0] = -90.0, fAngles[1] = 0.0, fAngles[2] = 0.0;
			
			fFinalOrigin = fOrigin;
			fFinalOrigin[2] += 12.0;
			
			DispatchKeyValue(iEmitter, "EndSize", "15");
			DispatchKeyValue(iEmitter, "JetLength", "80");
			DispatchKeyValue(iEmitter, "Rate", "75");
			DispatchKeyValue(iEmitter, "rollspeed", "8");
			DispatchKeyValue(iEmitter, "spawnflags", "0");
			DispatchKeyValue(iEmitter, "Speed", "150");
			DispatchKeyValue(iEmitter, "SpreadSpeed", "25");
			DispatchKeyValue(iEmitter, "StartSize", "5");
			
			DispatchSpawn(iEmitter);
			
			TeleportEntity(iEmitter, fFinalOrigin, fAngles, NULL_VECTOR);
			
			SetVariantString("!activator");
			AcceptEntityInput(iEmitter, "SetParent", iBase);
			
			KS_SetEmitterAttachment(iBase, iEmitter);
			
			KS_SetColor(KS_GetEmitterAttachment(iBase), iColor[0], iColor[1], iColor[2], iColor[3]);
			KS_SetEntity(KS_GetEmitterAttachment(iBase), true);
			KS_SetOwner(iClient, KS_GetEmitterAttachment(iBase));
			
			SDKHook(iBase, SDKHook_UsePost, Hook_EmitterUse);
			
			KS_SetEmitterActive(iBase, bActivate);
			
			KS_SetEmitterType(iBase, etEmitter);
			
			AcceptEntityInput(KS_GetEmitterAttachment(iBase), KS_IsEmitterActive(iBase) ? "TurnOn" : "TurnOff");
			
			return iBase;
		}
	}
	
	return -1;
}
