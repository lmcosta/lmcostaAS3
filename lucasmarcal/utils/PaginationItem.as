package lucasmarcal.utils
{
	
	import flash.display.MovieClip;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*
	
	public class PaginationItem extends MovieClip
	{
		public var id:int       = 0;
		public var idpage:int   = 0;
		public var destinyX:int = 0;
		public var destinyY:int = 0;
		
		public function PaginationItem(idmc:int)
		{
			resetPosition();
			this.id   =  idmc;
			this.name = "item" + idmc;
			
			//TweenMax.to(this,0.5, {blurFilter: { blurX:50, blurY:2 },ease:Linear.easeNone})
			
		}
		
		public function resetPosition():void
		{
			this.x = 0;
			this.y = 0;
		}
		
		public function setDestinyPosition():void
		{
			this.x = destinyX;
			this.y = destinyY;
		}
	}
}