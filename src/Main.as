package {
	import code.account;
	import code.crypt;
	import code.GameInfo;
	import code.ParamEvent;
	import code.ParamWriter;
	import code.profile_poke;
	import code.profile_story;
	import flash.display.Sprite;
	import flash.events.Event;
	import ui.ui_accountLogin;
	import ui.ui_profileEditorManager;
	import ui.ui_profileSelect;
	
	public class Main extends Sprite {
        protected var myAccount:account;
		protected var currentProfile:profile_story;
		
		private var loginScreen:ui_accountLogin;
		private var profileSelect:ui_profileSelect;
		private var editorManger:ui_profileEditorManager;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Create Login Screen
			renderLoginScreen();
		}
		
		///- Login Menus
		private function renderLoginScreen():void 
		{
			if (!loginScreen)
			{
				loginScreen = new ui_accountLogin(this, 5, 5);
				loginScreen.addEventListener(ui_accountLogin.EVENT_LOGIN, e_doLogin);
			}
		}
		
		
		private function e_doLogin(e:Event):void 
		{
			trace("4:Starting Login...");
			myAccount = new account(loginScreen.emailText.text, loginScreen.passwordText.text);
			myAccount.addEventListener(account.ACCOUNT_LOAD_SUCCESS, e_loginSuccess);
			myAccount.addEventListener(account.ACCOUNT_LOAD_ERROR, e_loginError);
			
			myAccount.loadAccount();
		}
		
		private function e_loginSuccess(e:Event):void 
		{
			trace("4:Login Success!");
			loginScreen.status.text = "";
			renderProfileSelect();
		}
		
		private function e_loginError(e:Event):void 
		{
			trace("4:Login Failure...");
			loginScreen.status.text = "Login Error!";
		}
		
		///- Profile Selection
		private function renderProfileSelect():void
		{
			if (profileSelect)
			{
				removeChild(profileSelect);
				profileSelect.removeEventListener(ui_profileSelect.PROFILE_SELECT, e_profileSelect);
				profileSelect = null;
			}
			profileSelect = new ui_profileSelect(myAccount, this, 5, 302);
			profileSelect.addEventListener(ui_profileSelect.PROFILE_SELECT, e_profileSelect);
		}
		
		private function e_profileSelect(e:ParamEvent):void 
		{
			currentProfile = myAccount.getProfile(e.params.id);
			currentProfile.addEventListener(profile_story.PROFILE_LOAD_SUCCESS, e_profileSuccess);
			currentProfile.addEventListener(profile_story.PROFILE_LOAD_ERROR, e_profileError);
			currentProfile.loadStory();
		}
		
		
		private function e_profileSuccess(e:Event):void 
		{
			var profileID:int = (e.target as profile_story).id;
			renderEditorScreen(profileID);
		}
		
		private function e_profileError(e:Event):void 
		{
			trace("4:Profile Loading Error...");
		}
		
		///- Editor
		private function renderEditorScreen(profileID:int):void 
		{
			
			if (editorManger)
			{
				this.removeChild(editorManger);
				editorManger = null;
			}
			
			editorManger = new ui_profileEditorManager(myAccount, profileID, this, 212, 5);
		}
	}

}