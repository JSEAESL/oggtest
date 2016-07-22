/**
 * Created by Administrator on 2016/7/21.
 */
package {
import com.jac.ogg.OggManager;
import com.jac.ogg.events.OggManagerEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

public class Ogg_Sound extends Sound{

    private const BYTES_PER_SAMPLE:Number = 8;
    private const NUM_SAMPLES:int = 2048
    private var _oggBytes:ByteArray;
    private var _oggManager:OggManager;
    private var _soundChannel:SoundChannel;

    private var _url:String;
    public function Ogg_Sound(url:String = null)
    {
        super();
        _oggBytes = new ByteArray();
        _oggManager = new OggManager();
        this.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSoundData, false, 0, true);
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

    private var initComlete:Boolean = false;
    private function onComplete(e:Event):void
    {
        //Save bytes
        _oggBytes.length = 0;
        _oggBytes.writeBytes(_urlLoader.data);
        _oggBytes.position = 0;
        initComlete = true;

        _oggManager.addEventListener(OggManagerEvent.DECODE_BEGIN, handleDecodeBegin, false, 0, true);
        _oggManager.addEventListener(OggManagerEvent.DECODE_PROGRESS, handleDecodeProgress, false, 0, true);
        _oggManager.addEventListener(OggManagerEvent.DECODE_COMPLETE, handleDecodeComplete, false, 0, true);
        _oggManager.addEventListener(OggManagerEvent.DECODE_CANCEL, handleDecodeCancel, false, 0, true);

        _oggManager.decode(_oggBytes,8192, 33,true);
        //toPlay();
    }

    private function handleDecodeBegin(e:OggManagerEvent):void
    {
        trace("handleDecodeBegin")
    }
    private function handleDecodeProgress(e:OggManagerEvent):void
    {
        trace("handleDecodeProgress")
    }
    private function handleDecodeComplete(e:OggManagerEvent):void
    {
        var Ogg:Ogg__Sound = new Ogg__Sound();
        Ogg.loadBytes(_oggManager.decodedBytes);
        trace("handleDecodeComplete")
    }
    private function handleDecodeCancel(e:OggManagerEvent):void
    {
        trace("handleDecodeCancel")
    }


    public function toPlay():void
    {
        if(initComlete)
        {
            if(_soundChannel)
            {
                _soundChannel.stop();
            }
            _soundChannel = this.play();
        }
    }

    override public function play(startTime:Number = 0,loops:int = 0,sndTransform:SoundTransform = null):SoundChannel
    {
        return super.play(startTime,loops,sndTransform);
    }

    private function handleSoundData(e:SampleDataEvent):void
    {
        var result:Object;
        var tmpBuffer:ByteArray = new ByteArray();
        result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);

        if (tmpBuffer.length < NUM_SAMPLES * BYTES_PER_SAMPLE)
        {//reset
            trace("Rewind");
            //return;
            //Right now the only way to rewind is reseting the decoder
            _oggManager.initDecoder(_oggBytes);
            result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);
        }//reset

        tmpBuffer.position = 0;
        trace(tmpBuffer.bytesAvailable)
        trace(tmpBuffer.length)
        while (tmpBuffer.bytesAvailable)
        {//feed
            //feed data
            e.data.writeFloat(tmpBuffer.readFloat());		//Left Channel
            e.data.writeFloat(tmpBuffer.readFloat());		//Right Channel
        }//feed
    }
}
}
