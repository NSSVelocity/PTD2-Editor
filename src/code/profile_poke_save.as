package code
{
	public class profile_poke_save extends Object
	{
		public var extra:int;
		public var isNew:Boolean;
		public var posChange:Boolean;
		public var needEvolve:Boolean;
		public var needLevel:Boolean;
		public var needExp:Boolean;
		public var needMoves:Boolean;
		public var needCaptured:Boolean;
		public var needTag:Boolean;
		public var needTarget:Boolean;
		public var needAbility:Boolean;
		public var needNickname:Boolean;
		public var needMoveSelected:Boolean;
		public var needItem:Boolean;
		public var needTrade:Boolean;
		
		public function profile_poke_save():void
		{
			reset();
		}
		
		public function need_Save():Boolean
		{
			return (posChange || needEvolve || needLevel || needExp || needMoves || needCaptured || needTag || needTarget || needNickname || needMoveSelected || needTrade || needAbility || needItem);
		}
		
		public function reset():void
		{
			extra = 0;	// 0 = Regular, Pokemon Number = Shiny, Pokemon Number + 5 = Shadow
			posChange = false;
			posChange = false;
			needEvolve = false;
			needLevel = false;
			needExp = false;
			needMoves = false;
			needCaptured = false;
			needTag = false;
			needTarget = false;
			needNickname = false;
			needMoveSelected = false;
			needAbility = false;
			needTrade = false;
			needItem = false;
		}
	}
}
