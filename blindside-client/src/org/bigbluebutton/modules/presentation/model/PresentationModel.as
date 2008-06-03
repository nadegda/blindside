package org.bigbluebutton.modules.presentation.model
{
	import mx.collections.ArrayCollection;
	
	import org.bigbluebutton.modules.presentation.model.vo.SlidesDeck;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * The PresentationModel class holds the properties of the presentation 
	 * @author dzgonjan
	 * 
	 */	
	public class PresentationModel extends Mediator implements IMediator
	{
		public static const NAME:String = "PresentationModel";
		
		/**
		 * The userid of this participant.
		 */
		public var userid : Number;
		
		// If connected to the presentation server or not
		[Bindable] public var isConnected : Boolean = false;				
		
		// The host of the presentation server application.
		public var host : String;
		
		public var room : String;
		
		// Is this user the presenter?
		private var _isPresenter : Boolean = false;
		
		public function set isPresenter(value : Boolean) : void
		{
			_isPresenter = value;
		}
		
		[Bindable] public function get isPresenter() : Boolean
		{
			return _isPresenter;
		}
		
		[Bindable] public var presenterName : String = "No presenter";
		
		// Has this presenter loaded a presentation
		[Bindable] public var presentationLoaded : Boolean = false;
		
		/**
		 * If a presentation is being shared or not.
		 */
		[Bindable] public var isSharing : Boolean = false;
				
		/**
		 * The presentation slides being shared.
		 */
		[Bindable] public var decks:SlidesDeck;
		
		public function PresentationModel() : void {
			super(NAME);
		}
				
		public function displayDefaultSlide() : void
		{
			decks.displayDefaultSlide();
		}
				
		/**
		 * Register a new SlidesDeck with this presentation 
		 * @param deck
		 * 
		 */				
		public function newDeckOfSlides(deck : SlidesDeck) : void
		{
		    if (decks == null) {
		    	decks = deck;
		    } else {
		        decks.name = deck.name;	        
		        decks.selected = deck.selected;
		        decks.title = deck.title;
		        decks.slides.removeAll();
		        decks.slides = new ArrayCollection(deck.slides.source);
		    }		
		    
			presentationLoaded = true;	
		}
		
		public function open(userid:Number):void
		{
			this.userid = userid;
		}
		
		public function close():void
		{
			isConnected = false;
		}
		
	}
}