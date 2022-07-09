# ACRE2 Custom Signal Calculation

This script adds an additional layer to ACRE2's signal calculation which allows to modify the output power and receive power of radios on the fly.

With this script it is possible to either boost or jam a signal from any specific unit. The script will allow setting custom modifiers to units to modify the unit’s radios receiving and sending power.

Just copy the script folder into your mission folder and edit your `description.ext`'s `CfgFunctions` class like in the example.\
With this the custom signal calculation is active!

You will _not be able_ to boost your radio signal across the whole map with this! ACRE2's algorithm has some hard limits for radios!

You will need to set your ACRE's signal model to Arcade or LOS Multipath. LOS Simple will not work! LOS Multipath is ACRE's default signal model.

## Examples

### Boosting and crippling radios

Boost sending and receiving power

```sqf
player setVariable ["acre_send_power", 1000, true];
player setVariable ["acre_receive_power", 1000, true];
```

Make it impossible for the unit to receive any radio comms while still able to talk over comms

```sqf
player setVariable ["acre_send_power", 1, true];
player setVariable ["acre_receive_power", 0, true];
```

Make it impossible to talk over radio but still be able to hear radio comms

```sqf
player setVariable ["acre_send_power", 0, true];
player setVariable ["acre_receive_power", 1, true];
```

Degrade signal so badly that being 200 meters away is already completely garbled on the 343

```sqf
player setVariable ["acre_send_power", 0.00001, true];
player setVariable ["acre_receive_power", 0.00001, true];
```

### Radio jammers

Add radio jamming to an object. If the jamming object is destroyed the jamming from it will stop. Moving objects are possible!

```sqf
/*
 * example for setting up a radio jammer zone
 * Must be called on server!
 *
 * Params:
 * 1: object which is jamming
 * 2: Jamming strength in mW (see included "radio frequencies and power.txt" for frequencies and sending power)
 * 3: Array of frequencies jammed, Array in array possible, notation is [start frequency, end frequency]
 * 4: Effective zone, distance to jammer which fully applies the full jamming strength
 * 5: Falloff zone, zone in which units are still affected, but the strengths gets linear worse of the jammer
*/
[antenna, 100, [[0,9000],9002], 50, 10] call diw_acre_fnc_createRadioJammer;
```
