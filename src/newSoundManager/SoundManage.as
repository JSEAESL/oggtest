package newSoundManager {
import flash.utils.Dictionary;

public class SoundManage extends Object
{
	public static var DEFAULT_VALUE:int =50;
	private static var _mute:int = 1;
	private static var _bgVolume:int = DEFAULT_VALUE;
	private static var _gameVolume:int = DEFAULT_VALUE;
	private static var _bgSound:ISound = null;
	private static var _lastBgSoundUrl:String;
	private static var onWaitingSoundStr:String;

	public function SoundManage()
	{
		return;
	}

	public static function get bgVolume():int
	{
		return _bgVolume;
	}

	public static function set bgVolume(num:int) : void
	{
		_bgVolume = num;
		upBgVolume();
	}

	public static function get gameVolume():int
	{
		return _gameVolume;
	}

	public static function set gameVolume(num:int) : void
	{
		_gameVolume = num;
		upGameVolume();
	}

	/**
	 * 开关音乐的缩放值，1开启，0为关闭音乐
	 * @param num
	 *
	 */
	public static function set mute(num:int) : void
	{
		_mute = num;
		upSoundTransform();
	}

	public static function get mute() : int
	{
		return _mute;
	}

	/**
	 * 控制整个游戏的声音
	 */
	private static function upSoundTransform() : void
	{
		upBgVolume();
		upGameVolume();
	}

	private static function upBgVolume() : void
	{
		var volumes:int = _bgVolume * _mute;

		ASoundObj.getSTF(volumes,0);

		if (_bgSound != null)
		{
			_bgSound.upSoundVoice(volumes);
		}
		else
		{
			if (volumes < 5)
			{
				stopBgSound();
			}
			else
			{
				if(onWaitingSoundStr)
				{
					playBgSound(onWaitingSoundStr);
					onWaitingSoundStr = null;
				}
			}
		}
	}

	private static function upGameVolume() : void
	{
		trace("upGameVolume******"+ _bgVolume+" "+_mute);
		var volumes:int = _bgVolume * _mute;
		ASoundObj.getSTF(volumes,1);
		for(var obj:* in _gameSoundDic)
		{
			(_gameSoundDic[obj] as ISound).upSoundVoice(volumes);
		}
	}

	public static function playBgSound(str:String) : ISound
	{
		if (!str || str == "")
		{
			stopBgSound();
			return null;
		}
		var voice:* = _bgVolume * _mute;
		if (voice < 5)
		{
			stopBgSound();
			onWaitingSoundStr = str;
			return null;
		}
		if(_lastBgSoundUrl != str)
		{
			stopBgSound();
			_lastBgSoundUrl = str;
			var soundObject:ISound = SoundFactory.creatSoundObject(ASoundObj.SOUNDTYPE_BG);
			soundObject.playSound(voice,str);
			_bgSound = soundObject;
		}
		return _bgSound;
	}

	public static function stopBgSound() : void
	{
		if (_bgSound != null)
		{
			_bgSound.stopSound();
			_bgSound = null;
		}
		_lastBgSoundUrl = null;
	}
	public static function stopGameSound(obj:*) : ISound
	{
		var sound:ISound;
		if (obj is String)
		{
			sound = getGameSound(obj);
			//没加载的先进行加载
			if(sound.loadState == ASoundObj.BEGIN_STATE)
			{
				loadGameSound(String(obj),playGameSound);
				return null;
			}
			else if(sound.loadState ==ASoundObj.COMPLELE_STATE)
			{
				sound.stopSound();
			}
		}
		else if(obj is ISound)
		{
			sound = obj as ISound;
			//没加载的先进行加载
			if(sound.loadState == ASoundObj.BEGIN_STATE)
			{
				loadGameSound(sound.soundurl,playGameSound);
				return null;
			}else if(sound.loadState ==ASoundObj.COMPLELE_STATE)
			{
				sound.stopSound()
			}
		}
		else if (obj is Class)
		{
			sound = new obj;
		}
		return sound;
	}

	public static function playGameSound(obj:*,boo1:Boolean = false,boo2:Boolean = false) : ISound
	{
		var voice:* = _gameVolume * _mute;
		if (voice < 5)
		{
			return null;
		}
		var sound:ISound;
		if (obj is String)
		{
			sound = getGameSound(obj);
			//没加载的先进行加载
			if(sound.loadState == ASoundObj.BEGIN_STATE)
			{
				if(!checkISogg(obj))
				{
					loadGameSound(String(obj),playGameSound);
					return null;
				}
				obj  = OggSoundProMap3Buff(obj);
				playGameSound(String(obj));
				obj  = OggSoundProMap3Buff(obj,"ogg");
				loadGameSound(String(obj),null);
				//org
				//loadGameSound(String(obj),playGameSound);
				return null;
			}
			else if(sound.loadState ==ASoundObj.COMPLELE_STATE)
			{
				sound.playSound(voice,String(obj));
			}
		}
		else if(obj is ISound)
		{
			sound = obj as ISound;
			//没加载的先进行加载
			if(sound.loadState == ASoundObj.BEGIN_STATE)
			{
				var buffUrl:String = sound.soundurl;
				if(!checkISogg(sound.soundurl))
				{
					loadGameSound(buffUrl,playGameSound);
				}
				buffUrl  = OggSoundProMap3Buff(buffUrl);
				loadGameSound(String(buffUrl),playGameSound);
				buffUrl  = OggSoundProMap3Buff(buffUrl,"ogg");
				loadGameSound(String(buffUrl),null);

				//org
				//loadGameSound(String(obj),playGameSound);
				return null;
			}else if(sound.loadState ==ASoundObj.COMPLELE_STATE)
			{
				sound.playSound(voice,String(obj));
			}
		}
		else if (obj is Class)
		{
			sound = new obj;
		}
		return sound;
	}

	private static function checkISogg(obj:*):Boolean
	{
		var suffix:String = JStrUnti.getUrlSuffixStr(obj);
		return suffix.toLowerCase() == "ogg"?true:false
	}

	private static function OggSoundProMap3Buff(obj:*,suff:String = "mp3"):*
	{
		if (obj is String)
		{
			var suffix:String = JStrUnti.replaceSuffixStr(obj,suff);
			return suffix;
		}
		return obj;
	}

	private static function loadGameSound(obj:*,loadComplete:Function=null):void
	{
		var sound:ISound;
		if(obj is String)
		{
			sound = getGameSound(obj) as ISound;
		}
		else if(obj is ISound)
		{
			sound = obj as ISound;
		}
		function loadEnd(sd:ISound):void
		{
			_gameSoundDic[sd.soundurl] = sd;
			if(loadComplete)
			{
				loadComplete(sd);
			}
		}
		sound.loadSound(sound.soundurl,loadEnd);
	}

	/**
	 * 音效字典
	 */
	private static var _gameSoundDic:Dictionary = new Dictionary();
	/**
	 * 获取音效
	 */
	public static function getGameSound(uri:String):ISound
	{
		var sound:ISound = _gameSoundDic[uri];
		if(!sound)
		{
			var suffix:String = JStrUnti.getUrlSuffixStr(uri);
			sound = SoundFactory.creatSoundObjectBySuffix(suffix,false, false);
			//sound = SoundFactory.creatSoundObject(ASoundObj.SOUNDTYPE_GAME,false, false);
			sound.soundurl = uri;
			_gameSoundDic[uri] = sound;
		}
		return sound;
	}

	public static function delectOneGameSound(str:String):void
	{
		var sound:ISound = _gameSoundDic[str];
		if(!sound)
		{
			sound.stopSound();
			delete  _gameSoundDic[str];
		}
	}
}
}
