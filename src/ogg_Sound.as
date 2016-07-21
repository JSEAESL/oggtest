/**
 * Created by Administrator on 2016/7/21.
 */
package {
import cmodule.hookOggVorbisLib.CLibInit;

import com.automatastudios.audio.audiodecoder.decoders.OggVorbisDecoder;

import com.jac.ogg.OggManager;

import flash.errors.IOError;

import flash.events.Event;
import flash.events.IOErrorEvent;

import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

public class ogg_Sound {


    private const BYTES_PER_SAMPLE:Number = 8;
    private const NUM_SAMPLES:int = 2048;

    private var _isPlaying:Boolean;
    private var _oggBytes:ByteArray;
    private var _sound:Sound;
    private var _soundChannel:SoundChannel;
    private var _oggManager:OggManager;
    private var _playPosition:int;

    //Alchemy Loader object
    private var _loader:CLibInit;

    //Alchemy -> AS3 object (our hook to the alchemy methods)
    private var _lib:Object;
    private var _isFullyDecoded:Boolean;
    private var _url:String;
    public function ogg_Sound(url:String)
    {
        _isPlaying = false;
        _oggBytes = new ByteArray();
        _oggManager = new OggManager();
        _isFullyDecoded = false;
        _playPosition = 0;
        _sound = new Sound();
        _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSoundData, false, 0, true);
        _loader = new CLibInit;
        _lib = _loader.init();
        loadUrl(url)
    }
    private var _urlLoader:URLLoader;
    private function loadUrl(url:String):void
    {
        _url  = url;
        var urlRequest:URLRequest = new URLRequest(url);
        _urlLoader = new URLLoader(urlRequest);
        _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        _urlLoader.addEventListener(Event.COMPLETE,onComplete);
        _urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
    }

    private function onError(e:IOErrorEvent):void
    {
        trace("IOErrorEvent");
    }

    private function onComplete(e:Event):void
    {
        //Save bytes
        _oggBytes.length = 0;
        _oggBytes.writeBytes(_urlLoader.data);
        trace("Load Complete: " + _oggBytes.length);
        _oggBytes.position = 0;
        trace("Init Decoder");
        _oggManager.initDecoder(_oggBytes);
        _soundChannel = _sound.play();
    }

    private function handleSoundData(e:SampleDataEvent):void
    {//handleSoundData
        var result:Object;
        var tmpBuffer:ByteArray = new ByteArray();
        result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);

        if (tmpBuffer.length < NUM_SAMPLES * BYTES_PER_SAMPLE)
        {//reset
            trace("Rewind");
            //Right now the only way to rewind is reseting the decoder
            _oggManager.initDecoder(_oggBytes);
            result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);
        }//reset

        tmpBuffer.position = 0;

        while (tmpBuffer.bytesAvailable)
        {//feed
            //feed data
            e.data.writeFloat(tmpBuffer.readFloat());		//Left Channel
            e.data.writeFloat(tmpBuffer.readFloat());		//Right Channel
        }//feed

    }//handleSoundData
}
}
