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
package org.bigbluebutton.modules.video
{
	import org.bigbluebutton.common.InputPipe;
	import org.bigbluebutton.common.OutputPipe;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.MainApplicationConstants;
	import org.bigbluebutton.modules.video.view.ViewCameraWindow;
	import org.bigbluebutton.modules.video.view.mediators.ViewCameraWindowMediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	
	/**
	 * The VideoModuleMediator is a mediator class for the VideoModule
	 * <p>
	 * This class extends the Mediator class of the puremvc framework 
	 * @author dzgonjan
	 * 
	 */	
	public class VideoModuleMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "VideoModuleMediator";
		
		private var outpipe : OutputPipe;
		private var inpipe : InputPipe;
		private var router : Router;
		private var inpipeListener : PipeListener;
		
		private var videoWindow:ViewCameraWindow;
		
		/**
		 * The constructor. Registers the VideoModule with this mediator class 
		 * @param module
		 * 
		 */		
		public function VideoModuleMediator(module:VideoModule)
		{
			super(NAME, module);
			router = module.router;
			inpipe = new InputPipe(VideoConstants.TO_VIDEO_MODULE);
			outpipe = new OutputPipe(VideoConstants.FROM_VIDEO_MODULE);
			inpipeListener = new PipeListener(this, messageReceiver);
			router.registerOutputPipe(outpipe.name, outpipe);
			router.registerInputPipe(inpipe.name, inpipe);
			addVideoWindow();
		}
		
		private function messageReceiver(message:IPipeMessage):void{
			var msg:String = message.getHeader().MSG;
		}
		
		/**
		 * Adds the gui window of this module to the main application shell. The component is sent
		 * through the puremvc piping utility 
		 * 
		 */		
		private function addVideoWindow():void{
			var msg:IPipeMessage = new Message(Message.NORMAL);
			msg.setHeader({MSG:MainApplicationConstants.ADD_WINDOW_MSG, SRC: VideoConstants.FROM_VIDEO_MODULE,
   						TO: MainApplicationConstants.TO_MAIN });
   			msg.setPriority(Message.PRIORITY_HIGH);
   			
   			videoWindow.width = 200;
   			videoWindow.height = 200;
   			videoWindow.title = ViewCameraWindow.TITLE;
   			msg.setBody(viewComponent as VideoModule);
   			outpipe.write(msg);
   			
		}
		
		/**
		 * Initialize the notifier key of this mediator. This method need not be called, it is executed
		 * automatically. It is needed because in the multicore version of puremvc one cannot communicate
		 * directly with the facade through the constructor. 
		 * @param key
		 * 
		 */		
		override public function initializeNotifier(key:String):void{
			super.initializeNotifier(key);
			facade.registerMediator(new ViewCameraWindowMediator(videoWindow));
		}
		
		/**
		 * Lists the notifications that this class listens to 
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array{
			return [];
		}
		
		/**
		 * Handles the notifications upon receiving them 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void{
			
		}		

	}
}