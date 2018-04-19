# ACRE2 Custom Signal Calculation
This script adds an additional layer to ACRE2’s signal calculation which allows to modify the output power and receive power of radios on the fly.

With this script it is possible to either boost or jam a signal from any specific unit. The script will allow setting custom modifiers to units to modify the unit’s radios receiving and sending power.

Just copy the script "acre_custom_signal.sqf" into your mission folder and call it within initPlayerLocal.sqf with

`[] call compile preProcessFileLineNumbers "scripts\diwako\acre_custom_signal.sqf";`\
With this the custom signal calculation is active!

You will *not be able* to boost your radio signal across the whole map with this! ACRE2's algorithm has some hard limits for radios!

__Examples:__ \
Boost sending and receiving power
```sqf
player setVariable ["acre_send_power", 1000];
player setVariable ["acre_receive_power", 1000];
```

Make it impossible for the unit to receive any radio comms while still able to talk over comms
```sqf
player setVariable ["acre_send_power", 1];
player setVariable ["acre_receive_power", 0];
```

Make it impossible to talk over radio but still be able to hear radio comms
```sqf
player setVariable ["acre_send_power", 0];
player setVariable ["acre_receive_power", 1];
```

Degrade signal so badly that being 200 meters away is already completely garbled on the 343
```sqf
player setVariable ["acre_send_power", 0.00001];
player setVariable ["acre_receive_power", 0.00001];
```