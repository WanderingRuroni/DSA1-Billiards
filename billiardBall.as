 package  {
	
	import flash.display.*;
	import flash.events.Event;
	
	public class billiardBall extends Sprite {

		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number = 1;

		public function billiardBall(radius:Number = 20, color:uint = 0x000000) 
		{
			this.radius = radius;
			this.color = color;
			init();
		}
		
		public function init():void 
		{
			graphics.lineStyle(2, 0, 1);
			graphics.beginFill(color);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
		}
	}
	
}
