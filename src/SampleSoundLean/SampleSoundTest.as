/**
 * Created by Administrator on 2016/7/23.
 */
package SampleSoundLean {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class SampleSoundTest  extends Sprite{
    public function SampleSoundTest()
    {

        var t:Sprite = Draw.creatRect(10,10,10,10,0x666666,1);
        t.x = 300;
        t.y = 300;
        addChild(t);
        t.addEventListener(MouseEvent.CLICK, onSampleSound);

        sampleSound = new SampleSound();
        ton = ToneFactory.creatTone();


    }

    private var sampleSound:SampleSound;
    private var ton:ITone;


    private function onSampleSound(e:MouseEvent):void
    {
        ton.frequency = 300 + 1000*Math.random();
        sampleSound.setSampleVector(ton.creat());
        sampleSound.play();
    }
}
}
