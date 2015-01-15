package ui 
{
	import code.account;
	import code.GameInfo;
	import code.profile_poke;
	import code.profile_poke_save;
	import code.profile_story;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ui_editorPokemon extends Component 
	{
		private var acc:account;
		private var profile:profile_story;
		private var pan:ScrollPane;
		private var totalWindows:int = 0;
		private var pokeWin:Window;
		
		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param id The profile id selected.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_editorPokemon(acc:account, id:int, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
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
			pan.setSize(382, 531);
			pan.autoHideScrollBar = true;
			pan.color = 0xFFFFFF;
			pan.bordercolor = 0;
			
			totalWindows = 0;
			for each (var pkmn:Object in profile.pokemon) 
			{
				_renderItemWindow(pan, totalWindows++, pkmn);
			}
			
			// Add Item Right Click
			var cm:ContextMenu = new ContextMenu();
			var sscmi:ContextMenuItem = new ContextMenuItem("Add Pokemon");
			sscmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _addItemWindow);
			cm.customItems.push(sscmi);
			cm.hideBuiltInItems();
			pan.contextMenu = cm;
		}
		
		private function _addItemWindow(e:ContextMenuEvent = null):void
		{
			_renderItemWindow(pan, totalWindows++, null);
		}
		
		private function _renderItemWindow(par:DisplayObjectContainer, index:int, pkmn:Object = null):void
		{
			var ext:Window;
			var btn:PushButton;
			
			// Window
			ext = new Window(par, (index % 2) * 187 + 1, Math.floor(index / 2) * 57 + 1, _getWindowTitle(pkmn));
			ext.draggable = false;
			ext.setSize(180, 50);

			// Edit
			btn = new PushButton(ext, 5, 5, "Edit", e_onPressEdit);
			btn.setSize(82, 21);
			btn.tag = { "pkmn": pkmn, "win": ext, "index": index };
			
			// Clone
			btn = new PushButton(ext, 93, 5, "Clone", e_onPressClone);
			btn.setSize(82, 21);
			btn.tag = { "pkmn": pkmn, "win": ext, "index": index };
			
			pan.update();
		}
		
		private function _getWindowTitle(pkmn:Object, withChanged:Boolean = true):String
		{
			var winTitle:String = "";
			
			if (!pkmn) {
				winTitle = "NEW";
			}
			if (pkmn && pkmn["saveInfo"]["needCaptured"]) {
				winTitle = "NEW";
			}
			if (pkmn && withChanged && (pkmn["saveInfo"] as profile_poke_save).need_Save() && !pkmn["saveInfo"]["needCaptured"]) {
				winTitle += "CHANGED"
			}
			if (pkmn) {
				if(pkmn["nickname"]) {
					if (winTitle != "") winTitle += " - ";
					winTitle += pkmn["nickname"];
				}
				
				if(pkmn["level"]) {
					if (winTitle != "") winTitle += " - ";
					winTitle += "L" + pkmn["level"];
				}
				
				if(pkmn["shiny"] != 0) {
					if (winTitle != "") winTitle += " - ";
					winTitle += GameInfo.getShinyTags[pkmn["shiny"]]["label"];
				}
				
				if(pkmn["myTag"] == "h") {
					winTitle +=  "(H)";
				}
			}
			return winTitle;
		}
		
		private function e_onPressEdit(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			
			_renderPokemonEditWindow(data["pkmn"]);
		}
		
		private function e_onPressClone(e:Event):void 
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			var pkmn:profile_poke = data["pkmn"] as profile_poke;
			
			profile.pokemon.push(pkmn.clone());
			
			render();
		}
		//////////////////////////////////////////////////////////////////////////////////////
		private var lblPokemonNickname:Label;
		private var inpPokemonNickname:InputText;
		private var lblPokemonNum:Label;
		private var inpPokemonNum:ComboBox;
		private var lblPokemonGender:Label;
		private var inpPokemonGender:ComboBox;
		private var lblPokemonShiny:Label;
		private var inpPokemonShiny:ComboBox;
		private var lblPokemonExp:Label;
		private var inpPokemonExp:InputText;
		private var lblPokemonLevel:Label;
		private var inpPokemonLevel:InputText;
		private var lblPokemonMoves:Label;
		private var inpPokemonMove1:ComboBox;
		private var inpPokemonMove2:ComboBox;
		private var inpPokemonMove3:ComboBox;
		private var inpPokemonMove4:ComboBox;
		private var lblPokemonItem:Label;
		private var inpPokemonItem:ComboBox;
		private var lblPokemonTag:Label;
		private var inpPokemonTag:InputText;
		private var lblPokemonIsValid:Label;
		private var inpSave:PushButton;
		private var inpReset:PushButton;
		private function _renderPokemonEditWindow(pkmn:profile_poke = null, index:int = 0):void
		{
			var gamePkmnNames:Array = GameInfo.buildItemList(GameInfo.POKEMON_FUNC_NAME, GameInfo.POKEMON_INDEX_START, GameInfo.POKEMON_INDEX_END);
			var gamePkmnMoves:Array = GameInfo.buildItemList(GameInfo.MOVES_FUNC_NAME, GameInfo.MOVES_INDEX_START, GameInfo.MOVES_INDEX_END);
			var gameItemNames:Array = GameInfo.buildItemList(GameInfo.ITEMS_FUNC_NAME, GameInfo.ITEMS_INDEX_START, GameInfo.ITEMS_INDEX_END);
			
			var yOff:int = 5;
			
			// Remove Old
			if (pokeWin != null) {
				this.removeChild(pokeWin);
				pokeWin = null;
			}
			
			if (pkmn == null) {
				pkmn = new profile_poke();
				pkmn.saveInfo.isNew = true;
				pkmn.saveInfo.needCaptured = true;
			}
			
			pkmn.id = index;
			
			// Render Window
			pokeWin = new Window(this, 387, 0, "EDITING: " + _getWindowTitle(pkmn, false));
			pokeWin.draggable = false;
			pokeWin.setSize(195, 531);
			
			// Nickname
			lblPokemonNickname = new Label(pokeWin, 5, yOff, "Nickname:");
			lblPokemonNickname.setSize(185, 20);
			
			inpPokemonNickname = new InputText(pokeWin, 5, yOff += 20, pkmn.nickname);
			inpPokemonNickname.setSize(185, 20);
			
			// Gender
			lblPokemonGender = new Label(pokeWin, 5, yOff += 23, "Gender: ");
			lblPokemonGender.setSize(185, 20);
			
			inpPokemonGender = new ComboBox(pokeWin, 5, yOff += 20, "", GameInfo.getGenderTags);
			inpPokemonGender.selectedItem = pkmn.gender;
			inpPokemonGender.setSize(185, 20);
			inpPokemonGender.numVisibleItems = 2;
			if (!pkmn.saveInfo.isNew && !pkmn.saveInfo.needCaptured) inpPokemonGender.enabled = false;
			
			// Shiny
			lblPokemonShiny = new Label(pokeWin, 5, yOff += 23, "Shiny: ");
			lblPokemonShiny.setSize(185, 20);
			
			inpPokemonShiny = new ComboBox(pokeWin, 5, yOff += 20, "", GameInfo.getShinyTags);
			inpPokemonShiny.selectedItem = pkmn.shiny;
			inpPokemonShiny.numVisibleItems = 3;
			inpPokemonShiny.setSize(185, 20);
			inpPokemonShiny.addEventListener(Event.SELECT, e_checkPokemonValid, false, 0, true);
			if (!pkmn.saveInfo.isNew && !pkmn.saveInfo.needCaptured) inpPokemonShiny.enabled = false;
			
			// Number
			lblPokemonNum = new Label(pokeWin, 5, yOff += 23, "Pokemon: ");
			lblPokemonNum.setSize(185, 20);
			
			inpPokemonNum = new ComboBox(pokeWin, 5, yOff += 20, "", gamePkmnNames);
			inpPokemonNum.selectedItem = pkmn.num;
			inpPokemonNum.setSize(185, 20);
			inpPokemonNum.addEventListener(Event.SELECT, e_editorNumberSelect, false, 0, true);
				
			// Experience
			lblPokemonExp = new Label(pokeWin, 5, yOff += 23, "Experience: ");
			lblPokemonExp.setSize(185, 20);
			
			inpPokemonExp = new InputText(pokeWin, 5, yOff += 20, pkmn.experience.toString());
			inpPokemonExp.setSize(185, 20);
			
			// Level
			lblPokemonLevel = new Label(pokeWin, 5, yOff += 23, "Level: ");
			lblPokemonLevel.setSize(185, 20);
			
			inpPokemonLevel = new InputText(pokeWin, 5, yOff += 20, pkmn.level.toString());
			inpPokemonLevel.setSize(185, 20);
			
			// Moves
			lblPokemonMoves = new Label(pokeWin, 5, yOff += 23, "Moves: ");
			lblPokemonMoves.setSize(185, 20);
			
			inpPokemonMove1 = new ComboBox(pokeWin, 5, yOff += 20, "", gamePkmnMoves);
			inpPokemonMove1.selectedItem = pkmn.move1;
			inpPokemonMove1.setSize(185, 20);
			inpPokemonMove2 = new ComboBox(pokeWin, 5, yOff += 22, "", gamePkmnMoves);
			inpPokemonMove2.selectedItem = pkmn.move2;
			inpPokemonMove2.setSize(185, 20);
			inpPokemonMove3 = new ComboBox(pokeWin, 5, yOff += 22, "", gamePkmnMoves);
			inpPokemonMove3.selectedItem = pkmn.move3;
			inpPokemonMove3.setSize(185, 20);
			inpPokemonMove4 = new ComboBox(pokeWin, 5, yOff += 22, "", gamePkmnMoves);
			inpPokemonMove4.selectedItem = pkmn.move4;
			inpPokemonMove4.setSize(185, 20);
			
			// Item
			lblPokemonItem = new Label(pokeWin, 5, yOff += 23, "Item: ");
			lblPokemonItem.setSize(185, 20);
			
			inpPokemonItem = new ComboBox(pokeWin, 5, yOff += 20, "", gameItemNames);
			inpPokemonItem.selectedItem = pkmn.item;
			inpPokemonItem.openPosition = ComboBox.TOP;
			inpPokemonItem.setSize(185, 20);
			inpPokemonItem.addEventListener(Event.SELECT, e_checkPokemonValid, false, 0, true);
			
			// Tag
			lblPokemonTag = new Label(pokeWin, 5, yOff += 23, "Tag:");
			lblPokemonTag.setSize(185, 20);
			
			inpPokemonTag = new InputText(pokeWin, 5, yOff += 20, pkmn.myTag);
			inpPokemonTag.setSize(185, 20);
			
			// Is Valid
			lblPokemonIsValid = new Label(pokeWin, 5, yOff += 26, "");
			lblPokemonIsValid.setSize(185, 20);
			
			// Buttons - Save
			inpSave = new PushButton(pokeWin, 5, yOff += 25, "Save", e_onPressPokemonEditorSave);
			inpSave.setSize(90, 20);
			inpSave.tag = { "pkmn": pkmn };
			
			// Buttons - Reset
			inpReset = new PushButton(pokeWin, 100, yOff, "Reset", e_onPressPokemonEditorReset);
			inpReset.setSize(90, 20);
			inpReset.tag = { "pkmn": pkmn };
			
			// Check Valid
			e_checkPokemonValid();
		}
		
		private function e_checkPokemonValid(e:Event = null):void 
		{
			var invalidThings:Array = [];
			
			// Reset
			lblPokemonIsValid.text = "";
			
			// Check Number + Shiny/Shadow Status
			var pkmnum:int = int(_getSelectedListData(inpPokemonNum));
			var pkmnshi:int = int(_getSelectedListData(inpPokemonShiny));
			if (!GameInfo.canCapturePokemon(pkmnum, pkmnshi)) {
				invalidThings.push("Uncatchable");
			}
			
			// Check Item
			var pkmitem:int = int(_getSelectedListData(inpPokemonItem));
			if (!GameInfo.isItemLegal(pkmitem)) {
				invalidThings.push("Invalid Item");
			}
			
			// Print Results
			if(invalidThings.length > 0) {
				lblPokemonIsValid.text = "INVALID: " + invalidThings.join(", ");
			}
		}
		
		private function e_editorNumberSelect(e:Event):void
		{
			inpPokemonNickname.text = GameInfo.getPokemonName(int(_getSelectedListData(inpPokemonNum)));
			e_checkPokemonValid(e);
		}
		
		private function e_onPressPokemonEditorSave(e:Event):void
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			var pkmn:profile_poke = data["pkmn"] as profile_poke;
			
			// Save Values
			if (pkmn.saveInfo.isNew || pkmn.saveInfo.needCaptured) {
				pkmn.gender = int(_getSelectedListData(inpPokemonGender));
				pkmn.shiny = int(_getSelectedListData(inpPokemonShiny));
			}
			
			if (inpPokemonNickname.text == "") {
				inpPokemonNickname.text = GameInfo.getPokemonName(int(_getSelectedListData(inpPokemonNum)));
			}

			if(pkmn.nickname != inpPokemonNickname.text) {
				pkmn.nickname = inpPokemonNickname.text;
				pkmn.saveInfo.needNickname = true;
			}

			if(pkmn.experience != int(inpPokemonExp.text)) {
				pkmn.experience = int(inpPokemonExp.text);
				pkmn.saveInfo.needExp = true;
			}

			if(pkmn.level != int(inpPokemonLevel.text)) {
				pkmn.level = int(inpPokemonLevel.text);
				pkmn.saveInfo.needLevel = true;
			}

			if(pkmn.myTag != inpPokemonTag.text) {
				pkmn.myTag = inpPokemonTag.text;
				pkmn.saveInfo.needTag = true;
			}

			var pkmnum:int = int(_getSelectedListData(inpPokemonNum));
			if(pkmn.num != pkmnum) {
				pkmn.num = pkmnum;
				pkmn.saveInfo.needEvolve = true;
			}

			if(pkmn.nickname == "") {
				pkmn.nickname = GameInfo.getPokemonName(pkmn.num);
				pkmn.saveInfo.needNickname = true;
			}
			
			var m1:int = int(_getSelectedListData(inpPokemonMove1));
			var m2:int = int(_getSelectedListData(inpPokemonMove2));
			var m3:int = int(_getSelectedListData(inpPokemonMove3));
			var m4:int = int(_getSelectedListData(inpPokemonMove4));
			if(pkmn.move1 != m1 || pkmn.move2 != m2 || pkmn.move3 != m3 || pkmn.move4 != m4) {
				pkmn.move1 = m1;
				pkmn.move2 = m2;
				pkmn.move3 = m3;
				pkmn.move4 = m4;
				pkmn.saveInfo.needMoves = true;
			}

			var pkmitem:int = int(_getSelectedListData(inpPokemonItem));
			if(pkmn.item != pkmitem && GameInfo.isItemLegal(pkmitem)) {
				pkmn.item = pkmitem;
				pkmn.saveInfo.needItem = true;
			}
			
			// Save Items
			if (pkmn.saveInfo.isNew == true) {
				pkmn.saveInfo.isNew = false;
				profile.pokemon.push(pkmn);
			}
			
			render();
			_renderPokemonEditWindow(pkmn, pkmn.id);
		}
		
		private function e_onPressPokemonEditorReset(e:Event):void
		{
			var target:PushButton = (e.target as PushButton);
			var data:Object = target.tag;
			var pkmn:profile_poke = data["pkmn"] as profile_poke;
			
			if (pkmn.saveInfo.isNew == true) {
				_renderPokemonEditWindow(null);
			}
			else {
				_renderPokemonEditWindow(pkmn, pkmn.id);
			}
		}
		
		private function _getSelectedListData(list:ComboBox):*
		{
			var obj:* = list.selectedItem;
			return (obj ? obj["data"] : 0);
		}
		
	}

}