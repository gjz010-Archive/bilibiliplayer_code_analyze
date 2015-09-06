package
{
   import tv.bilibili.script.interfaces.IExternalScriptLibrary;
   import flash.display.DisplayObjectContainer;
   import tv.bilibili.script.interfaces.IScriptManager;
   
   public class libBitmap extends Object implements IExternalScriptLibrary
   {
       
      public function libBitmap()
      {
         super();
      }
      
      public function initVM(param1:Object, param2:DisplayObjectContainer, param3:IScriptManager) : uint
      {
         var _loc4_:ScriptBitmap = new ScriptBitmap(param1,param2,param3);
         param1.Bitmap = _loc4_;
         return 0;
      }
   }
}
