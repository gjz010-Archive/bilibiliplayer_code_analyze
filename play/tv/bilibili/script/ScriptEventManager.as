package tv.bilibili.script
{
   import flash.events.EventDispatcher;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class ScriptEventManager extends EventDispatcher
   {
       
      private var stage:Stage;
      
      private var hooks:Vector.<Function>;
      
      private var hooksUp:Vector.<Function>;
      
      public function ScriptEventManager(param1:Stage)
      {
         this.hooks = new Vector.<Function>();
         this.hooksUp = new Vector.<Function>();
         super();
         this.stage = param1;
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var code:uint = 0;
         var f:Function = null;
         var event:KeyboardEvent = param1;
         if(this.hooks.length)
         {
            code = event.keyCode;
            if(code == 27 || code >= 96 && code <= 105 || code >= 34 && code <= 40 || code == Keyboard.W || code == Keyboard.S || code == Keyboard.A || code == Keyboard.D)
            {
               for each(f in this.hooks)
               {
                  try
                  {
                     f(code);
                  }
                  catch(e:Error)
                  {
                     trace("KeyTriggerError:" + e.toString());
                     continue;
                  }
               }
            }
         }
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         var code:uint = 0;
         var f:Function = null;
         var event:KeyboardEvent = param1;
         if(this.hooksUp.length)
         {
            code = event.keyCode;
            if(code == 27 || code >= 96 && code <= 105 || code >= 34 && code <= 40 || code == Keyboard.W || code == Keyboard.S || code == Keyboard.A || code == Keyboard.D)
            {
               for each(f in this.hooksUp)
               {
                  try
                  {
                     f(code);
                  }
                  catch(e:Error)
                  {
                     trace("KeyTriggerError:" + e.toString());
                     continue;
                  }
               }
            }
         }
      }
      
      public function addKeyboardHook(param1:Function, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.hooksUp.push(param1);
         }
         else
         {
            this.hooks.push(param1);
         }
      }
      
      public function removeKeyboardHook(param1:Function, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(param2)
         {
            _loc3_ = this.hooksUp.indexOf(param1);
            if(_loc3_ !== -1)
            {
               this.hooksUp.splice(_loc3_,1);
            }
         }
         else
         {
            _loc3_ = this.hooks.indexOf(param1);
            if(_loc3_ !== -1)
            {
               this.hooks.splice(_loc3_,1);
            }
         }
      }
      
      public function removeAll() : void
      {
         this.hooks = new Vector.<Function>();
         this.hooksUp = new Vector.<Function>();
      }
   }
}
