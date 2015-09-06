package
{
   import flash.display.Bitmap;
   import tv.bilibili.script.interfaces.IMotionElement;
   import tv.bilibili.script.interfaces.IMotionManager;
   import flash.display.BitmapData;
   
   public class CommentBitmap extends Bitmap implements IMotionElement
   {
       
      private var _motionManager:IMotionManager;
      
      public function CommentBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function play() : void
      {
      }
      
      public function stop() : void
      {
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function remove() : void
      {
         try
         {
            if(this.parent)
            {
               this.parent.removeChild(this);
            }
            if(this._motionManager)
            {
               this._motionManager.stop();
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      public function setParent(param1:*) : void
      {
         param1.addChild(this);
      }
      
      public function get motionManager() : IMotionManager
      {
         return this._motionManager;
      }
      
      bilibili function set motionManager(param1:IMotionManager) : void
      {
         this._motionManager = param1;
      }
   }
}
