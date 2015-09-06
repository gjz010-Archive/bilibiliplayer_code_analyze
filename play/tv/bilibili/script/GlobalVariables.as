package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IGlobal;
   
   public class GlobalVariables extends Object implements IGlobal
   {
       
      protected var _dict:Object;
      
      public function GlobalVariables()
      {
         this._dict = {};
         super();
      }
      
      public function _set(param1:String, param2:*) : void
      {
         this._dict[param1] = param2;
      }
      
      public function _get(param1:String) : *
      {
         return this._dict[param1];
      }
      
      public function _(param1:String) : *
      {
         return this._dict[param1];
      }
   }
}
