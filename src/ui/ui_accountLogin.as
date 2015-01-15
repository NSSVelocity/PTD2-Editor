package ui
{
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ui_accountLogin extends Component
	{
		// Events
		public static const EVENT_LOGIN:String = "doAccountLogin";
		private var evt_doLogin:Event = new Event(EVENT_LOGIN);
		
		// Variables
		public var emailText:InputText;
		public var passwordText:InputText;
		public var loginBtn:PushButton;
		public var status:Label;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_accountLogin(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			render();
		}
		
		public function render():void
		{
			var lbl:Label;
			
			// Window Setup
			var win:Window = new Window(this, 0, 0, "Login");
			win.setSize(200, 290);
			win.draggable = false;
			
			lbl = new Label(win, 5, 5, "Email:");
			emailText = new InputText(win, 5, 25, "");
			emailText.setSize(win.width - 10, 16);
			
			lbl = new Label(win, 5, 55, "Password:");
			passwordText = new InputText(win, 5, 75, "");
			passwordText.setSize(win.width - 10, 16);
			passwordText.password = true;
			
			loginBtn = new PushButton(win, 5, 100, "Login", e_doLogin);
			loginBtn.setSize(190, 20);
			
			status = new Label(win, 5, 130, "");
		}
		
		private function e_doLogin(e:Event):void
		{
			status.text = "Logging In...";
			this.dispatchEvent(evt_doLogin);
		}
	
	}

}