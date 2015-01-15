package ui
{
	import code.account;
	import code.profile_story;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class ui_profileEditorManager extends Component
	{
		private var acc:account;
		private var id:int;
		
		private var panel:DisplayObject;

		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_profileEditorManager(acc:account, id:int, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			this.acc = acc;
			this.id = id;
			render();
		}
		
		public function render():void 
		{
			// Menubar
			var menubar:Window = new Window(this, 0, 0, "Menu - Profile "  + id + " - " + acc.getProfile(id).nickname);
			menubar.setSize(582, 50);
			menubar.draggable = false;
			
			// Menubar Items
			var menuBarItem:PushButton;
			var index:int = 0;
			for each (var item:String in ["Info", "Pokemon", "Items", "Extra Tags", "Pokedex", "Save"]) 
			{
				menuBarItem = new PushButton(menubar, 5 + index * 96, 5, item, e_menubarItemClicked);
				menuBarItem.tag = index;
				menuBarItem.setSize(90, 20);
				index++;
			}
		}
		
		private function e_menubarItemClicked(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			
			switch(target.tag)
			{
				// Info
				case 0:
					setPanel(new ui_editorInfo(acc, id, this, 0, 57));
					break;
					
				// Pokemon
				case 1: 
					setPanel(new ui_editorPokemon(acc, id, this, 0, 57));
					break;
					
				// Items
				case 2:
					setPanel(new ui_editorItems(acc, id, this, 0, 57));
					break;
					
				// Extra Tag
				case 3:
					setPanel(new ui_editorExtraTag(acc, id, this, 0, 57));
					break;
					
				// Pokedex
				case 4:
					setPanel(new ui_editorPokedex(acc, this, 0, 57));
					break;
					
				// Save
				case 5:
					acc.getProfile(id).saveStory();
					break;
					
			}
		}
		
		private function setPanel(newPanel:Component):void 
		{
			if (panel)
			{
				this.removeChild(panel);
				panel = null;
			}
			panel = newPanel;
		}
	}

}