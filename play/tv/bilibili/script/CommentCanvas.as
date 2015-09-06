package tv.bilibili.script
{
   import flash.display.Sprite;
   import tv.bilibili.script.interfaces.ICommentCanvas;
   import tv.bilibili.script.interfaces.IMotionManager;
   
   public class CommentCanvas extends Sprite implements ICommentCanvas
   {
       
      protected var _motionManager:IMotionManager;
      
      public function CommentCanvas()
      {
         super();
         this._motionManager = new MotionManager(this);
      }
      
      public function get motionManager() : IMotionManager
      {
         return this._motionManager;
      }
      
      public function initStyle(param1:Object) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         this.alpha = param1.alpha;
         this.scaleX = this.scaleY = param1.scale;
         this.mouseEnabled = false;
      }
      
      public function remove() : void
      {
         try
         {
            this._motionManager.stop();
            this.parent.removeChild(this);
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
   }
}
