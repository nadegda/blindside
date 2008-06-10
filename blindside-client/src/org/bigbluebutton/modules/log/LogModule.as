package org.bigbluebutton.modules.log
{
	import mx.modules.ModuleBase;
	
	import org.bigbluebutton.common.IRouterAware;
	import org.bigbluebutton.common.Router;
	import org.bigbluebutton.main.view.components.MainApplicationShell;
	
	public class LogModule extends ModuleBase implements IRouterAware
	{
		public static const NAME:String = 'LogModule';
		
		private var facade : LogModuleFacade;		
		private var _router : Router;
		public var mshell : MainApplicationShell;
		
		public function LogModule()
		{
			super();
			facade = LogModuleFacade.getInstance(NAME);			
		}

		public function acceptRouter(router : Router, shell : MainApplicationShell) : void
		{
			mshell = shell;
			shell.debugLog.text = 'In LogModule';
			_router = router;
			shell.debugLog.text = 'In LogModule 2';
			LogModuleFacade(facade).startup(this);			
			shell.debugLog.text = 'In LogModule 3';
		}
		
		public function get router() : Router
		{
			return _router;
		}
	}
}