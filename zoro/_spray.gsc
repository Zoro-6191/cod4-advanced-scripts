#include maps\mp\_utility;

init()
{
	preCacheMenu("spray");
	level.sprayInfo = [];
	level.numSprays = 0;
	
	for( idx = 1; isdefined( tableLookup( "mp/sprayTable.csv", 0, idx, 0 ) ) && tableLookup( "mp/sprayTable.csv", 0, idx, 0 ) != ""; idx++ )
	{
		id = int( tableLookup( "mp/sprayTable.csv", 0, idx, 1 ) );
		level.sprayInfo[id]["effect"] = loadFx( tableLookup( "mp/sprayTable.csv", 0, idx, 2 ) );
		level.numSprays++;
	}
	if( isDefined(level.on) )
	{
		[[level.on]]( "connected", ::processOnConnect );
		[[level.on]]( "spawned", ::loadMySprays );
		[[level.on]]( "menu_response", ::processMenuResponse );
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
		player thread processOnConnect();
		player thread onPlayerSpawned();
		player thread onPlayerMenuResponse();
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
		self thread loadMySprays();
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
		processMenuResponse( menu, response );
	}
}

processMenuResponse( menu, response )
{
	switch( response )
	{
		case "spray_0":
		case "spray_1":
		case "spray_2":
		case "spray_3":
		case "spray_4":
		case "spray_5":
		case "spray_6":
		case "spray_7":
		case "spray_8":
		case "spray_9":
		case "spray_10":
		case "spray_11":
		case "spray_12":
		case "spray_13":
		case "spray_14":
		case "spray_15":
		case "spray_16":
		case "spray_17":
		case "spray_18":
		case "spray_19":
		case "spray_20":
		case "spray_21":
		case "spray_22":
		case "spray_23":
		case "spray_24":
		case "spray_25":
		case "spray_26":
		case "spray_27":
		case "spray_28":
		case "spray_29":
		case "spray_30":
		case "spray_31":
		case "spray_32":
		case "spray_33":
		case "spray_34":
		case "spray_35":
		case "spray_36":
		case "spray_37":
		case "spray_38":
		case "spray_39":
			num = strTok(response, "_")[1];
			self.pers["spray"] = int(num);
			self setStat(70,int(num));
			break;
			
		case "spray":
			if( !isDefined(self.sprayed) || !self.sprayed )
				self thread sprayIt();
			break;
	}
}

processOnConnect()
{
	self.pers["spray"] = self getstat(70);
}

loadMySprays()
{
	self endon("disconnect");
	if(!isDefined(self.pers["savedSpray"]))
		return;

	playFx( level.sprayInfo[self.pers["savedSpray"][0]]["effect"], self.pers["savedSpray"][1], self.pers["savedSpray"][2], self.pers["savedSpray"][3] );
}

sprayIt()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	
	angles = self getPlayerAngles();
	eye = self getTagOrigin( "j_head" );
	forward = eye + vector_scale( anglesToForward( angles ), 70 );
	trace = bulletTrace( eye, forward, false, self );
	
	if( !isAlive(self) || trace["fraction"] == 1 )
		return;
	
	position = trace["position"] - vector_scale( anglesToForward( angles ), -2 );
	angles = vectorToAngles( eye - position );
	forward = anglesToForward( angles );
	up = anglesToUp( angles );
	sprayId = int(self.pers["spray"]);
	
	self.sprayed = true;
	
	if( sprayId < 0 || sprayId > level.numSprays)
		sprayId = 0;
	
	playFx( level.sprayInfo[sprayId]["effect"], position, forward, up );
	self playSound( "sprayer" );
	
	thread saveSpray( self.guid, sprayId, position, forward, up );
	
	wait 2;
	
	self.sprayed = false;
}

saveSpray( guid, sprayId, position, forward, up ) // doesnt seem to save if its not .pers[""] and doesnt seem to load 3rd dimention array, so stuck with saving only 1 spray of 1 person, couple things that can still work it out but idc that much :D
{
	level endon("restarting");
	
	if(!isDefined( self.pers["savedSpray"] ))
		self.pers["savedSpray"] = [];

	self.pers["savedSpray"][0] = sprayId;
	self.pers["savedSpray"][1] = position;
	self.pers["savedSpray"][2] = forward;
	self.pers["savedSpray"][3] = up;
}