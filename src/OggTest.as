package
{
import com.app.FileManager;

import flash.display.Sprite;
import flash.events.MouseEvent;

public class OggTest extends Sprite
	{
		public function OggTest()
		{
			//var ogg:OggSound = new OggSound("../ogg/2X.ogg")
			//var ogg:Ogg_Sound = new Ogg_Sound("../ogg/ogg73/Backroad.ogg")

			//OOOO
			//var ogg:Ogg_Sound = new Ogg_Sound("../ogg/1.ogg")
			var t:Sprite = Draw.creatRect(10,10,10,10,0x666666,1);
			t.x = 300;
			t.y = 300;
			addChild(t );
			t.addEventListener(MouseEvent.CLICK, NewSound)
		}


		private var _fileManager:FileManager;

		private function NewSound(e:MouseEvent):void
		{
			//var ogg:OggSound = new OggSound("../ogg/1.ogg");
			//var ogg:Ogg_Sound = new Ogg_Sound("../ogg/2X.ogg");
			var ogg:Ogg_Sound = new Ogg_Sound("../ogg/1.ogg");
			//SoundManage.playGameSound("../mp3/soundEffect/1.mp3")
			SoundManage.playOggSound("../ogg/1.ogg")

		}
	}
}
