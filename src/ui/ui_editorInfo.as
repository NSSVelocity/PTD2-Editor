package ui 
{
	import code.account;
	import code.GameInfo;
	import code.profile_story;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class ui_editorInfo extends Component 
	{
		private var acc:account;
		private var profile:profile_story;
		private var pan:ScrollPane;
		
		private var inpNickname:InputText;
		private var inpVersion:ComboBox;
		private var inpGender:ComboBox;
		private var inpMap:ComboBox;
		private var inpMapSpot:InputText;
		private var inpMoney:InputText;
		private var inpTime:InputText;
		
		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param id The profile id selected.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_editorInfo(acc:account, id:int, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			this.acc = acc;
			this.profile = acc.getProfile(id);
			render();
		}
		
		public function render():void 
		{
			var yOff:int = 10;
			var listMaps:Array = GameInfo.buildItemList(GameInfo.MAP_FUNC_NAME, GameInfo.MAP_INDEX_START, GameInfo.MAP_INDEX_END);
			var ext:Window;
			var btn:PushButton;
			
			// Remove Old
			if (pan != null) {
				this.removeChild(pan);
				pan = null;
			}
			
			// ScrollPane
			pan = new ScrollPane(this);
			pan.setSize(583, 532);
			pan.autoHideScrollBar = true;
			pan.color = 0xFFFFFF;
			pan.bordercolor = 0;
			
			// Window - Info
			ext = new Window(pan, 1, 1, "Information");
			ext.draggable = false;
			ext.setSize(392, 531);
			
			// Inputs
			var lblNickname:Label = new Label(ext, 5, yOff, "NickName:");
			inpNickname = new InputText(ext, 5, yOff + 20, profile.nickname);
			inpNickname.setSize(180, 20);
			inpNickname.enabled = false;
			
			var lblGender:Label = new Label(ext, 195, yOff, "Gender:");
			inpGender = new ComboBox(ext, 195, yOff + 20, profile.myGender.toString(), GameInfo.getGenderTags);
			inpGender.numVisibleItems = 2;
			inpGender.selectedItem = profile.myGender;
			inpGender.setSize(180, 20);
			inpGender.enabled = false;
			
			
			var lblVersion:Label = new Label(ext, 5, yOff += 45, "Version:");
			inpVersion = new ComboBox(ext, 5, yOff + 20, profile.version.toString(), GameInfo.getVersionTags);
			inpVersion.numVisibleItems = 2;
			inpVersion.selectedItem = profile.version;
			inpVersion.setSize(180, 20);
			inpVersion.enabled = false;
			
			
			var lblMap:Label = new Label(ext, 5, yOff += 45, "Map:");
			inpMap = new ComboBox(ext, 5, yOff + 20, profile.currentMap.toString(), listMaps);
			inpMap.selectedItem = profile.currentMap;
			inpMap.setSize(180, 20);
			
			var lblMapSpot:Label = new Label(ext, 195, yOff, "Map Spot:");
			inpMapSpot = new InputText(ext, 195, yOff + 20, profile.currentSpot.toString());
			inpMapSpot.setSize(180, 20);
			
			
			var lblMoney:Label = new Label(ext, 5, yOff += 45, "Money:");
			inpMoney = new InputText(ext, 5, yOff + 20, profile.money.toString());
			inpMoney.setSize(180, 20);
			
			var lblTime:Label = new Label(ext, 5, yOff += 45, "Time:");
			inpTime = new InputText(ext, 5, yOff + 20, profile.currentTime.toString());
			inpTime.setSize(180, 20);
			
			// Window - Buttons
			ext = new Window(pan, 400, 1, "Options");
			ext.draggable = false;
			ext.setSize(183, 531);
			
			// Save
			btn = new PushButton(ext, 5, 5, "Save", e_onPressSave);
			btn.setSize(173, 21);
			
			// Reset
			btn = new PushButton(ext, 5, 31, "Reset", e_onPressReset);
			btn.setSize(173, 21);
		}

		private function e_onPressSave(e:Event):void 
		{
			var sName:String = inpNickname.text;
			var sVer:int = int(_getSelectedListData(inpVersion));
			var sGen:int = int(_getSelectedListData(inpGender));
			var sMap:int = int(_getSelectedListData(inpMap));
			var sMapSpot:int = parseInt(inpMapSpot.text);
			var sMoney:int = parseInt(inpMoney.text);
			var sTime:int = parseInt(inpTime.text) % 240;
			
			// New Game Variables
			/*
			if (profile.nickname != sName) {
				profile.nickname = sName;
				profile.saveData.newGame = true;
			}
			
			if (profile.version != sVer) {
				profile.version = sVer;
				profile.saveData.newGame = true;
			}
			
			if (profile.myGender != sGen) {
				profile.myGender = sGen;
				profile.saveData.newGame = true;
			}
			*/
			
			// Map and Spot
			if (profile.currentMap != sMap) {
				profile.currentMap = sMap;
				profile.saveData.needMapSave = true;
			}
			if (profile.currentSpot != sMapSpot) {
				profile.currentSpot = sMapSpot;
				profile.saveData.needMapSave = true;
			}
			
			// Money
			if (profile.money != sMoney) {
				profile.money = sMoney;
				profile.saveData.needMoneySave = true;
			}
			
			// Time
			if (profile.currentTime != sTime) {
				profile.currentTime = sTime;
				profile.saveData.needTimeSave = true;
			}
		}
		
		private function e_onPressReset(e:Event):void 
		{
			render();
		}
		
		private function _getSelectedListData(list:ComboBox):*
		{
			var obj:* = list.selectedItem;
			return (obj ? obj["data"] : 0);
		}
	}

}