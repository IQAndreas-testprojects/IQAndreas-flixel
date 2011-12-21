package org.flixel
{
	import org.flixel.FlxState;

	/**
	 * @author andreas
	 */
	public class FlxSubState extends FlxState
	{
		
		public static const CLOSED_BY_PARENT:String = "FlxSubState::closed_by_parent";
		
		public function FlxSubState(isBlocking:Boolean, backgroundColor:uint = 0x00000000)
		{
			_isBlocking = isBlocking;
			
			//Is it better to keep the background separate if you want to do things
			// like clearing all children etc??
			_background = new FlxSprite();
			add(_background);
			this.backgroundColor = backgroundColor;
		}
		
		private var _isBlocking:Boolean;
		public function get isBlocking():Boolean { return _isBlocking; }
		public function set isBlocking(value:Boolean):void { _isBlocking = value; } 
		
		private var _background:FlxSprite;
		private var _backgroundColor:uint;
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void
		{
			//Will not detect if the background resizes!!
			_backgroundColor = value;
			_background.makeGraphic(FlxG.width, FlxG.height, _backgroundColor);
		}
		
		//This looks ugly. :(
		internal var parentState:FlxState;
		
		public function close(reason:String):void
		{
			if (parentState) { parentState.subStateCloseHandler(reason); }
			else { /* Missing parent from this state! Do something!!" */ }
		}
	}
}
