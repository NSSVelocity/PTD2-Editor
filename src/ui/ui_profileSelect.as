package ui
{
	import code.account;
	import code.ParamEvent;
	import code.profile_story;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ui_profileSelect extends Component
	{
		static public const PROFILE_SELECT:String = "profileSelect";
		
		private var acc:account;
		
		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_profileSelect(acc:account, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			this.acc = acc;
			render();
		}
		
		public function render():void
		{
			var win:Window = new Window(this, 0, 0, "Profile Selection");
			win.draggable = false;
			win.setSize(200, 291);
			
			var offset:int = 0;
			var btn:PushButton;
			for each (var item:profile_story in acc.profiles)
			{
				btn = new PushButton(win, 5, 5 + offset, item.nickname, e_profileSelect);
				btn.setSize(190, 30);
				btn.tag = item.id;
				btn.color = item.version == "1" ? 0xffe599 : 0xeef8ff;
				
				offset += 35;
			}
		}
		
		private function e_profileSelect(e:MouseEvent):void
		{
			var target:PushButton = (e.target as PushButton);
			this.dispatchEvent(new ParamEvent(PROFILE_SELECT, { id: target.tag } ));
		}
	}

}