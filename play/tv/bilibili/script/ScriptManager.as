package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IScriptManager;
   import flash.utils.Dictionary;
   import com.longtailvideo.jwplayer.player.IPlayer;
   import com.longtailvideo.jwplayer.events.MediaEvent;
   import tv.bilibili.script.interfaces.IMotionElement;
   import com.longtailvideo.jwplayer.events.PlayerStateEvent;
   import com.longtailvideo.jwplayer.player.PlayerState;
   import flash.utils.Timer;
   
   public class ScriptManager extends Object implements IScriptManager
   {
       
      protected var _elements:Dictionary;
      
      protected var _timers:Dictionary;
      
      private var _player:IPlayer;
      
      bilibili var factory:CommentScriptFactory;
      
      public function ScriptManager(param1:IPlayer)
      {
         this._elements = new Dictionary(true);
         this._timers = new Dictionary(true);
         super();
         this._player = param1;
         this._player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE,this.stateHandler);
         this._player.addEventListener(MediaEvent.JWPLAYER_MEDIA_SEEK,this.seekHandler);
         this._player.addEventListener(MediaEvent.JWPLAYER_MEDIA_COMPLETE,this.playerCompleteHandler);
      }
      
      private function playerCompleteHandler(param1:MediaEvent) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._elements)
         {
            if(_loc2_ is IMotionElement)
            {
               _loc2_["visible"] = false;
            }
         }
      }
      
      private function seekHandler(param1:MediaEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Number = this._player.stime * 1000;
         for(_loc3_ in this._elements)
         {
            if(_loc3_ is IMotionElement)
            {
               _loc3_["visible"] = IMotionElement(_loc3_).motionManager.forcasting(_loc2_);
            }
         }
      }
      
      private function stateHandler(param1:PlayerStateEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.newstate === PlayerState.PLAYING)
         {
            for(_loc2_ in this._elements)
            {
               if(_loc2_ is IMotionElement)
               {
                  IMotionElement(_loc2_).motionManager.play();
               }
            }
            for(_loc3_ in this._timers)
            {
               if(_loc3_ is Timer)
               {
                  Timer(_loc3_).start();
               }
            }
         }
         else if(param1.oldstate === PlayerState.PLAYING)
         {
            for(_loc2_ in this._elements)
            {
               if(_loc2_ is IMotionElement)
               {
                  IMotionElement(_loc2_).motionManager.stop();
               }
            }
            for(_loc3_ in this._timers)
            {
               if(_loc3_ is Timer)
               {
                  Timer(_loc3_).stop();
               }
            }
         }
      }
      
      public function pushTimer(param1:Timer) : void
      {
         this._timers[param1] = true;
      }
      
      public function popTimer(param1:Timer) : void
      {
         var t:Timer = param1;
         try
         {
            delete this._timers[t];
            t.stop();
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function clearTimer() : void
      {
         var t:* = undefined;
         for(t in this._timers)
         {
            try
            {
               delete this._timers[t];
               t["stop"]();
            }
            catch(error:Error)
            {
               continue;
            }
         }
      }
      
      public function pushEl(param1:IMotionElement) : void
      {
         this._elements[param1] = true;
      }
      
      public function popEl(param1:IMotionElement) : void
      {
         var m:IMotionElement = param1;
         try
         {
            delete this._elements[m];
            m.motionManager.stop();
            m["remove"]();
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function clearEl() : void
      {
         var m:* = undefined;
         for(m in this._elements)
         {
            try
            {
               delete this._elements[m];
               m["motionManager"].stop();
               m["remove"]();
            }
            catch(error:Error)
            {
               continue;
            }
         }
      }
      
      public function clearTrigger() : void
      {
         (CommentScriptFactory.getInstance().splayer as ScriptPlayer).bilibili::scriptEventManager.removeAll();
      }
   }
}
