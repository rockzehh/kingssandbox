#pragma semicolon 1

#include <kingssandbox>

#pragma newdecls required

bool g_bEntity[MAXENTS + 1] = false;
bool g_bLate = false;
bool g_bMovement[MAXENTS + 1] = false;

char g_sDisplayName[MAXENTS + 1][128];
char g_sExtraInfo[MAXENTS + 1][256];

int g_iColor[MAXENTS + 1][4];
int g_iOwner[MAXENTS + 1];

RenderFx g_rfFx[MAXENTS + 1];

RenderMode g_rmMode[MAXENTS + 1];

public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max)
{
	CreateNative("KSEntity.Entity.get", Native_GetEntity);
	CreateNative("KSEntity.Entity.set", Native_SetEntity);
	CreateNative("KSEntity.GetColor", Native_GetColor);
	CreateNative("KSEntity.GetDisplayName", Native_GetDisplayName);
	CreateNative("KSEntity.GetExtraInfo", Native_GetExtraInfo);
	CreateNative("KSEntity.Movement.get", Native_GetMovement);
	CreateNative("KSEntity.Movement.set", Native_SetMovement);
	CreateNative("KSEntity.Owner.get", Native_GetOwner);
	CreateNative("KSEntity.Owner.set", Native_SetOwner);
	CreateNative("KSEntity.RenderFX.get", Native_GetRenderFx);
	CreateNative("KSEntity.RenderFX.set", Native_SetRenderFx);
	CreateNative("KSEntity.RenderMode.get", Native_GetRenderMode);
	CreateNative("KSEntity.RenderMode.set", Native_SetRenderMode);
	CreateNative("KSEntity.SetColor", Native_SetColor);
	CreateNative("KSEntity.SetDisplayName", Native_SetDisplayName);
	CreateNative("KSEntity.SetExtraInfo", Native_SetExtraInfo);
	CreateNative("KSEntity.TeleportToCrosshair", Native_TeleportToCrosshair);
	CreateNative("KSPlayer.GetCrosshairHitOrigin", Native_GetCrosshairHitOrigin);
	
	g_bLate = bLate;
	
	return APLRes_Success;
}

public Plugin myinfo = 
{
	name = "King's Sandbox", 
	author = SANDBOX_AUTHOR, 
	description = "A fully customized building experience with a roleplay aspect, and extra features to enhance the standard gameplay.", 
	version = SANDBOX_VERSION, 
	url = SANDBOX_URL
};

public void OnPluginStart()
{
	if (g_bLate)
	{
		for (int i = 1; i < MaxClients; i++)
		{
			if (IsClientAuthorized(i))
			{
			}
		}
	}
}

//Plugin Natives:
public int Native_GetColor(Handle hPlugin, int iNumParams)
{
	int iColor[4] =  { 0, 0, 0, 0 }, iEntity = GetNativeCell(1);
	
	GetEntityRenderColor(iEntity, iColor[0], iColor[1], iColor[2], iColor[3]);
	g_iColor[iEntity] = iColor;
	
	SetNativeCellRef(2, iColor[0]);
	SetNativeCellRef(3, iColor[1]);
	SetNativeCellRef(4, iColor[2]);
	SetNativeCellRef(5, iColor[3]);
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

public int Native_GetDisplayName(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1), iMaxLength = GetNativeCell(3);
	
	SetNativeString(2, g_sDisplayName[iEntity], iMaxLength);
}

public int Native_GetEntity(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return g_bEntity[iEntity];
}

public int Native_GetExtraInfo(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1), iMaxLength = GetNativeCell(3);
	
	SetNativeString(2, g_sExtraInfo[iEntity], iMaxLength);
}

public int Native_GetMovement(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return g_bMovement[iEntity];
}

public int Native_GetOwner(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	return GetClientOfUserId(g_iOwner[iEntity]);
}

public int Native_GetRenderFx(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	RenderFx rfFx = GetEntityRenderFx(iEntity);
	
	g_rfFx[iEntity] = rfFx;
	
	return view_as<int>(rfFx);
}

public int Native_GetRenderMode(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	RenderMode rmMode = GetEntityRenderMode(iEntity);
	
	g_rmMode[iEntity] = rmMode;
	
	return view_as<int>(rmMode);
}

public int Native_SetColor(Handle hPlugin, int iNumParams)
{
	int iColor[4] =  { 0, 0, 0, 0 }, iEntity = GetNativeCell(1);
	
	iColor[0] = GetNativeCell(2);
	iColor[1] = GetNativeCell(3);
	iColor[2] = GetNativeCell(4);
	iColor[3] = GetNativeCell(5);
	
	SetEntityRenderColor(iEntity, iColor[0], iColor[1], iColor[2], iColor[3]);
	g_iColor[iEntity] = iColor;
}

public int Native_SetDisplayName(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	GetNativeString(2, g_sDisplayName[iEntity], sizeof(g_sDisplayName));
}

public int Native_SetEntity(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	g_bEntity[iEntity] = view_as<bool>(GetNativeCell(2));
}

public int Native_SetExtraInfo(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	GetNativeString(2, g_sExtraInfo[iEntity], sizeof(g_sExtraInfo));
}

public int Native_SetMovement(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	g_bMovement[iEntity] = view_as<bool>(GetNativeCell(2));
}

public int Native_SetOwner(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	g_iOwner[iEntity] = GetClientUserId(GetNativeCell(2));
}

public int Native_SetRenderFx(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	g_rfFx[iEntity] = view_as<RenderFx>(GetNativeCell(2));
}

public int Native_SetRenderMode(Handle hPlugin, int iNumParams)
{
	int iEntity = GetNativeCell(1);
	
	g_rmMode[iEntity] = view_as<RenderMode>(GetNativeCell(2));
}

public int Native_TeleportToCrosshair(Handle hPlugin, int iNumParams)
{
	float fOrigin[3];
	int iClient = GetNativeCell(2), iEntity = GetNativeCell(1);
	
	KSPlayer ksPlayer = KSPlayer(iClient);
	
	ksPlayer.GetCrosshairHitOrigin(fOrigin);
	
	TeleportEntity(iEntity, fOrigin, NULL_VECTOR, NULL_VECTOR);
}
