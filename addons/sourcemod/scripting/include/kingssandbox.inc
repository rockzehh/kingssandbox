#if defined _kingssandbox_included
#endinput
#endif
#define _kingssandbox_included

#include <morecolors>
#include <sdkhooks>
#include <sdktools>
#include <sourcemod>

enum EntityCatagory
{
	ENTCATAGORY_CEL = 0, /**< Cel entity. cel_internet, emitter_*, prop_door_rotating */
	ENTCATAGORY_PROP = 1, /**< Prop entity. cycler, prop_dynamic, prop_dynamic_override, prop_physics, prop_physics_override */
	ENTCATAGORY_UNKNOWN = 2, /**< Unknown entity. */
};

enum EntityType
{
	ENTTYPE_CYCLER = 0, /**< Cycler prop type. cycler */
	ENTTYPE_DOOR = 1, /**< Door prop type. prop_door_rotating */
	ENTTYPE_DYNAMIC = 2, /**< Dynamic prop type. prop_dynamic, prop_dynamic_override */
	ENTTYPE_EMITTER = 3, /**< Emitter prop type. emitter_* */
	ENTTYPE_INTERNET = 4, /**< Internet prop type. cel_internet */
	ENTTYPE_PHYSICS = 5, /**< Physics prop type. prop_physics, prop_physics_override */
	ENTTYPE_UNKNOWN = 6, /**< Unknown prop type. */
};

enum EmitterType
{
	EMITTER_CORE = 0,  /**< Core emitter type. env_citadel_energy_core */
	EMITTER_EXPLOSION = 1, /**< Explosion emitter type. env_explosion */
	EMITTER_FIRE = 2,  /**< Fire emitter type. env_fire */
	EMITTER_SHAKE = 3, /**< Shake emitter type. env_shake */
	EMITTER_SMOKESTACK = 4,  /**< Smokestack emitter type. env_smokestack */
	EMITTER_SPOTLIGHT = 5,  /**< Spotlight emitter type. point_spotlight */
	EMITTER_STEAM = 6,  /**< Steam emitter type. env_steam */
	EMITTER_UNKNOWN = 7, /**< Unknown emitter type. */
};

#define SANDBOX_VERSION "1.1.0.0" /**< Global version. */
#define MAXENTS 2048 /**< Max number of entities Source can handle. */

float g_fZero[3] = { 0.0, 0.0, 0.0 };

//========== kingssandbox.smx ==========
/**
 * Adds one to the client's cel count.
 *
 * @param iClient		Index of the client.
 */
native void KS_AddToCelCount(int iClient);

/**
 * Adds one to the client's prop count.
 *
 * @param iClient		Index of the client.
 */
native void KS_AddToPropCount(int iClient);

/**
 * Sends out a beam to the entity provided from the client signalling a change to the entity.
 *
 * @param iClient		Index of the client.
 * @param iEntity		Index of the entity.
 */
native void KS_ChangeBeam(int iClient, int iEntity);

/**
 * Checks if the client's cel count has reached the server's cel limit.
 *
 * @param iClient		Index of the client.
 * @return				True if the cel limit has been reached, false if it hasn't.
 */
native bool KS_CheckCelCount(int iClient);

/**
 * Checks if the color exists in the color database.
 *
 * @param sColor		String to check.
 * @param sColorString	Buffer to store the color string.
 * @param iMaxLength	Maximum length of the buffer.
 * @return				True if the color exists, false if it doesn't.
 */
native bool KS_CheckColorDB(const char[] sColor, char[] sColorString, int iMaxLength);

native bool KS_CheckEntityCatagory(int iEntity, EntityCatagory ecEntityCatagory);

/**
 * Checks if the prop type matches the search string.
 *
 * @param iEntity		Prop index.
 * @param sTypeCheck	Prop type to check.
 * @return				True if the string matches the prop type, false if it doesn't.
 */
native bool KS_CheckEntityType(int iEntity, const char[] sTypeCheck);

/**
 * Checks if the client is the owner of the entity.
 *
 * @param iClient		Client index.
 * @param iEntity		Entity index.
 * @return				True if the client is the owner of the entity, false if it isn't.
 */
native bool KS_CheckOwner(int iClient, int iEntity);

/**
 * Checks if the client's prop count has reached the server's prop limit.
 *
 * @param iClient		Index of the client.
 * @return				True if the prop limit has been reached, false if it hasn't.
 */
native bool KS_CheckPropCount(int iClient);

/**
 * Checks if the prop exists in the spawn database.
 *
 * @param sAlias		String to check.
 * @param sSpawnString	Buffer to store the spawn string.
 * @param iMaxLength	Maximum length of the buffer.
 * @return				True if the prop exists, false if it doesn't.
 */
native bool KS_CheckSpawnDB(const char[] sAlias, char[] sSpawnString, int iMaxLength);

/**
 * Dissolves the entity provided.
 *
 * @param iEntity		Entity index.
 */
native void KS_DissolveEntity(int iEntity);

/**
 * Gets the client's auth id and stores it.
 *
 * @param iClient		Client index.
 * @param sAuthID		Buffer to store the auth id.
 * @param iMaxLength	Maximum length of the buffer.
 */
native char KS_GetAuthID(int iClient, char[] sAuthID, int iMaxLength);

native int KS_GetBeamMaterial();

/**
 * Gets the entity index that the client is looking at and checks if it belongs to the plugin.
 *
 * @param iClient		Client index.
 * @return				Entity index if it belongs to the plugin, -1 if it doesn't.
 */
native int KS_GetClientAimTarget(int iClient);

/**
 * Gets the client's cel count.
 *
 * @param iClient		Client index.
 * @return				Returns the client's cel count.
 */
native int KS_GetCelCount(int iClient);

/**
 * Gets the server's cel limit.
 *
 * @return				Returns the server's cel limit.
 */
native int KS_GetCelLimit();

/**
 * Gets the entity color.
 *
 * @param iEntity		Entity index.
 * @param iColor		Buffer to store the color values.
 */
native int KS_GetColor(int iEntity, int iColor[4]);

/**
 * Gets the crosshair origin.
 *
 * @param iClient			Client index.
 * @param fCrosshairOrigin	Buffer to store the crosshair origin.
 */
native float KS_GetCrosshairHitOrigin(int iClient, float fCrosshairOrigin[3]);

stock float KS_GetEntityAngles(int iEntity, float fAngles[3])
{
	GetEntPropVector(iEntity, Prop_Data, "m_angAbsRotation", fAngles);
}

native EntityCatagory KS_GetEntityCatagory(int iEntity);

native char KS_GetEntityCatagoryName(int iEntity, char[] sEntityCatagory, int iMaxLength);

stock float KS_GetEntityOrigin(int iEntity, float fOrigin[3])
{
	GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fOrigin);
}

/**
 * Gets the prop type.
 *
 * @param iEntity		Entity index.
 * @return				Returns the prop type.
 */
native EntityType KS_GetEntityType(int iEntity);

/**
 * Gets the prop type from name.
 *
 * @param sEntityType		String to check.
 * @return				Returns the prop type, ENTTYPE_UNKNOWN if the name is invalid.
 */
native EntityType KS_GetEntityTypeFromName(const char[] sEntityType);

/**
 * Gets the prop type name from prop type.
 *
 * @param etEntityType	Prop type.
 * @param sEntityType		Buffer to store the prop type.
 * @param iMaxLength	Maximum length of the buffer.
 */
native char KS_GetEntityTypeName(EntityType etEntityType, char[] sEntityType, int iMaxLength);

native int KS_GetHaloMaterial();

/**
 * Gets the internet cel url.
 *
 * @param iEntity		Entity index.
 * @param sURL			Buffer to store the url.
 * @param iMaxLength	Maximum length of the buffer.
 */
native char KS_GetInternetURL(int iEntity, const char[] sURL, int iMaxLength);

/**
 * Checks if the client has nokill enabled.
 *
 * @param iClient			Client index.
 * @return					True if the client does, false if they don't.
 */
native int KS_GetNoKill(int iClient);

/**
 * Gets the entity's owner index.
 *
 * @param iEntity			Entity index.
 * @return					Returns the owner's client index.
 */
native int KS_GetOwner(int iEntity);

native int KS_GetPhysicsMaterial();

/**
 * Gets the client's prop count.
 *
 * @param iClient		Client index.
 * @return				Returns the client's prop count.
 */
native int KS_GetPropCount(int iClient);

/**
 * Gets the client's prop limit.
 *
 * @return				Returns the server's prop limit.
 */
native int KS_GetPropLimit();

/**
 * Gets the name of the prop.
 *
 * @param iEntity		Entity index.
 * @param sPropNamm		Buffer to store the propname.
 * @param iMaxLength	Maximum length of the buffer.
 */
native char KS_GetPropName(int iEntity, const char[] sPropName, int iMaxLength);

/**
 * Checks if the entity is a plugin entity.
 *
 * @param iEntity		Entity index.
 * @return				True if the entity is, false if it isn't.
 */
native bool KS_IsEntity(int iEntity);

/**
 * Checks if the entity is frozen.
 *
 * @param iEmitter		Entity index.
 * @return				True if the entity is, false if it isn't.
 */
native bool KS_IsFrozen(int iEntity);

native bool KS_IsPlayer(int iClient);

/**
 * Checks if the entity is solid.
 *
 * @param iEmitter		Entity index.
 * @return				True if the entity is, false if it isn't.
 */
native bool KS_IsSolid(int iEntity);

native void KS_NotLooking(int iClient);

native void KS_NotYours(int iClient, int iEntity);

forward void KS_OnCelSpawn(int iCel, int iOwner, EntityType etEntityType);

forward void KS_OnEntityRemove(int iEntity, int iOwner, bool bCel);

forward void KS_OnPropSpawn(int iProp, int iOwner, EntityType etEntityType);

native void KS_PlayChatMessageSound(int iClient);

native void KS_PrintToChat(int iClient, const char[] sMessage, any ...);

native void KS_PrintToChatAll(const char[] sMessage, any ...);

native void KS_RemovalBeam(int iClient, int iEntity);

native void KS_ReplyToCommand(int iClient, const char[] sMessage, any ...);

native void KS_SetAuthID(int iClient);

native void KS_SetCelCount(int iClient, int iCount);

native void KS_SetCelLimit(int iLimit);

native void KS_SetColor(int iEntity, int iR, int iG, int iB, int iA);

native void KS_SetEntity(int iEntity, bool bEntity);

native void KS_SetFrozen(int iEntity, bool bFrozen);

native void KS_SetInternetURL(int iEntity, const char[] sURL);

native void KS_SetNoKill(int iClient, bool bNoKill);

native void KS_SetOwner(int iClient, int iEntity);

native void KS_SetPlayer(int iClient, bool bPlayer);

native void KS_SetPropCount(int iClient, int iCount);

native void KS_SetPropLimit(int iLimit);

native void KS_SetPropName(int iEntity, const char[] sPropName);

native void KS_SetSolid(int iEntity, bool bSolid);

native int KS_SpawnDoor(int iClient, const char[] sSkin, float fAngles[3], float fOrigin[3], int iR, int iG, int iB, int iA);

native int KS_SpawnInternet(int iClient, const char[] sURL, float fAngles[3], float fOrigin[3], int iR, int iG, int iB, int iA);

native int KS_SpawnProp(int iClient, const char[] sAlias, const char[] sEntityType, const char[] sModel, float fAngles[3], float fOrigin[3], int iR, int iG, int iB, int iA);

native void KS_SubFromCelCount(int iClient);

native void KS_SubFromPropCount(int iClient);

//========== ks_emitters.smx ==========
/**
 * Checks if the emitter type matches the search string.
 *
 * @param iEmitter		Emitter index.
 * @param sType			Emitter type to check.
 * @return				True if the string matches the emitter type, false if it doesn't.
 */
native bool KS_CheckEmitterType(const int iEmitter, const char[] sType);

/**
 * Gets the emitter attachment entity index.
 *
 * @param iEmitter		Emitter index.
 * @return				Returns the emitter attachment index.
 */
native int KS_GetEmitterAttachment(int iEmitter);

/**
 * Gets the emitter type.
 *
 * @param iEmitter		Emitter index.
 * @return				Returns the emitter type.
 */
native EmitterType KS_GetEmitterType(int iEmitter);

/**
 * Gets the emitter type from name.
 *
 * @param sEmitterName	String to check.
 * @return				Returns the emitter type, EMITTER_UNKNOWN if the name is invalid.
 */
native EmitterType KS_GetEmitterTypeFromName(const char[] sEmitterName);

/**
 * Gets the emitter type name from emitter type.
 *
 * @param etEmitterType	Emitter type.
 * @param sEmitterType	Buffer to store the emitter type.
 * @param iMaxLength	Maximum length of the buffer.
 */
native char KS_GetEmitterTypeName(EmitterType etEmitterType, char[] sEmitterType, int iMaxLength);

/**
 * Checks if the emitter is active.
 *
 * @param iEmitter		Emitter index.
 * @return				True if the emitter is, false if it isn't.
 */
native bool KS_IsEmitterActive(int iEmitter);

forward void KS_OnEmitterSpawn(int iEmitter, int iOwner, EmitterType etEmitterType);

native void KS_SetEmitterActive(int iEmitter, bool bActive);

native void KS_SetEmitterAttachment(int iEmitter, int iAttachment);

native void KS_SetEmitterType(int iEmitter, EmitterType etEmitterType);

native int KS_SpawnEmitter(const int iClient, const float fOrigin[3], const EmitterType etEmitter, bool bActivate, const int iR, const int iG, const int iB, const int iA);

//========== ks_help.smx ==========
native char KS_CheckInputURL(const char[] sInput, char[] sOutput, int iMaxLength);

/**
 * Exports the color list to a file.
 *
 * @param bHTML			If true, a html list will be generated.
 * @return				True if the list could be generated, false if it couldn't.
 */
native bool KS_ExportColorList(bool bHTML);

/**
 * Exports the command list to a file.
 *
 * @param bHTML			If true, a html list will be generated.
 * @return				True if the list could be generated, false if it couldn't.
 */
native bool KS_ExportCommandList(bool bHTML);

/**
 * Exports the prop list to a file.
 *
 * @param bHTML			If true, a html list will be generated.
 * @return				True if the list could be generated, false if it couldn't.
 */
native bool KS_ExportPropList(bool bHTML);

native void KS_OpenMOTDOnClient(int iClient, bool bShow, const char[] sTitle, const char[] sDestination, int iType = MOTDPANEL_TYPE_URL);

//========== ks_hud.smx ==========
native void KS_ChooseHudColor(int iClient);

native int KS_GetHudColor(int iClient, int iColor[4]);

native void KS_SendHudMessage(int iClient, int iChannel, float fX, float fY, int iR, int iG, int iB, int iA, int iEffect, float fFadeIn, float fFadeOut, float fHoldTime, float fFxTime, char[] sMessage);

native void KS_SetHudColor(int iClient, int iR, int iG, int iB, int iA);

//========== ks_serverconvars.smx ==========
native void KS_ReloadServerConVars();

//Hooks:
public void Hook_EmitterUse(int iEntity, int iActivator, int iCaller, UseType utType, float fValue)
{
	switch(KS_GetEmitterType(iEntity))
	{
		case EMITTER_CORE:
		{
			SetVariantFloat(0.0);
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), KS_IsEmitterActive(iEntity) ? "StartDischarge" : "StartCharge");
		}
		case EMITTER_EXPLOSION:
		{
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), "Explode");
		}
		case EMITTER_FIRE:
		{
			SetVariantFloat(0.0);
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), KS_IsEmitterActive(iEntity) ? "StartFire" : "ExtinguishTemporary");
		}
		case EMITTER_SHAKE:
		{
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), "StartShake");
		}
		case EMITTER_SMOKESTACK:
		{
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), KS_IsEmitterActive(iEntity) ? "TurnOn" : "TurnOff");
		}
		case EMITTER_SPOTLIGHT:
		{
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), KS_IsEmitterActive(iEntity) ? "LightOn" : "LightOff");
		}
		case EMITTER_STEAM:
		{
			AcceptEntityInput(KS_GetEmitterAttachment(iEntity), KS_IsEmitterActive(iEntity) ? "TurnOn" : "TurnOff");
		}
	}
	
	KS_SetEmitterActive(iEntity, !KS_IsEmitterActive(iEntity));
}

public void Hook_InternetUse(int iEntity, int iActivator, int iCaller, UseType utType, float fValue)
{
	char sURL[PLATFORM_MAX_PATH];
	
	KS_GetInternetURL(iEntity, sURL, sizeof(sURL));
	
	KS_OpenMOTDOnClient(iActivator, true, "King's Web Viewer", sURL, MOTDPANEL_TYPE_URL);
}

//Timers:
public Action Timer_DelayRemove(Handle hTimer, any iRef)
{
	int iEntity = EntRefToEntIndex(iRef);
	
	AcceptEntityInput(iEntity, "kill");
}

public Action Timer_DisRemove(Handle hTimer, any iRef)
{
	int iEntity = EntRefToEntIndex(iRef);
	
	KS_DissolveEntity(iEntity);
}
