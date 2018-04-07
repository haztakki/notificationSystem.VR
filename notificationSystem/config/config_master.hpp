/*
	Code written by Haz
*/

class config_master
{
	// 0 = FALSE
	// 1 = TRUE
	debugMode = 0; // If set to 1 then debug mode will be enabled (used for DEV purposes only)
	defaultTitleTextColour[] = {1, 1, 1, 1}; // Default title text colour (used if you don't pass custom argument to function)
	defaultTitleBgColour[] = {"(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.13])", "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.54])", "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.21])", 1}; // Default title text colour (used if you don't pass custom argument to function)
	maxNotificationsOnScreen = 4; // Maximum number of notifications to show on screen at once (4 is the currently the max - if you try to set higher then it will revert to 3)
	positionOnScreen = "LEFT"; // Where to position notifications on the screen - "LEFT" or "RIGHT"
	expandShrinkToggle = 0; // Enable player to expand/shrink notifications
	showNotificationsQueue = 1; // Show notification queue count in bottom left corner of screen
};