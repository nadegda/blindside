package org.bigbluebutton.modules.viewers.model.services
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	import org.bigbluebutton.modules.viewers.ViewersFacade;
	import org.bigbluebutton.modules.viewers.controller.notifiers.StatusNotifier;
	import org.bigbluebutton.modules.viewers.model.business.Conference;
	import org.bigbluebutton.modules.viewers.model.vo.User;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SharedObjectConferenceDelegate extends Proxy implements IProxy
	{
		public static const NAME:String = "SharedObjectConferenceDelegate";
		
		private var _conference : Conference;
		private var _connection : NetConnection;
		private var _participantsSO : SharedObject;
		private var _ncDelegate : NetConnectionDelegate;
		
		private static const SO_NAME : String = "participantsSO";
		
		public function SharedObjectConferenceDelegate(conference:Conference)
		{
			super(NAME);
			_conference = conference;	
		}
		
		public function sendNewStatus(newStatus : String) : void {
			_conference.me.status = newStatus;
	
			var id : Number = _conference.me.userid;			
			var aUser:User = _conference.getParticipant(id);			
			if (aUser != null) {
				// This sets this user's status
				aUser.status = newStatus;
				_participantsSO.setProperty(id.toString(), aUser);
				_participantsSO.setDirty(id.toString());
			}
		}

		public function sendBroadcastStream(hasStream : Boolean, streamName : String) : void {
			var id : Number = _conference.me.userid;
			var aUser : User = _conference.getParticipant(id);			
			
			if (aUser != null) {
				// This sets the users stream
				aUser.hasStream = hasStream;
				aUser.streamName = streamName;
				_participantsSO.setProperty(id.toString(), aUser);
				_participantsSO.setDirty(id.toString());
				
				//log.debug( "Conference::sendBroadcastStream::found =[" + id + "," 
				//		+ aUser.hasStream + "," + aUser.streamName + "]");				
			}
		}

		public function broadcastStream(id : Number, hasStream : Boolean, streamName : String) : void
		{
			var aUser : User = _conference.getParticipant(id);			
			if (aUser != null) {
				aUser.hasStream = hasStream;
				aUser.streamName = streamName;
			}		
		}
				
		public function join(host : String, username : String, password : String, room : String) : void
		{
			_connection = new NetConnection();
			_connection.client = this;
			
			_conference.host = host;
			_conference.room = room;
			_conference.me.name = username;
			
			_ncDelegate = new NetConnectionDelegate(this);
			_ncDelegate.connect(host, room, username, password);
		}
		
		public function get netConnection() : NetConnection
		{
			return _connection;
		}
		
		public function disconnected(reason : String) : void
		{
			_conference.connected = false;
			_conference.connectFailReason = reason;
		}
		
		public function connected() : void
		{
			_conference.connected = true;
			_conference.connectFailReason = null;
			
			joinConference();
			
			sendNotification(ViewersFacade.CONNECT_SUCCESS);
		}
		
		private function joinConference() : void
		{
			// Start with a fresh list
			_conference.removeAllParticipants();
			
			_participantsSO = SharedObject.getRemote(SO_NAME, _conference.host, false);
			
			_participantsSO.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_participantsSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_participantsSO.addEventListener(SyncEvent.SYNC, sharedObjectSyncHandler);
			
			_participantsSO.client = this;

			_participantsSO.connect(_connection);
		}

		public function leave() : void
		{
			removeListeners();
			_participantsSO.close();
			_ncDelegate.disconnect();
			
			// Cleanup list of participants
			_conference.removeAllParticipants();		
		}

		private function removeListeners() : void
		{
			_participantsSO.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_participantsSO.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_participantsSO.removeEventListener(SyncEvent.SYNC, sharedObjectSyncHandler);
		}			

		private function sharedObjectSyncHandler( event : SyncEvent) : void
		{
			//log.debug( "Conference::sharedObjectSyncHandler " + event.changeList.length);
			
			for (var i : uint = 0; i < event.changeList.length; i++) 
			{
				//log.debug( "Conference::handlingChanges[" + event.changeList[i].name + "][" + i + "]");
				handleChangesToSharedObject(event.changeList[i].code, 
						event.changeList[i].name, event.changeList[i].oldValue);
			}
		}

		/**
		 * See flash.events.SyncEvent
		 */
		private function handleChangesToSharedObject(code : String, name : String, oldValue : Object) : void
		{
			switch (code)
			{
				case "clear":
					/** From flash.events.SyncEvent doc
					 * 
					 * A value of "clear" means either that you have successfully connected 
					 * to a remote shared object that is not persistent on the server or the 
					 * client, or that all the properties of the object have been deleted -- 
					 * for example, when the client and server copies of the object are so 
					 * far out of sync that Flash Player resynchronizes the client object 
					 * with the server object. In the latter case, SyncEvent.SYNC is dispatched 
					 * and the "code" value is set to "change". 
					 */
					 
					_conference.removeAllParticipants();
													
					break;	
																			
				case "success":
					/** From flash.events.SyncEvent doc
					 * 	 A value of "success" means the client changed the shared object. 		
					 */
					
					// do nothing... just log it 
					//log.debug( "Conference::success =[" + name + "," 
					//		+ _participantsSO.data[name].status + ","
					//		+ _participantsSO.data[name].hasStream
					//		+ "]");	
					break;

				case "reject":
					/** From flash.events.SyncEvent doc
					 * 	A value of "reject" means the client tried unsuccessfully to change the 
					 *  object; instead, another client changed the object.		
					 */
					
					// do nothing... just log it 
					// Or...maybe we should check if the value is the same as what we wanted it
					// to be..if not...change it?
					//log.debug( "Conference::reject =[" + code + "," + name + "," + oldValue + "]");	
					break;

				case "change":
					/** From flash.events.SyncEvent doc
					 * 	A value of "change" means another client changed the object or the server 
					 *  resynchronized the object.  		
					 */
					 
					if (name != null) {						
						if (_conference.hasParticipant(_participantsSO.data[name].userid)) {
							var changedUser : User = _conference.getParticipant(Number(name));
							changedUser.status = _participantsSO.data[name].status;
							changedUser.hasStream = _participantsSO.data[name].hasStream;
							changedUser.streamName = _participantsSO.data[name].streamName;	

							//log.debug( "Conference::change =[" + 
							//	name + "," + changedUser.name + "," + changedUser.hasStream + "]");
																					
						} else {
							// The server sent us a new user.
							var user : User = new User();
							user.userid = _participantsSO.data[name].userid;
							user.name = _participantsSO.data[name].name;
							user.status = _participantsSO.data[name].status;
							user.hasStream = _participantsSO.data[name].hasStream;
							user.streamName = _participantsSO.data[name].streamName;							
							user.role = _participantsSO.data[name].role;						
							
							//log.debug( "Conference::change::newuser =[" + 
							//	name + "," + user.name + "," + user.hasStream + "]");
							
							_conference.addUser(user);
						}
						
					} else {
						//log.warn( "Conference::SO::change is null");
					}
																	
					break;

				case "delete":
					/** From flash.events.SyncEvent doc
					 * 	A value of "delete" means the attribute was deleted.  		
					 */
					
					//log.debug( "Conference::delete =[" + code + "," + name + "," + oldValue + "]");	
					
					// The participant has left. Cast name (string) into a Number.
					_conference.removeParticipant(Number(name));
					break;
										
				default:	
					//log.debug( "Conference::default[" + _participantsSO.data[name].userid
					//				+ "," + _participantsSO.data[name].name + "]");		 
					break;
			}
		}
		
		private function netStatusHandler ( event : NetStatusEvent ) : void
		{
			//log.debug( "Conference::netStatusHandler " + event.info.code );
		}
		
		private function asyncErrorHandler ( event : AsyncErrorEvent ) : void
		{
			//log.debug( "Conference::asyncErrorHandler " + event.error);
		}

		public function sendNewUserStatusEvent(userid : Number, newStatus : String):void
		{
			//var event : StatusChangeEvent = 
			//		new StatusChangeEvent(userid, newStatus);
			//event.dispatch();
			sendNotification(ViewersFacade.CHANGE_STATUS, new StatusNotifier(userid, newStatus));
		}	
		
		/**
	 	*  Callback from server
	 	*/
		public function setUserIdAndRole(id : Number, role : String ) : String
		{
			//log.debug( "SOConferenceDelegate::setConnectionId: id=[" + id + "]");
			if( isNaN( id ) ) return "FAILED";
			
			_conference.me.userid = id;
			_conference.me.role = role;
									
			return "OK";
		}	
	}
}