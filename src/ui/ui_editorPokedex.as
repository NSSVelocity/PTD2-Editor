package ui 
{
	import code.account;
	import code.GameInfo;
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class ui_editorPokedex extends Component 
	{
		private var acc:account;
		
		/**
		 * Constructor
		 * @param acc The user account loaded.
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ui_editorPokedex(acc:account, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			this.acc = acc;
			render();
		}
		
		public function render():void 
		{
			renderPokedex(1, 196*0, 269*0);
			renderPokedex(2, 196*1, 269*0);
			renderPokedex(3, 196*2, 269*0);
			renderPokedex(4, 196*0, 269*1);
			renderPokedex(5, 196*1, 269*1);
			renderPokedex(6, 196*2, 269*1);
		}
		
		private function renderPokedex(dexID:Number, posx:Number, posy:Number):void 
		{
			// Window
			var win:Window = new Window(this, posx, posy, "Generation " + dexID);
			win.draggable = false;
			win.setSize(190, 262);
			
			// ScrollPane
			var pan:ScrollPane = new ScrollPane(win);
			pan.setSize(win.width, win.height - 20);
			pan.autoHideScrollBar = true;
			
			// Pokedex
			var lbl:Label;
			var btn:CheckBox;
			var dex:Array = acc.pokedexs[dexID];
			
			for (var i:int = 0; i < dex.length; i++)
			{
				var item:Array = dex[i];
				
				// Pokemon Name
				lbl = new Label(pan, 5, 5 + i * 20, GameInfo.getPokemonName(i + PokedexOffset(dexID)));
				
				// Normal
				btn = new CheckBox(pan, 80, 9 + i * 20, "", e_onChange);
				btn.selected = item[0];
				btn.tag = { "dex": dexID, "index": i, "type": 0 };
				
				// Shiny
				btn = new CheckBox(pan, 100, 9 + i * 20, "", e_onChange);
				btn.selected = item[1];
				btn.tag = { "dex": dexID, "index": i, "type": 1 };
				
				// Shadow
				btn = new CheckBox(pan, 120, 9 + i * 20, "", e_onChange);
				btn.selected = item[2];
				btn.tag = { "dex": dexID, "index": i, "type": 2 };
				
			}
		}
		
		private function e_onChange(e:Event):void 
		{
			var target:CheckBox = (e.target as CheckBox);
			var data:Object = target.tag;
			
			acc.pokedexs[data.dex][data.index][data.type] = target.selected;
		}
		
		private function PokedexOffset(i:int):int 
		{
			var off:int = 1;
			if (i > 1) off += 151; // #2 = 152
			if (i > 2) off += 100; // #3 = 252
			if (i > 3) off += 135; // #4 = 387
			if (i > 4) off += 108; // #5 = 495
			if (i > 5) off += 155; // #6 = 650
			return off;
		}
		
	}

}