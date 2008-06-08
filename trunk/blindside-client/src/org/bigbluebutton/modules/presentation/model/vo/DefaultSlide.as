package org.bigbluebutton.modules.presentation.model.vo
{
	
	/**
	 * This class represents the default empty slide
	 * @author dzgonjan
	 * 
	 */	        
	[Bindable]
	public class DefaultSlide
	{
		public var name : String;
		public var title : String;
		public var source : String;
		 
		public function DefaultSlide()
		{
			this.name = "Blindside Project";
			this.source = "assets/slides/slide-0.swf";				
		}
	}
}