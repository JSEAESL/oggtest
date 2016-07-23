/**
 * Created by Administrator on 2016/7/23.
 */
package SampleSoundLean {
public class SampleTone extends ATone implements ITone{
    public function SampleTone()
    {
    }
    override public function creat():Vector.<Number>
    {
        var _samples:Vector.<Number> = new <Number>[];
        var amp:Number = 1.0;
        var i:int = 0;
        var mult:Number = frequency / RATE * Math.PI * 2;
        while(amp > 0.01)
        {
            _samples[i] = Math.sin(i * mult) * amp;
            amp *= 0.9998;
            i++;
        }
        _samples.length = i;
        return _samples;
    }

}
}
