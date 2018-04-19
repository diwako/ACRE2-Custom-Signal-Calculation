// call this to activate the custom signal function!
[] call compile preProcessFileLineNumbers "scripts\diwako\acre_custom_signal.sqf";

/*==== Examples below ====*/

// example to boost sending and receiving power on mission start
player setVariable ["acre_send_power", 1000, true];
player setVariable ["acre_receive_power", 1000, true];

// example to make it impossible for unit to receive any radio comms while still able to talk over comms
player setVariable ["acre_send_power", 1, true];
player setVariable ["acre_receive_power", 0, true];

// example to make it impossible to talk over radio but still be able to hear radio comms
player setVariable ["acre_send_power", 0, true];
player setVariable ["acre_receive_power", 1, true];

// example to degrade signal so badly that being 200 meters away is already completely garbled on the 343
player setVariable ["acre_send_power", 0.00001, true];
player setVariable ["acre_receive_power", 0.00001, true];