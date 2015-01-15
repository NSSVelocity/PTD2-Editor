package code
{
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
		
		public var params:Object;
		
		public function ParamEvent(type:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.params = params;
		}
		
		public override function clone():Event
		{
			return new ParamEvent(type, this.params, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("ParamEvent", "params", "type", "bubbles", "cancelable");
		}
	}
}