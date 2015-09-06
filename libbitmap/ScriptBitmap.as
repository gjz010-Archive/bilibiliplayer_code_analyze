package
{
   import flash.display.DisplayObjectContainer;
   import tv.bilibili.script.interfaces.IScriptManager;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import tv.bilibili.script.bilibili;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ScriptBitmap extends Object
   {
       
      private var clip:DisplayObjectContainer;
      
      private var scope:Object;
      
      private var manager:IScriptManager;
      
      public function ScriptBitmap(param1:Object, param2:DisplayObjectContainer, param3:IScriptManager)
      {
         super();
         this.clip = param2;
         this.scope = param1;
         this.manager = param3;
      }
      
      public function createBitmapData(param1:int, param2:int, param3:Boolean = true, param4:uint = 4.294967295E9) : BitmapData
      {
         return new BitmapData(param1,param2,param3,param4);
      }
      
      public function createRectangle(param1:Number, param2:Number, param3:Number, param4:Number) : Rectangle
      {
         return new Rectangle(param1,param2,param3,param4);
      }
      
      public function createBitmap(param1:Object) : CommentBitmap
      {
         if(param1.pixelSnapping == undefined)
         {
            param1.pixelSnapping = "auto";
         }
         if(param1.smoothing == undefined)
         {
            param1.smoothing = false;
         }
         var _loc2_:CommentBitmap = new CommentBitmap(param1.bitmapData,param1.pixelSnapping,param1.smothing);
         var _loc3_:* = this.scope["Display"];
         var _loc4_:Object = _loc3_[new QName(bilibili,"_defaultConfig")];
         var _loc5_:Function = getDefinitionByName(getQualifiedClassName(_loc3_))[new QName(bilibili,"extend")];
         var _loc6_:Function = _loc3_[new QName(bilibili,"setupMotionElement")];
         _loc5_(param1,_loc4_);
         _loc6_(param1,_loc2_);
         if(param1.scale != undefined)
         {
            _loc2_.scaleX = param1.scale;
            _loc2_.scaleY = param1.scale;
         }
         return _loc2_;
      }
      
      public function createParticle(param1:Object) : CommentBitmap
      {
         var iParticleStart:uint = 0;
         var Arr_tp:Array = null;
         var Out:int = 0;
         var bm1:BitmapData = null;
         var bms:CommentBitmap = null;
         var rect:Rectangle = null;
         var loop:Function = null;
         var j:int = 0;
         var tp:Simple2D = null;
         var param:Object = param1;
         loop = function(param1:Event):void
         {
            var _loc3_:Simple2D = null;
            bm1.lock();
            bm1.fillRect(rect,0);
            var _loc2_:* = 0;
            while(_loc2_ < Arr_tp.length)
            {
               _loc3_ = Arr_tp[_loc2_] as Simple2D;
               if(!_loc3_.isOut)
               {
                  _loc3_.update();
                  if(_loc3_.valid(bm1))
                  {
                     Out++;
                  }
                  bm1.setPixel32(_loc3_.x,_loc3_.y,_loc3_.Allcolor);
               }
               _loc2_++;
            }
            bm1.unlock();
            if(Out / Arr_tp.length > 0.8)
            {
               del_loop();
            }
         };
         var del_loop:Function = function():void
         {
            scope.trace("Particle Done @ " + (getTimer() - iParticleStart));
            bms.removeEventListener(Event.ENTER_FRAME,loop);
            bms.remove();
            bm1.dispose();
         };
         if(param.obj == undefined)
         {
            return null;
         }
         iParticleStart = getTimer();
         var pic:DisplayObject = param.obj;
         var radius:int = param.radius == undefined?200:param.radius;
         Arr_tp = [];
         Out = 0;
         var bm:BitmapData = new BitmapData(pic.width,pic.height);
         bm.draw(pic);
         bm1 = new BitmapData(pic.width + radius * 2,pic.height + radius * 2,true,0);
         bms = new CommentBitmap(bm1);
         this.clip.stage.addChild(bms);
         bms.x = 0;
         bms.y = 0;
         var i:int = 0;
         while(i < pic.width)
         {
            j = 0;
            while(j < pic.height)
            {
               if(bm.getPixel32(i,j) != 0)
               {
                  bm1.setPixel32(i + radius,j + radius,bm.getPixel32(i,j));
                  tp = new Simple2D(i + radius,j + radius,(Math.random() - Math.random()) * 5,(Math.random() - Math.random()) * 5,0.5 + Math.random() * 5,bm.getPixel32(i,j));
                  Arr_tp.push(tp);
               }
               j++;
            }
            i++;
         }
         bm.dispose();
         rect = new Rectangle(0,0,bms.width,bms.height);
         bms.addEventListener(Event.ENTER_FRAME,loop);
         return bms;
      }
   }
}
