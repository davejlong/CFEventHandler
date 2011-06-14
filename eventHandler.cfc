<cfcomponent>
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfscript>
			Variables.events = ArrayNew(1);
			Variables.listeners = ArrayNew(1);
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addEventListener" access="public" returntype="void">
		<cfargument name="eventType" type="string" required="true" />
		<cfargument name="listener" type="string" required="true" />
		<cfargument name="cfcpath" type="string" required="true" />
		<cfset var listener = structNew() />
		<cfif NOT arrayFind(Variables.events, Arguments.eventType)>
			<cfset arrayAppend(Variables.events, Arguments.eventType) />
		</cfif>
		<cfscript>
			listener.listener = Arguments.listener;
			listener.cfcpath = Arguments.cfcpath;
			listener.eventType = Arguments.eventType;
			arrayAppend(Variables.listeners, listener);
		</cfscript>
	</cffunction>
	
	<cffunction name="addListenersByCFC" access="public" returntype="void">
		<cfargument name="cfcdotpath" type="string" />
		<cfset var objMeta = '' />
		<cfset var listener = structNew() />
		<cfset var obj = '' />
		<cfset var key = '' />
		<!--- Setup the object, calling the onError event if it fails --->
		<cftry>
			<cfset obj = createObject('component',Arguments.cfcdotpath) />
		<cfcatch type="any">
			<cfset announceEvent('onError') />
		</cfcatch>
		</cftry>
		<!--- Get the meta data for the object and then loop through the functions --->
		<cfset objMeta = getMetadata(obj) />
		<cfloop array="#objMeta.functions#" index="key">
			<cfif left(key.name,2) IS 'on'>
				<cfscript>
					listener.cfcpath = objMeta.fullname;
					listener.eventType = right(key.name, len(key.name)-2);
					listener.listener = key.name;
					// Add the actual event listener
					addEventListener(argumentCollection=listener);
				</cfscript>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="announceEvent" access="public" returntype="void">
		<cfargument name="eventType" type="string" required="true" />
		<cfset var key = '' />
		<cfset var event = '' />
		<!--- Check if "on" is in the eventType and remove it if it is --->
		<cfif left(Arguments.eventType,2) IS 'on'>
			<cfset Arguments.eventType = right(Arguments.eventType,len(Arguments.eventType)-2) />
		</cfif>
		<!--- Check if the eventType exists --->
		<cfif arrayFind(Variables.events, Arguments.eventType)>
			<cfloop array="#Variables.listeners#" index="key">
				<cfif key.eventType IS Arguments.eventType>
					<cftry>
						<cfset event = createObject('component','Event').init(Arguments.eventType, FORM, URL) />
						<cfinvoke component="#key.cfcpath#" method="#key.listener#">
							<cfinvokeargument name="e" value="#event#" />
							<cfinvokeargument name="event" value="#event#" />
						</cfinvoke>
					<cfcatch type="any">
						<cfset announceEvent('error') />
					</cfcatch>
					</cftry>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="getEvents" returntype="array" access="public">
		<cfreturn Variables.events />
	</cffunction>
	<cffunction name="getListeners" returntype="array" access="public">
		<cfreturn Variables.listeners />
	</cffunction>
	
	<!--- Provide the arrayFind function for ColdFusion servers before CF9 --->
	<cfif left(Server.ColdFusion.productversion,1) LT 9>
		<cffunction name="arrayFind" access="private" output="false" returntype="Numeric" hint="Returns the index of the first found element in the array containing the value argument">
			<cfargument name="array" required="true" type="array" />
			<cfargument name="value" required="true" type="string" />
			<cfreturn (Arguments.array.indexOf(Arguments.value)) +1 />
		</cffunction>
	</cfif>
</cfcomponent>