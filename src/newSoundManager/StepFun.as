/**
 * Created by Administrator on 2016/7/23.
 */
package newSoundManager {
public class StepFun {

        public function StepFun()
        {
        }
        private  var FunList:Vector.<Function>;
        public  function pushStepFun(fun:Function):void
        {
            var list:Vector.<Function> = FunList?FunList:new Vector.<Function>();
            list.push(fun);
            FunList = list;
        }

        public  function callFun():void
        {
            var list:Vector.<Function> = FunList?FunList:new Vector.<Function>();
            var fun:Function = list.length?list.pop():null;
            fun?fun.apply(null,null):0
        }



    }
}
