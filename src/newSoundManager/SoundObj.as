package newSoundManager {

import com.ASoundObj;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.utils.Timer;

public class SoundObj extends ASoundObj implements ISound
{

	private var soundTime:int = 0;

	public function SoundObj(soundType:int, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true)
	{
		super(soundType,hasSoundFadeEffect,isLoop);
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
		this.addEventListener(Event.COMPLETE, this.completeFun);
		this.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
		this.load(new URLRequest(url));
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

	private function completeFun(event:Event) : void
	{
		_loadState = COMPLELE_STATE;
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

	override public function removeLoadEvent():void
	{
		this.removeEventListener(Event.COMPLETE, this.completeFun);
		this.removeEventListener(IOErrorEvent.IO_ERROR, this.completeFun);
	}


}
}
