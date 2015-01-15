package code 
{

	public class ParamWriter 
	{
		private var string:String = "";
		private var stringd:String = "";
		
		public function getString():String
		{
			return string;
		}
		
		public function getStringDecode():String
		{
			return stringd;
		}
		
		public function writeTag(val:int, append:Boolean = true):void
		{
			var varLength:int = val.toString().length;
			if (!append) {
				string = crypt.convertIntToString(varLength) + crypt.convertIntToString(val) + string;
				stringd = varLength.toString() + val.toString() + stringd;
			} else {
				string += crypt.convertIntToString(varLength) + crypt.convertIntToString(val);
				stringd += varLength.toString() + val.toString();
			}
		}
		
		public function writeTagLong(val:int, append:Boolean = true):void
		{
			var varLength:int = val.toString().length;
			var varLengthLong:int = varLength.toString().length;
			if (!append) {
				string = crypt.convertIntToString(varLengthLong)+ crypt.convertIntToString(varLength) + crypt.convertIntToString(val) + string;
				stringd = varLengthLong.toString() + varLength.toString() + val.toString() + stringd;
			} else {
				string += crypt.convertIntToString(varLengthLong);
				string += crypt.convertIntToString(varLength);
				string += crypt.convertIntToString(val);
				stringd += varLengthLong.toString() + varLength.toString() + val.toString();
			}
		}
		
		public function writeTagString(val:String, append:Boolean = true):void
		{
			var varLength:int = val.length;
			if (!append) {
				string = crypt.convertIntToString(varLength) + val + string;
				stringd = varLength.toString() + val.toString() + stringd;
			} else {
				string += crypt.convertIntToString(varLength) + val;
				stringd += varLength.toString() + val.toString();
			}
		}
	}

}