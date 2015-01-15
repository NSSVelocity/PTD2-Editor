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
	
	public class account extends EventDispatcher
	{
		// Events
		public static const ACCOUNT_LOAD_SUCCESS:String = "onAccountLoadComplete";
		public static const ACCOUNT_LOAD_ERROR:String = "onAccountLoadError";
		private var evt_loadSuccess:Event = new Event(ACCOUNT_LOAD_SUCCESS);
		private var evt_loadError:Event = new Event(ACCOUNT_LOAD_ERROR);
		
		// Variables
		public var email:String;
		public var password:String;
		
		public var profiles:Array = [];
		public var pokedexs:Array = [];
		
		private var loader:URLLoader;
		
		public function account(email:String, password:String)
		{
			this.email = email;
			this.password = password;
		}
		
		public function loadAccount():void
		{
			var variables:URLVariables = new URLVariables();
			variables.ver = Constants.GAME_VERSION;
			variables.Email = email;
			variables.Pass = password;
			variables.Action = "loadStory";
			
			var request:URLRequest = new URLRequest(Constants.SAVE_PHP + new Date().getTime());
			request.method = URLRequestMethod.POST;
			request.data = variables;
			try {
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, e_AccountLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, e_AccountFail);
			loader.load(request);
			trace("0:Requesting Account Information...");
			}
			catch (e:Error) {
				trace(e.getStackTrace());
			}
		}
		
		public function getProfile(id:int):profile_story
		{
			return profiles[id];
		}
		
		private function e_AccountLoad(e:Event):void
		{
			var vars:URLVariables = e.target.data;
			if (vars["Result"] && vars["Result"] == "Success")
			{
				// Read Pokedex Data (If it exist that is)
				if (vars["dextra1"])
					parsePokedex(1, vars["dextra1"]);
				if (vars["dextra2"])
					parsePokedex(2, vars["dextra2"]);
				if (vars["dextra3"])
					parsePokedex(3, vars["dextra3"]);
				if (vars["dextra4"])
					parsePokedex(4, vars["dextra4"]);
				if (vars["dextra5"])
					parsePokedex(5, vars["dextra5"]);
				if (vars["dextra6"])
					parsePokedex(6, vars["dextra6"]);
				
				// Read Profile Data
				var paramReader:ParamReader = new ParamReader(vars["extra"]);
				var profileStory:profile_story;
				var profilesFound:int = paramReader.readTagSmall();
				var currentProfile:int = 1;
				while (currentProfile <= profilesFound)
				{
					profileStory = new profile_story(this);
					profileStory.id = paramReader.readTagSmall();
					profileStory.money = paramReader.readTag();
					profileStory.badges = paramReader.readTag();
					profileStory.nickname = vars["Nickname" + profileStory.id];
					profileStory.version = vars["Version" + profileStory.id];
					
					profiles[profileStory.id] = profileStory;
					currentProfile++;
				}
				this.dispatchEvent(evt_loadSuccess);
				trace("0:Account Loaded Successfully.");
			}
			else
			{
				this.dispatchEvent(evt_loadError);
				trace("3:Account Loaded, but returned an error." + (vars["Result"] ? " (" + vars["Result"] + ")" : "(Unknown)"));
			}
		}
		
		private function e_AccountFail(e:Event):void
		{
			this.dispatchEvent(evt_loadError);
			trace("3:Account Load Failure...");
		}
		
		// Pokedexes
		private function parsePokedex(dex:int, dexchars:String):void
		{
			dexchars = crypt.convertStringToIntString(dexchars);
			pokedexs[dex] = [];
			for (var i:int = 0; i < dexchars.length; i++)
			{
				pokedexs[dex][i] = getInfoFromDexString(dexchars.charAt(i));
			}
		}
		
		public function getInfoFromDexString(char:String):Array
		{
			var out:Array = [false, false, false];
			
			if (char == "1" || char == "4" || char == "5" || char == "7") out[0] = true;
			if (char == "2" || char == "4" || char == "6" || char == "7") out[1] = true;
			if (char == "3" || char == "5" || char == "6" || char == "7") out[2] = true;
			
			return out;
		}
		
		public function getDexStringFromInfo(arr:Array):int
		{
			if (arr[0] && arr[1] && arr[2]) return 7;
			else if (arr[0] && arr[1]) return 4;
			else if (arr[0] && arr[2]) return 5;
			else if (arr[1] && arr[2]) return 6;
			else if (arr[2]) return 3;
			else if (arr[1]) return 2;
			else if (arr[0]) return 1;
			return 0;
		}
	}
}