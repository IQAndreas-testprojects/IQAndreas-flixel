package org.flixel
{
	
	/**
	 * This is the basic game "state" object - e.g. in a simple game
	 * you might have a menu state and a play state.
	 * It is for all intents and purpose a fancy FlxGroup.
	 * And really, it's not even that fancy.
	 * 
	 * @author	Adam Atomic
	 */
	public class FlxState extends FlxGroup
	{
		/**
		 * After much debate, I have decided to add the "useMouse" option
		 * which allows a SubState (most likely a menu) to have mouse interaction,
		 * and when the menu closes, the mouse either shows or hides depending on
		 * which preference the parent had.
		 * 
		 * Default background color is black.
		 */
		public function FlxState(bgColor:uint = 0xFF000000, useMouse:Boolean = false):void
		{
			//I hope setting them directly instead of waiting for "create" is not a problem. :(
			this.bgColor = bgColor;
			this.useMouse = useMouse;
		}
		
		/**
		 * This function is called after the game engine successfully switches states.
		 * Override this function, NOT the constructor, to initialize or set up your game state.
		 * We do NOT recommend overriding the constructor, unless you want some crazy unpredictable things to happen!
		 */
		public function create():void
		{
			
		}
		
		public function get bgColor():uint { return FlxG.bgColor; }
		public function set bgColor(value:uint):void { FlxG.bgColor = value; }
		
		private var _useMouse:Boolean = false;
		public function get useMouse():Boolean { return _useMouse; }
		public function set useMouse(value:Boolean):void
		{
			_useMouse = value;
			this.updateMouseVisibility();
		}
		private function updateMouseVisibility():void
		{ 
			if (_useMouse) { FlxG.mouse.show(); }
			else { FlxG.mouse.hide(); }
		}
		
		
		private var _subState:FlxSubState = null;
		private var _subStateCloseCallback:Function = null;
		
		public function get subState():FlxSubState
		{
			return _subState;
		}
		/*public function set subState(_requestedState:FlxSubState):void
		{
			this.setSubState(_requestedState, null);
		}*/
		
		/**
		 * Manually close the sub-state (will always give the reason FlxSubState.CLOSED_BY_PARENT)
		 */
		public function closeSubState():void
		{
			this.setSubState(null);
		}
		
		public function setSubState(requestedState:FlxSubState, closeCallback:Function = null):void
		{
			//New instances of the same class are however allowed
			//The new callback is ignored if returned. :(
			if (_subState == requestedState) { return; }
			_subStateCloseCallback = closeCallback;
			
			//Destroy the old state (if there is an old state)
			if(_subState != null)
			{
				_subState.close(FlxSubState.CLOSED_BY_PARENT);
			}
			
			//Finally assign and create the new state (or set it to null)
			_subState = requestedState;
			
			if (_subState)
			{
				//WARNING: What if the state has already been created?
				// I'm just copying the code from "FlxGame::switchState" which doesn't check for already craeted states. :/
				_subState.parentState = this;
				
				//Reset the keys so things like "justPressed" won't interfere
				if (_subState.isBlocking) { FlxG.keys.reset(); }
				_subState.create();
			}
		}
		
		internal function subStateCloseHandler(reason:String):void
		{
			//Call the "closeCallback" while subState variables are still in memory,
			//But after "FlxSubState.close()" has been called
			if (_subStateCloseCallback != null)
			{
				_subStateCloseCallback.call(null, _subState, reason);
				_subStateCloseCallback = null;
			}
			
			_subState.destroy();
			_subState.parentState = null;
			_subState = null;
			
			this.updateMouseVisibility();
		}
		
		
		public override function destroy():void
		{
			if (_subState) { this.closeSubState(); }
			super.destroy();
		}
		
		
		public function tryUpdate():void
		{
			if (!_subState || !_subState.isBlocking) 
			{
				this.update();
			}
			
			//The current state will update before the subState. Is that good or bad?
			if (_subState) { _subState.tryUpdate(); }
		}
		
		//Moved drawing to inside of FlxGame
		//ALWAYS draw the background state? Or is it better to only draw if if it's non-blocking?
		public override function draw():void
		{
			//Background is already drawin inside of FlxCamera.lockCameras()
			
			//Now draw all children
			super.draw();
			
			//If called in this order, draws the subState on top of the current state
			if (_subState) { _subState.draw(); }
		}
	}
}
