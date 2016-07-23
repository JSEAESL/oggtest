/**
 * Created by Administrator on 2016/7/23.
 */
package SampleSoundLean {
import flash.events.SampleDataEvent;
import flash.media.Sound;

public class SampleSound {
    private var _sound:Sound;
    private const sampleNum:uint = 2048;
    private var _position:uint = 0;//播放指针
    private var _sampleVector:Vector.<Number> = new Vector.<Number>();//存放样本数组

    public static var IS_BRG:int = 0;
    public static var IS_COMPLETE:int = 1;
    public static var IS_PLAY:int = 2;
    public static var IS_END:int = 3;
    private var _Stste:int = 0;

    public function SampleSound()
    {
        _sound = new Sound();
        _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
    }

    public function setSampleVector(sampleVector:Vector.<Number>):void
    {
        _sampleVector = sampleVector;
        _Stste = IS_COMPLETE;
    }

    public function play():void
    {
        if(_Stste!=IS_BRG )
        {
            _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
            _position = 0;
            _sound.play();
        }
    }

    public function stop():void
    {
        _sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
        _Stste = IS_END;
        _position = 0;
    }

    private function onSampleData(e:SampleDataEvent):void
    {
        _Stste = IS_PLAY;
        for(var i:int = 0; i < sampleNum; i++)
        {
            if(_position >= _sampleVector.length)
            {
                _sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
                _Stste = IS_END;
                return;
            }
            e.data.writeFloat(_sampleVector[_position]); // 左声道
            e.data.writeFloat(_sampleVector[_position]); // 右声道
            _position++;
        }
    }
}
}
