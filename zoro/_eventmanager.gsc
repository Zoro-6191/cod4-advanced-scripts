init()
{
	if(!isDefined( level.event )) //Singleton
	{
		level.event = [];
		level.event[ "connecting" ] = [];
		level.event[ "connected" ] = [];
		level.event[ "death" ] = [];
		level.event[ "spawned" ] = [];
		level.event[ "menu_response" ] = [];
		level.event[ "joined_team" ] = [];
		level.event[ "joined_spectators" ] = [];
		
		level.on = ::addEvent;

		thread onPlayerConnecting();
		thread onPlayerConnected();
	}
}

addEvent( event, process )
{
	if( !isdefined( level.event[ event ] ) || !isdefined( process ))
		return;
	level.event[ event ][ level.event[ event ].size ] = process;
}

onPlayerConnecting()
{
	level endon("restarting");
	level endon("game_ended");
	while(1)
	{
		level waittill( "connecting", player );
		for( i=0; i<level.event[ "connecting" ].size; i++ )
			player thread [[level.event[ "connecting" ][i]]]();
	}	
}

onPlayerConnected()
{
	level endon("restarting");
	level endon("game_ended");
	while(1)
	{
		level waittill( "connected", player );

		player thread onPlayerSpawned();
		player thread onPlayerDeath();
		player thread onPlayerJoinedSpectators();
		player thread onPlayerJoinedTeam();
		player thread onPlayerMenuResponse();
		for( i=0; i<level.event[ "connected" ].size; i++ )
			player thread [[level.event[ "connected" ][i]]]();
	}	
}

onPlayerSpawned()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "spawned_player" );
		for( i=0; i<level.event[ "spawned" ].size; i++ )
			self thread [[level.event[ "spawned" ][i]]]();
	}
}

onPlayerDeath()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "death" );
		for( i=0; i<level.event[ "death" ].size; i++ )
			self thread [[level.event[ "death" ][i]]]();
	}
}

onPlayerJoinedTeam()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "joined_team" );
		for( i=0; i<level.event[ "joined_team" ].size; i++ )
			self thread [[level.event[ "joined_team" ][i]]]();
	}
}

onPlayerMenuResponse()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );
	while(1)
	{
		self waittill( "menuresponse", menu, response );
		for( i=0; i<level.event[ "menu_response" ].size; i++ )
			self thread [[level.event[ "menu_response" ][i]]]( menu, response );
	}
}

onPlayerJoinedSpectators()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "joined_spectators" );
		for( i=0; i<level.event[ "joined_spectators" ].size; i++ )
			self thread [[level.event[ "joined_spectators" ][i]]]();
	}
}

