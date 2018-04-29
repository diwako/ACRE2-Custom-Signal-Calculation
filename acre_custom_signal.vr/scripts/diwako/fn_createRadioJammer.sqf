if(!isServer) exitWith {};

params[["_obj",objNull],["_power",1000],["_frequencies",[ [0,999999] ]],["_effectiveRange",1000],["_falloffArea",500]];

if(isNull _obj) exitWith {};
if(!isNull (_obj getVariable ["jammer_zone", objNull])) exitWith {hintC "Jammer cannot be created ontop of another jammer!"};
private _pos = getPosATL _obj;
_trg = createTrigger ["EmptyDetector", _pos];
_trg setPosATL _pos;
_trg setVariable ["jammer_active", true, true];
_trg setVariable ["jammer_object", _obj, true];
_trg setVariable ["jammer_effective_radius", _effectiveRange, true];
_trg setVariable ["jammer_falloff_radius", _falloffArea, true];
_trg setVariable ["jammer_power", _power, true];
_trg setVariable ["jammer_frequencies", _frequencies, true];
private _radius = _effectiveRange + _falloffArea;
[_trg, [_radius, _radius, 0, false, _radius]] remoteExec ["setTriggerArea",0,_trg];
[_trg, ["ANY", "PRESENT", true]] remoteExec ["setTriggerActivation",0,_trg];
[_trg, ["this && thisTrigger getVariable ['jammer_active',false] && alive (thisTrigger getVariable ['jammer_object',objNull]) && acre_player in thisList", "[thisTrigger, acre_player, true] call diw_acre_fnc_addJammerToPlayer", "[thisTrigger, acre_player, false] call diw_acre_fnc_addJammerToPlayer"]] remoteExec ["setTriggerStatements", 0, _trg];

_obj setVariable ["jammer_zone", _trg, true];
_obj addEventHandler ["Killed", {
	params ["_obj", "_killer", "_instigator", "_useEffects"];
	deleteVehicle (_obj getVariable ["jammer_zone", objNull]);
}];
_trg