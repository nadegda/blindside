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
package org.bigbluebutton.common
{
	[Bindable]
	public class Images
	{
		[Embed(source="assets/images/group.png")]
		public var participants_img:Class;

        [Embed(source="assets/images/user_gray.png")]
        public var user_gray:Class;
             
        [Embed(source="assets/images/user_green.png")]
        public var user_green:Class;
             
        [Embed(source="assets/images/user_orange.png")]
        public var user_orange:Class;
         
        [Embed(source="assets/images/user_red.png")]
        public var user_red:Class;

        [Embed(source="assets/images/user.png")]
        public var user:Class;		
        
        [Embed(source="assets/images/administrator.gif")]
        public var admin:Class;
        
        [Embed(source="assets/images/participant.gif")]
        public var participant:Class;
        
        [Embed(source="assets/images/participant-mute.png")]
        public var participant_mute:Class;
        
        [Embed(source="assets/images/raisehand.png")]
        public var raisehand:Class;
        
        [Embed(source="assets/images/sound_mute.png")]
        public var sound_mute:Class;
        
        [Embed(source="assets/images/sound_none.png")]
        public var sound_none:Class;
        
        [Embed(source="assets/images/sound.png")]
        public var sound:Class;                

        [Embed(source="assets/images/cancel.png")]
        public var cancel_user:Class;    

        [Embed(source="assets/images/waaaht.png")]
        public var eject_user:Class;  

        [Embed(source="assets/images/bin.png")]
        public var trash_bin:Class; 

        [Embed(source="assets/images/bin_closed.png")]
        public var bin_closed:Class; 

        [Embed(source="assets/images/door_in.png")]
        public var door_in:Class; 

        [Embed(source="assets/images/door_open.png")]
        public var door_open:Class;         

        [Embed(source="assets/images/door_out.png")]
        public var door_out:Class; 
      
        [Embed(source="assets/images/door.png")]
        public var door:Class;     
        
        [Embed(source="assets/images/application_get.png")]
        public var upload_file:Class;
        
        [Embed(source="assets/images/table_refresh.png")]
        public var refresh_slides:Class;
        
        [Embed(source="assets/images/table.png")]
        public var presentation:Class;

        [Embed(source="assets/images/tfn.png")]
        public var blindside:Class;    
        
        [Embed(source="assets/images/connect.png")]
        public var connect:Class; 

        [Embed(source="assets/images/disconnect.png")]
        public var disconnect:Class; 

        [Embed(source="assets/images/link.png")]
        public var link:Class;    

        [Embed(source="assets/images/webcam.png")]
        public var webcam:Class; 
        
        [Embed(source="assets/images/link_break.png")]
        public var link_break:Class; 

        [Embed(source="assets/images/page_white_powerpoint.png")]
        public var powerpoint:Class;        
        
        [Embed(source="assets/images/comment.gif")]
        public var chat_request:Class; 
        
        [Embed(source="assets/images/comment_yellow.gif")]
        public var chat_request_new:Class;                                  

        [Embed(source="assets/images/telephone.png")]
        public var phone:Class;   
	}
}