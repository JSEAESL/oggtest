package
{
	import com.automatastudios.audio.audiodecoder.AudioDecoder;
	import com.automatastudios.audio.audiodecoder.decoders.OggVorbisDecoder;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	public class OggSound
	{
		private var _url:String;
		public function OggSound(url:String)
		{
			super();
			_url = url;
			init(_url);
		}
		private var _urlStream:URLStream;
		private var _decoder:AudioDecoder;
		private var _soundChannel:SoundChannel;

		private function init(url:String):void
		{
			_decoder = new AudioDecoder();
			_urlStream= new URLStream();
			_urlStream.load(new URLRequest(url));
			_decoder.load(_urlStream, OggVorbisDecoder);
			_decoder.addEventListener(Event.INIT, onDecoderReady);
			_decoder.addEventListener(Event.COMPLETE, onSoundComplete);
			_decoder.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		public function play(event:Event = null):void {
			_soundChannel=loadEd?_decoder.sound.play():null;
		}
		public function stop(event:Event = null):void {
			loadEd?_soundChannel.stop():0;
		}
		public function frame(event:Event = null):void {
			trace(_decoder.getPosition().toFixed(2)+"   "+_decoder.getTotalTime().toFixed(2))
		}
		private function onDecoderReady(event:Event):void {
			_soundChannel=_decoder.play();
			trace("onDecoderReady")
		}
		private function onIOError(event:IOErrorEvent):void {
			trace("onIOError")
		}
		private var loadEd:Boolean = false;
		private function onSoundComplete(event:Event):void {
				trace("onSoundComplete");
				loadEd = true;
		}
	}
}