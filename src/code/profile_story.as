package code
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class profile_story extends EventDispatcher
	{
		// Events
		public static const PROFILE_LOAD_SUCCESS:String = "profileLoadSuccess";
		public static const PROFILE_LOAD_ERROR:String = "profileLoadError";
		private var evt_loadSuccess:Event = new Event(PROFILE_LOAD_SUCCESS);
		private var evt_loadError:Event = new Event(PROFILE_LOAD_ERROR);
		
		public var acc:account;
		
		public var saveData:profile_story_save;
		public var id:int;
		public var nickname:String;
		public var money:int;
		public var badges:int;
		public var currentSave:String;
		public var version:String;
		
		public var currentMap:int;
		public var currentSpot:int;
		public var currentTime:int;
		public var myGender:int;
		public var myAvatarGender:String;
		
		public var pokemon:Array = [];
		public var items:Array = [];
		public var extraInfo:Array = [];
		
		private var loader:URLLoader;
		
		public function profile_story(accc:account)
		{
			this.acc = accc;
		}
		
		public function loadStory():void
		{
			var variables:URLVariables = new URLVariables();
			variables.ver = Constants.GAME_VERSION;
			variables.Email = acc.email;
			variables.Pass = acc.password;
			variables.Action = "loadStoryProfile";
			variables.whichProfile = this.id;
			
			var request:URLRequest = new URLRequest(Constants.SAVE_PHP + new Date().getTime());
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, e_StoryProfileLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, e_StoryProfileFail);
			loader.load(request);
			trace("0:Loading Story Profile...");
		}
		
		private function e_StoryProfileLoad(e:Event):void
		{
			var vars:Object = e.target.data;
			if (vars["Result"] && vars["Result"] == "Success")
			{
				trace("4:Story Profile #"+this.id+" Loaded");
				_loadStoryData(vars);
				this.dispatchEvent(evt_loadSuccess);
			}
			else {
				trace("3:Profile Story #" + this.id + " Loaded, but returned an error." + (vars["Result"] ? " (" + vars["Result"] + ")" : "(Unknown)"));
				this.dispatchEvent(evt_loadError);
			}
		}
		
		private function e_StoryProfileFail(e:Event):void
		{
			trace("3:Story Profile Load Failure...");
			this.dispatchEvent(evt_loadError);
		}
		
		private function _resetVariables():void
		{
			saveData = new profile_story_save();
			this.currentSave = null;
			this.myAvatarGender = null;
			this.myGender = 0;
			this.currentMap = 0;
			this.currentSpot = 0;
			this.currentTime = 100;
			this.pokemon = [];
			this.items = [];
			this.extraInfo = [];
		}
		
		public function _loadStoryData(vars:Object):void
		{
			var loopVal:int = 0;
			var loopValTotal:int = 0;
			
			_resetVariables();
			
			var newPoke:profile_poke = null;
			
			// Profile Information
			this.currentSave = vars.CS;
			this.myGender = vars.Gender;
			this.myAvatarGender = this.myGender == 1 ? "boy" : "girl";
			
			// Map Location
			var currentParam:ParamReader = new ParamReader(vars["extra"]);
			
			this.currentMap = currentParam.readTag();
			this.currentSpot = currentParam.readTag();
			
			// Etxra Values
			currentParam = new ParamReader(vars["extra2"]);
			loopValTotal = currentParam.readTag();
			for (loopVal = 1; loopVal <= loopValTotal; loopVal++)
			{
				this.add_Extra_Value(currentParam.readTag(), currentParam.readTag());
			}
			
			// Profile Items
			currentParam = new ParamReader(vars["extra4"]);
			loopValTotal = currentParam.readTag();
			for (loopVal = 1; loopVal <= loopValTotal; loopVal++)
			{
				this.add_Item(currentParam.readTag(), currentParam.readTag());
			}
			
			// Profile Pokemon
			currentParam = new ParamReader(vars["extra3"]);
			loopValTotal = currentParam.readTag();
			for (loopVal = 1; loopVal <= loopValTotal; loopVal++)
			{
				// Create Pokemon
				newPoke = new profile_poke();
				newPoke.nickname = vars["PN" + loopVal];
				newPoke.num = currentParam.readTag();
				newPoke.experience = currentParam.readTagLong();
				newPoke.level = currentParam.readTag();
				newPoke.move1 = currentParam.readTag();
				newPoke.move2 = currentParam.readTag();
				newPoke.move3 = currentParam.readTag();
				newPoke.move4 = currentParam.readTag();
				newPoke.targetingType = currentParam.readTag();
				newPoke.gender = currentParam.readTag();
				newPoke.saveID = currentParam.readTagLong();
				newPoke.pos = currentParam.readTag();
				newPoke.shiny = currentParam.readTag();
				newPoke.item = currentParam.readTag();
				newPoke.myTag = currentParam.readTagString();
				pokemon.push(newPoke);
			}
			
			//trace("2:Legal - Pokemon:", checkLegalPokemon());
			//trace("2:Legal - Items:", checkLegalItems());
		}
		
		public function add_Item(item:int, val:int, isNew:Boolean = false, save:Boolean = false):void
		{
			items[item] = {"id": item, "value": val, "isNew": isNew, "save": save};
		}
		
		public function add_Extra_Value(tag:int, val:int, isNew:Boolean = false, save:Boolean = false):void
		{
			extraInfo[tag] = {"id": tag, "value": val, "isNew": isNew, "save": save};
		}
		
		// Save Functions
		public function saveStory():void
		{
			var pkmn:Array = _savePokemon();
			var pkmnsum:String = crypt.convertIntToString(crypt.checkSumCreate(pkmn[0] + currentSave));
			var pkdex:Array = _savePokedex();
			
			var variables:URLVariables = new URLVariables();
			variables.Action = "saveStory";
            variables.Email = acc.email;
            variables.Pass = acc.password;
            variables.whichProfile = id;
            variables.ver = Constants.GAME_VERSION;
            variables.extra = _saveGameInfo() + pkmn[1]; // Pokemon Nicknames
            variables.extra2 = _saveExtraTags();
            variables.extra3 = pkmn[0]; // Pokemon
            variables.extra4 = _saveInventory(); 
            variables.extra5 = pkmnsum;
            variables.needD = 1;
            variables.dextra1 = pkdex[1][0];
            variables.dcextra1 = pkdex[1][1];
            variables.dextra2 = pkdex[2][0];
            variables.dcextra2 = pkdex[2][1];
            variables.dextra3 = pkdex[3][0];
            variables.dcextra3 = pkdex[3][1];
            variables.dextra4 = pkdex[4][0];
            variables.dcextra4 = pkdex[4][1];
            variables.dextra5 = pkdex[5][0];
            variables.dcextra5 = pkdex[5][1];
            variables.dextra6 = pkdex[6][0];
            variables.dcextra6 = pkdex[6][1];
			
			var request:URLRequest = new URLRequest(Constants.SAVE_PHP + new Date().getTime());
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, e_ProfileSaveLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, e_ProfileSaveFail);
			loader.load(request);
			trace("0:Saving Story Profile #" + id + "...");
		}
		
		private function _saveGameInfo():String
		{
			var saveInfo:String = "Save=true";
			
			if(saveData.newGame)
			{
				saveInfo += "&NewGameSave=true";
				saveInfo += "&Nickname=" + nickname;
				saveInfo += "&Color=" + version;
				saveInfo += "&Gender=" + myGender;
			}
			
			if(saveData.needMapSave)
			{
				saveInfo += "&MapSave=true";
				saveInfo += "&MapLoc=" + currentMap;
				saveInfo += "&MapSpot=" + currentSpot;
			}
			
			saveInfo += "&CS=" + currentSave;
			
			if(saveData.needTimeSave)
			{
				saveInfo += "&TimeSave=true";
				saveInfo += "&CT=" + currentTime;
			}

			if(saveData.needMoneySave)
			{
				saveInfo += "&MSave=true";
				saveInfo += "&MA=" + crypt.convertIntToString(money);
			}
			return saveInfo;
		}
		
		private function _saveExtraTags():String 
		{
			var changeTotal:int = 0;
			var out:ParamWriter = new ParamWriter();
			for each (var item:Object in this.extraInfo) 
			{
				if (item.save)
				{
					out.writeTag(item.id);
					out.writeTag(item.value);
					changeTotal++;
				}
			}
			out.writeTag(changeTotal, false);
			
			return crypt.getLengthString(out.getString()) + out.getString();
		}
		
		private function _saveInventory():String 
		{
			var changeTotal:int = 0;
			var out:ParamWriter = new ParamWriter();
			for each (var item:Object in this.items) 
			{
				if (item.save || (!GameInfo.isItemLegal(item.id) && !item.isNew))
				{
					out.writeTag(item.id);
					out.writeTag(GameInfo.isItemLegal(item.id) ? item.value : 0); // Prevent Illegal item.
					changeTotal++;
				}
			}
			out.writeTag(changeTotal, false);
			
			return crypt.getLengthString(out.getString()) + out.getString();
		}
		
		private function _savePokedex():Array 
		{
			var out:Array = [];
			
			for (var i:int = 1; i <= 6; i++)
			{
				var pokedex:Array = acc.pokedexs[i];
				var pout:String = "";
				for (var p:int = 0; p < pokedex.length; p++)
				{
					pout += crypt.convertToString(acc.getDexStringFromInfo(pokedex[p]));
				}
				out[i] = [pout, crypt.convertIntToString(crypt.checkSumCreate(pout + this.currentSave))];
			}
			return out;
		}
		
		private function _savePokemon():Array
		{
			var output:String = "";
			var pkmnWrite:ParamWriter = new ParamWriter();
			var nickNames:String = "";
			var currentPoke:profile_poke;
			var currentPokeSave:profile_poke_save;
			var totalSaved:int = 0;
			var totalChanges:int = 0;
			
			// Remove Invalid Pokemon
			for (var loopVal:int = pokemon.length - 1; loopVal >= 0; loopVal-- )
			{
				currentPoke = pokemon[loopVal];
				if (!currentPoke.isLegal()) {
					trace("Removing Invalid Pokemon");
					pokemon.splice(loopVal, 1);
				}
			}
			
			// Save
			for (loopVal = 0; loopVal < pokemon.length; loopVal++ )
			{
				currentPoke = pokemon[loopVal];
				currentPokeSave = currentPoke.saveInfo;
				totalChanges = 0;
				if (currentPoke.pos != loopVal)
				{
					currentPokeSave.posChange = true;
				}
				currentPoke.pos = loopVal;
				if (currentPokeSave.need_Save())
				{
					pkmnWrite = new ParamWriter();
					pkmnWrite.writeTagLong(currentPoke.saveID);
					
					totalSaved++;
					if (currentPokeSave.needCaptured)
					{
						currentPoke.updateShinyExtra();
						totalChanges++;
						pkmnWrite.writeTag(1);
						pkmnWrite.writeTag(currentPoke.num);
						pkmnWrite.writeTagLong(currentPoke.experience);
						pkmnWrite.writeTag(currentPoke.level);
						pkmnWrite.writeTag(currentPoke.move1);
						pkmnWrite.writeTag(currentPoke.move2);
						pkmnWrite.writeTag(currentPoke.move3);
						pkmnWrite.writeTag(currentPoke.move4);
						pkmnWrite.writeTag(currentPoke.targetingType);
						pkmnWrite.writeTag(currentPoke.gender);
						pkmnWrite.writeTag(currentPoke.pos);
						pkmnWrite.writeTag(currentPokeSave.extra);	// 0 = Normal, num = Shiny, num+5 = Shadow
						pkmnWrite.writeTag(currentPoke.item);
						pkmnWrite.writeTagString(currentPoke.myTag);
						nickNames += ("&PokeNick" + totalSaved + "=" + currentPoke.nickname);
					}
					else
					{
						if (currentPokeSave.needExp)
						{
							totalChanges++;
							pkmnWrite.writeTag(3);
							pkmnWrite.writeTagLong(currentPoke.experience);
							
						}
						if (currentPokeSave.needLevel)
						{
							totalChanges++;
							pkmnWrite.writeTag(2);
							pkmnWrite.writeTag(currentPoke.level);
						}
						if (currentPokeSave.needMoves)
						{
							totalChanges++;
							pkmnWrite.writeTag(4);
							pkmnWrite.writeTag(currentPoke.move1);
							pkmnWrite.writeTag(currentPoke.move2);
							pkmnWrite.writeTag(currentPoke.move3);
							pkmnWrite.writeTag(currentPoke.move4);
						}
						if (currentPokeSave.needItem)
						{
							totalChanges++;
							pkmnWrite.writeTag(5);
							pkmnWrite.writeTag(currentPoke.item);
						}
						if (currentPokeSave.needEvolve)
						{
							totalChanges++;
							pkmnWrite.writeTag(6);
							pkmnWrite.writeTag(currentPoke.num);
						}
						if (currentPokeSave.needTrade)
						{
							totalChanges++;
							pkmnWrite.writeTag(10);
							pkmnWrite.writeTag(currentPoke.num);
						}
						if (currentPokeSave.needNickname)
						{
							totalChanges++;
							pkmnWrite.writeTag(7);
							nickNames += ("&PokeNick" + totalSaved + "=" + currentPoke.nickname);
						}
						if (currentPokeSave.posChange)
						{
							totalChanges++;
							pkmnWrite.writeTag(8);
							pkmnWrite.writeTag(currentPoke.pos);
							
						}
						if (currentPokeSave.needTag)
						{
							totalChanges++;
							pkmnWrite.writeTag(9);
							pkmnWrite.writeTagString(currentPoke.myTag);
						}
					}
					pkmnWrite.writeTag(totalChanges, false);
					
					output += pkmnWrite.getString();
				}
			}
			
			// Write Total Pokemon Changed
			var varLength:int = totalSaved.toString().length;
			output = crypt.convertIntToString(varLength) + crypt.convertIntToString(totalSaved) + output;
			
			// Write Checksum
			return [crypt.getLengthString(output) + output, nickNames];
		}
				
		private function e_ProfileSaveLoad(e:Event):void
		{
			var vars:URLVariables = e.target.data;
			if ((vars["Result"] && vars["Result"] == "Success") || (vars["Reason"] && vars["Reason"] == "saved"))
			{
				this.dispatchEvent(evt_loadSuccess);
				this.currentSave = vars["CS"];
				_pokemonAssignSaveIDs(vars);
				trace("4:Story Profile #" + id + " Saved Successfully.");
			}
			else
			{
				this.dispatchEvent(evt_loadError);
				trace("3:Story Profile #" + id + " Failure...");
			}
		}
		
		private function e_ProfileSaveFail(e:Event):void
		{
			this.dispatchEvent(evt_loadError);
			trace("3:Story Profile #" + id + " Failure...");
		}
		
		private function _pokemonAssignSaveIDs(vars:Object):void
		{
			var currentPoke:profile_poke;
			for (var loopVal:int = 0; loopVal < pokemon.length; loopVal++ )
			{
				currentPoke = pokemon[loopVal];
				if (currentPoke.saveID == 0) {
					currentPoke.saveID = vars["PID" + currentPoke.pos];
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////
		public function checkLegalPokemon():Boolean
		{
			var currentPoke:profile_poke;
			for (var loopVal:int = 0; loopVal < pokemon.length; loopVal++ )
			{
				currentPoke = pokemon[loopVal];
				if (!currentPoke.isLegal()) {
					return false;
				}
			}
			return true;
		}
		public function checkLegalItems():Boolean
		{
			for each (var item:Object in items) 
			{
				var tagDesc:String = GameInfo.getItemName(item.id);
				if (tagDesc.indexOf("INVALID") != -1) {
					return false;
				}
			}
			return true;
		}
	}

}