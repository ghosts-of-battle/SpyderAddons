#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(personalityHandler);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_personalityHandler

Description:
Main handler for civilian personalities

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
[_logic,_operation, _args] call SpyderAddons_fnc_personalityHandler
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_args", []]
];

//-- Define function shortcuts
#define MAINCLASS 		SpyderAddons_fnc_personalityHandler

switch (_operation) do {

	case "getPersonality": {
		_civ = _args;
		_civID = _civ getVariable ["agentID", ""];

		if (_civID == "") exitWith {};

		_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
		_result = [_civProfile,"Personality", ""] call ALiVE_fnc_hashGet;

		if (typename _result == "STRING") then {
			_result = [_logic,"create", _civ] call MAINCLASS;
			[_civProfile,"Personality", _result] call ALiVE_fnc_hashSet;
		};
	};

	case "create": {
		//_hostility = [nil,"generateHostilityValue"] call MAINCLASS;
		_bravery = [nil,"generateBraveryValue"] call MAINCLASS;
		_aggressiveness = [nil,"generateAggressivenessValue", [_bravery,_indecisiveness]] call MAINCLASS;
		_patience = [nil,"generatePatienceValue", _aggressiveness] call MAINCLASS;
		_indecisiveness = [nil,"generateIndecisivenessValue", _bravery] call MAINCLASS;

		_result = [] call ALiVE_fnc_hashCreate;
		[_result,"Bravery", _bravery] call ALiVE_fnc_hashSet;
		[_result,"Aggressiveness", _aggressiveness] call ALiVE_fnc_hashSet;
		[_result,"Patience", _patience] call ALiVE_fnc_hashSet;
		[_result,"Indecisiveness", _indecisiveness] call ALiVE_fnc_hashSet;

		_forces = [SpyderAddons_civilianInteraction,"forces"] call SpyderAddons_fnc_civilianInteraction;
		_forceAlignments = [] call ALiVE_fnc_hashCreate;
		{
			[_forceAlignments,(_x select 2) select 0, (_x select 2) select 2] call ALiVE_fnc_hashSet;
		} foreach _forces;

		[_result,"ForceAlignments", _forceAlignments] call ALiVE_fnc_hashSet;
	};

	case "generateBraveryValue": {
		//-- Average over 10,000 iterations: 24
		_result = 10 + ((ceil random 90) - (floor random 50));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generatePatienceValue": {
		__aggressiveness = _args;

		//-- Average over 10,000 iterations: 59
		_result = ((ceil random 100) + 30) - (ceil random 20 + (ceil random 20));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generateAggressivenessValue": {
		_args params ["_bravery","_indecisiveness"];

		//-- Average over 10,000 iterations: 34
		_result = ((ceil random 100) + 15) - (ceil random 30 + (ceil random 30));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generateIndecisivenessValue": {
		_bravery = _args;

		//-- Average over 10,000 iterations: 59
		_result = ((ceil random 100) + 20) - (ceil random 15 + (ceil random 15));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "bravery": {
		if (typename _args == "ARRAY") then {
			_result = [_logic,"Bravery"] call ALiVE_fnc_hashGet;
		} else {
			[_logic,"Bravery", _args] call ALiVE_fnc_hashSet;
			_result = _args;
		};
	};

	case "indecisiveness": {
		if (typename _args == "ARRAY") then {
			_result = [_logic,"Indecisiveness"] call ALiVE_fnc_hashGet;
		} else {
			[_logic,"Indecisiveness", _args] call ALiVE_fnc_hashSet;
			_result = _args;
		};
	};

	case "aggressiveness": {
		if (typename _args == "ARRAY") then {
			_result = [_logic,"Aggressiveness"] call ALiVE_fnc_hashGet;
		} else {
			[_logic,"Aggressiveness", _args] call ALiVE_fnc_hashSet;
			_result = _args;
		};
	};

	case "patience": {
		if (typename _args == "ARRAY") then {
			_result = [_logic,"patience"] call ALiVE_fnc_hashGet;
		} else {
			[_logic,"patience", _args] call ALiVE_fnc_hashSet;
			_result = _args;
		};
	};

	case "getForceAlignment": {
		_args params ["_personality","_force"];
		_sideAlignments = [_personality,"SideAlignments"] call ALiVE_fnc_hashGet;
		_return = [_sideAlignments,_force] call ALiVE_fnc_hashGet;
	};

	case "save": {
		if !(isServer) exitWith {[_logic,_operation,_args] remoteExecCall [QUOTE(MAINCLASS),2]};
		_args params ["_civ","_personality"];

		_civID = _civ getVariable ["agentID", ""];
		if (_civID == "") exitWith {};

		_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
		[_civProfile,"Personality", _personality] call ALiVE_fnc_hashSet;
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};