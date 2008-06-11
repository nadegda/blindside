package org.bigbluebutton.modules.log.controller
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.bigbluebutton.modules.log.LogModuleFacade;
	import org.bigbluebutton.modules.log.view.LogModuleMediator;
	import org.bigbluebutton.modules.log.LogModule;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ViewPrepCommand extends SimpleCommand
	{
		public function ViewPrepCommand()
		{
			super();
		}

		override public function execute(note:INotification):void
		{
			var app:LogModule = note.getBody() as LogModule;
			facade.registerMediator( new LogModuleMediator( app ) );			
		}				
	}
}