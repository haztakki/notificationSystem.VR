scriptName "fn_createNotification";

/*
	Code written by Haz
*/

#define __FILENAME "fn_createNotification.sqf"

if (isDedicated || !hasInterface) exitWith {};

#include "..\macros.hpp"

#define pixelScale 0.50
#define GRID_W (pixelW * pixelGrid * pixelScale)
#define GRID_H (pixelH * pixelGrid * pixelScale)

#define UI_GRID_X (0.5)
#define UI_GRID_Y (0.5)
#define UI_GRID_W (2.5 * pixelW * pixelGrid)
#define UI_GRID_H (2.5 * pixelH * pixelGrid)

#define CUI_GRID_X (0.5)
#define CUI_GRID_Y (0.5)
#define CUI_GRID_W UI_GRID_W
#define CUI_GRID_H UI_GRID_H

#define H_NOTIFICATION (6.1 * UI_GRID_H)
#define W_NOTIFICATION (0.25 * safeZoneW)
#define X_NOTIFICATION ([safeZoneX + 1 * UI_GRID_W, safeZoneX + safeZoneW - W_NOTIFICATION - 1 * UI_GRID_W] select (SCREEN_POS isEqualTo "RIGHT"))
#define MAX_W_NOTIFICATION (safeZoneW/2 - 1 * UI_GRID_W)
#define Y_ORIGIN (0.5 - 2 * H_NOTIFICATION - 0.5 * UI_GRID_H)

disableSerialization;

// ["create"] call Haz_fnc_initNotification;
// ["My title", "my message"] call Haz_fnc_createNotification;
// ["create", ["title", "message", "textColour", "bgColour"]] call Haz_fnc_createNotification;
// ["", ["title", "message", "textColour", "bgColour"]] call Haz_fnc_createNotification;

if (_this select 1 isEqualType "") exitWith {
	["create", _this] spawn Haz_fnc_createNotification;
}; 

params ["_mode", "_this"];

switch _mode do {
	case "create" : {
		params
		[
			["_notificationTitle", localize "STR_notification_title_example"],
			["_notificationMessage", localize "STR_notification_message_example"],
			["_titleTextColour", TITLE_TEXT_COLOUR],
			["_titleBgColour", TITLE_BG_COLOUR call BIS_fnc_colorConfigToRGBA]
		];
		private _display = uiNamespace getVariable ["disp_notifications", displayNull];
		private _posW = 10 * UI_GRID_W;
		private _posWExpanded = safeZoneW - 2 * UI_GRID_W;
		private _posX = if (SCREEN_POS isEqualTo "LEFT") then {safeZoneX + 1 * UI_GRID_W} else {safeZoneX + safeZoneW - 1 * UI_GRID_W - _posW};
		_display setVariable ["expanded", false];
		_fnc_autoExpand = {
			private _display = uiNamespace getVariable ["disp_notifications", displayNull];
			if !(_display getVariable ["expanded", false]) then {_display setVariable ["expanded", true]} else {_display setVariable ["expanded", false];};
			{
				private _position = ctrlPosition _x;
				_position set [0, safeZoneX + 1 * UI_GRID_W];
				_position set [2, MAX_W_NOTIFICATION];
				_x ctrlSetPosition _position;
				_x ctrlCommit EXPAND_DISPLAY_TIME / 10;
			} forEach (allControls _display);
		};
		if (EXPAND_SHRINK_TOGGLE isEqualTo 1) then
		{
			expandKeyEH = findDisplay 46 displayAddEventHandler ["KeyDown",
			{
				["keyDown", _this] call Haz_fnc_createNotification;
			}];
		};
		if (isNil "notificationsIndex") then {notificationsIndex = 0;};
		if (isNil "notificationsHiddenIndex") then {notificationsHiddenIndex = 0;};
		_myIndex = notificationsIndex;
		notificationsIndex = notificationsIndex + 1;
		_numNotifications = if (MAX_SHOWN_NOTIFICATIONS > 4) then {3} else {MAX_SHOWN_NOTIFICATIONS};
		if (SHOW_QUEUE_COUNT isEqualTo 1) then
		{
			(_display displayCtrl 10) ctrlSetText format [localize "STR_notification_queueCount", if (notificationsIndex > MAX_SHOWN_NOTIFICATIONS) then {(notificationsIndex - MAX_SHOWN_NOTIFICATIONS)} else {0}];
		};
		waitUntil {_myIndex - notificationsHiddenIndex < _numNotifications};
		_position = _myIndex % _numNotifications;
		_safeZoneX = if (SCREEN_POS isEqualTo "LEFT") then {(-1 * safeZoneW + safeZoneX)} else {(2 * safeZoneW + safeZoneX)};
		_title = _display ctrlCreate ["RscStructuredText", 10];
		_title ctrlSetPosition
		[
			_safeZoneX,
			Y_ORIGIN + _position * H_NOTIFICATION,
			W_NOTIFICATION,
			1 * UI_GRID_H
		];
		_title ctrlSetStructuredText parseText _notificationTitle;
		_title ctrlSetTextColor _titleTextColour;
		_title ctrlSetBackgroundColor _titleBgColour;
		_title ctrlCommit 0;
		_background = _display ctrlCreate ["RscPicture", 20];
		_background ctrlSetPosition
		[
			_safeZoneX,
			Y_ORIGIN + 1.1 * UI_GRID_H + _position * H_NOTIFICATION,
			W_NOTIFICATION,
			4 * UI_GRID_H
		];
		_background ctrlSetText "#(argb,8,8,3)color(0,0,0,0.75)";
		_background ctrlCommit 0;
		_notification = _display ctrlCreate ["RscStructuredText", 30];
		_notification ctrlSetPosition (ctrlPosition _background);
		_notification ctrlSetStructuredText parseText _notificationMessage;
		_notification ctrlCommit 0;
		_controls = [_title, _background, _notification];
		if (ctrlTextHeight _notification > ctrlPosition _notification select 3) then {
			//[] spawn _fnc_autoExpand;
			["toggleExpand"] call Haz_fnc_createNotification;
		};
		{
			_position = ctrlPosition _x;
			_position set [0, X_NOTIFICATION];
			_x ctrlSetPosition _position;
			_x ctrlCommit 1;
		} forEach _controls;
		sleep 7;
		waitUntil {_myIndex - notificationsHiddenIndex == 0};
		_sleep = if (_display getVariable ["expanded", false]) then {5} else {1};
		{_x ctrlSetPositionW W_NOTIFICATION; _x ctrlCommit EXPAND_DISPLAY_TIME / 10;} forEach _controls;
		sleep EXPAND_DISPLAY_TIME;
		{
			_position = ctrlPosition _x;
			_position set [0, (_safeZoneX)];
			_x ctrlSetPosition _position;
			_x ctrlCommit 1;
		} forEach _controls;
		sleep 1;
		{
			ctrlDelete _x;
		} forEach _controls;
		notificationsHiddenIndex = notificationsHiddenIndex + 1;
		if (SHOW_QUEUE_COUNT isEqualTo 1) then
		{
			(_display displayCtrl 10) ctrlSetText format [localize "STR_notification_queueCount", if (notificationsIndex > MAX_SHOWN_NOTIFICATIONS) then {(notificationsIndex - MAX_SHOWN_NOTIFICATIONS) - 1} else {0}];
		};
	};
	case "keyDown" : {
		params ["", "_key"];
		_display = uiNamespace getVariable "disp_notifications";
		hintSilent "Hello world";
		_toggleKey = if (isText EXPAND_SHRINK_KEY) then {actionKeys (getText EXPAND_SHRINK_KEY) select 0} else {getNumber EXPAND_SHRINK_KEY};
		if (_key isEqualTo _toggleKey) then
		{
			["toggleExpand"] call Haz_fnc_createNotification;
			true
		};
	};
	case "toggleExpand" : {
		
		private _display = uiNamespace getVariable "disp_notifications";
		private _expanded = _display getVariable ["expanded", false];
		_display setVariable ["expanded",!_expanded];
		{	
			private _cPos = ctrlPosition _x;
			private _xPos = _cPos select 0;
			if (SCREEN_POS isEqualTo "RIGHT") then {
				_xPos = [X_NOTIFICATION, safezoneW / 2] select _expanded;
			};
			_x ctrlSetPosition [
				_xPos,
				_cPos select 1,
				[safeZoneW / 2 - 1 * UI_GRID_W, W_NOTIFICATION] select _expanded,
				_cPos select 3
			];
			_x ctrlCommit (EXPAND_DISPLAY_TIME / 10);
		} forEach allControls _display;
	};
};