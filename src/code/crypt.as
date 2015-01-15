package code
{
	
	public class crypt
	{
		public static const letterList:Array = ["m","y","w","c","q","a","p","r","e","o"];
		
		public static function checkSumCreate(param1:String):int
		{
			var sum:int = 15;
			for (var x:int = 0; x < param1.length; x++)
			{
				sum += convertCharToBase26(param1.charAt(x));
			}
			sum *= 3;
			return sum;
		}
		
		public static function getLength(param1:int, param2:int):String
		{
			var total:int = param1 + param2 + 1;
			var totalString:String = total.toString();
			var totalLength:int = totalString.length;
			if (totalString.length != param1)
			{
				return getLength(totalLength, param2);
			}
			return totalLength.toString() + totalString.toString();
		}
		
		public static function getLengthString(string:String):String
		{
			var outputLength:int = string.length;
			var outputLengthLength:int = outputLength.toString().length;
			return convertIntToString(parseInt(getLength(outputLengthLength, outputLength)));
		}
		
		public static function convertCharToBase26(char:String):int
		{
			var cc:int = char.toLowerCase().charCodeAt(0);
			if (cc >= 97 && cc <= 122) return cc - 96;
			return Number(char);
		}
		
		public static function convertStringToIntString(param1:String):String
		{
			var currentChar:String = "";
			var currentInt:String = "";
			var offset:Number = 0;
			var output:String = "";
			while (offset < param1.length)
			{
				currentChar = param1.charAt(offset);
				currentInt = convertToInt(currentChar);
				if (currentInt == "-1")
				{
					return "-100";
				}
				output += currentInt;
				offset++;
			}
			return output;
		}
		
		public static function convertStringToInt(param1:String):int
		{
			return int(convertStringToIntString(param1));
		}
		
		public static function convertIntToString(param1:int):String
		{
			var currentString:String = "";
			var offset:Number = 0;
			var output:String = "";
			var paramString:String = param1.toString();
			while (offset < paramString.length)
			{
				currentString = convertToString(int(paramString.charAt(offset)));
				if (currentString == "-1")
				{
					return "-100";
				}
				output += currentString;
				offset++;
			}
			return output;
		}
		
		public static function convertToInt(param1:String):String
		{
			return String(letterList.indexOf(param1));
		}
		
		public static function convertToString(param1:int):String
		{
			if (param1 < letterList.length)
			{
				return letterList[param1];
			}
			return "-1";
		}
	
	}
}