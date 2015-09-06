package tv.bilibili.script.interfaces
{
   public interface ICommentTriggerManager
   {
       
      function addTrigger(param1:Function) : void;
      
      function removeTrigger(param1:Function) : void;
      
      function trigger(param1:Object) : Boolean;
   }
}
