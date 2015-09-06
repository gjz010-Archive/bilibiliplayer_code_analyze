package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IScriptPlayer;
   import com.longtailvideo.jwplayer.player.IPlayer;
   import tv.bilibili.script.interfaces.IScriptConfig;
   import flash.external.ExternalInterface;
   import flash.utils.setTimeout;
   import flash.utils.clearTimeout;
   import flash.display.DisplayObject;
   import tv.bilibili.script.interfaces.IScriptSound;
   import com.longtailvideo.jwplayer.events.PlayerStateEvent;
   import com.longtailvideo.jwplayer.player.PlayerState;
   import com.longtailvideo.jwplayer.events.MediaEvent;
   
   public final class ScriptPlayer extends Object implements IScriptPlayer
   {
       
      protected var _player:IPlayer;
      
      protected var _state:String;
      
      protected var _time:Number;
      
      protected var _config:IScriptConfig;
      
      bilibili var scriptEventManager:ScriptEventManager;
      
      public function ScriptPlayer(param1:IPlayer, param2:IScriptConfig)
      {
         super();
         this._player = param1;
         this._state = "pause";
         this._time = 0;
         this._config = param2;
         bilibili::scriptEventManager = new ScriptEventManager(this._player["stage"]);
         this._player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE,this.stateHandler);
         this._player.addEventListener(MediaEvent.JWPLAYER_MEDIA_COMPLETE,this.completeHandler);
         this._player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME,this.timeHandler);
      }
      
      public function play() : void
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return;
         }
         this._player.play();
      }
      
      public function pause() : void
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return;
         }
         this._player.pause();
      }
      
      public function seek(param1:Number) : void
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return;
         }
         this._player.seek(param1 / 1000);
      }
      
      public function jump(param1:String, param2:int = 1, param3:Boolean = false) : void
      {
         var av:String = param1;
         var page:int = param2;
         var newWindow:Boolean = param3;
         if(!this._config.isPlayerControlApiEnable)
         {
            return;
         }
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.call("onPlayerScriptJump",av,page,newWindow);
               return;
            }
            catch(e:Error)
            {
               return;
            }
         }
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get time() : Number
      {
         return this._time * 1000;
      }
      
      public function commentTrigger(param1:Function, param2:Number = 1000) : uint
      {
         var timer:uint = 0;
         var func:Function = param1;
         var timeout:Number = param2;
         if(!this._config.isPlayerControlApiEnable)
         {
            return 0;
         }
         this._config.commentTriggerManager.addTrigger(func);
         timer = setTimeout(function():void
         {
            clearTimeout(timer);
            _config.commentTriggerManager.removeTrigger(func);
         },timeout);
         return timer;
      }
      
      public function keyTrigger(param1:Function, param2:Number = 1000, param3:Boolean = false) : uint
      {
         var timer:uint = 0;
         var func:Function = param1;
         var timeout:Number = param2;
         var isUp:Boolean = param3;
         if(!this._config.isPlayerControlApiEnable)
         {
            return 0;
         }
         bilibili::scriptEventManager.addKeyboardHook(func,isUp);
         timer = setTimeout(function():void
         {
            clearTimeout(timer);
            bilibili::scriptEventManager.removeKeyboardHook(func,isUp);
         },timeout);
         return timer;
      }
      
      public function setMask(param1:DisplayObject) : void
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return;
         }
         var _loc2_:DisplayObject = this._player["parent"];
         _loc2_.mask = param1;
      }
      
      public function createSound(param1:String, param2:Function = null) : IScriptSound
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return null;
         }
         var _loc3_:IScriptSound = new ScriptSound(param1,param2);
         return _loc3_;
      }
      
      public function get commentList() : Array
      {
         if(!this._config.isPlayerControlApiEnable)
         {
            return [];
         }
         return this._config.commentList;
      }
      
      public function get refreshRate() : int
      {
         return 0;
      }
      
      public function set refreshRate(param1:int) : void
      {
      }
      
      public function get width() : uint
      {
         return this._player.controls.display.width;
      }
      
      public function get height() : uint
      {
         return this._player.controls.display.height;
      }
      
      public function get videoWidth() : uint
      {
         return this._player.videoWidth;
      }
      
      public function get videoHeight() : uint
      {
         return this._player.videoHeight;
      }
      
      public function get isContinueMode() : Boolean
      {
         return false;
      }
      
      protected function stateHandler(param1:PlayerStateEvent) : void
      {
         if(param1.newstate == PlayerState.PAUSED)
         {
            this._state = "pause";
         }
         else
         {
            this._state = "playing";
         }
      }
      
      protected function completeHandler(param1:MediaEvent) : void
      {
         this._state = "stop";
      }
      
      protected function timeHandler(param1:MediaEvent) : void
      {
         this._time = param1.position;
      }
   }
}
