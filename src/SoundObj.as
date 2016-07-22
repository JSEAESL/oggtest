package {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.Timer;

internal class SoundObj extends Sound
{
	public static const SOUNDTYPE_BG:int =0;
	public static const SOUNDTYPE_GAME:int =0;
	public static const SOUNDTYPE_OGG:int =1;

	private static var count:int;

	private static var timer:Timer;
	private static var gameTsf:SoundTransform;
	private static var bgTsf:SoundTransform;

	public var soundurl:String = "";

	private var state:String = "stop";
	private var soundchannel:SoundChannel = null;

	private var voiceNum:int = 0;
	private var currFadeVoiceValue:Number = 0;
	private var soundTime:int = 0;

	private var mHasSoundFadeEffect:Boolean = true;
	private var mIsLoop:Boolean = true;

	private var _loadState:int =BEGIN_STATE;
	public static const ERROR_STATE:int = -1;
	public static const BEGIN_STATE:int = 0;
	public static const LOADING_STATE:int = 1;
	public static const COMPLELE_STATE:int = 2;
	public static const OGG_DECODE_STATE:int = 3;
	public var _oggBytes:ByteArray;

	/**
	 * 0表示没有加载，1表示正在加载中，2表示加载完成,-1表示加载出错了
	 */
	public function get loadState():int { return _loadState;}

	//0表示背景音乐，1表示音效
	private var _soundType:int =SOUNDTYPE_BG;

	public var uid:int ;

	public function SoundObj(soundType:int, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true)
	{
		super();
		count++;
		uid  = count;
		_soundType = soundType;
		mHasSoundFadeEffect = hasSoundFadeEffect;
		mIsLoop = isLoop;
	}

	private var _loadCompeteRecall:Function;
	public function loadSound(url:String,loadCompeteRecall:Function):void
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
		this.addEventListener(Event.COMPLETE, this.completeFun);
		this.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);

		this.load(new URLRequest(url));
	}

	public function playSound(voiceNum:int,url:String=null) : void
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

		this.soundchannel = play(0, 1, getSTF(currFadeVoiceValue,_soundType));

		if (this.soundchannel == null)
		{
			return;
		}

		this.soundchannel.addEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);

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
		}
	}

	public function stopSound() : void
	{
		if(_loadState==LOADING_STATE)
		{
			this.close();
		}
		this.state = "stop";

		removeLoadEvent();

		if(this.soundchannel)
		{
			this.soundchannel.removeEventListener(Event.SOUND_COMPLETE, this.playSoundComplete);
			this.soundchannel.stop();
		}

		if(timer)
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, this.soundIn);
			timer = null;
		}
	}

	public function upSoundVoice(num:int):void
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

	private function completeFun(event:Event) : void
	{

		_loadState = COMPLELE_STATE;
		/*if(_soundType == SOUNDTYPE_OGG)
		 {
		 _loadState = OGG_DECODE_STATE;
		 }else
		 {
		 _loadState = COMPLELE_STATE;
		 }*/
		_loadCompeteRecall(this);
		removeLoadEvent();
	}

	private function loadError(e:IOErrorEvent):void
	{
		_loadState = ERROR_STATE;
		_loadCompeteRecall(this);

		removeLoadEvent();
		trace(e);
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

	private function nextVoice():int
	{
		var sbs:int = Math.abs(voiceNum-currFadeVoiceValue)
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

	public function removeLoadEvent():void
	{
		this.removeEventListener(Event.COMPLETE, this.completeFun);
		this.removeEventListener(IOErrorEvent.IO_ERROR, this.completeFun);
	}

	/**
	 * 设置声道音量1-100的整数
	 */
	public static function getSTF(num:int,soundType:int) : SoundTransform
	{
		if(num>100) num = 100;
		if(num<0) num = 0;

		var tsf:SoundTransform
		if(soundType == SoundObj.SOUNDTYPE_BG)
		{
			if(bgTsf)
			{
				bgTsf.volume = num * 0.01;
			}else{
				bgTsf = new SoundTransform(num * 0.01);
			}
			tsf = bgTsf;
		}
		else if(soundType == SoundObj.SOUNDTYPE_GAME)
		{
			if(gameTsf)
			{
				gameTsf.volume = num * 0.01;
			}else{
				gameTsf = new SoundTransform(num * 0.01);
			}
			tsf = gameTsf;
		} else if(soundType == SoundObj.SOUNDTYPE_OGG)
		{
			if(gameTsf)
			{
				gameTsf.volume = num * 0.01;
			}else{
				gameTsf = new SoundTransform(num * 0.01);
			}
			tsf = gameTsf;
		}
		return tsf;
	}

}
}
