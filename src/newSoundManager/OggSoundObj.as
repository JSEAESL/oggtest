/**
 * Created by Administrator on 2016/7/23.
 */
package newSoundManager {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.media.SoundChannel;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.Timer;

public class OggSoundObj extends ASoundObj implements ISound {

    private var oggEncode:OggEncode;
    public static var stepFun:StepFun;
    public function OggSoundObj(soundType:int, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true)
    {
        super(soundType,hasSoundFadeEffect,isLoop);
        oggEncode = new OggEncode();
        stepFun = new StepFun();
    }

    public function get oggSound():OggSound
    {
        return oggEncode.ogg;
    }

    override public function loadSound(url:String,loadCompeteRecall:Function):void
    {
        if(url == soundurl&&_loadState !=BEGIN_STATE)
        {
            return ;
        }
        else if(_loadState == LOADING_STATE)
        {
            stopSound();
        }
        if(!url)
        {
            loadCompeteRecall(this);
            return;
        }
        _loadCompeteRecall = loadCompeteRecall;
        _loadState =LOADING_STATE;
        this.soundurl = url;
        var urlRequest:URLRequest = new URLRequest(url);
        _urlLoader = new URLLoader(urlRequest);
        _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        _urlLoader.addEventListener(Event.COMPLETE,onComplete);
        _urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
    }
    private var _urlLoader:URLLoader;
    private function onComplete(e:Event = null):void
    {
        if(!isOGGDecode)
        {
            trace("ogg   onComplete");
            isOGGDecode = true;
            oggEncode.addEventListener(Event.COMPLETE,onAllComplete);
            oggEncode.toDecode(_urlLoader.data)
        }else
        {
            trace("ogg   pushStepFun");
            stepFun.pushStepFun(onComplete)
        }
    }
    private function onAllComplete(e:Event):void
    {
        trace("ogg   onAllComplete");
        isOGGDecode = false;
        stepFun.callFun();
        _loadState = COMPLELE_STATE;
        _loadCompeteRecall(this);
        removeLoadEvent();
    }

    private function onError(e:IOErrorEvent):void
    {
        _loadState = ERROR_STATE;
        _loadCompeteRecall(this);
        removeLoadEvent();
        trace(e);
    }

    override public function playSound(voiceNum:int,url:String=null) : void
    {
        if(_loadState!=COMPLELE_STATE)
        {
            if(_loadState ==BEGIN_STATE&&url&&url!="")
            {
                loadSound(url,function(sound:SoundObj):void
                {
                    if(sound.loadState == COMPLELE_STATE)
                    {
                        playSound(voiceNum);
                    }
                } )
            }
            return;
        }
        this.voiceNum = voiceNum;
        this.state = "play";
        //this.soundchannel = oggSound.startPlay();
        this.soundchannel = oggSound.startPlay(0, 1, getSTF(currFadeVoiceValue,_soundType));
        if (this.soundchannel == null)
        {
            return;
        }
      /*  this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
        if(mHasSoundFadeEffect&&_soundType==SOUNDTYPE_BG)
        {
            this.currFadeVoiceValue = 0;
            if (timer == null)
            {
                timer = new Timer(100);
            }
            timer.start();
            timer.addEventListener(TimerEvent.TIMER, this.soundIn, false, 0, true);
        }
        else
        {
            currFadeVoiceValue = voiceNum;
            this.soundchannel.soundTransform = getSTF(this.currFadeVoiceValue,_soundType);
        }*/
    }


    private function playSoundComplete(event:Event) : void
    {
        var _loc_2:* = event.currentTarget as SoundChannel;
        _loc_2.removeEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
        if(!mIsLoop) return;
        if (_loc_2 == this.soundchannel && this.state == "play")
        {
            this.soundchannel = play(0, 1, getSTF(this.currFadeVoiceValue,_soundType));
            if (this.soundchannel == null)
            {
                return;
            }
            this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
        }
    }

    private function nextVoice():int
    {
        var sbs:int = Math.abs(voiceNum-currFadeVoiceValue);
        if(sbs<5)
        {
            return voiceNum;
        }
        return currFadeVoiceValue+5*(voiceNum-currFadeVoiceValue)/sbs;
    }

    private function soundOut(event:Event) : void
    {
        if(this.state == "stop" && this.currFadeVoiceValue > 0)
        {
            this.currFadeVoiceValue = this.currFadeVoiceValue - 10;
            this.soundchannel.soundTransform = getSTF(this.currFadeVoiceValue,_soundType);
            if (this.currFadeVoiceValue <= 0)
            {
                timer.removeEventListener(TimerEvent.TIMER, this.soundOut);

                this.soundchannel.stop();
            }
        }
    }

    private function soundIn(event:Event) : void
    {
        if (this.state == "play" && this.currFadeVoiceValue != this.voiceNum)
        {
            this.currFadeVoiceValue = nextVoice();
            this.soundchannel.soundTransform =getSTF(this.currFadeVoiceValue,_soundType);
        }
        else
        {
            timer.removeEventListener(TimerEvent.TIMER, this.soundIn);
            timer = null;
        }
    }

    override public function stopSound() : void
    {
        if(_loadState==LOADING_STATE)
        {
            this.close();
        }
        this.state = "stop";
        removeLoadEvent();
        if(this.soundchannel)
        {
            this.soundchannel.stop();
            oggSound.stopPlay();
        }
    }
    override public function upSoundVoice(num:int):void
    {
        this.voiceNum = num;
        if (this.soundchannel == null)
        {
            return;
        }
        this.soundchannel.soundTransform = getSTF(this.currFadeVoiceValue,_soundType);
        if (this.state == "play")
        {
            this.currFadeVoiceValue = voiceNum;
            this.soundchannel.soundTransform = getSTF(this.currFadeVoiceValue,_soundType);
        }
    }
    override public function removeLoadEvent():void
    {
        _urlLoader.removeEventListener(Event.COMPLETE,onComplete);
        _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
        oggEncode.removeEventListener(Event.COMPLETE,onAllComplete);

    }

}
}
