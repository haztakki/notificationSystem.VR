# Notification System for ArmA III

![](https://i.imgur.com/ZBVeGta.jpg)

## Installation

1) Copy notificationSystem folder to your mission root
2) Copy contents from init.sqf to your mission
3) Copy contents from description.ext to your mission (if you already have class RscTitles then please only copy the #include part inside your existing RscTitles)
4) Configure config options in notificationSystem\config\config_master
5) Execute function where ever needed

## Usage examples

```sqf
["New notification", "This is a notification!", [0, 0, 0, 1], [1, 1, 0, 1]] spawn Haz_fnc_createNotification;
["<img size='1' color='#ffffff' image='\A3\Ui_f\data\GUI\Cfg\Ranks\private_gs.paa'/> New notification", "This is a notification!"] spawn Haz_fnc_createNotification;
["<img size='1' align='right' color='#ffffff' image='\A3\Ui_f\data\GUI\Cfg\Ranks\private_gs.paa'/> New notification", "This is a notification!"] spawn Haz_fnc_createNotification;
["<img size='1' align='right' color='#ffffff' image='\A3\Ui_f\data\GUI\Cfg\Ranks\private_gs.paa'/> Rank Promotion", "Good work!", [1, 1, 1, 1], [0.12, 0.63, 0.94, 1]] spawn Haz_fnc_createNotification;
```

## Config options

```
0 = FALSE
1 = TRUE
```

```
debugMode = 0; // If set to 1 then debug mode will be enabled (used for DEV purposes only)
defaultTitleTextColour[] = {1, 1, 1, 1}; // Default title text colour (used if you don't pass custom argument to function)
defaultTitleBgColour[] = {"(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.13])", "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.54])", "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.21])", 1}; // Default title text colour (used if you don't pass custom argument to function)
maxNotificationsOnScreen = 4; // Maximum number of notifications to show on screen at once (4 is the currently the max - if you try to set higher then it will revert to 3)
positionOnScreen = "LEFT"; // Where to position notifications on the screen - "LEFT" or "RIGHT"
expandShrinkToggle = 1; // Enable player to expand/shrink notifications
showNotificationsQueue = 1; // Show notification queue count in bottom left corner of screen
```

## Changelog

* 0.3.1
	* Fixed expand/shrink positioning when using RIGHT config option (thanks to Tankbuster for reporting)
	* Added config option for expand/shrink key
	* Minor code tweaks
* 0.3
	* Added load save fix (thanks AZCoder)
	* Added functionality for the inactive customisable config options that were added last version (for example: positionOnScreen)
	* Fixed the bug with the key press toggle (expand/shrink control elements)
	* Fixed queue counter
* 0.2
	* Added customisable config options
	* Added key press toggle which expands/shrinks the control elements out to show more/less information (inspired by BIS_fnc_advHint)
	* Added RscStructuredText styling support for title
	* Added option to pass arguments directly to the function
	* Add text which shows total number of notifications in the queue
* 0.1
	* Initital release

## Known issues

* Key press toggle - Issue: https://youtu.be/-J8_dImuIXk

## Credits

Haz

## Contributors

Thank you to everyone who provided suggestions, bug-reports and overall feedback!<br>
Sa-Matra<br>
AZCoder - Load save fix
Tankbuster - Bug report

## Notes

If you change values in config_master then you may need to reload the mission (not just restart). Please do not remove my name from file(s) - Give credit where due!

## Useful information

https://community.bistudio.com/wiki/DIK_KeyCodes
https://community.bistudio.com/wiki/Category:Key_Actions