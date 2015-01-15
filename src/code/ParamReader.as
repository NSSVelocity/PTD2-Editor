package code 
{
	public class ParamReader 
	{
		public var offset:int = 0;
		public var text:String;
		public var textd:String;
		
		public function ParamReader(param:String, skipChecksum:Boolean = true) 
		{
			this.text = param;
			this.textd = crypt.convertStringToIntString(param);
			if(skipChecksum) readTag();
		}
		
		public function readTagSmall():int
		{
			return crypt.convertStringToInt(text.charAt(offset++));
		}
		
		public function readTag():int
		{
			var strLength:int = crypt.convertStringToInt(text.charAt(offset++));
			var returnVal:int = crypt.convertStringToInt(text.substr(offset, strLength));
			offset += strLength;
			
			return returnVal;
		}
		
		public function readTagLong():int
		{
			var strLengthLong:int = crypt.convertStringToInt(text.charAt(offset++));
			var strLength:int = crypt.convertStringToInt(text.substr(offset, strLengthLong));
			var returnVal:int = crypt.convertStringToInt(text.substr(offset+strLengthLong, strLength));
			offset += strLength+strLengthLong;
				
			return returnVal;
		}
		
		
		public function readTagString():String
		{
			var strLength:int = crypt.convertStringToInt(text.charAt(offset++));
			var returnVal:String = text.substr(offset, strLength);
			offset += strLength;
			
			return returnVal;
		}
		
		
	}

}