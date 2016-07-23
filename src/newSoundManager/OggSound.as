/**
 * Created by admin on 2016/7/22.
 */
package newSoundManager {

import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
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
        }

        public function togglePlay():SoundChannel
        {//togglePlay
            if (_isPlaying)
            {//stop
                return stopPlay();
            }//stop
            else
            {//play
                return startPlay();
            }//play

            return null
        }//togglePlay

        private var _startTime:Number;
        private var _loops:int;
        private var _sndTransform:SoundTransform;

        public function startPlay(startTime:Number = 0,loops:int = 0,sndTransform:SoundTransform = null):SoundChannel
        {
            _isPlaying = true;
            stopPlay();
            _startTime = startTime;
            _loops = loops;
            _sndTransform = sndTransform;
            removeEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false);
            addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false, 0, true);
            _soundChannel = this.play();
            return _soundChannel;
        }

        public function stopPlay():SoundChannel
        {
            _isPlaying = false;
            removeEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false);

            if(_soundChannel)
            {
                _soundChannel.stop();
            }
            _OggBytes.position = 0;
            return _soundChannel
        }

        public function loadBytes($bytes:ByteArray):void
        {
            _newBytes = true;
            _OggBytes.length = 0;
            _OggBytes.writeBytes($bytes);
            trace("Loaded New Bytes");
            dispatchEvent(new Event(Event.CHANGE));
            _newBytes = false;
        }

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
