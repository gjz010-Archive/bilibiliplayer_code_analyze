package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IScriptUtils;
   import flash.utils.setTimeout;
   import flash.utils.clearTimeout;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   
   public class ScriptUtils extends Object implements IScriptUtils
   {
       
      protected var _scriptManager:ScriptManager;
      
      public function ScriptUtils(param1:ScriptManager)
      {
         super();
         this._scriptManager = param1;
      }
      
      public function hue(param1:int) : int
      {
         var _loc2_:Array = [0,120,240];
         var _loc3_:Array = [124,240,360];
         var _loc4_:Array = [240,360,480];
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var param1:int = param1 % 360;
         if(param1 > _loc2_[0] && param1 < _loc2_[2])
         {
            _loc5_ = 100 - 50 * Math.abs(param1 - _loc2_[1]) / 120;
         }
         if(param1 > _loc3_[0] && param1 < _loc3_[2])
         {
            _loc6_ = 100 - 50 * Math.abs(param1 - _loc3_[1]) / 120;
         }
         if(param1 > _loc4_[0] && param1 <= _loc4_[1])
         {
            _loc7_ = 100 - 50 * Math.abs(param1 - _loc4_[1]) / 120;
         }
         else if(param1 + 360 >= _loc4_[1] && param1 + 360 < _loc4_[2])
         {
            _loc7_ = 100 - 50 * Math.abs(param1 + 360 - _loc4_[1]) / 120;
         }
         return int(_loc5_ * 255 / 100) << 16 | int(_loc6_ * 255 / 100) << 8 | int(_loc7_ * 255 / 100);
      }
      
      public function rgb(param1:int, param2:int, param3:int) : int
      {
         return param1 << 16 | param2 << 8 | param3;
      }
      
      public function formatTimes(param1:Number) : String
      {
         if(param1 < 0)
         {
            return "-" + this.formatTimes(-param1);
         }
         var _loc2_:uint = Math.floor(param1 % 60);
         var _loc3_:uint = Math.floor(param1 / 60);
         return (_loc3_ < 10?"0":"") + _loc3_.toString() + ":" + ("0" + _loc2_.toString()).substr(-2,2);
      }
      
      public function delay(param1:Function, param2:Number = 1000) : uint
      {
         var t:uint = 0;
         var f:Function = param1;
         var time:Number = param2;
         if(time < 1)
         {
            time = 1;
         }
         t = setTimeout(function():void
         {
            f();
            clearTimeout(t);
         },time);
         return t;
      }
      
      public function interval(param1:Function, param2:Number = 1000, param3:uint = 1) : Timer
      {
         var timer:Timer = null;
         var timerHandler:Function = null;
         var completeHandler:Function = null;
         var f:Function = param1;
         var time:Number = param2;
         var times:uint = param3;
         timerHandler = function(param1:TimerEvent):void
         {
            f();
         };
         completeHandler = function(param1:TimerEvent):void
         {
            _scriptManager.popTimer(timer);
            timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
         };
         timer = new Timer(time,times);
         this._scriptManager.pushTimer(timer);
         timer.addEventListener(TimerEvent.TIMER,timerHandler);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
         timer.start();
         return timer;
      }
      
      public function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.sqrt((param3 - param1) * (param3 - param1) + (param4 - param2) * (param4 - param2));
      }
      
      public function rand(param1:Number, param2:Number) : Number
      {
         return Math.floor(param1 + Math.random() * (param2 - param1));
      }
      
      public function clone(param1:*) : *
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Class = getDefinitionByName(_loc2_) as Class;
         registerClassAlias(_loc2_,_loc3_);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param1);
         _loc4_.position = 0;
         return _loc4_.readObject();
      }
      
      public function foreach(param1:Object, param2:Function) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            param2.call(null,_loc3_,param1[_loc3_]);
         }
      }
   }
}
