component {
	public eventHandler function init(){
		Variables.events = ArrayNew(1);
		Variables.listeners = ArrayNew(1);
		return this;
	}
	
	public void function addEventListener(string eventType, string listener, string cfcpath){
		if(!arrayFind(Variables.events,Arguments.eventType))arrayAppend(Variables.events,Arguments.eventType);
		var listener = {
			listener = Arguments.listener,
			cfcpath = Arguments.cfcpath,
			eventType = Arguments.eventType
		};arrayAppend(Variables.listeners, listener);
	}
	
	public void function addListenersByCFC(string cfcdotpath){
		var objMeta = '';
		var listener = structNew();
		try{
			var obj = createObject('component', Arguments.cfcdotpath);
		}catch(any e){
			// Announce the error event
		}
		objMeta = getMetaData(obj);
		for(var i IN objMeta['functions']){
			if(left(i.name,2) IS 'on'){
				listener.cfcpath = objMeta.fullName;
				listener.eventType = right(i.name,len(i.name)-2);
				listener.listener = i.name;
				
				addEventListener(argumentCollection=listener);
			}
		}
	}
	
	public void function announceEvent(string eventType){
		var obj = '';
		if(left(Arguments.eventType,2) IS 'on')Arguments.eventType = right(Arguments.eventType,len(Arguments.eventType)-2);
		if(arrayFind(Variables.events, Arguments.eventType)){
			for(var key IN Variables.listeners){
				if(key.eventType IS Arguments.eventType){
					try{
						event = new Event(Arguments.eventType, FORM, URL);
						obj = createObject('component',key.cfcpath);
						evaluate('obj.#key.listener#(event)');
					}catch(any e){
						announceEvent('onError');
					}
				}
			}
		}
	}
	
	public array function getEvents(){return Variables.events;}
	public array function getListeners(){return Variables.listeners;}
}