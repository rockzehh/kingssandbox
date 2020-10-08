/*
** King's Sandbox:
** A fully customized building experience with a roleplay aspect, and extra features to enhance the standard gameplay.
*/

#if defined _kingssandbox_included
#endinput
#endif
#define _kingssandbox_included

#include <morecolors>
#include <sdkhooks>
#include <sdktools>
#include <sourcemod>

enum KSEffectType
{
	EFFECT_UNKNOWN = 0, /**< Unknown effect. */
};

enum KSEntityCatagory
{
	ENTCATAGORY_CEL = 0, /**< Cel entities. cel_*, effects_*, prop_door_rotating */
	ENTCATAGORY_PROP = 1, /**< Prop entities. cycler, prop_dynamic, prop_dynamic_override, prop_physics, prop_physics_override */
	ENTCATAGORY_UNKNOWN = 2, /**< Unknown entity. */
};

enum KSEntityType
{
	ENTTYPE_CYCLER = 0, /**< Cycler entity type. cycler */
	ENTTYPE_DOOR = 1, /**< Door entity type. prop_door_rotating */
	ENTTYPE_DYNAMIC = 2, /**< Dynamic entity type. prop_dynamic, prop_dynamic_override */
	ENTTYPE_EFFECT = 3, /**< Effect entity type. effect_* */
	ENTTYPE_INTERNET = 4, /**< Internet entity type. cel_internet */
	ENTTYPE_PHYSICS = 5, /**< Physics entity type. prop_physics, prop_physics_override */
	ENTTYPE_UNKNOWN = 6, /**< Unknown entity type. */
};

#define MAXENTS 2048
#define SANDBOX_AUTHOR "King Nothing" /**< Global author. */
#define SANDBOX_URL "https://github.com/rockzehh/kingssandbox" /**< Global project url. */
#define SANDBOX_VERSION "1.2.0.0" /**< Global version. */

methodmap KSEntity
{
	/** Declaring KSEntity. */
	public KSEntity(int iEnt)
	{
		return view_as<KSEntity>(iEnt);
	}
	
	/** Declaring iEntity. */
	property int iEntity
	{
		public get() { return view_as<int>(this); }
	}
	
	/** Plugin entities tag. */
	property bool Entity
	{
		public native get();
		public native set(bool bEntity);
	}
	
	/**
	 * Gets the entities angles.
	 *
	 * @param fAngles		Angles buffer.
	 */
	public float GetAngles(float fAngles[3])
	{
		GetEntPropVector(this.iEntity, Prop_Data, "m_angAbsRotation", fAngles);
	}
	
	/**
	 * Gets the entities render color.
	 *
	 * @param iR			Red channel buffer.
	 * @param iG			Green channel buffer.
	 * @param iB			Blue channel buffer.
	 * @param iA			Alpha channel buffer.
	 */
	public native void GetColor(int& iR, int& iG, int& iB, int& iA);
	
	/**
	 * Gets the entities display name.
	 *
	 * @param sName			Name buffer.
	 * @param iMaxLength	Maximum length of the buffer.
	 */
	public native void GetDisplayName(char[] sName, int iMaxLength);
	
	/**
	 * Gets the entities extra information.
	 *
	 * @param sInfo			Information buffer.
	 */
	public native void GetExtraInfo(char[] sInfo, int iMaxLength);
	
	/**
	 * Gets the entities origin.
	 *
	 * @param fOrigin		Origin buffer.
	 */
	public float GetOrigin(float fOrigin[3])
	{
		GetEntPropVector(this.iEntity, Prop_Send, "m_vecOrigin", fOrigin);
	}
	
	/**
	 * Gets the entities velocity.
	 *
	 * @param fVelocity		Velocity buffer.
	 */
	public float GetVelocity(float fVelocity[3])
	{
		GetEntPropVector(this.iEntity, Prop_Data, "m_vecVelocity", fVelocity);
	}
	
	/** Entity movement. */
	property bool Movement
	{
		public native get();
		public native set(bool bMovement);
	}
	
	/** Entity ownership. */
	property int Owner
	{
		public native get();
		public native set(int iClient);
	}
	
	/** Entity render fx. */
	property RenderFx RenderFX
	{
		public native get();
		public native set(RenderFx rfFx);
	}
	
	/** Entity render mode. */
	property RenderMode RenderMode
	{
		public native get();
		public native set(RenderMode rmMode);
	}
	
	/**
	 * Sets the entities angles.
	 *
	 * @param fAngles		Angles buffer.
	 */
	public float SetAngles(float fAngles[3])
	{
		TeleportEntity(this.iEntity, NULL_VECTOR, fAngles, NULL_VECTOR);
	}
	
	/**
	 * Sets the entities render color.
	 *
	 * @param iR			Red channel buffer.
	 * @param iG			Green channel buffer.
	 * @param iB			Blue channel buffer.
	 * @param iA			Alpha channel buffer.
	 */
	public native void SetColor(int iR, int iG, int iB, int iA);
	
	/**
	 * Sets the entities display name.
	 *
	 * @param sName			Name buffer.
	 */
	public native void SetDisplayName(char[] sName);
	
	/**
	 * Sets the entities extra information.
	 *
	 * @param sInfo			Information buffer.
	 */
	public native void SetExtraInfo(char[] sInfo);
	
	/**
	 * Sets the entities origin.
	 *
	 * @param fOrigin		Origin buffer.
	 */
	public float SetOrigin(float fOrigin[3])
	{
		TeleportEntity(this.iEntity, fOrigin, NULL_VECTOR, NULL_VECTOR);
	}
	
	/**
	 * Sets the entities velocity.
	 *
	 * @param fVelocity		Velocity buffer.
	 */
	public float SetVelocity(float fVelocity[3])
	{
		TeleportEntity(this.iEntity, NULL_VECTOR, NULL_VECTOR, fVelocity);
	}
	
	/**
	 * Teleports entity to client crosshair.
	 *
	 * @param iClient		Client index.
	 */
	public native void TeleportToCrosshair(int iClient);
}

methodmap KSPlayer
{
	/** Declaring KSPlayer. */
	public KSPlayer(int iPlayer)
	{
		return view_as<KSPlayer>(iPlayer);
	}
	
	/** Declaring iClient. */
	property int iClient
	{
		public get() { return view_as<int>(this); }
	}
	
	/**
	 * Gets hit origin of client crosshair.
	 *
	 * @param fOrigin	Origin buffer.
	 */
	public native void GetCrosshairHitOrigin(float fOrigin[3]);
}

stock bool KS_FilterPlayer(int iEntity, any iContentsMask)
{
	return iEntity > MaxClients;
}
