#define SIGNAL_MODEL_CASUAL        0
#define SIGNAL_MODEL_LOS_SIMPLE    1
#define SIGNAL_MODEL_LOS_MULTIPATH 2
#define SIGNAL_MODEL_ITM           3
#define SIGNAL_MODEL_ITWOM         4  // This model is for now disabled.

#define SIGNAL_ENUMS SIGNAL_MODEL_CASUAL, SIGNAL_MODEL_LOS_SIMPLE, SIGNAL_MODEL_LOS_MULTIPATH, SIGNAL_MODEL_ITM
#define SIGNAL_NAMES "Arcade", "LOS Simple", "LOS Multipath", "Longley-Rice (ITM) Experimental"

{
    private _compile = compileFinal preprocessFileLineNumbers (_x # 1);
    missionNamespace setVariable[(_x # 0), _compile];
} forEach
[
	["diw_acre_fnc_createRadioJammer","scripts\diwako\fn_createRadioJammer.sqf"],
	["diw_acre_fnc_getPowerAfterJamming","scripts\diwako\fn_getPowerAfterJamming.sqf"],
	["diw_acre_fnc_addJammerToPlayer","scripts\diwako\fn_addJammerToPlayer.sqf"]
];

if(!hasInterface) exitWith {};

_customSignalFunc = {
	params ["_f", "_mW", "_receiverClass", "_transmitterClass"];

	private _count = missionNamespace getVariable [_transmitterClass + "_running_count", 0];
	if (_count == 0) then {
		private _senderStrength = 1;
		private _sender = "null";
		private _mWnew = _mW;

		_sender = [_transmitterClass] call acre_sys_components_fnc_findAntenna select 0 select 1;

		if (!isNil "_sender" && {!isNull _sender}) then {
			_senderStrength = (_sender getVariable ["acre_send_power",1]);
			_mWnew = [_sender, _mWnew, _f] call diw_acre_fnc_getPowerAfterJamming;
		} else {
			_sender = "nilled";
		};
		_mWnew = [acre_player, _mWnew, _f] call diw_acre_fnc_getPowerAfterJamming;

		_mWnew = _mWnew * _senderStrength;

		_receiverStrength = acre_player getVariable ["acre_receive_power",1];

		_mWnew = _mWnew * _receiverStrength;

		// debug, you can leave that commented out
		// _debug = ("Singal: " + _transmitterClass + " to " + _receiverClass + " | F: " + (str _f) + ", mW: " + (str _mW) + " | SenderPower: " + (str _senderStrength) + ", ReceiverPower: " + (str _receiverStrength) + ", NewmW: " + (str _mWnew) + " | Sender: " + (str _sender) );
		// if(!(_sender isEqualType "")) then {
		// 	_debug = _debug + " | Distance: " + (str (acre_player distance _sender) );
		// };
		// systemChat _debug;

		/*==== begin ACRE2 base logic ====*/

		private _rxAntennas = [_receiverClass] call acre_sys_components_fnc_findAntenna;
		private _txAntennas = [_transmitterClass] call acre_sys_components_fnc_findAntenna;

		{
			private _txAntenna = _x;
			{
				private _rxAntenna = _x;
				private _model = acre_sys_signal_signalModel;

				// Make sure ITWOM is not used for the moment
				if (_model > SIGNAL_MODEL_ITWOM || {_model < SIGNAL_MODEL_CASUAL}) then {
					_model = SIGNAL_MODEL_LOS_MULTIPATH;  // Default to LOS Multipath if the model is out of range
					acre_sys_signal_signalModel = _model;           // And make sure we do not use an invalid mode next time
				};

				_count = _count + 1;
				private _id = format ["%1_%2_%3_%4", _transmitterClass, (_txAntenna select 0), _receiverClass, (_rxAntenna select 0)];
				[
					"process_signal",
					[
						_model,
						_id,
						(_txAntenna select 2),
						(_txAntenna select 3),
						(_txAntenna select 0),
						(_rxAntenna select 2),
						(_rxAntenna select 3),
						(_rxAntenna select 0),
						_f,
						_mWnew, // custom radio power
						acre_sys_signal_terrainScaling,
						diag_tickTime,
						ACRE_SIGNAL_DEBUGGING,
						acre_sys_signal_omnidirectionalRadios
					],
					2,
					acre_sys_signal_fnc_handleSignalReturn,
					[_transmitterClass, _receiverClass]
				] call acre_sys_core_fnc_callExt;
			} forEach _rxAntennas;
		} forEach _txAntennas;
		missionNamespace setVariable [_transmitterClass + "_running_count", _count];
	};

	private _maxSignal = missionNamespace getVariable [_transmitterClass + "_best_signal", -992];
	private _Px = missionNamespace getVariable [_transmitterClass + "_best_px", 0];

	if (ACRE_SIGNAL_DEBUGGING > 0) then {
		private _signalTrace = missionNamespace getVariable [_transmitterClass + "_signal_trace", []];
		_signalTrace pushBack _maxSignal;
		missionNamespace setVariable [_transmitterClass + "_signal_trace", _signalTrace];
	};

	[_Px, _maxSignal]
};
[_customSignalFunc] call acre_api_fnc_setCustomSignalFunc;