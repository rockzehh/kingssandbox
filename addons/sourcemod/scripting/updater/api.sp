
/* API - Natives & Forwards */

static Handle fwd_OnPluginChecking = INVALID_HANDLE;
static Handle fwd_OnPluginDownloading = INVALID_HANDLE;
static Handle fwd_OnPluginUpdating = INVALID_HANDLE;
static Handle fwd_OnPluginUpdated = INVALID_HANDLE;

void API_Init()
{
	CreateNative("Updater_AddPlugin", Native_AddPlugin);
	CreateNative("Updater_RemovePlugin", Native_RemovePlugin);
	CreateNative("Updater_ForceUpdate", Native_ForceUpdate);
	
	fwd_OnPluginChecking = CreateForward(ET_Event);
	fwd_OnPluginDownloading = CreateForward(ET_Event);
	fwd_OnPluginUpdating = CreateForward(ET_Ignore);
	fwd_OnPluginUpdated = CreateForward(ET_Ignore);
}

// native Updater_AddPlugin(const char[] url);
public int Native_AddPlugin(Handle plugin, int numParams)
{
	char url[MAX_URL_LENGTH];
	GetNativeString(1, url, sizeof(url));
	
	Updater_AddPlugin(plugin, url);
}

// native Updater_RemovePlugin();
public int Native_RemovePlugin(Handle plugin, int numParams)
{
	int index = PluginToIndex(plugin);
	
	if (index != -1)
	{
		Updater_QueueRemovePlugin(plugin);
	}
}

// native bool Updater_ForceUpdate();
public int Native_ForceUpdate(Handle plugin, int numParams)
{
	int index = PluginToIndex(plugin);
	
	if (index == -1)
	{
		ThrowNativeError(SP_ERROR_NOT_FOUND, "Plugin not found in updater.");
	}
	else if (Updater_GetStatus(index) == Status_Idle)
	{
		Updater_Check(index);
		return 1;
	}
	
	return 0;
}

// forward Action:Updater_OnPluginChecking();
Action Fwd_OnPluginChecking(Handle plugin)
{
	Action result = Plugin_Continue;
	Function func = GetFunctionByName(plugin, "Updater_OnPluginChecking");
	
	if (func != INVALID_FUNCTION && AddToForward(fwd_OnPluginChecking, plugin, func))
	{
		Call_StartForward(fwd_OnPluginChecking);
		Call_Finish(result);
		RemoveAllFromForward(fwd_OnPluginChecking, plugin);
	}
	
	return result;
}

// forward Action:Updater_OnPluginDownloading();
Action Fwd_OnPluginDownloading(Handle plugin)
{
	Action result = Plugin_Continue;
	Function func = GetFunctionByName(plugin, "Updater_OnPluginDownloading");
	
	if (func != INVALID_FUNCTION && AddToForward(fwd_OnPluginDownloading, plugin, func))
	{
		Call_StartForward(fwd_OnPluginDownloading);
		Call_Finish(result);
		RemoveAllFromForward(fwd_OnPluginDownloading, plugin);
	}
	
	return result;
}

// forward Updater_OnPluginUpdating();
void Fwd_OnPluginUpdating(Handle plugin)
{
	Function func = GetFunctionByName(plugin, "Updater_OnPluginUpdating");
	
	if (func != INVALID_FUNCTION && AddToForward(fwd_OnPluginUpdating, plugin, func))
	{
		Call_StartForward(fwd_OnPluginUpdating);
		Call_Finish();
		RemoveAllFromForward(fwd_OnPluginUpdating, plugin);
	}
}

// forward Updater_OnPluginUpdated();
void Fwd_OnPluginUpdated(Handle plugin)
{
	Function func = GetFunctionByName(plugin, "Updater_OnPluginUpdated");
	
	if (func != INVALID_FUNCTION && AddToForward(fwd_OnPluginUpdated, plugin, func))
	{
		Call_StartForward(fwd_OnPluginUpdated);
		Call_Finish();
		RemoveAllFromForward(fwd_OnPluginUpdated, plugin);
	}
}
