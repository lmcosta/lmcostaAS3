package lucasmarcal.utils
{
	import com.greensock.TweenMax;
	import flash.text.TextField;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class PaginationPage extends MovieClip
	{
		private var _pagination:Pagination;
		private var _pageNumber:int;
		public var txtNumber:TextField;
		public var mcPageBackground:MovieClip
		public function PaginationPage(pagination:Pagination, number:int)
		{
			_pagination = pagination;
			_pageNumber = number;
			
			TweenMax.to(mcPageBackground, 0, {tint:_pagination._naviNormalColor});
			
			txtNumber.selectable = false;
			txtNumber.text = number.toString();
			
			if (number == _pagination._pageCurrent)
			{
				TweenMax.to(mcPageBackground, 0, {tint:_pagination._naviActiveColor});
			}
			else
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 1);
				this.addEventListener(MouseEvent.MOUSE_OUT,  onMouseOut,  false, 1);
				this.addEventListener(MouseEvent.CLICK,      onClick,     false, 1);
				this.mouseEnabled = true;
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			TweenMax.to(mcPageBackground, 0, {tint:_pagination._naviHoverColor});
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			TweenMax.to(mcPageBackground, 0, {tint:_pagination._naviNormalColor});
		}
		
		private function onClick(e:MouseEvent):void
		{
			//trace("_pageNumber " + _pageNumber );
			_pagination.gotoPage(_pageNumber);
		}
	}
}