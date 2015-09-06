package tv.bilibili.script.interfaces
{
   public interface IScriptSound
   {
       
      function loadPercent() : uint;
      
      function play(param1:Number = 0, param2:int = 0) : void;
      
      function stop() : void;
      
      function remove() : void;
   }
}
