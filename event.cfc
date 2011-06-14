<cfcomponent output="false">
	<cfproperty name="eventType" type="string" />

	<cffunction name="init" access="public" returntype="void">
		<cfargument name="eventType" type="string" required="false" />
		<cfargument name="formStruct" type="struct" required="false" />
		<cfargument name="urlStruct" type="struct" required="false" />
		<cfscript>
			Variables.values = structNew();
			setValues(Arguments.urlStruct);
			setValues(Arguments.formStruct);
			setEventType(Argumetns.eventType);
		</cfscript>
	</cffunction>

	<cffunction name="getValue" access="public" returntype="any">
		<cfargument name="valuename" type="string" required="true" />
		<cfset var value = '' />
		<cfif hasValue(Arguments.valueName)>
			<cfset value = Variables.values[Arguments.valueName] />
		</cfif>
		<cfreturn value />
	</cffunction>

	<cffunction name="getValues" access="public" returntype="struct">
		<cfreturn Variables.values />
	</cffunction>

	<cffunction name="hasValue" access="public" returntype="boolean">
		<cfargument name="valuename" type="string" required="true" />
		<cfreturn structKeyExists(Variables.values, Arguments.valueName) />
	</cffunction>

	<cffunction name="setValue" access="public" returntype="void">
		<cfargument name="key" type="string" required="false" />
		<cfargument name="value" type="any" required="true" />
		<cfset Variables.values[Arguments.key] = Arguments.value />
	</cffunction>

	<cffunction name="setValues" access="public" returntype="void">
		<cfargument name="values" type="struct" required="true" />
		<cfset structAppend(Variables.values, Arguments.values) />
	</cffunction>	

	<cffunction name="getEventType" access="public" output="false" returntype="string">
		<cfreturn eventType />
	</cffunction>

	<cffunction name="setEventType" access="public" output="false" returntype="void">
		<cfargument name="argEventType" type="string" required="true" />
		<cfset eventType=argEventType />
	</cffunction>

</cfcomponent>