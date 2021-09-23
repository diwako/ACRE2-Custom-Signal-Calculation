/*==== Examples below ====*/
/*
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
*/

/*
// example for setting up a radio jammer zone
// Params:
// 1: object which is jamming
// 2: Jamming strength in mW
// 3: Array of frequencies jammed, Array in array possible, notation is [start frequency, end frequency]
// 4: Effective zone, distance to jammer which fully applies the full jamming strength
// 5: Falloff zone, zone in which units are still affected, but the strengths gets linear worse of the jammer
*/
[antenna, 100, [[0,9000],9002], 50, 10] call diw_acre_fnc_createRadioJammer;