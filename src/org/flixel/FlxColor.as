package org.flixel 
{
	/**
	 * Static class containing color constants plus a few helper functions from FlxU
	 */
	public class FlxColor 
	{
		/**
		 * Some handy color presets.  Less glaring than pure RGB full values.
		 * Primarily used in the visual debugger mode for bounding box displays.
		 * Red is used to indicate an active, movable, solid object.
		 */
		static public const RED:uint = 0xffff0012;
		/**
		 * Green is used to indicate solid but immovable objects.
		 */
		static public const GREEN:uint = 0xff00f225;
		/**
		 * Blue is used to indicate non-solid objects.
		 */
		static public const BLUE:uint = 0xff0090e9;
		/**
		 * Pink is used to indicate objects that are only partially solid, like one-way platforms.
		 */
		static public const PINK:uint = 0xfff01eff;
		/**
		 * White... for white stuff.
		 */
		static public const WHITE:uint = 0xffffffff;
		/**
		 * And black too.
		 */
		static public const BLACK:uint = 0xff000000;
		
				
		/**
		 * Generate a Flash <code>uint</code> color from RGBA components.
		 * 
		 * @param   Red     The red component, between 0 and 255.
		 * @param   Green   The green component, between 0 and 255.
		 * @param   Blue    The blue component, between 0 and 255.
		 * @param   Alpha   How opaque the color should be, either between 0 and 1 or 0 and 255.
		 * 
		 * @return  The color as a <code>uint</code>.
		 */
		static public function makeColor(Red:uint, Green:uint, Blue:uint, Alpha:Number=1.0):uint
		{
			return (((Alpha>1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | (Red & 0xFF) << 16 | (Green & 0xFF) << 8 | (Blue & 0xFF);
		}
		
		/**
		 * Generate a grayscale Flash <code>uint</code> color from brightness and alpha.
		 * 
		 * @param   Brightness	How "light" the black should be. Pass 1 for white, 0 for black, and all tones in between.
		 * @param   Alpha   How opaque the color should be, either between 0 and 1 or 0 and 255.
		 * 
		 * @return  The color as a <code>uint</code>.
		 */
		// Should I allow them to pass from 0 to 255 for the "Brightness" parameter as well?
		static public function makeGray(Brightness:Number, Alpha:Number=1.0):uint
		{
			var tone:uint = (Brightness * 255) & 0xFF;
			return (((Alpha>1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | tone << 16 | tone << 8 | tone;
		}

		/**
		 * Generate a Flash <code>uint</code> color from HSB components.
		 * 
		 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
		 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
		 * @param	Brightness	A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright.
		 * @param   Alpha   	How opaque the color should be, either between 0 and 1 or 0 and 255.
		 * 
		 * @return	The color as a <code>uint</code>.
		 */
		static public function makeColorFromHSB(Hue:Number,Saturation:Number,Brightness:Number,Alpha:Number=1.0):uint
		{
			var red:Number;
			var green:Number;
			var blue:Number;
			if(Saturation == 0.0)
			{
				red   = Brightness;
				green = Brightness;        
				blue  = Brightness;
			}       
			else
			{
				if(Hue == 360)
					Hue = 0;
				var slice:int = Hue/60;
				var hf:Number = Hue/60 - slice;
				var aa:Number = Brightness*(1 - Saturation);
				var bb:Number = Brightness*(1 - Saturation*hf);
				var cc:Number = Brightness*(1 - Saturation*(1.0 - hf));
				switch (slice)
				{
					case 0: red = Brightness; green = cc;   blue = aa;  break;
					case 1: red = bb;  green = Brightness;  blue = aa;  break;
					case 2: red = aa;  green = Brightness;  blue = cc;  break;
					case 3: red = aa;  green = bb;   blue = Brightness; break;
					case 4: red = cc;  green = aa;   blue = Brightness; break;
					case 5: red = Brightness; green = aa;   blue = bb;  break;
					default: red = 0;  green = 0;    blue = 0;   break;
				}
			}
			
			return (((Alpha>1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | uint(red*255) << 16 | uint(green*255) << 8 | uint(blue*255);
		}
		
		/**
		 * Loads an array with the RGBA values of a Flash <code>uint</code> color.
		 * RGB values are stored 0-255.  Alpha is stored as a floating point number between 0 and 1.
		 * 
		 * @param	Color	The color you want to break into components.
		 * @param	Results	An optional parameter, allows you to use an array that already exists in memory to store the result.
		 * 
		 * @return	An <code>Array</code> object containing the Red, Green, Blue and Alpha values of the given color.
		 */
		 
		static public function getRGBA(Color:uint,Results:Array=null):Array
		{
			if(Results == null)
				Results = new Array();
			Results[0] = (Color >> 16) & 0xFF;
			Results[1] = (Color >> 8) & 0xFF;
			Results[2] = Color & 0xFF;
			Results[3] = Number((Color >> 24) & 0xFF) / 255;
			return Results;
		}
		
		/**
		 * Loads an array with the HSB values of a Flash <code>uint</code> color.
		 * Hue is a value between 0 and 360.  Saturation, Brightness and Alpha
		 * are as floating point numbers between 0 and 1.
		 * 
		 * @param	Color	The color you want to break into components.
		 * @param	Results	An optional parameter, allows you to use an array that already exists in memory to store the result.
		 * 
		 * @return	An <code>Array</code> object containing the Red, Green, Blue and Alpha values of the given color.
		 */
		static public function getHSB(Color:uint,Results:Array=null):Array
		{
			if(Results == null)
				Results = new Array();
			
			var red:Number = Number((Color >> 16) & 0xFF) / 255;
			var green:Number = Number((Color >> 8) & 0xFF) / 255;
			var blue:Number = Number((Color) & 0xFF) / 255;
			
			var m:Number = (red>green)?red:green;
			var dmax:Number = (m>blue)?m:blue;
			m = (red>green)?green:red;
			var dmin:Number = (m>blue)?blue:m;
			var range:Number = dmax - dmin;
			
			Results[2] = dmax;
			Results[1] = 0;
			Results[0] = 0;
			
			if(dmax != 0)
				Results[1] = range / dmax;
			if(Results[1] != 0) 
			{
				if (red == dmax)
					Results[0] = (green - blue) / range;
				else if (green == dmax)
					Results[0] = 2 + (blue - red) / range;
				else if (blue == dmax)
					Results[0] = 4 + (red - green) / range;
				Results[0] *= 60;
				if(Results[0] < 0)
					Results[0] += 360;
			}
			
			Results[3] = Number((Color >> 24) & 0xFF) / 255;
			return Results;
		}
	}
}
