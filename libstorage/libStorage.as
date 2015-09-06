package
{
   import flash.display.Sprite;
   import tv.bilibili.script.interfaces.IExternalScriptLibrary;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.getDefinitionByName;
   import flash.net.URLRequestMethod;
   import flash.display.DisplayObjectContainer;
   import tv.bilibili.script.interfaces.IScriptManager;
   import tv.bilibili.script.bilibili;
   import flash.system.Security;
   
   public class libStorage extends Sprite implements IExternalScriptLibrary
   {
      
      private static const StorageUrl:String = "http://interface.bilibili.tv/advcmtStorage";
      
      private static var Cid:String;
       
      public function libStorage()
      {
         super();
         Security.allowDomain("*");
      }
      
      public static function loadRank(param1:Function, param2:Function = null) : void
      {
         var complete:Function = param1;
         var err:Function = param2;
         var req:URLRequest = new URLRequest(StorageUrl);
         var data:URLVariables = new URLVariables();
         data.act = "scores";
         data["do"] = "rank";
         data.cid = Cid;
         req.data = data;
         new SimpleLoader(req,function(param1:String):void
         {
            var _loc2_:Object = getDefinitionByName("com.adobe.serialization.json.JSON").decode(param1);
            complete(_loc2_);
         },err);
      }
      
      public static function uploadScore(param1:Number, param2:String = null, param3:Function = null, param4:Function = null) : void
      {
         var _loc5_:URLRequest = new URLRequest(StorageUrl + "?act=scores");
         var _loc6_:URLVariables = new URLVariables();
         _loc6_["do"] = "submit";
         _loc6_.cid = Cid;
         _loc6_.score = param1;
         _loc6_.name = param2 == null?"":param2;
         _loc5_.data = _loc6_;
         _loc5_.method = URLRequestMethod.POST;
         new SimpleLoader(_loc5_,param3,param4);
      }
      
      public static function saveData(param1:*, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:URLRequest = new URLRequest(StorageUrl);
         var _loc5_:URLVariables = new URLVariables();
         _loc5_.act = "save";
         _loc5_["do"] = "set";
         _loc5_.cid = Cid;
         _loc5_.data = getDefinitionByName("com.adobe.serialization.json.JSON").encode(param1);
         _loc4_.data = _loc5_;
         _loc4_.method = URLRequestMethod.POST;
         new SimpleLoader(_loc4_,param2,param3);
      }
      
      public static function loadData(param1:Function, param2:Function = null) : void
      {
         var complete:Function = param1;
         var err:Function = param2;
         var req:URLRequest = new URLRequest(StorageUrl);
         var data:URLVariables = new URLVariables();
         data.act = "save";
         data["do"] = "get";
         data.cid = Cid;
         req.data = data;
         req.method = URLRequestMethod.POST;
         new SimpleLoader(req,function(param1:String):void
         {
            var _loc2_:Object = getDefinitionByName("com.adobe.serialization.json.JSON").decode(param1);
            complete(_loc2_);
         },err);
      }
      
      public function initVM(param1:Object, param2:DisplayObjectContainer, param3:IScriptManager) : uint
      {
         Cid = param3[new QName(bilibili,"factory")][new QName(bilibili,"cid")];
         param1["Storage"] = libStorage;
         return 0;
      }
   }
}

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

class SimpleLoader extends Object
{
    
   private var okHandler:Function;
   
   private var errHandler:Function;
   
   function SimpleLoader(param1:URLRequest, param2:Function, param3:Function)
   {
      super();
      this.okHandler = param2;
      this.errHandler = param3;
      var _loc4_:URLLoader = new URLLoader();
      _loc4_.addEventListener(Event.COMPLETE,this.completeHandler);
      _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
      _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      _loc4_.load(param1);
   }
   
   private function completeHandler(param1:Event) : void
   {
      if(this.okHandler != null)
      {
         this.okHandler(param1.target.data);
      }
   }
   
   private function errorHandler(param1:Event) : void
   {
      if(this.errHandler != null)
      {
         this.errHandler(param1.toString());
      }
   }
}
