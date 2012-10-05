package lucasmarcal.utils
{
	
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class Pagination extends MovieClip
	{
		
		private var _items:Array;
		private var _btnPrev:MovieClip;
		private var _btnNext:MovieClip;
		private var _content:MovieClip;
		private var _navigation:MovieClip;
		private var _object:IEventDispatcher;
		
		private var _fncAnimate:Function;
		private var _fncDestroy:Function;
		
		private var _width:int;
		private var _height:int;
		private var _spacing:int;
		private var _screenW:int;
		private var _screenH:int;
		private var _itemTotal:int;
		private var _itemRows:int;
		private var _itemCols:int;
		private var _itemPerPage:int;
		public var _pageCurrent:int;
		private var _pageTotal:int;
		private var _naviItems:int;
		private var _naviSpacing:int;
		public var _naviNormalColor:uint;
		public var _naviHoverColor:uint;
		public var _naviActiveColor:uint;
		
		public function Pagination(object:IEventDispatcher, items:Array)
		{
			_object = object;
			_items = items;
			_pageCurrent = 1;
			_pageTotal = 1;
		}
		
		private function baseX():int
		{
			return (_spacing + _width);
		}
		
		private function baseY():int
		{
			return (_spacing + _height);
		}
		
		private function areaCalculation():void
		{
			_itemCols = Math.floor(_screenW / (_spacing + _width));
			_itemRows = Math.floor(_screenH / (_spacing + _height));
			_itemPerPage = (_itemCols * _itemRows);
			
			var item:Number = (_itemTotal / _itemPerPage);
			if (_itemTotal <= _itemPerPage)
			{
				_pageTotal = 1;
			}
			else
			{
				_pageTotal = (Math.floor(item / 2) != (item / 2)) ? Math.floor(item) + 1 : Math.floor(item);
			}
		}
		
		private function enableButtons():void
		{
			if (_pageCurrent == 1)
			{
				_btnPrev.visible = false;
			}
			else if (_pageTotal > 1)
			{
				_btnPrev.visible = true;
			}
			
			if (_pageCurrent < _pageTotal)
			{
				_btnNext.visible = true;
			}
			else if (_pageCurrent >= _pageTotal)
			{
				_btnNext.visible = false;
			}
		}
		
		private function enableNavigation():void
		{
			while (_navigation.mcPagesArea.numChildren)
			{
				_navigation.mcPagesArea.removeChildAt(0);
			}
			
			var firstPage:int;
			var lastPage:int;
			
			if ((_pageCurrent - _naviItems) < 1)
			{
				firstPage = 1;
			}
			else
			{
				firstPage = (_pageCurrent - _naviItems);
			}
			
			if ((_pageCurrent + _naviItems) > _pageTotal)
			{
				lastPage = _pageTotal;
			}
			else
			{
				lastPage = (_pageCurrent + _naviItems);
			}
			
			var area:int = 1;
			for (var i:int = firstPage; i <= lastPage; i++)
			{
				var page:PaginationPage = new PaginationPage(this, i);
				var size:int = page.width + _naviSpacing;
				page.x = (area * size) - size;
				page.y = 0;
				
				_navigation.mcPagesArea.addChild(page);
				area++;
			}
			
			//TODO COlocar isso dentro dos itens de paginação
			//_navigation.positionNavigation();
		}
		
		private function itemsCol():int
		{
			return _itemCols;
		}
		
		private function itemsPerPage():int
		{
			return _itemPerPage;
		}
		
		private function itemsRow():int
		{
			return _itemRows;
		}
		
		private function itemsTotal():int
		{
			return _itemTotal;
		}
		
		public function listAll():Array
		{
			return _items;
		}
		
		private function listCurrentItems():Array
		{
			
			var perpage = (_pageCurrent * _itemPerPage);
			if (perpage > _itemTotal)
			{
				perpage = _itemTotal;
			}
			
			var list:Array = _items.slice(((_pageCurrent * _itemPerPage) - _itemPerPage), perpage);
			var initX:int = baseX();
			var initY:int = baseY();
			var row:int = 1;
			var column:int = 1;
			var global:int = 0;
			
			for (var i:int = 0; i < list.length; i++)
			{
				list[i].idpage = i;
				list[i].destinyX = ((initX * row) - initX);
				list[i].destinyY = ((initY * column) - initY);
				list[i].setDestinyPosition();
				_content.addChild(list[i]);
				
				row++;
				global++;
				
				if ((row - 1) >= itemsCol())
				{
					column++;
					row = 1;
				}
			}
			
			return list;
		}
		
		private function listHiddenItens():Array
		{
			var list:Array = new Array();
			for (var item:int = (_content.numChildren - 1); item >= 0; item--)
			{
				if (_content.getChildAt(item) is PaginationItem)
				{
					list.push((_content.getChildAt(item) as PaginationItem));
				}
			}
			
			return list;
		}
		
		private function onAnimateComplete(e:PaginationEvent):void
		{
			_object.removeEventListener(PaginationEvent.ANIMATE_COMPLETE, onAnimateComplete);
			_btnPrev.mouseEnabled = true;
			_btnNext.mouseEnabled = true;
		}
		
		private function onDestroyComplete(e:PaginationEvent):void
		{
			_object.removeEventListener(PaginationEvent.DESTROY_COMPLETE, onDestroyComplete);
			
			while (_content.numChildren)
			{
				_content.removeChildAt(0);
			}
			
			_object.addEventListener(PaginationEvent.ANIMATE_COMPLETE, onAnimateComplete, false, 1);
			_fncAnimate(listCurrentItems());
		}
		
		private function onPrev(e:MouseEvent):void
		{
			if (_btnPrev.mouseEnabled)
			{
				if (_pageCurrent > 1)
				{
					_pageCurrent--;
					gotoPage(_pageCurrent);
				}
			}
			trace("OnPrev " + "\n" + "W " + this._screenW + "\n" + "H " + this._screenH);
		}
		
		private function onNext(e:MouseEvent):void
		{
			if (_btnNext.mouseEnabled)
			{
				if (_pageCurrent < _pageTotal)
				{
					_pageCurrent++;
					gotoPage(_pageCurrent);
				}
			}
			trace("OnNext " + "\n" + "W " + this._screenW + "\n" + "H " + this._screenH);
		}
		
		public function gotoPage(page:int):void
		{
			if ((_btnPrev.mouseEnabled) && (_btnNext.mouseEnabled))
			{
				_btnPrev.mouseEnabled = false;
				_btnNext.mouseEnabled = false;
				
				if ((page >= 1) && (page <= _pageTotal))
				{
					_pageCurrent = page;
				}
				else
				{
					_pageCurrent = 1;
				}
				
				if (_navigation is MovieClip)
				{
					enableNavigation();
				}
				
				enableButtons();
				
				_object.addEventListener(PaginationEvent.DESTROY_COMPLETE, onDestroyComplete, false, 1);
				_fncDestroy(listHiddenItens());
			}
		}
		
		public function setCallback(animate:Function, destroy:Function):void
		{
			_fncAnimate = animate;
			_fncDestroy = destroy;
		}
		
		public function setNavigation(navigation:MovieClip, items:int, spacing:int, normalColor:uint, hoverColor:uint, activeColor:uint):void
		{
			_navigation = navigation;
			_naviItems = items;
			_naviSpacing = spacing;
			_naviNormalColor = normalColor;
			_naviHoverColor = hoverColor;
			_naviActiveColor = activeColor;
			
			enableNavigation();
		}
		
		public function setSettings(content:MovieClip, sizeW:Number, sizeH:Number, prev:MovieClip, next:MovieClip, width:int, height:int, spacing:int):void
		{
			_content = content;
			_btnPrev = prev;
			_btnNext = next;
			_width = width;
			_height = height;
			_spacing = spacing;
			_screenW = sizeW
			_screenH = sizeH
			
			_btnPrev.mouseEnabled = true;
			_btnNext.mouseEnabled = true;
			
			_btnPrev.visible = false;
			_btnNext.visible = false;
			
			_btnPrev.addEventListener(MouseEvent.CLICK, onPrev);
			_btnNext.addEventListener(MouseEvent.CLICK, onNext);
			
			_itemTotal = _items.length;
			
			areaCalculation();
		}
		
		public function resizeContent(sizeW:Number, sizeH:Number):void
		{
			_screenW = sizeW;
			_screenH = sizeH;
			areaCalculation();
			refreshPage();
		}
		
		public function refreshPage():void
		{
			if (_pageCurrent > _pageTotal)
			{
				_pageCurrent = _pageTotal;
			}
			gotoPage(_pageCurrent);
		}
	}
}