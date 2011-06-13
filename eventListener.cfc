component{
	public void function onSayHello(event e){
		Application.helloEvent = 'I said hello ' & e.getEventType();
	}
}