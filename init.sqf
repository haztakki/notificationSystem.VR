"layer_notifications" cutRsc ["rsc_notifications", "PLAIN"];

addMissionEventHandler ["Loaded",
{
	[] spawn
	{
		sleep 2;
		"layer_notifications" cutRsc ["rsc_notifications", "PLAIN"];
	};
}];