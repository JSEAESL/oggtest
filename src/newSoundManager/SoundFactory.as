/**
 * Created by Administrator on 2016/7/23.
 */
package newSoundManager {
public class SoundFactory {
    public function SoundFactory() {
    }
    public static function creatSoundObject(soundType:int, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true):ISound
    {
            switch(soundType)
            {
                case ASoundObj.SOUNDTYPE_GAME:
                    return new SoundObj(soundType,hasSoundFadeEffect,isLoop);
                    break;
                case ASoundObj.SOUNDTYPE_EFFECT:
                    return new SoundObj(soundType,hasSoundFadeEffect,isLoop);
                    break;
                case ASoundObj.SOUNDTYPE_OGG:
                    return new OggSoundObj(soundType,hasSoundFadeEffect,isLoop);
                    break;
            }
            return null;
    }
    public static function creatSoundObjectBySuffix(Suffix:String, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true):ISound
    {
        Suffix = Suffix.toLowerCase();
        switch(Suffix)
        {
            case "ogg":
                return new OggSoundObj(1,hasSoundFadeEffect,isLoop);
                break;
            case "mp3":
                return new SoundObj(1,hasSoundFadeEffect,isLoop);
                break;

        }
        return null;
    }


    }
}
