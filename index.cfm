<cfscript>
	eventHandler = new eventHandler();
	writeDump(var=getMetaData(eventHandler), expand=false, label='EventHandler Meta Data');
	eventHandler.addListenersByCFC(cfcdotpath='eventListener');
	writeDump(var=eventHandler.getEvents(), expand=false, label='Events');
	writeDump(var=eventHandler.getListeners(), expand=false, label='Listeners');
	writeDump(var=Application, expand=false, label='Application Scope (pre event)');
	eventHandler.announceEvent('SayHello');
	writeDump(var=Application, expand=false, label='Application Scope (post event)');
</cfscript>