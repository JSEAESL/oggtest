package {
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Draw extends Sprite
	{
		public function Draw()
		{
			
		}
		
		public static function creatCirle(x:Number,y:Number,r:Number,color:uint,alp:Number):Sprite
		{
			var result:Sprite = new Sprite();
			result.graphics.beginFill(color,alp);
			result.graphics.drawCircle(x,y,r);
			result.graphics.lineStyle(1);
			result.graphics.endFill();
			return result;
		}
		
		public static function cleanCreatRoundRect(dim:Sprite,x:Number,y:Number,width:Number,height:Number,ellW:Number = 5,ellH:Number = 5, color:uint = 0xffffff,alp:Number = 1):void
		{
			dim.graphics.clear();
			dim.graphics.beginFill(color,alp);
			dim.graphics.drawRoundRect(x,y,width,height,ellW,ellH);
			dim.graphics.lineStyle(1);
			dim.graphics.endFill();
		}
		public static function creatRect(x:Number,y:Number,width:Number,height:Number,color:uint = 0xffffff,alp:Number = 1):Sprite
		{
			var result:Sprite = new Sprite();
			result.graphics.beginFill(color,alp);
			result.graphics.drawRect(x,y,width,height);
			result.graphics.lineStyle(1);
			result.graphics.endFill();
			return result;
		}
		
		public static function creatRoundRect(x:Number,y:Number,width:Number,height:Number,ellW:Number = 5,ellH:Number = 5, color:uint = 0xffffff,alp:Number = 1):Sprite
		{
			var result:Sprite = new Sprite();
			result.graphics.beginFill(color,alp);
			result.graphics.drawRoundRect(x,y,width,height,ellW,ellH);
			result.graphics.lineStyle(1);
			result.graphics.endFill();
			return result;
		}
		
		public static function creatShape(x:Number,y:Number,width:Number,height:Number,color:uint = 0,alp:Number = 1):Shape
		{
			var result:Shape = new Shape();
			result.graphics.beginFill(color,alp);
			result.graphics.drawRect(x,y,width,height);
			result.graphics.endFill();
			//result.visible = false;
			//result.alpha = 0;
			return result;
		}
		
		public static function creatLineRect(w:uint,h:uint):Shape
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(1,0x000000,0.3);
			line.graphics.lineTo(0,0);
			line.graphics.lineTo(w,0);
			line.graphics.lineTo(w,h);
			line.graphics.lineTo(0,h);
			line.graphics.lineTo(0,0);
			line.graphics.endFill();
			return line
		}
	}
}