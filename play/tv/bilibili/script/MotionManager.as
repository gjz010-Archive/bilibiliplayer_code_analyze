package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IMotionManager;
   import org.libspark.betweenas3.tweens.ITweenGroup;
   import flash.utils.Timer;
   import flash.display.DisplayObject;
   import flash.utils.getTimer;
   import flash.events.Event;
   import org.libspark.betweenas3.tweens.ITween;
   import org.libspark.betweenas3.core.easing.IEasing;
   import org.libspark.betweenas3.easing.Back;
   import org.libspark.betweenas3.easing.Bounce;
   import org.libspark.betweenas3.easing.Circular;
   import org.libspark.betweenas3.easing.Cubic;
   import org.libspark.betweenas3.easing.Elastic;
   import org.libspark.betweenas3.easing.Exponential;
   import org.libspark.betweenas3.easing.Sine;
   import org.libspark.betweenas3.easing.Quintic;
   import org.libspark.betweenas3.easing.Linear;
   import org.libspark.betweenas3.BetweenAS3;
   import org.libspark.betweenas3.events.TweenEvent;
   import flash.events.TimerEvent;
   
   public class MotionManager extends Object implements IMotionManager
   {
       
      private const acceptValue:Array = ["x","y","alpha","rotationZ","rotationY","rotationX","fontsize"];
      
      private var _$tmv:ITweenGroup;
      
      private var _$tmr:Timer = null;
      
      private var _$MotionConfig:Object;
      
      private var _$CompleteCallBack:Function = null;
      
      private var _$target:DisplayObject;
      
      private var optimizedGroup:Array;
      
      private var isRelative:Boolean = false;
      
      private var motionComplete:Boolean = false;
      
      private var motionPlayTime:uint = 0;
      
      private var _$internalTimer:uint = 0;
      
      private var _$internalRun:uint = 0;
      
      private var _$running:Boolean = false;
      
      private var uniqid:uint;
      
      public function MotionManager(param1:DisplayObject)
      {
         this._$MotionConfig = new Object();
         this.optimizedGroup = [];
         this.uniqid = getTimer() * 10 + Math.floor(Math.random() * 10);
         super();
         this._$target = param1;
      }
      
      public function get running() : Boolean
      {
         return this._$running;
      }
      
      private function onEnterFrame(... rest) : void
      {
         if(this._$internalRun + getTimer() - this._$internalTimer > this._$MotionConfig.lifeTime * 1000)
         {
            this._$target.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.stop();
            if(this._$CompleteCallBack != null)
            {
               this._$CompleteCallBack(null);
            }
         }
      }
      
      public function reset() : void
      {
         this.stop();
         this._$tmv.gotoAndStop(0);
         this.motionComplete = false;
      }
      
      public function play() : void
      {
         if(this._$running)
         {
            return;
         }
         if(this.isRelative)
         {
            this.updateTween();
         }
         if(!this._$running && this._$MotionConfig.lifeTime > 0)
         {
            this._$internalTimer = getTimer();
            this._$target.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this._$running = true;
         if(!this.motionComplete && this._$tmv)
         {
            this._$tmv.play();
         }
      }
      
      public function stop() : void
      {
         if(!this._$running)
         {
            return;
         }
         if(this._$tmv)
         {
            this._$tmv.stop();
         }
         if(this._$running)
         {
            if(this._$MotionConfig.lifeTime > 0)
            {
               this._$internalRun = this._$internalRun + (getTimer() - this._$internalTimer);
               this._$target.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            this._$running = false;
         }
      }
      
      public function forcasting(param1:Number) : Boolean
      {
         if(this._$MotionConfig.lifeTime == 0 && param1 > this.motionPlayTime)
         {
            return true;
         }
         if(this._$MotionConfig.lifeTime == 0)
         {
            return false;
         }
         if(param1 > this.motionPlayTime && param1 < this.motionPlayTime + this._$MotionConfig.lifeTime * 1000)
         {
            return true;
         }
         return false;
      }
      
      public function setPlayTime(param1:Number) : void
      {
         this.motionPlayTime = param1;
      }
      
      private function updateTween() : void
      {
         var optimizedGroupItem:Array = null;
         var cfg_grp:Object = null;
         var tmv:ITween = null;
         var fromValue:Object = null;
         var toValue:Object = null;
         var lifeTime:Number = NaN;
         var startDelay:Number = NaN;
         var repeat:Number = NaN;
         var s_easing:String = null;
         var t_easing:IEasing = null;
         var cfg:Object = null;
         var tmv_f:Function = null;
         var tmvList:Array = [];
         var serials:Array = [];
         for each(optimizedGroupItem in this.optimizedGroup)
         {
            for each(cfg_grp in optimizedGroupItem)
            {
               fromValue = [];
               toValue = [];
               lifeTime = 0;
               repeat = 1;
               s_easing = "Sine";
               for each(cfg in cfg_grp)
               {
                  if(!lifeTime)
                  {
                     lifeTime = cfg.lifeTime;
                     startDelay = cfg.startDelay;
                     s_easing = cfg.easing;
                     repeat = cfg.repeat;
                  }
                  if(this.isRelative)
                  {
                     if(cfg.key == "x")
                     {
                        if(cfg.fromValue > 0 && cfg.fromValue < 1)
                        {
                           cfg.fromValue = this._$target.parent.width * cfg.fromValue;
                        }
                        if(cfg.toValue > 0 && cfg.toValue < 1)
                        {
                           cfg.toValue = this._$target.parent.width * cfg.toValue;
                        }
                     }
                     else if(cfg.key == "y")
                     {
                        if(cfg.fromValue > 0 && cfg.fromValue < 1)
                        {
                           cfg.fromValue = this._$target.parent.width * cfg.fromValue;
                        }
                        if(cfg.toValue > 0 && cfg.toValue < 1)
                        {
                           cfg.toValue = this._$target.parent.width * cfg.toValue;
                        }
                     }
                  }
                  fromValue[cfg.key] = cfg.fromValue;
                  toValue[cfg.key] = cfg.toValue;
               }
               switch(s_easing)
               {
                  case "None":
                     t_easing = null;
                     break;
                  case "Back":
                     t_easing = Back.easeInOut;
                     break;
                  case "Bounce":
                     t_easing = Bounce.easeInOut;
                     break;
                  case "Circular":
                     t_easing = Circular.easeInOut;
                     break;
                  case "Cubic":
                     t_easing = Cubic.easeInOut;
                     break;
                  case "Elastic":
                     t_easing = Elastic.easeInOut;
                     break;
                  case "Exponential":
                     t_easing = Exponential.easeInOut;
                     break;
                  case "Sine":
                     t_easing = Sine.easeInOut;
                     break;
                  case "Quintic":
                     t_easing = Quintic.easeInOut;
                     break;
                  case "Linear":
                     t_easing = Linear.easeInOut;
                     break;
                  default:
                     t_easing = Sine.easeInOut;
               }
               tmv = BetweenAS3.tween(this._$target,toValue,fromValue,lifeTime,t_easing);
               if(startDelay)
               {
                  tmv = BetweenAS3.delay(tmv,startDelay / 1000);
               }
               if(repeat > 1)
               {
                  tmv = BetweenAS3.repeat(tmv,repeat);
               }
               tmv_f = function():void
               {
                  motionComplete = true;
                  tmv.removeEventListener(TweenEvent.COMPLETE,tmv_f);
               };
               tmv.addEventListener(TweenEvent.COMPLETE,tmv_f);
               tmvList.push(tmv);
            }
            serials.push(BetweenAS3.parallelTweens(tmvList));
         }
         if(serials.length == 1)
         {
            this._$tmv = serials.pop();
         }
         else
         {
            this._$tmv = BetweenAS3.serialTweens(tmvList);
         }
      }
      
      public function initTween(param1:Object, param2:Boolean = false) : String
      {
         var key:String = null;
         var subKey:String = null;
         var tmr_f:Function = null;
         var MotionConfig:Object = param1;
         var motionGroup:Boolean = param2;
         if(!motionGroup)
         {
            this.optimizedGroup.length = 0;
         }
         var mKey:int = this.optimizedGroup.length;
         this.optimizedGroup[mKey] = [];
         this.isRelative = false;
         if(MotionConfig.lifeTime == undefined)
         {
            MotionConfig.lifeTime = 3;
         }
         for each(key in this.acceptValue)
         {
            if(MotionConfig[key] != undefined)
            {
               if(!MotionConfig[key].lifeTime)
               {
                  MotionConfig[key].lifeTime = MotionConfig.lifeTime;
               }
               if(MotionConfig[key].startDelay == undefined || MotionConfig[key].startDelay <= 0)
               {
                  MotionConfig[key].startDelay = 0;
               }
               if(MotionConfig[key].toValue == undefined)
               {
                  if(MotionConfig[key].fromValue == undefined)
                  {
                     return "Motion " + key + " error: no transform";
                  }
                  MotionConfig[key].toValue = MotionConfig[key].fromValue;
               }
               if(MotionConfig[key].easing == undefined)
               {
                  MotionConfig[key].easing = "Linear";
               }
               if(MotionConfig[key].repeat == undefined)
               {
                  MotionConfig[key].repeat = 1;
               }
               subKey = MotionConfig[key].lifeTime.toString() + "," + MotionConfig[key].startDelay.toString() + "," + MotionConfig[key].easing + "," + MotionConfig[key].repeat;
               if(key == "x")
               {
                  if(MotionConfig[key].fromValue > 0 && MotionConfig[key].fromValue < 1)
                  {
                     this.isRelative = true;
                  }
                  else if(MotionConfig[key].toValue > 0 && MotionConfig[key].toValue < 1)
                  {
                     this.isRelative = true;
                  }
               }
               else if(key == "y")
               {
                  if(MotionConfig[key].fromValue > 0 && MotionConfig[key].fromValue < 1)
                  {
                     this.isRelative = true;
                  }
                  else if(MotionConfig[key].toValue > 0 && MotionConfig[key].toValue < 1)
                  {
                     this.isRelative = true;
                  }
               }
               MotionConfig[key].key = key;
               if(this.optimizedGroup[mKey][subKey] == undefined)
               {
                  this.optimizedGroup[mKey][subKey] = [];
               }
               this.optimizedGroup[mKey][subKey].push(MotionConfig[key]);
            }
         }
         if(MotionConfig.lifeTime > 0 && !motionGroup)
         {
            this._$tmr = new Timer(MotionConfig.lifeTime * 1000,1);
            this._$tmr.stop();
            tmr_f = function(param1:TimerEvent):void
            {
               _$tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmr_f);
               _$tmr.stop();
               _$tmv.stop();
               if(_$CompleteCallBack != null)
               {
                  _$CompleteCallBack(param1);
               }
            };
            this._$tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmr_f);
         }
         else if(!motionGroup)
         {
            this._$tmr = null;
         }
         this._$MotionConfig = MotionConfig;
         if(!this.isRelative)
         {
            this.updateTween();
         }
         return "";
      }
      
      public function initTweenGroup(param1:Array, param2:Number = NaN) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         this.optimizedGroup.length = 0;
         for each(_loc3_ in param1)
         {
            if(!isNaN(param2))
            {
               _loc3_.lifeTime = param2;
            }
            _loc4_ = this.initTween(_loc3_,true);
            if(_loc4_)
            {
               throw new Error(_loc4_);
            }
         }
      }
      
      public function setCompleteListener(param1:Function) : void
      {
         this._$CompleteCallBack = param1;
      }
   }
}
