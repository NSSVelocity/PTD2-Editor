package ui 
{
	import code.account;
	import code.GameInfo;
	import code.profile_story;
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ui_editorItems extends Component 
	{
		private var acc:account;
		private var profile:profile_story;
		private var pan:ScrollPane;
		private var totalWindows:int = 0;
		
		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param id The profile id selected.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_editorItems(acc:account, id:int, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			this.acc = acc;
			this.profile = acc.getProfile(id);
			render();
		}
		
		public function render():void 
		{
			// Remove Old
			if (pan != null) {
				this.removeChild(pan);
				pan = null;
			}
			
			// ScrollPane
			pan = new ScrollPane(this);
			pan.setSize(582, 531);
			pan.autoHideScrollBar = true;
			pan.color = 0xFFFFFF;
			pan.bordercolor = 0;
			
			totalWindows = 0;
			for each (var item:Object in profile.items) 
			{
				_renderItemWindow(pan, totalWindows++, item);
			}
			
			// Add Item Right Click
			var cm:ContextMenu = new ContextMenu();
			var sscmi:ContextMenuItem = new ContextMenuItem("Add Item");
			sscmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _addItemWindow);
			cm.customItems.push(sscmi);
			cm.hideBuiltInItems();
			pan.contextMenu = cm;
		}
		
		private function _addItemWindow(e:ContextMenuEvent = null):void
		{
			_renderItemWindow(pan, totalWindows++, null, true);
		}
		
		private function _renderItemWindow(par:DisplayObjectContainer, index:int, item:Object = null, isNew:Boolean = false):void
		{
			var ext:Window;
			var value_input:InputText;
			var id_input:InputText;
			var btn:PushButton;
			
			// Window
			ext = new Window(par, (index % 2) * 287 + 1, Math.floor(index / 2) * 57 + 1, (item ? item.id + ") " + GameInfo.getItemName(item.id) : "NEW"));
			ext.draggable = false;
			ext.setSize(280, 50);
			
			// Input textboxes
			if (isNew) {
				// ID
				id_input = new InputText(ext, 57, 5, "");
				id_input.setSize(104, 20);
				
				// Value
				value_input = new InputText(ext, 166, 5, "1");
				value_input.setSize(104, 20);
			}
			else {
				// Value
				value_input = new InputText(ext, 57, 5, item["value"]);
				value_input.setSize(219, 20);
			}
			
			// Save
			btn = new PushButton(ext, 5, 5, "S", e_onPressSave);
			btn.setSize(21, 21);
			btn.tag = { "item": item, "win": ext, "i_input": id_input, "v_input": value_input };
			
			// Reset
			btn = new PushButton(ext, 31, 5, "R", e_onPressReset);
			btn.setSize(21, 21);
			btn.tag = { "item": item, "win": ext, "i_input": id_input, "v_input": value_input };
			
			pan.update();
		}
		private function e_onPressSave(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			
			if(data["item"] != null) {
				var ext:Object = profile.items[data["item"]["id"]];
				var val:int = parseInt((data["v_input"] as InputText).text);
				if(ext["value"] != val) {
					ext["value"] = val;
					ext["save"] = true;
					(data["win"] as Window).title = (ext["value"] == 0 ? "REMOVING" : "CHANGED") + " - " + data["item"]["id"] + ") " + GameInfo.getItemName(data["item"]["id"]);
				}
			}
			else {
				var i_id:int = parseInt((data["i_input"] as InputText).text);
				var i_va:int = parseInt((data["v_input"] as InputText).text);
				if (GameInfo.isItemLegal(i_id)) {
					(data["win"] as Window).title = "NEW - " + i_id + ") " + GameInfo.getItemName(i_id);
					profile.add_Item(i_id, i_va, true, true);
				}
			}
		}
		
		private function e_onPressReset(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			if(data["item"] != null) {
				(data["v_input"] as InputText).text = profile.items[data["item"]["id"]]["value"];
			}
			else {
				(data["i_input"] as InputText).text = "";
				(data["v_input"] as InputText).text = "1";
			}
		}
		
	}

}