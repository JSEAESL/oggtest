package
{
import com.greensock.TweenLite;

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

		private var count:int = 0;
		private function NewSound(e:MouseEvent):void
		{
			count++;
			switch(count)
			{
				case 1:
						trace("step1");
					/*SoundManage.playGameSound("../ogg/2.ogg");
					SoundManage.playGameSound("../ogg/2.ogg");
					SoundManage.playGameSound("../ogg/2.ogg");*/
					//SoundManage.playGameSound("../ogg/3.ogg");
					//SoundManage.playGameSound("../ogg/4.ogg");

					/*SoundManage.playGameSound("../ogg/2.ogg");
					TweenLite.delayedCall(0.5,function():void
					{
						SoundManage.playGameSound("../ogg/2.ogg");
					});*/

					SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					 TweenLite.delayedCall(0.5,function():void
					 {
					 SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					 });

					/*SoundManage.playGameSound("../mp3/soundEffect/2.mp3");
					SoundManage.playGameSound("../mp3/soundEffect/2.mp3");
					SoundManage.playGameSound("../mp3/soundEffect/2.mp3");*/


					//SoundManage.playGameSound("../ogg/2.ogg");
					//SoundManage.playGameSound("../ogg/3.ogg");

					//SoundManage.playGameSound("../mp3/soundEffect/1.mp3");
					//SoundManage.playGameSound("../mp3/soundEffect/2.mp3");
					break;
				case 2:
					trace("step2");
					//SoundManage.stopGameSound("../ogg/2.ogg");


					SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					TweenLite.delayedCall(0.5,function():void
					{
						SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					});


					/*SoundManage.playGameSound("../ogg/6.ogg");
					TweenLite.delayedCall(0.5,function():void
					{
						SoundManage.playGameSound("../ogg/6.ogg");
					});*/


					//SoundManage.stopGameSound("../ogg/2.ogg");
					//SoundManage.stopGameSound("../ogg/3.ogg");
					//SoundManage.playGameSound("../mp3/soundEffect/3.mp3");
					//SoundManage.playGameSound("../mp3/soundEffect/4.mp3");
					break;
				case 3:

					SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					TweenLite.delayedCall(0.5,function():void
					{
						SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					});


					/*SoundManage.playGameSound("../ogg/6.ogg");*/

					//SoundManage.playGameSound("../ogg/6.ogg");
					//SoundManage.playGameSound("../ogg/4.ogg");
					//SoundManage.playGameSound("../ogg/5.ogg");
					//SoundManage.playGameSound("../mp3/soundEffect/5.mp3");
					//SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					break;
				case 4:
					SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					TweenLite.delayedCall(0.5,function():void
					{
						SoundManage.playGameSound("../mp3/soundEffect/6.mp3");
					});


					/*SoundManage.stopGameSound("../ogg/6.ogg");*/
					//SoundManage.playGameSound("../mp3/soundEffect/4.mp3");
					count = 0;
					break;
			}
		}
	}
}
