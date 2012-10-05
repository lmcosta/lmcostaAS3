package lucasmarcal.utils
{
	import flash.events.Event;
	
	public class PaginationEvent extends Event
	{
		public static const ANIMATE_COMPLETE:String = "animate";
		public static const DESTROY_COMPLETE:String = "destroy";
		
		public function PaginationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}