package org.blindsideproject.core.apps.chat.business
{
	import flash.events.Event;
	
	public class ConnectionEvent extends Event
	{
		public var code:String = "";
		public function ConnectionEvent(type:String, bubbles:Boolean, cancelable:Boolean, p_code:String=""):void
		{
			super(type, bubbles, cancelable);
			code = p_code;
		}	
	}
}