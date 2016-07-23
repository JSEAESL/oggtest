/**
 * Created by Administrator on 2016/7/23.
 */
package newSoundManager {
    public interface ISound
    {
         function loadSound(url:String,loadCompeteRecall:Function):void
         function playSound(voiceNum:int,url:String=null) : void
         function stopSound() : void
         function upSoundVoice(num:int):void
         function removeLoadEvent():void
         function get soundurl():String
         function set soundurl(str:String):void
         function get loadState():int

    }
}
