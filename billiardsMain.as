package 
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.*;

	public class billiardsMain extends Sprite
	{

		private var ball:billiardBall;
		private var cueBall:billiardBall;
		private var rack:Array;
		public var pockets:Array;
		private var numPockets:uint = 6;
		public var table:Rectangle;
		public var bottomPocketNum:Number = 0;
		private var radius:Number = 10;
		private var friction:Number = 0.95;
		
		public var info1:TextField;
		public var info2:TextField;

		public function billiardsMain()
		{
			init();
		}

		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			table = new Rectangle(75,75,stage.stageWidth - 150,stage.stageHeight / 2 + 100);
			graphics.lineStyle(1,0,1);
			graphics.beginFill(0x00AA00);
			graphics.drawRect(table.x, table.y, table.width, table.height);
			graphics.endFill();

			rack = new Array();
			pockets = new Array();
			
			info1 = new TextField();
			info1.width = 200;
			info1.text = "Press SPACE to use Cue Stick";
			addChild(info1);
			
			info2 = new TextField();
			info2.width = 200;
			info2.text = "Press N for a New Game";
			info2.y = 20;
			addChild(info2);
			
			setUpBalls();

			for (var l:uint = 0; l < numPockets; l++)
			{
				var pocket:billiardBall = new billiardBall(20,0x000000);
				if (l < 3)
				{
					pocket.x = table.x + (l * table.width/2);
					pocket.y = table.y;
					addChild(pocket);
					pockets.push(pocket);
				}
				else
				{
					pocket.x = table.x + (bottomPocketNum * table.width/2);
					pocket.y = table.height + table.y;
					bottomPocketNum++;
					addChild(pocket);
					pockets.push(pocket);
				}
			}

			addEventListener(Event.ENTER_FRAME, onEnter);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyRelease);
		}
		
		public function setUpBalls():void 
		{
			if(rack != null && rack.length > 0)
				{
					for(var k:int = 0; k < rack.length; k++) 
					{
						removeChild(rack[k]);
						rack.splice(k, 1);
						k--;
					}
				}
			
			var centerX:Number = stage.stageWidth / 3;
			var centerY:Number = stage.stageHeight / 2;

			cueBall = new billiardBall(radius,0xffffff);
			cueBall.x = stage.stageWidth / 1.3;
			cueBall.y = centerY;
			addChild(cueBall);
			rack.push(cueBall);

			for (var i:uint = 0; i < 5; i++)
			{
				for (var j:uint = 0; j < i + 1; j++)
				{
					var colorNum:int = Math.random() * 4294967296;
					ball = new billiardBall(radius,colorNum);
					ball.x = centerX - i * (2 * ball.radius);
					ball.y = centerY - j * (2 * ball.radius) + i * ball.radius;
					addChild(ball);
					rack.push(ball);
				}
			}
		}

		public function onEnter(event:Event):void
		{
			checkPocketCollision();

			for (var i:uint = 0; i < rack.length; i++)
			{
				var poolBall:billiardBall = rack[i];
				poolBall.x +=  poolBall.vx;
				poolBall.y +=  poolBall.vy;
				poolBall.vx *=  friction;
				poolBall.vy *=  friction;
				PoolCollision.checkWalls(poolBall, table);
			}
			for (i = 0; i < rack.length - 1; i++)
			{
				var poolBallA:billiardBall = rack[i];
				for (var j:uint = i + 1; j < rack.length; j++)
				{
					var poolBallB:billiardBall = rack[j];
					PoolCollision.checkCollision(poolBallA, poolBallB);
				}
			}
		}

		public function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == 32)
			{
				graphics.clear();

				table = new Rectangle(75,75,stage.stageWidth - 150,stage.stageHeight / 2 + 100);
				graphics.lineStyle(1,0,1);
				graphics.beginFill(0x00AA00);
				graphics.drawRect(table.x, table.y, table.width, table.height);
				graphics.endFill();

				graphics.lineStyle(1,0,1);
				graphics.moveTo(cueBall.x, cueBall.y);
				graphics.lineTo(mouseX, mouseY);
			}
		}

		public function keyRelease(event:KeyboardEvent):void
		{
			if(event.keyCode == 32)
			{
				graphics.clear();
				table = new Rectangle(75,75,stage.stageWidth - 150,stage.stageHeight / 2 + 100);
				graphics.lineStyle(1,0,1);
				graphics.beginFill(0x00AA00);
				graphics.drawRect(table.x, table.y, table.width, table.height);
				graphics.endFill();
	
				var dx:int = mouseX - cueBall.x;
				var dy:int = mouseY - cueBall.y;
	
				cueBall.vx -=  dx/3;
				cueBall.vy -=  dy/3;
			}
			else if(event.keyCode == 78)
			{
				setUpBalls();
			}
		}

		public function checkPocketCollision():void
		{
			for (var ballNum:int = 0; ballNum < rack.length; ballNum++)
			{
				for (var pocketNum:int = 0; pocketNum < pockets.length; pocketNum++)
				{
					var ball:billiardBall = rack[ballNum];
					var pocket:billiardBall = pockets[pocketNum];

					var dx:Number = pocket.x - ball.x;
					var dy:Number = pocket.y - ball.y;
					var dist:Number = Math.sqrt(dx * dx + dy * dy);
					if (dist < pocket.radius + ball.radius)
					{
						if (ball == cueBall)
						{
							cueBall.x = stage.stageWidth / 1.3;
							cueBall.y = stage.stageHeight / 2;
							cueBall.vx = 0;
							cueBall.vy = 0;
						}
						else
						{
							removeChild(ball);
							rack.splice(ballNum, 1);
							ballNum--;
						}
					}
				}
			}
		}
	}

}