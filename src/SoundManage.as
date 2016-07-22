package {
import flash.media.Sound;
import flash.utils.Dictionary;

public class SoundManage extends Object
{
	public static var DEFAULT_VALUE:int =50;
	private static var _mute:int = 1;
	private static var _bgVolume:int = DEFAULT_VALUE;
	private static var _gameVolume:int = DEFAULT_VALUE;
	private static var _bgSound:SoundObj = null;
	private static var _lastBgSoundUrl:String;

	private static var _ogg

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

		SoundObj.getSTF(volumes,0);

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
		SoundObj.getSTF(volumes,1);
		for(var obj:* in _gameSoundDic)
		{
			(_gameSoundDic[obj] as SoundObj).upSoundVoice(volumes);
		}
	}

	private static var onWaitingSoundStr:String;
	public static function playBgSound(str:String) : Sound
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
			var soundObject:SoundObj = new SoundObj(SoundObj.SOUNDTYPE_BG);
			soundObject.playSound(voice,str);
			_bgSound = soundObject;
		}
		return _bgSound;
	}



	public static function playOggSound(str:String) : SoundObj
	{
		if (!str || str == "")
		{
			//stopBgSound();
			return null;
		}
		var voice:* = _bgVolume * _mute;
		if (voice < 5)
		{
			//stopBgSound();
			//onWaitingSoundStr = str;
			return null;
		}
		//if(_lastBgSoundUrl != str)
		{
			//stopBgSound();
			_lastBgSoundUrl = str;
			var soundObject:SoundObj = new SoundObj(SoundObj.SOUNDTYPE_OGG);
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

	public static function playGameSound(obj:*,boo1:Boolean = false,boo2:Boolean = false) : Sound
	{
		var voice:* = _gameVolume * _mute;
		if (voice < 5)
		{
			return null;
		}
		var sound:Sound;
		if (obj is String)
		{
			sound = getGameSound(obj);
			//没加载的先进行加载
			if(SoundObj(sound).loadState == SoundObj.BEGIN_STATE)
			{
				loadGameSound(String(obj),playGameSound);
				return null;
			}
			else if(SoundObj(sound).loadState ==SoundObj.COMPLELE_STATE)
			{
				SoundObj(sound).playSound(voice,String(obj));
			}
		}
		else if(obj is SoundObj)
		{
			sound = obj as Sound;
			//没加载的先进行加载
			if(SoundObj(sound).loadState == SoundObj.BEGIN_STATE)
			{
				loadGameSound(SoundObj(sound).soundurl,playGameSound);
				return null;
			}else if(SoundObj(sound).loadState ==SoundObj.COMPLELE_STATE)
			{
				SoundObj(sound).playSound(voice,String(obj));
			}
		}
		else if (obj is Class)
		{
			sound = new obj;
		}
		return sound;
	}

	private static function loadGameSound(obj:*,loadComplete:Function=null):void
	{
		var sound:SoundObj;
		if(obj is String)
		{
			sound = getGameSound(obj) as SoundObj;
		}
		else if(obj is SoundObj)
		{
			sound = obj as SoundObj;
		}
		function loadEnd(sd:SoundObj):void
		{
			_gameSoundDic[sd.soundurl] = sd;
			loadComplete(sd);
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
	public static function getGameSound(uri:String):Sound
	{
		var sound:SoundObj = _gameSoundDic[uri];
		if(!sound)
		{
			sound = new SoundObj(SoundObj.SOUNDTYPE_GAME, false, false);
			sound.soundurl = uri;
			_gameSoundDic[uri] = sound;
		}
		return sound;
	}

	public static function getGameOgg(uri:String):SoundObj
	{
		var sound:SoundObj = _gameSoundDic[uri];
		if(!sound)
		{
			sound = new SoundObj(SoundObj.SOUNDTYPE_OGG, false, false);
			sound.soundurl = uri;
			_gameSoundDic[uri] = sound;
		}
		return sound;
	}


	public static function delectOneGameSound(str:String):void
	{
		var sound:SoundObj = _gameSoundDic[str];
		if(!sound)
		{
			sound.stopSound();
			delete  _gameSoundDic[str];
		}
	}
}
}
