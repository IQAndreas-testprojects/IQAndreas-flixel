package org.flixel 
{
	/**
	 * Extra class added to group the "vcr" commands in FlxG.
	 * 
	 * I was thinking of putting the class inside "org.flixel.system",
	 * but it needed access to internal members of FlxG.
	 */
	public class FlxVCR 
	{
		public function FlxVCR(game:FlxGame)
		{
			this._game = game;
		}
		
		protected var _game:FlxGame;
		/**
		 * Load replay data from a string and play it back.
		 * 
		 * @param	Data		The replay that you want to load.
		 * @param	State		Optional parameter: if you recorded a state-specific demo or cutscene, pass a new instance of that state here.
		 * @param	CancelKeys	Optional parameter: an array of string names of keys (see FlxKeyboard) that can be pressed to cancel the playback, e.g. ["ESCAPE","ENTER"].  Also accepts 2 custom key names: "ANY" and "MOUSE" (fairly self-explanatory I hope!).
		 * @param	Timeout		Optional parameter: set a time limit for the replay.  CancelKeys will override this if pressed.
		 * @param	Callback	Optional parameter: if set, called when the replay finishes.  Running to the end, CancelKeys, and Timeout will all trigger Callback(), but only once, and CancelKeys and Timeout will NOT call FlxG.stopReplay() if Callback is set!
		 */
		public function loadReplay(Data:String,State:FlxState=null,CancelKeys:Array=null,Timeout:Number=0,Callback:Function=null):void
		{
			_game._replay.load(Data);
			if(State == null)
				FlxG.resetGame();
			else
				FlxG.switchState(State);
			_game._replayCancelKeys = CancelKeys;
			_game._replayTimer = Timeout*1000;
			_game._replayCallback = Callback;
			_game._replayRequested = true;
		}
		
		/**
		 * Resets the game or state and replay requested flag.
		 * 
		 * @param	StandardMode	If true, reload entire game, else just reload current game state.
		 */
		public function reloadReplay(StandardMode:Boolean=true):void
		{
			if(StandardMode)
				FlxG.resetGame();
			else
				FlxG.resetState();
			if(_game._replay.frameCount > 0)
				_game._replayRequested = true;
		}
		
		/**
		 * Stops the current replay.
		 */
		public function stopReplay():void
		{
			_game._replaying = false;
			if(_game._debugger != null)
				_game._debugger.vcr.stopped();
			
			FlxG.resetInput();
		}
		
		/**
		 * Resets the game or state and requests a new recording.
		 * 
		 * @param	StandardMode	If true, reset the entire game, else just reset the current state.
		 */
		public function recordReplay(StandardMode:Boolean=true):void
		{
			if(StandardMode)
				FlxG.resetGame();
			else
				FlxG.resetState();
			_game._recordingRequested = true;
		}
		
		/**
		 * Stop recording the current replay and return the replay data.
		 * 
		 * @return	The replay data in simple ASCII format (see <code>FlxReplay.save()</code>).
		 */
		public function stopRecording():String
		{
			_game._recording = false;
			if(_game._debugger != null)
				_game._debugger.vcr.stopped();
			return _game._replay.save();
		}
	}
}
