component output="false" accessors="true" {
	property name="eventType" type="string" required="true";
	
	public function init(string eventType="", struct formStruct={}, struct urlStruct={}) {
		variables.values = {};
		setValues(arguments.urlStruct);
		setValues(arguments.formStruct);
		setEventType(arguments.eventType);
	}
	
	public function getValue(required string valueName) {
		local.return = "";
	
		if (hasValue(arguments.valueName)) {
			local.return = variables.values[arguments.valueName];
		}
		return local.return;
	}
	
	public function getValues() {
		return variables.values;
	}
	
	public function hasValue(required string valueName) {
		return structKeyExists(variables.values,arguments.valueName);
	}
	
	public function setValue(required string key,required any value) {
		variables.values[arguments.key] = arguments.value;   
	}
	
	private function setValues(required struct values) {
		structAppend(variables.values,arguments.values);   
	}
}