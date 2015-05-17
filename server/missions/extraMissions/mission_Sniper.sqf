// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Sniper.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "extraMissionDefines.sqf";

private ["_positions", "_boxes1", "_currBox1", "_box1"];

_setupVars =
{
	_missionType = "Sniper Nest";
	_positions = [[4002.00,7028.00,0.1],[4806.00,4374.00,0.1],[2645.00,1613.00,0.1],[2645.00,607.00,0.1],[4324.00,5743.00,0.1]];

	_missionPos = _positions call BIS_fnc_SelectRandom;
};

_setupObjects =
{
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos] spawn createsniperGroup;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";

	_missionHintText = format ["A Sniper Nest has been spotted. Head to the marked area and Take them out! Be careful they are fully armed and dangerous!", extraMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
};

_successExec =
{
	// Mission completed

	_boxes1 = ["Box_East_WpsSpecial_F","Box_IND_WpsSpecial_F"];
	_currBox1 = _boxes1 call BIS_fnc_selectRandom;
	_box1 = createVehicle [_currBox1, _lastPos, [], 2, "None"];
	_box1 allowDamage false;
	_box1 setVariable ["R3F_LOG_disabled", false, true];

	_successHintMessage = format ["The snipers are dead! Well Done!"];
};

_this call extraMissionProcessor;