package org.bigbluebutton.modules.meetme
{
	import com.adobe.cairngorm.*;
	
	import org.bigbluebutton.modules.meetme.control.StartupMeetMeCommand;
	import org.bigbluebutton.modules.meetme.model.MeetMeRoom;
	import org.bigbluebutton.modules.meetme.view.ListenersWindow;
	import org.blindsideproject.core.util.log.ILogger;
	import org.blindsideproject.core.util.log.LoggerModelLocator;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
		
	/**
	 * The  MeetMeFacade is the main Facade of the MeetMe module. It extends the Facade class of the PureMVC
	 * framework
	 * @author Richard Alam
	 * 
	 */	
	public class MeetMeFacade extends Facade implements IFacade
	{
		public static const ID : String = "VoiceConferenceFacade";
		public static const STARTUP:String = "StartupVoiceConference";
		
		//EVENTS
		public static const MUTE_UNMUTE_USER_COMMAND : String = "MEETME_MUTE_UNMUTE_USER";
		public static const EJECT_USER_COMMAND : String = "MEETME_EJECT_USER";
		public static const MUTE_ALL_USERS_COMMAND : String = "MEETME_MUTE_ALL_USER";
		public static const USER_JOIN_EVENT:String = "User Join Event";
		public static const MUTE_EVENT:String = "mute event";
		
		private var log : ILogger = LoggerModelLocator.getInstance().log;
		
		public var meetMeRoom:MeetMeRoom;
				
		/**
		 * The default constructor. Should NEVER be called directly, as this class is a singleton.
		 * Instead, use the getInstance() method 
		 * 
		 */		
		public function MeetMeFacade()
		{
			super(ID);		
		}
		
		/**
		 *  
		 * @return The instance of MeetMeFacade singleton class
		 * 
		 */		
		public static function getInstance() : MeetMeFacade
		{
			if (instanceMap[ID] == null) instanceMap[ID] = new MeetMeFacade();
			return instanceMap[ID] as MeetMeFacade;
	   	}		
	   	
	   	/**
	   	 * Initializes the controller part of this MVC module 
	   	 * 
	   	 */	   	
	   	override protected function initializeController():void{
	   		super.initializeController();
	   		registerCommand(STARTUP, StartupMeetMeCommand);
	   	}
	   	
	   	/**
	   	 * Sends out a notification to start the command which initiates the mediators and the proxies 
	   	 * @param app
	   	 * 
	   	 */	   	
	   	public function startup(app:ListenersWindow):void{
	   		meetMeRoom = new MeetMeRoom();
	   		sendNotification(STARTUP, app);
	   		//meetMeRoom.getConnection().connect();
	   	}
	   	
	   	/**
	   	 *  Richard: Had to create this to prevent stack overflow when done during initialize	 
	   	 * @param userRole
	   	 * 
	   	 */	   	
	   	public function setupMeetMeRoom(userRole : String) : void
	   	{
			meetMeRoom.userRole = userRole;
	   	}  	

		/**
		 * Initializes the connection to the server 
		 * 
		 */
		public function connectToMeetMe() : void
	   	{
			meetMeRoom.getConnection().connect();		
	   	}
	   		   	
	   	/**
	   	 * 
	   	 * @return The MeetMeRoom of the MeetMe module
	   	 * 
	   	 */	   		   	
	   	public function getMeetMeRoom() : MeetMeRoom
	   	{
	   		return meetMeRoom;
	   	}
	}
}