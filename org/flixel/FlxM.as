package org.flixel 
{
	/**
	 * Contains all Flixel "Math" classes.
	 * 
	 * Moved from FlxU as it's much more organized here. :)
	 */
	public class FlxM 
	{
		
		/**
		 * Calculate the absolute value of a number.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The absolute value of that number.
		 */
		static public function abs(Value:Number):Number
		{
			return (Value>0)?Value:-Value;
		}
		
		/**
		 * Round down to the next whole number. E.g. floor(1.7) == 1, and floor(-2.7) == -2.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		static public function floor(Value:Number):Number
		{
			var number:Number = int(Value);
			return (Value>0)?(number):((number!=Value)?(number-1):(number));
		}
		
		/**
		 * Round up to the next whole number.  E.g. ceil(1.3) == 2, and ceil(-2.3) == -3.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		static public function ceil(Value:Number):Number
		{
			var number:Number = int(Value);
			return (Value>0)?((number!=Value)?(number+1):(number)):(number);
		}
		
		/**
		 * Round to the closest whole number. E.g. round(1.7) == 2, and round(-2.3) == -2.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		static public function round(Value:Number):Number
		{
			var number:Number = int(Value+0.5);
			return (Value>0)?(number):((number!=Value)?(number-1):(number));
		}
		
		/**
		 * Figure out which number is smaller.
		 * 
		 * @param	Number1		Any number.
		 * @param	Number2		Any number.
		 * 
		 * @return	The smaller of the two numbers.
		 */
		static public function min(Number1:Number,Number2:Number):Number
		{
			return (Number1 <= Number2)?Number1:Number2;
		}
		
		/**
		 * Figure out which number is larger.
		 * 
		 * @param	Number1		Any number.
		 * @param	Number2		Any number.
		 * 
		 * @return	The larger of the two numbers.
		 */
		static public function max(Number1:Number,Number2:Number):Number
		{
			return (Number1 >= Number2)?Number1:Number2;
		}
		
		/**
		 * Bound a number by a minimum and maximum.
		 * Ensures that this number is no smaller than the minimum,
		 * and no larger than the maximum.
		 * 
		 * @param	Value	Any number.
		 * @param	Min		Any number.
		 * @param	Max		Any number.
		 * 
		 * @return	The bounded value of the number.
		 */
		static public function bound(Value:Number,Min:Number,Max:Number):Number
		{
			var lowerBound:Number = (Value<Min)?Min:Value;
			return (lowerBound>Max)?Max:lowerBound;
		}
		
		/**
		 * Generates a random number based on the seed provided.
		 * 
		 * @param	Seed	A number between 0 and 1, used to generate a predictable random number (very optional).
		 * 
		 * @return	A <code>Number</code> between 0 and 1.
		 */
		static public function srand(Seed:Number):Number
		{
			return ((69621 * int(Seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
		}
		
		
		/**
		 * A tween-like function that takes a starting velocity
		 * and some other factors and returns an altered velocity.
		 * 
		 * @param	Velocity		Any component of velocity (e.g. 20).
		 * @param	Acceleration	Rate at which the velocity is changing.
		 * @param	Drag			Really kind of a deceleration, this is how much the velocity changes if Acceleration is not set.
		 * @param	Max				An absolute value cap for the velocity.
		 * 
		 * @return	The altered Velocity value.
		 */
		static public function computeVelocity(Velocity:Number, Acceleration:Number=0, Drag:Number=0, Max:Number=10000):Number
		{
			if(Acceleration != 0)
				Velocity += Acceleration*FlxG.elapsed;
			else if(Drag != 0)
			{
				var drag:Number = Drag*FlxG.elapsed;
				if(Velocity - drag > 0)
					Velocity = Velocity - drag;
				else if(Velocity + drag < 0)
					Velocity += drag;
				else
					Velocity = 0;
			}
			if((Velocity != 0) && (Max != 10000))
			{
				if(Velocity > Max)
					Velocity = Max;
				else if(Velocity < -Max)
					Velocity = -Max;
			}
			return Velocity;
		}
		
		//*** NOTE: THESE LAST THREE FUNCTIONS REQUIRE FLXPOINT ***//
		
		/**
		 * Rotates a point in 2D space around another point by the given angle.
		 * 
		 * @param	X		The X coordinate of the point you want to rotate.
		 * @param	Y		The Y coordinate of the point you want to rotate.
		 * @param	PivotX	The X coordinate of the point you want to rotate around.
		 * @param	PivotY	The Y coordinate of the point you want to rotate around.
		 * @param	Angle	Rotate the point by this many degrees.
		 * @param	Point	Optional <code>FlxPoint</code> to store the results in.
		 * 
		 * @return	A <code>FlxPoint</code> containing the coordinates of the rotated point.
		 */
		static public function rotatePoint(X:Number, Y:Number, PivotX:Number, PivotY:Number, Angle:Number,Point:FlxPoint=null):FlxPoint
		{
			var sin:Number = 0;
			var cos:Number = 0;
			var radians:Number = Angle * -0.017453293;
			while (radians < -3.14159265)
				radians += 6.28318531;
			while (radians >  3.14159265)
				radians = radians - 6.28318531;
			
			if (radians < 0)
			{
				sin = 1.27323954 * radians + .405284735 * radians * radians;
				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}
			else
			{
				sin = 1.27323954 * radians - 0.405284735 * radians * radians;
				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}
			
			radians += 1.57079632;
			if (radians >  3.14159265)
				radians = radians - 6.28318531;
			if (radians < 0)
			{
				cos = 1.27323954 * radians + 0.405284735 * radians * radians;
				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			else
			{
				cos = 1.27323954 * radians - 0.405284735 * radians * radians;
				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			
			var dx:Number = X-PivotX;
			var dy:Number = PivotY+Y; //Y axis is inverted in flash, normally this would be a subtract operation
			if(Point == null)
				Point = new FlxPoint();
			Point.x = PivotX + cos*dx - sin*dy;
			Point.y = PivotY - sin*dx - cos*dy;
			return Point;
		};
		
		/**
		 * Calculates the angle between two points.  0 degrees points straight up.
		 * 
		 * @param	Point1		The X coordinate of the point.
		 * @param	Point2		The Y coordinate of the point.
		 * 
		 * @return	The angle in degrees, between -180 and 180.
		 */
		static public function getAngle(Point1:FlxPoint, Point2:FlxPoint):Number
		{
			var x:Number = Point2.x - Point1.x;
			var y:Number = Point2.y - Point1.y;
			if((x == 0) && (y == 0))
				return 0;
			var c1:Number = 3.14159265 * 0.25;
			var c2:Number = 3 * c1;
			var ay:Number = (y < 0)?-y:y;
			var angle:Number = 0;
			if (x >= 0)
				angle = c1 - c1 * ((x - ay) / (x + ay));
			else
				angle = c2 - c1 * ((x + ay) / (ay - x));
			angle = ((y < 0)?-angle:angle)*57.2957796;
			if(angle > 90)
				angle = angle - 270;
			else
				angle += 90;
			return angle;
		};
		
		/**
		 * Calculate the distance between two points.
		 * 
		 * @param Point1	A <code>FlxPoint</code> object referring to the first location.
		 * @param Point2	A <code>FlxPoint</code> object referring to the second location.
		 * 
		 * @return	The distance between the two points as a floating point <code>Number</code> object.
		 */
		static public function getDistance(Point1:FlxPoint,Point2:FlxPoint):Number
		{
			var dx:Number = Point1.x - Point2.x;
			var dy:Number = Point1.y - Point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
	}
}
