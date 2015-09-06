package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IScriptSound;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.events.Event;
   
   public class ScriptSound extends Object implements IScriptSound
   {
       
      protected var _sound:Sound;
      
      public function ScriptSound(param1:String, param2:Function = null)
      {
         var name:String = param1;
         var onLoad:Function = param2;
         super();
         var url:String = "http://i2.hdslb.com/soundlib/" + name + ".mp3";
         this._sound = new Sound();
         this._sound.load(new URLRequest(url));
         if(onLoad != null)
         {
            this._sound.addEventListener(Event.OPEN,function(param1:Event):void
            {
               onLoad();
            });
         }
      }
      
      public function loadPercent() : uint
      {
         return Math.floor(100 * this._sound.bytesLoaded / this._sound.bytesTotal);
      }
      
      public function play(param1:Number = 0, param2:int = 0) : void
      {
         this._sound.play(param1,param2);
      }
      
      public function stop() : void
      {
      }
      
      public function remove() : void
      {
         this._sound.close();
      }
   }
}
