package org.bigbluebutton.modules.chat.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.bigbluebutton.common.InputPipe;
	import org.bigbluebutton.common.OutputPipe;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.modules.chat.ChatModule;
	import org.bigbluebutton.modules.chat.model.business.ChatProxy;
	import org.bigbluebutton.modules.chat.ChatModuleConstants;
	import org.bigbluebutton.modules.chat.view.components.ChatWindow;
	import org.bigbluebutton.modules.log.LogModuleFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
	/**
	 * This class is a mediator for the ChatModule viewComponent
	 * 
	 * 
	 */	
	public class ChatModuleMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'LogModuleMediator';
			

		private var outpipe : OutputPipe;
		private var inpipe : InputPipe;
		private var router : Router;
		private var inpipeListener : PipeListener;
		private var chatWindow : ChatWindow;
		private var log : LogModuleFacade = LogModuleFacade.getInstance("LogModule");
		
		/**
		 * Constructor
		 * It sets the required initialization for the router and piping 
		 * @param viewComponent
		 * 
		 */		
		public function ChatModuleMediator( viewComponent:ChatModule )
		{
			super( NAME, viewComponent );	
			router = viewComponent.router;
			log.debug("initializing input pipes for chat module...");
			inpipe = new InputPipe(ChatModuleConstants.TO_CHAT_MODULE);
			log.debug("initializing output pipes for chat module...");
			outpipe = new OutputPipe(ChatModuleConstants.FROM_CHAT_MODULE);
			log.debug("initializing pipe listener for chat module...");
			inpipeListener = new PipeListener(this, messageReceiver);
			router.registerOutputPipe(outpipe.name, outpipe);
			router.registerInputPipe(inpipe.name, inpipe);
			chatWindow = viewComponent.chatWindow;
			addWindow();
			
			
		}
		
		override public function initializeNotifier(key:String):void
		{
			super.initializeNotifier(key);
		} 
		
		//override public function handleNotification(note:INotification):void
		//{
		//	switch(note.getName())
		//	{
				//case ChatFacade.DEBUG:
				//break;	
		//	}
		//}
		
		/**
		 * prepares the chat window to be sent as a message through pipes to Shell 
		 * 
		 */		
		private function addWindow() : void
		{
			// create a message
   			var msg:IPipeMessage = new Message(Message.NORMAL);
   			msg.setHeader( {MSG:MainApplicationConstants.ADD_WINDOW_MSG, SRC: ChatModuleConstants.FROM_CHAT_MODULE,
   						TO: MainApplicationConstants.TO_MAIN });
   			msg.setPriority(Message.PRIORITY_HIGH );
   			
			chatWindow.width = 210;
			chatWindow.height = 200;
			chatWindow.title = ChatWindow.TITLE;
			msg.setBody(chatWindow);
			outpipe.write(msg);
			chatWindow.closeBtn.addEventListener(MouseEvent.CLICK, removeWindow);
			log.debug("A message has been sent to show the chat window.");			
		}
		/**
		 * preparing the remove window event to send through pipes to shell
		 * @param event:Event
		 * 
		 */		
		private function removeWindow(event:Event) : void
		{
			var msg:IPipeMessage = new Message(Message.NORMAL);
   			msg.setHeader( {MSG:MainApplicationConstants.REMOVE_WINDOW_MSG, SRC: ChatModuleConstants.FROM_CHAT_MODULE,
   						TO: MainApplicationConstants.TO_MAIN });
   			msg.setPriority(Message.PRIORITY_HIGH );
   			chatWindow.closeBtn.removeEventListener(MouseEvent.CLICK, removeWindow);
   			msg.setBody(chatWindow);
			outpipe.write(msg);
			log.debug("A message has been sent to remove the chat window.");
			log.debug("Disconnecting chat module...");
			proxy.closeConnection();
		}
		/**
		 * 
		 * @return view component chatModule
		 * 
		 */		
		protected function get chatModule():ChatModule
		{
			return viewComponent as ChatModule;
		}
		
		/**
		 * handler for incoming messages 
		 * @param message
		 * 
		 */		
		private function messageReceiver(message : IPipeMessage) : void
		{
			var msg : String = message.getHeader().MSG;
		}
		
		/**
		 * 
		 * @return proxy
		 * 
		 */		
		public function get proxy():ChatProxy
		{
			return facade.retrieveProxy(ChatProxy.NAME) as ChatProxy;
		} 
		
	//	override public function listNotificationInterests():Array
	//	{
		//	return [
					//ChatFacade.DEBUG
	//			   ];
		//}
		
		/*
		private function debug(message:String) : void 
		{
		 	
		 	var msg:IPipeMessage = new Message(Message.NORMAL);
   			msg.setHeader( {MSG: LogModuleConstants.DEBUG , SRC: ChatModuleConstants.FROM_CHAT_MODULE,
   						TO: LogModuleConstants.TO_LOG_MODULE });
   	
			msg.setBody(message);
			
			outpipe.write(msg);			
		}
      */

	}
}