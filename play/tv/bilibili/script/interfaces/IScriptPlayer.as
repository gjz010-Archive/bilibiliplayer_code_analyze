package tv.bilibili.script.interfaces
{
   import flash.display.DisplayObject;
   
   public interface IScriptPlayer
   {
       
      function play() : void;
      
      function pause() : void;
      
      function seek(param1:Number) : void;
      
      function jump(param1:String, param2:int = 1, param3:Boolean = false) : void;
      
      function get state() : String;
      
      function get time() : Number;
      
      function commentTrigger(param1:Function, param2:Number = 1000) : uint;
      
      function keyTrigger(param1:Function, param2:Number = 1000, param3:Boolean = false) : uint;
      
      function setMask(param1:DisplayObject) : void;
      
      function createSound(param1:String, param2:Function = null) : IScriptSound;
      
      function get commentList() : Array;
      
      function get refreshRate() : int;
      
      function set refreshRate(param1:int) : void;
      
      function get width() : uint;
      
      function get height() : uint;
   }
}
