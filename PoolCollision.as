package  {
	
	import flash.geom.*;
	
	public class PoolCollision {
		
		public static var bounce:Number = -0.8;
		
		public static function checkWalls(ball:billiardBall, bounds:Rectangle):void
		{
			if (ball.x + ball.radius > bounds.right)
			{
				ball.x = bounds.right - ball.radius;
				ball.vx *=  bounce;
			}
			else if (ball.x - ball.radius < bounds.left)
			{
				ball.x = bounds.left + ball.radius;
				ball.vx *=  bounce;
			}
			if (ball.y + ball.radius > bounds.bottom)
			{
				ball.y = bounds.bottom - ball.radius;
				ball.vy *=  bounce;
			}
			else if (ball.y - ball.radius < bounds.top)
			{
				ball.y = bounds.top + ball.radius;
				ball.vy *=  bounce;
			}
		}
		
		public static function checkCollision(ball0:billiardBall, ball1:billiardBall):void
		{
			var dx:Number = ball1.x - ball0.x;
			var dy:Number = ball1.y - ball0.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			if (dist < ball0.radius + ball1.radius)
			{
				// calculate angle, sine, and cosine
				var angle:Number = Math.atan2(dy,dx);
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);

				// rotate ball0's position
				var pos0:Point = new Point(0,0);

				// rotate ball1's position
				var pos1:Point = rotate(dx,dy,sin,cos,true);

				// rotate ball0's velocity
				var vel0:Point = rotate(ball0.vx,ball0.vy,sin,cos,true);

				// rotate ball1's velocity
				var vel1:Point = rotate(ball1.vx,ball1.vy,sin,cos,true);

				// collision reaction
				var vxTotal:Number = vel0.x - vel1.x;
				vel0.x = (2 * ball1.mass * vel1.x)/(ball0.mass + ball1.mass);
				vel1.x = vxTotal + vel0.x;

				// update position
				var absV:Number = Math.abs(vel0.x) + Math.abs(vel1.x);
				var overlap:Number = (ball0.radius + ball1.radius) 
				                      - Math.abs(pos0.x - pos1.x);
				pos0.x +=  vel0.x / absV * overlap;
				pos1.x +=  vel1.x / absV * overlap;

				// rotate positions back
				var pos0F:Object = rotate(pos0.x, pos0.y, sin, cos, false);

				var pos1F:Object = rotate(pos1.x, pos1.y, sin, cos, false);

				// adjust positions to actual screen positions
				ball1.x = ball0.x + pos1F.x;
				ball1.y = ball0.y + pos1F.y;
				ball0.x = ball0.x + pos0F.x;
				ball0.y = ball0.y + pos0F.y;

				// rotate velocities back
				var vel0F:Object = rotate(vel0.x, vel0.y, sin, cos, false);
				
				var vel1F:Object = rotate(vel1.x, vel1.y, sin, cos, false);
				
				ball0.vx = vel0F.x;
				ball0.vy = vel0F.y;
				ball1.vx = vel1F.x;
				ball1.vy = vel1F.y;
			}
		}
		
		public static function rotate(x:Number, y:Number, sin:Number, cos:Number, reverse:Boolean):Point
		{
			var result:Point = new Point();
			if (reverse)
			{
				result.x = x * cos + y * sin;
				result.y = y * cos - x * sin;
			}
			else
			{
				result.x = x * cos - y * sin;
				result.y = y * cos + x * sin;
			}
			return result;
		}
	}
	
}
