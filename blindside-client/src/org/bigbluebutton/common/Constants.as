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
	/**
	 * Holds various constants
	 * NOTE: PLEASE DON'T CHANGE THE CONSTANTS, JUST CHANGE THE STATIC VARIABLES. ADD YOUR OWN CONSTANTS IF
	 * YOU WANT 
	 * @author Denis Zgonjanin
	 * 
	 */	
	public class Constants
	{
		public static const RED5_HOST:String = "present.carleton.ca";
		public static const PRESENTATION_HOST:String = "present.carleton.ca";		
		public static const KIRUS_COMP:String = "134.117.58.103";
		
		public static const NEW_RELATIVE_FILE_UPLOAD:String = "/bigbluebutton/file";
		//The old relative file upload is used for testing the new client on the old server 
		//at present.carleton.ca. The reference to this string can be found in the 
		//PresentationApplication class, in the presentation module under model
		public static const OLD_RELATIVE_FILE_UPLOAD:String = "/blindside/file";
		
		public static const ROOM_85115:String = "85115";
		public static const ROOM_85901:String = "85901";
				
		public static var red5Host:String = KIRUS_COMP;
		public static var presentationHost:String = KIRUS_COMP;
		public static var relativeFileUpload:String = NEW_RELATIVE_FILE_UPLOAD;
		public static var currentRoom:String = ROOM_85115;

	}
}