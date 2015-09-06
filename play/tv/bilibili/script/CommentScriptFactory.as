package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.ICommentScriptFactory;
   import tv.bilibili.net.IAccessConfigConsumer;
   import tv.bilibili.script.interfaces.IScriptDisplay;
   import tv.bilibili.script.interfaces.IScriptPlayer;
   import tv.bilibili.script.interfaces.IScriptUtils;
   import tv.bilibili.script.interfaces.IGlobal;
   import tv.bilibili.script.interfaces.IScriptManager;
   import tv.bilibili.script.interfaces.IScriptConfig;
   import com.longtailvideo.jwplayer.player.IPlayer;
   import flash.display.DisplayObjectContainer;
   import tv.bilibili.net.AccessConfig;
   import flash.utils.getTimer;
   import flash.utils.clearTimeout;
   import org.libspark.betweenas3.BetweenAS3;
   import scripting.VirtualMachine;
   import scripting.Scanner;
   import scripting.Parser;
   import tv.bilibili.script.interfaces.IExternalScriptLibrary;
   import org.lala.event.EventBus;
   import flash.display.Loader;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import flash.events.IOErrorEvent;
   import tv.bilibili.net.AccessConsumerManager;
   
   public final class CommentScriptFactory extends Object implements ICommentScriptFactory, IAccessConfigConsumer
   {
      
      protected static var _instance:CommentScriptFactory;
       
      protected var _display:IScriptDisplay;
      
      protected var _player:IScriptPlayer;
      
      protected var _utils:IScriptUtils;
      
      protected var _global:IGlobal;
      
      protected var _scriptManager:IScriptManager;
      
      protected var globals:Object;
      
      protected var config:IScriptConfig;
      
      public var _$loaderData:Array;
      
      public var _$loaderList:Array;
      
      public var _jwplayer:IPlayer;
      
      bilibili var cid:String;
      
      bilibili var clip:DisplayObjectContainer;
      
      private const innerLibs:Array = [];
      
      public function CommentScriptFactory()
      {
         this._$loaderData = [];
         this._$loaderList = [];
         super();
         AccessConsumerManager.regist(this);
      }
      
      public static function getInstance() : CommentScriptFactory
      {
         if(_instance == null)
         {
            _instance = new CommentScriptFactory();
         }
         return _instance;
      }
      
      public function onAccessConfigUpdate(param1:AccessConfig) : void
      {
         bilibili::cid = param1.cid;
      }
      
      public function initial(param1:IPlayer, param2:DisplayObjectContainer, param3:IScriptConfig) : void
      {
         bilibili::clip = param2;
         this.config = param3;
         this._jwplayer = param1;
         this._scriptManager = new ScriptManager(param1);
         (this._scriptManager as ScriptManager).bilibili::factory = this;
         this._player = new ScriptPlayer(param1,param3);
         this._display = new ScriptDisplay(param1,param2,this._scriptManager as ScriptManager);
         this._utils = new ScriptUtils(this._scriptManager as ScriptManager);
         this._global = new GlobalVariables();
         this.globals = {
            "trace":this.tracex,
            "clear":this.clear,
            "getTimer":getTimer,
            "clearTimeout":clearTimeout,
            "parseInt":parseInt,
            "parseFloat":parseFloat,
            "Math":Math,
            "String":String,
            "interval":this._utils.interval,
            "timer":this._utils.delay,
            "clone":this._utils.clone,
            "foreach":this._utils.foreach,
            "Utils":this._utils,
            "Player":this._player,
            "Display":this._display,
            "$":this._display,
            "Global":this._global,
            "$G":this._global,
            "ScriptManager":this._scriptManager,
            "Tween":BetweenAS3,
            "TweenEasing":BetweenAS3TweenEasing
         };
         var _loc4_:Object = new ScriptBitmap(this.globals,(this._display as ScriptDisplay).root,this._scriptManager);
         this.globals.Bitmap = _loc4_;
         this.innerLibs.push("libBitmap");
      }
      
      public function exec(param1:String, param2:Boolean = true) : void
      {
         var vm:VirtualMachine = null;
         var getClass:Class = null;
         var childObj:IExternalScriptLibrary = null;
         var startTime:int = 0;
         var costTime:int = 0;
         var script:String = param1;
         var debugInfo:Boolean = param2;
         if(!this.config.scriptEnabled)
         {
            return;
         }
         vm = new VirtualMachine();
         this.installGlobals(vm);
         vm.getGlobalObject().load = function load(param1:String, param2:Function):void
         {
            if(innerLibs.indexOf(param1) !== -1)
            {
               param2();
               return;
            }
            if(_$loaderList.indexOf(param1) != -1)
            {
               param2();
               return;
            }
            _$loaderList.push(param1);
            importExtendLibrary(vm,param1,param2);
         };
         for each(getClass in this._$loaderData)
         {
            childObj = new getClass() as IExternalScriptLibrary;
            this.tracex("importExtendLibrary : create object..." + childObj.initVM(vm.getGlobalObject(),(this._display as ScriptDisplay).root,this._scriptManager));
         }
         if(debugInfo)
         {
            startTime = getTimer();
            this.tracex("=====================================");
         }
         var s:Scanner = new Scanner(script);
         var p:Parser = new Parser(s);
         vm.rewind();
         vm.setByteCode(p.parse(vm));
         var ret:Boolean = vm.execute();
         if(debugInfo)
         {
            costTime = getTimer() - startTime;
            this.tracex("Execute in " + costTime + "ms");
         }
      }
      
      protected function installGlobals(param1:VirtualMachine) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = param1.getGlobalObject();
         for(_loc3_ in this.globals)
         {
            _loc2_[_loc3_] = this.globals[_loc3_];
         }
      }
      
      protected function tracex(... rest) : void
      {
         EventBus.getInstance().log(rest.join(" "));
      }
      
      protected function clear() : void
      {
         EventBus.getInstance().clear();
      }
      
      private function importExtendLibrary(param1:*, param2:String, param3:Function) : void
      {
         var url:URLRequest = null;
         var vm:* = param1;
         var lib:String = param2;
         var callback:Function = param3;
         this.tracex("importExtendLibrary : " + lib);
         var loader:Loader = new Loader();
         var domain:ApplicationDomain = ApplicationDomain.currentDomain;
         var ldrContext:LoaderContext = new LoaderContext(false,domain);
         this.tracex("importExtendLibrary : " + lib + " Downloading...");
         if(bilibili::clip.loaderInfo.loaderURL.indexOf("https://") === 0)
         {
            url = new URLRequest("https://static-s.bilibili.com/playerLibrary/" + lib + "_2.swf");
         }
         else
         {
            url = new URLRequest("http://static.hdslb.com/playerLibrary/" + lib + "_2.swf");
         }
         var completeHandler:Function = function(param1:Event = null):void
         {
            var getClass:Class = null;
            var childObj:IExternalScriptLibrary = null;
            var event:Event = param1;
            try
            {
               tracex("importExtendLibrary : " + lib + " Initalizing...");
               getClass = getDefinitionByName(lib) as Class;
               _$loaderData.push(getClass);
               childObj = new getClass() as IExternalScriptLibrary;
               tracex("importExtendLibrary : " + lib + " create object..." + childObj.initVM(vm.getGlobalObject(),(_display as ScriptDisplay).root,_scriptManager));
               tracex("importExtendLibrary : " + lib + " done");
               callback();
               return;
            }
            catch(e:Error)
            {
               tracex("importExtendLibrary : err " + e.toString());
               return;
            }
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadErrorHandler);
         loader.load(url,ldrContext);
      }
      
      private function loadErrorHandler(param1:Event) : void
      {
         this.tracex("extendLibraryLoadingError:" + param1.toString());
      }
      
      public function trace(... rest) : void
      {
         this.tracex.apply(this,rest);
      }
      
      public function get player() : IPlayer
      {
         return this._jwplayer;
      }
      
      public function get splayer() : IScriptPlayer
      {
         return this._player;
      }
      
      public function get _$ScriptManager() : IScriptManager
      {
         return this._scriptManager;
      }
      
      public function get cm() : Object
      {
         return null;
      }
      
      public function get onPlay() : Function
      {
         return function():void
         {
         };
      }
   }
}
