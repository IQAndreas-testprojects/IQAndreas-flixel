package org.flixel
{
	import org.flixel.FlxState;

	/**
	 * @author andreas
	 */
	public class FlxSubState extends FlxState
	{
		
		public static const CLOSED_BY_PARENT:String = "FlxSubState::closed_by_parent";
		
		public function FlxSubState(isBlocking:Boolean)
		{
			_isBlocking = isBlocking;
		}
		
		private var _isBlocking:Boolean;
		public function get isBlocking():Boolean { return _isBlocking; }
		public function set isBlocking(value:Boolean):void { _isBlocking = value; } 
		
		//This looks ugly. :(
		internal var parentState:FlxState;
		
		public function close(reason:String):void
		{
			if (parentState) { parentState.subStateCloseHandler(reason); }
			else { /* Missing parent from this state! Do something!!" */ }
		}
	}
}
