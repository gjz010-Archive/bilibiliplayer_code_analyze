package tv.bilibili.script.interfaces
{
   import flash.utils.Timer;
   
   public interface IScriptUtils
   {
       
      function hue(param1:int) : int;
      
      function rgb(param1:int, param2:int, param3:int) : int;
      
      function formatTimes(param1:Number) : String;
      
      function delay(param1:Function, param2:Number = 1000) : uint;
      
      function interval(param1:Function, param2:Number = 1000, param3:uint = 1) : Timer;
      
      function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number;
      
      function rand(param1:Number, param2:Number) : Number;
      
      function clone(param1:*) : *;
      
      function foreach(param1:Object, param2:Function) : void;
   }
}
