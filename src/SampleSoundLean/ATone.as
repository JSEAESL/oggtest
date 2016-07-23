/**
 * Created by Administrator on 2016/7/23.
 */
package SampleSoundLean {
public class ATone implements ITone{
    public function ATone()
    {
    }
    protected const RATE:Number = 44100;
    protected var _frequency:Number;

    public function creat():Vector.<Number>
    {
        return new Vector.<Number>();
    }
    public function set frequency(value:Number):void
    {
        _frequency = value;
    }
    public function get frequency():Number
    {
        return _frequency;
    }
}
}
