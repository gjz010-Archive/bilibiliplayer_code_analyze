package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.ICommentTriggerManager;
   import org.lala.event.EventBus;
   
   public class CommentTriggerManager extends Object implements ICommentTriggerManager
   {
       
      private var hooks:Vector.<Function>;
      
      public function CommentTriggerManager()
      {
         super();
         this.hooks = new Vector.<Function>();
      }
      
      public function addTrigger(param1:Function) : void
      {
         this.hooks.push(param1);
      }
      
      public function removeTrigger(param1:Function) : void
      {
         var _loc2_:int = this.hooks.indexOf(param1);
         if(_loc2_ !== -1)
         {
            this.hooks.splice(_loc2_,1);
         }
      }
      
      public function trigger(param1:Object) : Boolean
      {
         var i:int = 0;
         var item:Object = param1;
         if(this.hooks.length == 0)
         {
            return false;
         }
         var len:int = this.hooks.length;
         try
         {
            i = 0;
            while(i < len)
            {
               this.hooks[i].call(null,item);
               i++;
            }
         }
         catch(err:Error)
         {
            EventBus.getInstance().log(err.toString());
         }
         return true;
      }
   }
}
