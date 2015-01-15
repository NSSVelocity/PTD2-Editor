package code 
{

	public class profile_poke extends Object 
	{
		public var saveID:int = 0;
		public var saveInfo:profile_poke_save = new profile_poke_save();
		public var myTag:String = "n";
		public var pos:int;
		public var item:int;
		
		public var name:String = "";
		public var nickname:String = "";
		public var id:int = 0;
		public var num:int = 1;
		public var level:int = 1;
		public var experience:int = 0;
		public var gender:int = 1;
		public var shiny:int = 0;
		public var form:int = 0;
		
		public var move1:int = 1;
		public var move2:int = 0;
		public var move3:int = 0;
		public var move4:int = 0;
		public var moveSelected:int = 1;
		public var targetingType:int = 1;

		public var originalOwner:int = 0;
		
		public function isLegal():Boolean
		{
			return ((level > 0 && level <= 110) && (shiny >= 0 && shiny <= 2) && (num >= 1 && num <= 718 || num == 1010 || num >= 2500 && num <= 2508));
		}
		
		public function updateShinyExtra():void
		{
			saveInfo.extra = (shiny == 2 ? num + 5 : (shiny == 1 ? num : 0));
		}
		
		public function clone():profile_poke
		{
			var pkmn:profile_poke = new profile_poke();
			pkmn.nickname = this.nickname;
			pkmn.gender = this.gender;
			pkmn.num = this.num;
			pkmn.level = this.level;
			pkmn.experience = this.experience;
			pkmn.shiny = this.shiny;
			pkmn.move1 = this.move1;
			pkmn.move2 = this.move2;
			pkmn.move3 = this.move3;
			pkmn.move4 = this.move4;
			pkmn.item = this.item;
			pkmn.myTag = this.myTag;
			pkmn.saveInfo.needCaptured = true;
			return pkmn;
		}
	}

}