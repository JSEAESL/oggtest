package
{
import com.app.FileManager;

import flash.display.Sprite;
import flash.events.MouseEvent;

import newSoundManager.SoundManage;

public class OggTest extends Sprite
	{
		public function OggTest()
		{

			var t:Sprite = Draw.creatRect(10,10,10,10,0x666666,1);
			t.x = 300;
			t.y = 300;
			addChild(t );
			t.addEventListener(MouseEvent.CLICK, NewSound)
		}

		private function NewSound(e:MouseEvent):void
		{
			//SoundManage.playGameSound("../mp3/2.mp3");
			SoundManage.playBgSound("../mp3/soundEffect/2.mp3");
			SoundManage.playGameSound("../ogg/1.ogg");

		}
	}
}
