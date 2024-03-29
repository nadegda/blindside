/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/
package org.bigbluebutton.modules.chat.view
{
	import flash.events.Event;
	
	import org.bigbluebutton.modules.chat.ChatFacade;
	import org.bigbluebutton.modules.chat.model.business.ChatProxy;
	import org.bigbluebutton.modules.chat.model.vo.*;
	import org.bigbluebutton.modules.chat.view.components.ChatWindow;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * Mediator Class for ChatWindow view component
	 * 
	 */    
	public class ChatWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChatMediator";
		public static const NEW_MESSAGE:String = "newMessage";
		
		/**
		 * Constructor for class ChatWindowMediator 
		 * @param viewComponent
		 * 
		 */		
		public function ChatWindowMediator(viewComponent:ChatWindow)
		{
			super(NAME, viewComponent);
			viewComponent.addEventListener(ChatWindowMediator.NEW_MESSAGE, sendNewMessage);
		}
		
		/**
		 * 
		 * @return chatWindow, the view component
		 * 
		 */		
		public function get chatWindow():ChatWindow
		{
			return viewComponent as ChatWindow;
		}
		/**
		 * handler for the event of sending new message
		 * @param e
		 * 
		 */		
		public function sendNewMessage(e:Event):void
		{
			proxy.sendMessageToSharedObject(chatWindow.m);
		}
		
		/**
		 * notification(s) that should be taken care off
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array
		{
			return [
					ChatFacade.NEW_MESSAGE
				   ];
		}
		/**
		 * Handlers for notification(s) this class is listening to 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ChatFacade.NEW_MESSAGE:
					this.chatWindow.showNewMessage(notification.getBody() as MessageObject);
					break;	
			}
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
	}
}