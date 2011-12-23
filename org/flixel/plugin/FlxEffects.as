package org.flixel.plugin 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	
	/**
	 * Contains functions for making special effects.
	 */
	public class FlxEffects extends FlxBasic
	{
		// There must be a better way than any of these options:
		//	- Accessing the static property "FlxG.cameras"
		//	- Passing a reference to the cameras array in the constructor
		//  - Passing a reference to the Class "FlxG" (not an instance) and accessing the "cameras" property dynamically. :(
		// If only FlxG was an instance, we could keep track of it.
		// For now, we will access the static property. :(
		// EDIT: Solved by extending "FlxBasic". Now I have a cameras property. :D
		public function FlxEffects()
		{
			
		}
		
		/**
		 * All screens are filled with this color and gradually return to normal.
		 * 
		 * @param	Color		The color you want to use.
		 * @param	Duration	How long it takes for the flash to fade.
		 * @param	OnComplete	A function you want to run when the flash finishes.
		 * @param	Force		Force the effect to reset.
		 */
		public function flash(Color:uint=0xffffffff, Duration:Number=1, OnComplete:Function=null, Force:Boolean=false):void
		{
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
				(cameras[i++] as FlxCamera).flash(Color,Duration,OnComplete,Force);
		}
		
		/**
		 * The screen is gradually filled with this color.
		 * 
		 * @param	Color		The color you want to use.
		 * @param	Duration	How long it takes for the fade to finish.
		 * @param	OnComplete	A function you want to run when the fade finishes.
		 * @param	Force		Force the effect to reset.
		 */
		public function fade(Color:uint=0xff000000, Duration:Number=1, OnComplete:Function=null, Force:Boolean=false):void
		{
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
				(cameras[i++] as FlxCamera).fade(Color,Duration,OnComplete,Force);
		}
		
		/**
		 * A simple screen-shake effect.
		 * 
		 * @param	Intensity	Percentage of screen size representing the maximum distance that the screen can move while shaking.
		 * @param	Duration	The length in seconds that the shaking effect should last.
		 * @param	OnComplete	A function you want to run when the shake effect finishes.
		 * @param	Force		Force the effect to reset (default = true, unlike flash() and fade()!).
		 * @param	Direction	Whether to shake on both axes, just up and down, or just side to side (use class constants SHAKE_BOTH_AXES, SHAKE_VERTICAL_ONLY, or SHAKE_HORIZONTAL_ONLY).  Default value is SHAKE_BOTH_AXES (0).
		 */
		public function shake(Intensity:Number=0.05, Duration:Number=0.5, OnComplete:Function=null, Force:Boolean=true, Direction:uint=0):void
		{
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
				(cameras[i++] as FlxCamera).shake(Intensity,Duration,OnComplete,Force,Direction);
		}
	}
}
