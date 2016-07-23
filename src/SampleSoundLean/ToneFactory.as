/**
 * Created by Administrator on 2016/7/23.
 */
package SampleSoundLean {
public class ToneFactory {
    public function ToneFactory() {
    }

    public static function creatTone():ITone
    {
        return new SampleTone();
    }
}
}
