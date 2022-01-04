init()
{
	preCacheStatusIcon("statusicon_afk");

	level.afkplus = [];

	// time in seconds for which player will be warned to move
	level.afkplus["warningtime"] = 5;

	// time in seconds for which player will be switched to team_none
	level.afkplus["forcespectime"] = 10;

	// time in mins for which player will be kicked for being AFK
	level.afkplus["forcekicktime"] = 5;

	waittime = (level.afkplus["forcespectime"] - level.afkplus["warningtime"]);

	level.afkplus["warntext"] = "You appear to be AFK\nYou got ^3" + waittime + "seconds^7 to move";

	if( isDefined(level.on) )
	{
		[[level.on]]( "spawned", ::AFKMonitor );
		[[level.on]]( "connected", ::roundBasedKicker );
		[[level.on]]( "joined_team", ::noLongerAFK );
		[[level.on]]( "joined_spectators", ::noLongerAFK );
		[[level.on]]( "joined_spectators", ::noLongerAFK );
	}
	else thread onPlayerConnect();
}

onPlayerConnect()
{
	level endon("restarting");
	level endon("game_ended");
	while(true)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
		player thread roundBasedKicker();
		player thread onPlayerJoinedSpectators();
		player thread onPlayerJoinedTeam();
	}
}

onPlayerSpawned()
{
	level endon("restarting");
	level endon("game_ended");
	
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "spawned_player" );
		self thread AFKMonitor();
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
		self thread noLongerAFK();
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
		self thread noLongerAFK();
	}
}

AFKMonitor()
{
	level endon("restarting");
	level endon("game_ended");
    self endon("disconnect");
	self endon("joined_spectators");

	self.pers["idletime"] = 0;
	while( isAlive(self) )
	{
		ori = self.origin;
		wait 1;
		if( isDefined(self) && isAlive(self) && self.sessionteam != "spectator" )
		{
			if( self.origin == ori )
				self.pers["idletime"]++;
			else self.pers["idletime"] = 0;

			//TO-DO: diff hud than iprintlnbold.
			if( self.pers["idletime"] == level.afkplus["warningtime"] )
				self iPrintlnBOld(level.afkplus["warntext"]);

			if( self.pers["idletime"] >= level.afkplus["forcespectime"] )
			{
				self thread justWentAFK();
				return;
			}
		}
		else self.pers["idletime"] = 0;
	}
}

roundBasedKicker()
{
	level endon("restarting");
	level endon("game_ended");
	
	self endon("disconnect");

	if(!isDefined(self.pers["isafk"]))
		self.pers["isafk"] = 1;
	
	if( !isDefined( self.pers["team"] ) || self.pers["isafk"] || self.pers["team"] == "none" )
		self.statusicon = "statusicon_afk";

	if( !isDefined(self.slot) )
		self.slot = self getEntityNumber();

	wait 5;
	
	if( !isDefined( self.pers["team"] ) || self.pers["isafk"] || self.pers["team"] == "none" )
		self.statusicon = "statusicon_afk";

	if( self.pers["isafk"] > 0)
	{
		if(self.pers["isafk"]>3)
			exec("kick " + self.slot + " Reason: AFK for Too Long.");
		else
		{
			self.pers["isafk"]++;

			// TO-DO: diff hud than iprintlnbold.
			// self iPrintlnBOld("You will be kicked for being AFK");
		}
	}
}

justWentAFK()
{
	self endon("disconnect");

	self maps\mp\gametypes\_globallogic::closeMenus();
	self.switching_teams = true;
	self.joining_team = "spectator";
	self.leaving_team = self.pers["team"];

	self.pers["isafk"] = 1;
	self.statusIcon = "statusicon_afk";
	self.pers["class"] = undefined;
	self.class = undefined;
	self.pers["team"] = "none";
	self.team = "none";
	self setClientDvar( "loadout_curclass", "" );
	
	self.sessionteam = "none";
	self thread [[level.spawnSpectator]]( self.origin, self.angles );
	obituary( self, self, "knife_mp", "MOD_CRUSH" ); 
	self setclientdvar( "g_scriptMainMenu", game["menu_team"] );

	self notify("joined_spectators");

	self thread timeBasedKicker();
}

timeBasedKicker()
{
	level endon("restarting");
	level endon("game_ended");
	
	self endon("disconnect");

	time = 0;
	reqTime = int( level.afkplus["forcekicktime"] * 60 );

	while( isDefined(self) && self.pers["isafk"] > 0 )
	{
		if( time >= reqTime )
		{
			exec("kick " + self.slot + " Reason: AFK for Too Long.");
			return;
		}		
		wait 1;
		time++;
	}
}

noLongerAFK()
{
	self.pers["isafk"] = 0;
}