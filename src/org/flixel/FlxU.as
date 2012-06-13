package org.flixel
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	public class FlxU
	{
		/**
		 * Opens a web page in a new tab or window.
		 * MUST be called from the UI thread or else badness.
		 * 
		 * @param	URL		The address of the web page.
		 */
		static public function openURL(URL:String):void
		{
			navigateToURL(new URLRequest(URL), "_blank");
		}
		
		/**
		 * Shuffles the entries in an array into a new random order.
		 * <code>FlxG.shuffle()</code> is deterministic and safe for use with replays/recordings.
		 * HOWEVER, <code>FlxU.shuffle()</code> is NOT deterministic and unsafe for use with replays/recordings.
		 * 
		 * @param	A				A Flash <code>Array</code> object containing...stuff.
		 * @param	HowManyTimes	How many swaps to perform during the shuffle operation.  Good rule of thumb is 2-4 times as many objects are in the list.
		 * 
		 * @return	The same Flash <code>Array</code> object that you passed in in the first place.
		 */
		static public function shuffle(Objects:Array,HowManyTimes:uint):Array
		{
			var i:uint = 0;
			var index1:uint;
			var index2:uint;
			var object:Object;
			while(i < HowManyTimes)
			{
				index1 = Math.random()*Objects.length;
				index2 = Math.random()*Objects.length;
				object = Objects[index2];
				Objects[index2] = Objects[index1];
				Objects[index1] = object;
				i++;
			}
			return Objects;
		}
		
		/**
		 * Fetch a random entry from the given array.
		 * Will return null if random selection is missing, or array has no entries.
		 * <code>FlxG.getRandom()</code> is deterministic and safe for use with replays/recordings.
		 * HOWEVER, <code>FlxU.getRandom()</code> is NOT deterministic and unsafe for use with replays/recordings.
		 * 
		 * @param	Objects		A Flash array of objects.
		 * @param	StartIndex	Optional offset off the front of the array. Default value is 0, or the beginning of the array.
		 * @param	Length		Optional restriction on the number of values you want to randomly select from.
		 * 
		 * @return	The random object that was selected.
		 */
		static public function getRandom(Objects:Array,StartIndex:uint=0,Length:uint=0):Object
		{
			if(Objects != null)
			{
				var l:uint = Length;
				if((l == 0) || (l > Objects.length - StartIndex))
					l = Objects.length - StartIndex;
				if(l > 0)
					return Objects[StartIndex + uint(Math.random()*l)];
			}
			return null;
		}
		
		/**
		 * Just grabs the current "ticks" or time in milliseconds that has passed since Flash Player started up.
		 * Useful for finding out how long it takes to execute specific blocks of code.
		 * 
		 * @return	A <code>uint</code> to be passed to <code>FlxU.endProfile()</code>.
		 */
		static public function getTicks():uint
		{
			return getTimer();
		}
		
		/**
		 * Takes two "ticks" timestamps and formats them into the number of seconds that passed as a String.
		 * Useful for logging, debugging, the watch window, or whatever else.
		 * 
		 * @param	StartTicks	The first timestamp from the system.
		 * @param	EndTicks	The second timestamp from the system.
		 * 
		 * @return	A <code>String</code> containing the formatted time elapsed information.
		 */
		static public function formatTicks(StartTicks:uint,EndTicks:uint):String
		{
			return ((EndTicks-StartTicks)/1000)+"s";
		}
		
		/**
		 * Format seconds as minutes with a colon, an optionally with milliseconds too.
		 * 
		 * @param	Seconds		The number of seconds (for example, time remaining, time spent, etc).
		 * @param	ShowMS		Whether to show milliseconds after a "." as well.  Default value is false.
		 * 
		 * @return	A nicely formatted <code>String</code>, like "1:03".
		 */
		static public function formatTime(Seconds:Number,ShowMS:Boolean=false):String
		{
			var timeString:String = int(Seconds/60) + ":";
			var timeStringHelper:int = int(Seconds)%60;
			if(timeStringHelper < 10)
				timeString += "0";
			timeString += timeStringHelper;
			if(ShowMS)
			{
				timeString += ".";
				timeStringHelper = (Seconds-int(Seconds))*100;
				if(timeStringHelper < 10)
					timeString += "0";
				timeString += timeStringHelper;
			}
			return timeString;
		}
		
		/**
		 * Generate a comma-separated string from an array.
		 * Especially useful for tracing or other debug output.
		 * 
		 * @param	AnyArray	Any <code>Array</code> object.
		 * 
		 * @return	A comma-separated <code>String</code> containing the <code>.toString()</code> output of each element in the array.
		 */
		static public function formatArray(AnyArray:Array):String
		{
			if((AnyArray == null) || (AnyArray.length <= 0))
				return "";
			var string:String = AnyArray[0].toString();
			var i:uint = 1;
			var l:uint = AnyArray.length;
			while(i < l)
				string += ", " + AnyArray[i++].toString();
			return string;
		}
		
		/**
		 * Automatically commas and decimals in the right places for displaying money amounts.
		 * Does not include a dollar sign or anything, so doesn't really do much
		 * if you call say <code>var results:String = FlxU.formatMoney(10,false);</code>
		 * However, very handy for displaying large sums or decimal money values.
		 * 
		 * @param	Amount			How much moneys (in dollars, or the equivalent "main" currency - i.e. not cents).
		 * @param	ShowDecimal		Whether to show the decimals/cents component. Default value is true.
		 * @param	EnglishStyle	Major quantities (thousands, millions, etc) separated by commas, and decimal by a period.  Default value is true.
		 * 
		 * @return	A nicely formatted <code>String</code>.  Does not include a dollar sign or anything!
		 */
		static public function formatMoney(Amount:Number,ShowDecimal:Boolean=true,EnglishStyle:Boolean=true):String
		{
			var helper:int;
			var amount:int = Amount;
			var string:String = "";
			var comma:String = "";
			var zeroes:String = "";
			while(amount > 0)
			{
				if((string.length > 0) && comma.length <= 0)
				{
					if(EnglishStyle)
						comma = ",";
					else
						comma = ".";
				}
				zeroes = "";
				helper = amount - int(amount/1000)*1000;
				amount /= 1000;
				if(amount > 0)
				{
					if(helper < 100)
						zeroes += "0";
					if(helper < 10)
						zeroes += "0";
				}
				string = zeroes + helper + comma + string;
			}
			if(ShowDecimal)
			{
				amount = int(Amount*100)-(int(Amount)*100);
				string += (EnglishStyle?".":",") + amount;
				if(amount < 10)
					string += "0";
			}
			return string;
		}
		
		/**
		 * Get the <code>String</code> name of any <code>Object</code>.
		 * 
		 * @param	Obj		The <code>Object</code> object in question.
		 * @param	Simple	Returns only the class name, not the package or packages.
		 * 
		 * @return	The name of the <code>Class</code> as a <code>String</code> object.
		 */
		static public function getClassName(Obj:Object,Simple:Boolean=false):String
		{
			var string:String = getQualifiedClassName(Obj);
			string = string.replace("::",".");
			if(Simple)
				string = string.substr(string.lastIndexOf(".")+1);
			return string;
		}
		
		/**
		 * Check to see if two objects have the same class name.
		 * 
		 * @param	Object1		The first object you want to check.
		 * @param	Object2		The second object you want to check.
		 * 
		 * @return	Whether they have the same class name or not.
		 */
		static public function compareClassNames(Object1:Object,Object2:Object):Boolean
		{
			return getQualifiedClassName(Object1) == getQualifiedClassName(Object2);
		}
		
		/**
		 * Look up a <code>Class</code> object by its string name.
		 * 
		 * @param	Name	The <code>String</code> name of the <code>Class</code> you are interested in.
		 * 
		 * @return	A <code>Class</code> object.
		 */
		static public function getClass(Name:String):Class
		{
			return getDefinitionByName(Name) as Class;
		}
	}
}
