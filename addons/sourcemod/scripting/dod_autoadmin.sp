#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
//#include "oitc/config.sp"
//#include <dodhooks>
#pragma semicolon 1
//#pragma newdecls required
#define PLUGIN_VERSION		"1.0"
//##################
//# Plugin Details
//##################
public Plugin myinfo =
{
	name = "DOD:S 8th ID AutoAdmin",
	author = "ChesterSmitty",
	description = "AutoAdmin for 8th ID DOD:S Server",
	version = PLUGIN_VERSION,
	url = "https://github.com/ChesterSmitty/dod_autoadmin"
};

//##################
//# TO DOS
//##################
//1. Change map when team gets x(ScoreToWinMap) wins
//2. Auto Activate Flags at 6v6 or above
//3. Auto Vote customs at xvx (TBD)
//4. Set map back to flash when server slows down

//##################
//# Constants
//##################
#define DOD_MAXPLAYERS	33
#define TEAM_SPECTATOR  1
#define TEAM_ALLIES  		2
#define TEAM_AXIS  			3
#define TEAM_RANDOM  		4
#define MAXCLASSES		14
#define MAXWEAPONS		22

//##################
//# Variables
//##################
new Handle:ScoreToWinMap = INVALID_HANDLE;
new Handle:ScoreAxis = INVALID_HANDLE;
new Handle:ScoreAllies = INVALID_HANDLE;
new Handle:flags = INVALID_HANDLE;
new bool:g_bModRunning = true;
new bool:g_bRoundActive = true;
new g_bAutoModRunning = false;
new g_iMinPlayersFlags = 10;
//##################
//# Config
//##################

//##################
//# Actions
//##################

public void OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
	RegAdminCmd("sm_autoadmin", AutoAdmin, ADMFLAG_ROOT, "sm_autoadmin");
	//AutoExecConfig(true, "plugin_autoadmin");
}

public Event_PlayerSpawn(Handle:hEvent, const String:szName[], bool:bDontBroadcast)
{
	if (g_bAutoModRunning)
	{
		flags = FindConVar("flags");
		if (GetConVarInt(flags) == 0)
		{
			if (GetTeamClientCount(TEAM_ALLIES) + GetTeamClientCount(TEAM_AXIS) >= GetConVarInt(g_iMinPlayersFlags))
			{
				PrintToChatAll("%i players have joined, enabling flags",g_iMinPlayersFlags);
				flags = 1;
			}
			return Plugin_Handled;
		}
		if (GetConVarInt(flags) == 1)
		{
			if (GetTeamClientCount(TEAM_ALLIES) + GetTeamClientCount(TEAM_AXIS) < (GetConVarInt(g_iMinPlayersFlags) - 1))
			{
				PrintToChatAll("Low player count detected, disabling flags until %i players have joined",g_iMinPlayersFlags);
				flags = 0;
			}
			return Plugin_Handled;
		}
	}
}

public Action:AutoAdmin(int client, int args)
{
	ReplyToCommand(client, "Sgt. Smith's AutoAdmin here!");
	return Plugin_Handled;
}

//##################
//# Functions
//##################
