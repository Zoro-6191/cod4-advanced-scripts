#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    preCacheShader("headicon_dead");
    preCacheShader("compass_ping");

    if( isDefined(level.on) )
		[[level.on]]( "menu_response", ::processMenuResponse );
	else thread onPlayerConnect();
}

onPlayerConnect()
{
    level endon("restarting");
	level endon("game_ended");
	while(true)
	{
		level waittill( "connected", player );
		player thread onPlayerMenuResponse();
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
    if( response == "ping" )
        self thread pingRightNow();
}

pingRightNow()
{
	self endon("disconnect");

    if( !isDefined(self.pinged) )
        self.pinged = false;

	if(!isAlive(self)||self.pinged)
		return;

	angles=self getPlayerAngles();
	eye=self getTagOrigin("j_head");
	forward=eye + vector_scale(anglesToForward(angles),4000);
	trace=bulletTrace(eye,forward,false,self);

	if(trace["fraction"]==1)
		return;

	pingloc=trace["position"]-vector_scale(anglesToForward(angles),50);
	self.pinged=true;
	self pingPlayer();
	
	self thread minimap(pingloc);

	pinghud=newTeamHudElem(self.pers["team"]);
	pinghud setShader("headicon_dead",2,2);
	pinghud setwaypoint(true);
	pinghud.x=pingloc[0];
    pinghud.y=pingloc[1];
    pinghud.z=pingloc[2]+10;	
	pinghud.color=(1,1,0);

	a=0.8;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 1;
	pinghud fadeovertime(0.2);
	pinghud.alpha=0;
	wait 0.2;
	pinghud destroy();
	wait 0.3;
	self.pinged=false;
}

minimap(position)
{
	objCompass = maps\mp\gametypes\_gameobjects::getNextObjID();
	if ( objCompass > 0 && objCompass < 12 ) 
	{
		objective_Add( objCompass, "active", position + ( 0, 0, 25 ) );
		objective_Icon( objCompass, "compass_ping" );
		objective_Team( objCompass, self.team );
		
		while( self.pinged )
		{
			wait 0.1;
			objective_State( objCompass, "invisible" );
			wait 0.1;
			objective_State( objCompass, "active" );
		}
		objective_delete( objCompass );
		level.objectiveIDs[objCompass] = false;	
		level.numGametypeReservedObjectives--;
	}
	else level.numGametypeReservedObjectives--;
}