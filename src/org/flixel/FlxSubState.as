package org.flixel
{
	import org.flixel.FlxState;

	/**
	 * @author andreas
	 */
	public class FlxSubState extends FlxState
	{
		
		public static const CLOSED_BY_PARENT:String = "FlxSubState::closed_by_parent";
		
		//Default background color is transparent
		public function FlxSubState(isBlocking:Boolean, bgColor:uint = 0x00000000, useMouse:Boolean = false)
		{
			super(0x00000000, useMouse);
			_bgColor = bgColor;
			_isBlocking = isBlocking;
		}
		
		private var _isBlocking:Boolean;
		public function get isBlocking():Boolean { return _isBlocking; }
		public function set isBlocking(value:Boolean):void { _isBlocking = value; } 
		
		//Use the already existing protected variable "_bgColor"
		private var _bgColor:uint;
		public override function get bgColor():uint { return this._bgColor; }
		public override function set bgColor(value:uint):void {	this._bgColor = value; }
			
		override public function draw() : void 
		{
			//Draw background
			if(cameras == null) { cameras = FlxG.cameras; }
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
			{
				var camera:FlxCamera = cameras[i++];
				camera.fill(this.bgColor);
			}
			
			//Now draw all children
			super.draw();
		}
		
		//This looks ugly. :(
		internal var parentState:FlxState;
		public function get isSubState():Boolean { return Boolean(parentState); }
		
		public function close(reason:String):void
		{
			if (parentState) { parentState.subStateCloseHandler(reason); }
			else { /* Missing parent from this state! Do something!!" */ }
		}
	}
}
