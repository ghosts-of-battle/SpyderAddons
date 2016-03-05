#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(getResponses);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getResponses

Description:
Returns any responses for a question

Parameters:
Object - Logic
String - Question

Returns:
none

Examples:
(begin example)
(end)

See Also:
- nil

Author:
SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_result","_responses"];
params [
	["_logic", objNull],
	["_question", ""],
	["_args",[]]
];

//-- Define function macros
#define CIVILIANINTERACTION SpyderAddons_fnc_civilianInteraction

//-- Get information
_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;
_civData = [_logic,"CivData"] call ALiVE_fnc_hashGet;
_civInfo = [_civData,"CivInfo"] call ALiVE_fnc_hashGet;
_personality = [_civInfo,"Personality"] call ALiVE_fnc_hashGet;	// ["Bravery","Aggressiveness","Indecisiveness","ForceAlignments"]

_hostility = [_civInfo,"HostilityIndividual"] call ALiVE_fnc_hashGet;
_hostile = [_civInfo,"Hostile"] call ALiVE_fnc_hashGet;
_civName = [_civInfo,"Name"] call ALiVE_fnc_hashGet;

switch (_question) do {

	//-- How are you
	case "HowAreYou": {
		if (random 100 > _hostility) then {
			if (_hostile) then {
				//-- Impartial
				_responses = ["I am well.","I am well, how are you?","I am doing ok.","Life has been kind to me.","Please excuse me, I am busy."];

				_result = selectRandom _responses;
				_result = [_result, [["That is good to hear","['GoodToHear',1,1]"]]];
			} else {
				//-- Positive
				_responses = ["I am well.","I am well, how are you?","Everything is going well here.","Life has been kind to me.","No problems plague me.",
				"Thanks to your forces, everything is well.","There are no problems here.","I have no complaints."];

				_result = selectRandom _responses;
				_result = [_result, [["That is good to hear","['GoodToHear',1,1]"]]];
			};
		} else {
			//-- Negative
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Aggressive
				_responses = ["Get out of here!","Leave me alone you demon!","Leave now!","It will be fine once you leave.","I hate you.",
				"Every day I have to see you patrol is a day in hell.","Go to hell!","I have no time for you!","I hope you die in a hole!"];

				_result = selectRandom _responses;
				_result = [_result, [["You better calm down","['CalmDownThreat',1.3,2]"],["Sorry to bother you","['SorryForBother',1.3,1]"]]];
			} else {
				//-- Non Aggressive
				_responses = ["Leave now.","I have no time for you.","Awful, thanks to you.","Your forces have ruined life around here.","Leave me alone.",
				"You need to leave.","Go to hell.","Get our of here pig.","Make yourself useful and leave."];

				_result = selectRandom _responses;
				_result = [_result, [["Calm down","['CalmDown',1,1]"],["Sorry to bother you","['SorryForBother',1,1]"]]];
			};
		};
	};

	case "GoodToHear": {
		//-- No response
		_result = ["", []];
	};

	case "CalmDown": {
		if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
			_responses = ["You're right.","I am sorry.","Forgive me.","I will calm down.","Sorry.",format ["%1 appears to ignore you", _civName]];
			_result = [selectRandom _responses, []];
		} else {
			_responses = ["Screw you!","Do not even dare tell me what to do!","Do not tell me what to do.","I will not listen to you!","Sorry.",format ["%1 appears to ignore you", _civName]];
			_result = [selectRandom _responses, [["You better watch your attitude","['WatchOutThreat',1.5,2]"],["Sorry to bother you","['SorryForBother',1,1]"]]];
		};
	};

	case "CalmDownThreat": {
		if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
			//-- Succumbs to threat
			_responses = ["I am sorry.","I'm sorry, I shouldn't have said that.","Please forgive me, I do not want to cause trouble.","Oh, please forgive me.","You have my apologies."];
			_result = [selectRandom _responses, []];
		} else {
			//-- Defiant to threat
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non-Aggressive
				_responses = ["Do not talk to me like that.","I will not be bullied by you.","I will not surrender to you.","I refuse to be spoken to like that.","Your threats do not scare me."];
				_result = [selectRandom _responses, []];
			} else {
				//-- Aggressive
				_responses = ["You will not order me around!","I will not be bullied by you!","You must leave now! You are not welcome!","You better watch out.","Your threats do not scare me!"];
				_result = [selectRandom _responses, []];
			};
		};
	};

	case "SorryForBother": {
		if (_hostile) then {
			if (75 > (([_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) + ([_personality,"Patience"] call ALiVE_fnc_hashGet)) * .65) then {
				//-- Non-Aggressive
				_responses = ["It will take more than that for me to forgive you.","Thank you.","Don't worry about it.","It is ok.","You just remember that for next time we meet.","We can all be bothersome at times."];
				_result = [selectRandom _responses, []];
			} else {
				//-- Aggressive
				_responses = ["Your apologies mean nothing!","Don't waste your time apologizing.","Do you really expect that to fix the situation?","Your apologies insult me!","I will not forgive you so easily."];
				_result = [selectRandom _responses, []];
			};
		} else {
			if (random 100 > [_personality,"Patience"] call ALiVE_fnc_hashGet) then {
				//-- Doesn't like being bothered
				_responses = ["Think next time.","Learn to stop talking.","You need to learn manners.","You will not be favored here with that arrogant attitude.","You just remember that for next time we meet."];
				_result = [selectRandom _responses, []];
			} else {
				//-- Doesn't mind
				_responses = ["Thank you.","It is quite alright.","No worries brother.","You have not bothered me.","You are always welcome here.","Do not worry about it."];
				_result = [selectRandom _responses, []];
			};
		};
	};

	case "WatchOutThreat": {
		if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
			//-- Succumbs to threat
			_responses = ["My apologies.","I am sorry.","I'm sorry, I shouldn't have said that.","Please forgive me, I do not want to cause trouble.","Oh, please forgive me.","You have my apologies."];
			_result = [selectRandom _responses, []];
		} else {
			//-- Defiant to threat
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non-Aggressive
				_responses = ["Your words bring hosility.","Go bully someone else.","I will not surrender to you.","I refuse to be spoken to like that.","Your threats do not scare me."];
				_result = [selectRandom _responses, []];
			} else {
				//-- Aggressive
				_responses = ["Do not talk to me like that!","I will not be bullied by you!","You insult me? Leave now!","You better watch out.","Your threats do not scare me!"];
				_result = [selectRandom _responses, []];
			};
		};
	};

	//-- Where do you live
	case "Home": {
		if (_hostile) then {
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Aggressive
				_responses = ["No!", "Why would I give that information to you?","So you can spy on me? I don't think so.","Do you really think I am so foolish","Move along."];

				_result = selectRandom _responses;
				_result = [_result, []];
			} else {
				//-- Non Aggressive
				_responses = ["Move along.","I will not share that.","Leave me alone!","I am busy.","I do not give that information out.","Why would I tell you?","I don't trust you."];

				_result = selectRandom _responses;
				_result = [_result, [["Could you please reconsider?","['PleaseReconsider',1.5]"]]];

				[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
			};
		} else {
			if (random 100 > ([_personality,"Indecisiveness"] call ALiVE_fnc_hashGet)) then {
				//-- Gives answer
				_responses = ["I will show you!","Allow me to show you.","I will give you it's location.","It is not too far from here.","It is over there."];

				_result = format ["%1 (%2's home has been marked on the map).", selectRandom _responses, _civName];
				_result = [_result, []];

				//-- Create marker on home
				_pos = [_civInfo,"HomePosition"] call ALiVE_fnc_hashGet;

				_marker = [str _pos, _pos, "ICON", [1.2, 1.2], "ColorCivilian", (format ["%1's home", _civname]), "SpyderAddons_House"] call ALIVE_fnc_createMarker;
				_marker spawn {sleep 30; deleteMarker _this};
			} else {
				//-- Hesitant
				_responses = ["I don't know if I can tell you that..","That is very personal information.","I do not wish to give that type of information out.","I am sorry but I cannot tell you that.","Please, no personal questions."];

				_result = selectRandom _responses;
				_result = [_result, [["Could you please reconsider?","['PleaseReconsider',1.5]"]]];

				[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
			};
		};
	};

	case "PleaseReconsider": {
		if (random 100 > (([_personality,"Indecisiveness"] call ALiVE_fnc_hashGet) + 15)) then {
			//-- Reconsider question
			_questionData = [_logic,"ReconsiderQuestion"] call ALiVE_fnc_hashGet;
			[_logic,(_questionData select 0),(_questionData select 1)] call SpyderAddons_fnc_getResponses;
			_result = ["",[]];
		} else {
			//-- Will not reconsider
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non aggressive
				_responses = ["Please, do not pressure me.","I do not enjoy being pressured.","No, sorry.","I will not reconsider that question.","I have given you your answer already."];

				_result = selectRandom _responses;
				_result = [_result, []];
			} else {
				//-- Aggressive
				_responses = ["I do not think so.","Do not push it.","I have given you your answer already.","No, means no.","What does it take to get rid of you?","If I wanted to tell you, I would have told you."];

				_result = selectRandom _responses;
				_result = [_result, []];
			};
		};
	};

	case "SeenAnyIEDs": {
		private ["_pos"];
		_IEDClasses = ["ALIVE_IEDUrbanSmall_Remote_Ammo","ALIVE_IEDLandSmall_Remote_Ammo","ALIVE_IEDUrbanBig_Remote_Ammo","ALIVE_IEDLandBig_Remote_Ammo"];
		_IEDClasses append ([_logic,"IEDClasses"] call ALiVE_fnc_hashGet);

		_nearIEDs = nearestObjects [player, _IEDClasses, 700];

		if (count _nearIEDs > 0) then {
			//-- There are IED's nearby

			_pos = getPos (selectRandom _nearIEDs);

			if (_hostile) then {
				if (random 100 > [_personality,"Indecisiveness"] call ALiVE_fnc_hashGet) then {
					//-- Hostile
					_responses = ["Leave now!","I would not endanger myself for you.","I won't tell you anything.","Do you really think I would help you?","Leave me alone.","You are not welcome here!"];
					_result = selectRandom _responses;
					_result = [_result, [
						["Could you please reconsider?","['PleaseReconsider',1.5]"],
						["You need to calm down","['CalmDown',1,1]"],
						["Sorry to bother you","['SorryForBother',1,1]"]
					]];

					[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
				} else {
					//-- Civilian chokes, gives answer

					//-- Mark on map
					if (random 100 >= 50) then {
						[_logic,"markIEDLocation", [_pos,0,false,150]] call CIVILIANINTERACTION;
						_responses = ["Yes, I saw insurgents with IED equipment in a nearby area.","I saw insurgents planting IED's nearby.","Yes, insurgents target this area frequently.","I will show you an area that you should sweep for IED's.","Yes, let me show you the area where I saw them."];
					} else {
						[_logic,"markIEDLocation", [_pos,0,true]] call CIVILIANINTERACTION;
						_responses = ["Yes, I saw insurgents plant some nearby.","Yes, let me show you.","I know the location of a nearby IED, please remove it safely.","I will show you where to find one.","Yes, please take care of it."];
					};

					_result = selectRandom _responses;
					_result = format ["%1 (Possible IED location marked on map)", _result];
					_result = [_result, [["Thank you","['ThankYou',0.8,1]"]]];
				};
			} else {
				if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
					//-- Not Brave
					_responses = ["They would not like me talking to you.","I would not endanger myself for you.","I cannot tell you anything.","Do you want to get me killed!","I cannot help you, please leave.","They cannot see me talking to you."];
					_result = selectRandom _responses;
					_result = [_result, [
						["Could you please reconsider?","['PleaseReconsider',1.5]"]
					]];

					[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
				} else {
					//-- Brave, gives answer

					//-- Mark on map
					if (random 100 >= 50) then {
						[_logic,"markIEDLocation", [_pos,0,false,150]] call CIVILIANINTERACTION;
						_responses = ["Yes, I saw insurgents with IED equipment in a nearby area.","I saw insurgents planting IED's nearby.","Yes, insurgents target this area frequently.","I will show you an area that you should sweep for IED's.","Yes, let me show you the area where I saw them."];
					} else {
						[_logic,"markIEDLocation", [_pos,0,true]] call CIVILIANINTERACTION;
						_responses = ["Yes, I saw insurgents plant some nearby.","Yes, let me show you.","I know the location of a nearby IED, please remove it safely.","I will show you where to find one.","Yes, please take care of it."];
					};

					_result = selectRandom _responses;
					_result = format ["%1 (Possible IED location marked on map)", _result];
					_result = [_result, [["Thank you","['ThankYou',0.8,1]"]]];
				};
			};
		} else {
			//-- No IED's nearby
			if (_hostile) then {
				//-- Hostile
				if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
					//-- Not Brave
					_responses = ["Like I would tell you.","I would not endanger myself for you.","I cannot tell you anything.","Do you want to get me killed!","I cannot help you, please leave.","You are not welcome here!"];
					_result = selectRandom _responses;
					_result = [_result, [
						["Could you please reconsider?","['PleaseReconsider',1.5]"],
						["You need to calm down","['CalmDown',1,1]"],
						["Sorry to bother you","['SorryForBother',1,1]"]
					]];

					[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
				} else {
					//-- Brave
					if (random 100 < [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
						//-- Give false IED location

						//-- Create marker
						_nearRoads = player nearRoads 500;

						//-- Mark on map
						if (count _nearRoads > 0) then {
							_pos = getPos (selectRandom _nearRoads);
							[_logic,"markIEDLocation", [_pos,0,false,150]] call CIVILIANINTERACTION;

							_responses = ["Insurgents planted one on a nearby road.","There is one on the road over there.","Yes, I hear there was one nearby.","Insurgents like to target this area, you might want to sweep it.","Yes, I will show you.","I know the location of one nearby."];
						} else {
							_pos = getPos player;
							[_logic,"markIEDLocation", [_pos,0,false,150]] call CIVILIANINTERACTION;

							_responses = ["There might be a few around here.","I've heard that one might be near here.","This area is always a target.","You might want to give it a sweep, there could be IED's nearby.","I saw insurgents planting IED's somewhere nearby.","Yes, I can't remember where, but there are some nearby."];
						};

						_result = selectRandom _responses;
						_result = format ["%1 (Possible IED location marked on map)", _result];
						_result = [_result, [["Thank you","['ThankYou',0.8,1]"]]];
					} else {
						_responses = ["Sorry, I cannot help you.","I would not endanger myself for you.","I cannot tell you anything.","Do you want to get me killed!","I cannot help you, please leave.","You are not welcome here!"];
						_result = selectRandom _responses;
						_result = [_result, [["Could you please reconsider?","['PleaseReconsider',1.5]"]]];

						[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
					};
				};
			} else {
				//-- Not hostile
				if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
					//-- Not Brave
					_responses = ["They would not like me talking to you.","I would not endanger myself for you.","I cannot tell you anything.","Do you want to get me killed!","I cannot help you, please leave.","They cannot see me talking to you."];
					_result = selectRandom _responses;
					_result = [_result, [["Could you please reconsider?","['PleaseReconsider',1.5]"]]];

					[_logic,"ReconsiderQuestion",[_operation,_args]] call ALiVE_fnc_hashSet;
				} else {
					//-- Brave
					_responses = ["There are no IED's nearby.","They have not planted any here.","Thankfully, no.","We are safe from IED's here.","You are safe from IED's in this area."];
					_result = selectRandom _responses;
					_result = [_result, [["Thank you","['ThankYou',0.8,1]"]]];
				};
			};
		};

	};

	case "ThankYou": {
		if (random 100 > [_personality,"Patience"] call ALiVE_fnc_hashGet) then {
			//-- Not patient
			_responses = ["You are welcome.","Whatever.","Please leave me alone now.","Is that all?","I am busy, is that all you need?"];

			_result = selectRandom _responses;
			_result = [_result, []];
		} else {
			//-- Patient
			_responses = ["You are most welcome.","You are welcome.","It is my pleasure.","It is no problem.","I am happy to help.","Let me know if you need anything else."];

			_result = selectRandom _responses;
			_result = [_result, []];
		};
	};

	

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};