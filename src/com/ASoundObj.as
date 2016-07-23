/**
 * Created by Administrator on 2016/7/23.
 */
package com {
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Timer;

import newSoundManager.ISound;

public class ASoundObj extends Sound implements ISound {
    public static const SOUNDTYPE_BG:int =0;
    public static const SOUNDTYPE_GAME:int =0;
    public static const SOUNDTYPE_EFFECT:int =1;
    public static const SOUNDTYPE_OGG:int =1;
    public static const ERROR_STATE:int = -1;
    public static const BEGIN_STATE:int = 0;
    public static const LOADING_STATE:int = 1;
    public static const COMPLELE_STATE:int = 2;
    public var _soundurl:String = "";
    //0表示背景音乐，1表示音效
    public var uid:int ;
    /**
     * 0表示没有加载，1表示正在加载中，2表示加载完成,-1表示加载出错了
     */
    protected var _loadState:int;
    protected static var count:int;
    protected static var timer:Timer;

    protected var mHasSoundFadeEffect:Boolean = true;
    protected var mIsLoop:Boolean = true;
    protected var _soundType:int =SOUNDTYPE_BG;

    protected var _loadCompeteRecall:Function;
    protected var state:String = "stop";
    protected var soundchannel:SoundChannel = null;
    protected var voiceNum:int = 0;
    protected var currFadeVoiceValue:Number = 0;

    public function ASoundObj(soundType:int, hasSoundFadeEffect:Boolean = true, isLoop:Boolean = true)
    {
        super();
        count++;
        uid  = count;
        _soundType = soundType;
        mHasSoundFadeEffect = hasSoundFadeEffect;
        mIsLoop = isLoop;
    }

    public function get loadState():int
    {
        return _loadState;
    }

    public function get soundurl():String
    {
        return _soundurl;
    }
    public function set soundurl(str:String):void
    {
        _soundurl = str;
    }
    public function loadSound(url:String,loadCompeteRecall:Function):void
    {

    }
    public function playSound(voiceNum:int,url:String=null) : void
    {

    }
    public function stopSound():void
    {

    }
    public function upSoundVoice(num:int):void
    {

    }
    public function removeLoadEvent():void
    {

    }




    private static var gameTsf:SoundTransform;
    private static var bgTsf:SoundTransform;
    private static var oggTsf:SoundTransform;

    /**
     * 设置声道音量1-100的整数
     */
    public static function getSTF(num:int,soundType:int) : SoundTransform
    {
        if(num>100) num = 100;
        if(num<0) num = 0;
        var tsf:SoundTransform;
        if(soundType == ASoundObj.SOUNDTYPE_BG)
        {
            if(bgTsf)
            {
                bgTsf.volume = num * 0.01;
            }else{
                bgTsf = new SoundTransform(num * 0.01);
            }
            tsf = bgTsf;
        }
        else if(soundType == ASoundObj.SOUNDTYPE_GAME)
        {
            if(gameTsf)
            {
                gameTsf.volume = num * 0.01;
            }else{
                gameTsf = new SoundTransform(num * 0.01);
            }
            tsf = gameTsf;
        } else if(soundType == ASoundObj.SOUNDTYPE_OGG)
        {
            if(oggTsf)
            {
                oggTsf.volume = num * 0.01;
            }else{
                oggTsf = new SoundTransform(num * 0.01);
            }
            tsf = oggTsf;
        }
        return tsf;
    }
}
}
