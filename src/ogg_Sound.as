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
    private const NUM_SAMPLES:int = 2048;
    private var _oggBytes:ByteArray;
    private var _oggManager:OggManager;
    private var _soundChannel:SoundChannel;

    private var _url:String;
    public function Ogg_Sound(url:String = null)
    {
        super();
        _oggBytes = new ByteArray();
        _oggManager = new OggManager();
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


    }
}
