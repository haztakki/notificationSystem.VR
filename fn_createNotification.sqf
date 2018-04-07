scriptName "fn_createNotification";

/*
	Code written by Haz
*/

#define __FILENAME "fn_createNotification.sqf"

if (isDedicated || !hasInterface) exitWith {};

disableSerialization;

params ["_notificationTitle", "_notificationMessage"];

_display = uiNamespace getVariable ["disp_notifications", findDisplay 46];

if (isNil "notificationsIndex") then {notificationsIndex = 0;};
if (isNil "notificationsHiddenIndex") then {notificationsHiddenIndex = 0;};

private _myIndex = notificationsIndex;
notificationsIndex = notificationsIndex + 1;

waitUntil {_myIndex - notificationsHiddenIndex < 3};
private _position = _myIndex % 3;

_title = _display ctrlCreate ["RscTitle", -1];
_title ctrlSetPosition
[
	-1 * safezoneW + safezoneX,
	(0.209 + (_position * 0.16)) * safezoneH + safezoneY,
	0.2125 * safezoneW,
	0.0255 * safezoneH
];
_title ctrlSetText _notificationTitle;
_title ctrlSetBackgroundColor (["(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.13])", "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.54])", "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.21])", 1] call BIS_fnc_colorConfigToRGBA);
_title ctrlCommit 0;

_background = _display ctrlCreate ["RscPicture", -1];
_background ctrlSetPosition
[
	-1 * safezoneW + safezoneX,
	(0.24 + (_position * 0.16)) * safezoneH + safezoneY,
	0.2125 * safezoneW,
	0.12 * safezoneH
];
_background ctrlSetText "#(argb,8,8,3)color(0,0,0,0.75)";
_background ctrlCommit 0;

_notification = _display ctrlCreate ["RscStructuredText", -1];
_notification ctrlSetPosition
[
	-1 * safezoneW + safezoneX,
	(0.24 + (_position * 0.16)) * safezoneH + safezoneY,
	0.2125 * safezoneW,
	0.12 * safezoneH
];
_notification ctrlSetStructuredText parseText _notificationMessage;
_notification ctrlCommit 0;

_controls = [_title, _background, _notification];

{
	_position = ctrlPosition _x;
	_position set [0, (0.0125 * safezoneW + safezoneX)];
	_x ctrlSetPosition _position;
	_x ctrlCommit 1;
} forEach _controls;

sleep 7;

waitUntil {_myIndex - notificationsHiddenIndex == 0};

{
	_position = ctrlPosition _x;
	_position set [0, (-1 * safezoneW + safezoneX)];
	_x ctrlSetPosition _position;
	_x ctrlCommit 1;
} forEach _controls;

sleep 1;

{
	ctrlDelete _x;
} forEach _controls;

notificationsHiddenIndex = notificationsHiddenIndex + 1;