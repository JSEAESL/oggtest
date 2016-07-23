/**
 * Created by admin on 2016/7/22.
 */
package newSoundManager {

import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.ByteArray;

public class OggSound extends Sound
    {
        private var _OggBytes:ByteArray;
        private const NUM_SAMPLES:int = 2048;
        private var _isPlaying:Boolean = false;
        private var _newBytes:Boolean = false;
        private var _soundChannel:SoundChannel;
        public function OggSound()
        {
            super();
            init()
        }

        private function init():void
        {
            _OggBytes = new ByteArray();
            addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false, 0, true);
        }

        public function togglePlay():void
        {//togglePlay
            if (_isPlaying)
            {//stop
                stopPlay();
            }//stop
            else
            {//play
                startPlay();
            }//play
        }//togglePlay

        public function startPlay():void
        {//startPlay
            _isPlaying = true;
            _soundChannel = this.play();
            dispatchEvent(new Event(Event.CHANGE));
        }//startPlay

        public function stopPlay():void
        {//stopPlay
            _isPlaying = false;
            _soundChannel.stop();
            dispatchEvent(new Event(Event.CHANGE));
        }//stopPlay

        public function loadBytes($bytes:ByteArray):void
        {//loadBytes
            _newBytes = true;
            _OggBytes.length = 0;
            _OggBytes.writeBytes($bytes);
            trace("Loaded New Bytes");
            dispatchEvent(new Event(Event.CHANGE));
            togglePlay();
            _newBytes = false;
        }//loadBytes

        private function handleSampleData(e:SampleDataEvent):void
        {
            for (var i:int = 0; i < NUM_SAMPLES; i++)
            {//feed sound
                if (_OggBytes.bytesAvailable < 8)
                {//loop
                    _OggBytes.position = 0;
                }//loop
                //feed data
                e.data.writeFloat(_OggBytes.readFloat());		//Left Channel
                e.data.writeFloat(_OggBytes.readFloat());		//Right Channel
            }//feed sound
        }

        public function get isPlaying():Boolean { return _isPlaying; }
        public function get OggBytes():ByteArray { return _OggBytes; }
        public function get newBytes():Boolean { return _newBytes; }
    }
}
