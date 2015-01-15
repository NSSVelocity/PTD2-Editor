package ui 
{
	import code.account;
	import code.GameInfo;
	import code.profile_story;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
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
	
	public class ui_editorExtraTag extends Component 
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
		public function ui_editorExtraTag(acc:account, id:int, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
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
			for each (var item:Object in profile.extraInfo) 
			{
				_renderItemWindow(pan, totalWindows++, item);
			}
			
			// Add Item Right Click
			var cm:ContextMenu = new ContextMenu();
			var sscmi:ContextMenuItem = new ContextMenuItem("Add Extra Tag");
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
			var idsList:Array = GameInfo.buildItemList(GameInfo.EXTRA_FUNC_NAME, GameInfo.EXTRA_INDEX_START, GameInfo.EXTRA_INDEX_END);
			var ext:Window;
			var value_input:InputText;
			var id_input:ComboBox;
			var btn:PushButton;
			
			// Window
			ext = new Window(par, (index % 3) * 191 + 1, Math.floor(index / 3) * 87 + 1, (item ? item.id + ") " + GameInfo.getExtraDescription(item.id).join(" - ") : "NEW"));
			ext.draggable = false;
			ext.setSize(184, 80);
			
			// Input textboxes
			if (isNew) {
				// ID
				id_input = new ComboBox(ext, 32, 5, "1", idsList);
				id_input.setSize(147, 20);
				id_input.selectedItem = "1";
				id_input.listWidth = 200;
				
				// Value
				value_input = new InputText(ext, 32, 33, "1");
				value_input.setSize(147, 20);
			}
			else {
				// Value
				value_input = new InputText(ext, 32, 5, item["value"]);
				value_input.setSize(147, 20);
			}
			
			// Save
			btn = new PushButton(ext, 5, 5, "S", e_onPressSave);
			btn.setSize(21, 21);
			btn.tag = { "item": item, "win": ext, "i_input": id_input, "v_input": value_input };
			
			// Reset
			btn = new PushButton(ext, 5, 33, "R", e_onPressReset);
			btn.setSize(21, 21);
			btn.tag = { "item": item, "win": ext, "i_input": id_input, "v_input": value_input };
			
			pan.update();
		}
		private function e_onPressSave(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			
			if(data["item"] != null) {
				var ext:Object = profile.extraInfo[data["item"]["id"]];
				var val:int = parseInt((data["v_input"] as InputText).text);
				if(ext["value"] != val) {
					ext["value"] = val;
					ext["save"] = true;
					(data["win"] as Window).title = "CHANGED - " + data["item"]["id"] + ") " + GameInfo.getExtraDescription(data["item"]["id"]).join(" - ");
				}
			}
			else {
				var i_id:int = parseInt(_getSelectedListData(data["i_input"]));
				var i_va:int = parseInt((data["v_input"] as InputText).text);
				(data["win"] as Window).title = "NEW - " + i_id + ") " + GameInfo.getExtraDescription(i_id).join(" - ");
				profile.add_Extra_Value(i_id, i_va, true, true);
			}
		}
		
		private function e_onPressReset(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			if(data["item"] != null) {
				(data["v_input"] as InputText).text = profile.extraInfo[data["item"]["id"]]["value"];
			}
			else {
				(data["i_input"] as ComboBox).selectedIndex = 0;
				(data["v_input"] as InputText).text = "1";
			}
		}
		
		private function _getSelectedListData(list:ComboBox):*
		{
			var obj:* = list.selectedItem;
			return (obj ? obj["data"] : 0);
		}
	}

}