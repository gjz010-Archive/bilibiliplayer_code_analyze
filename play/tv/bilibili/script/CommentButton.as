package tv.bilibili.script
{
   import flash.display.Sprite;
   import tv.bilibili.script.interfaces.ICommentButton;
   import flash.filters.DropShadowFilter;
   import tv.bilibili.script.interfaces.IMotionManager;
   import flash.text.TextField;
   import flash.geom.Matrix;
   import flash.display.GradientType;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFieldAutoSize;
   
   public class CommentButton extends Sprite implements ICommentButton
   {
      
      protected static var _shadow:Array = [new DropShadowFilter(1,45,0,0.3,2,2)];
       
      protected var _motionManager:IMotionManager;
      
      protected var _label:TextField;
      
      protected var _colors:Array;
      
      protected var _alphas:Array;
      
      protected var _over:Boolean = false;
      
      protected var _fillMatrix:Matrix;
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      public function CommentButton()
      {
         this._colors = [];
         this._alphas = [];
         super();
         this._motionManager = new MotionManager(this);
         mouseEnabled = true;
         buttonMode = true;
         useHandCursor = true;
         this._label = new TextField();
         var _loc1_:TextFormat = new TextFormat(null,12,0,true);
         this._label.defaultTextFormat = _loc1_;
         this._label.autoSize = TextFieldAutoSize.LEFT;
         this._label.selectable = false;
         this._label.mouseEnabled = false;
         addChild(this._label);
         this._fillMatrix = new Matrix();
         addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
      }
      
      public function get motionManager() : IMotionManager
      {
         return this._motionManager;
      }
      
      public function initStyle(param1:Object) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         this.width = param1.width;
         this.height = param1.height;
         this.alpha = param1.alpha;
         this.scaleX = this.scaleY = param1.scale;
      }
      
      public function get text() : String
      {
         return this._label.text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._label.text != param1)
         {
            this._label.text = param1;
            this.updateRect();
         }
      }
      
      protected function updateRect() : void
      {
         if(this._width <= 0)
         {
            this._width = this._label.width + 12;
         }
         if(this._height <= 0)
         {
            this._height = this._label.height + 5;
         }
         this._label.x = (this._width - this._label.width) / 2;
         this._label.y = (this._height - this._label.height) / 2;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         if(this._colors.length == 0)
         {
            _loc1_ = [16777215,14540253];
         }
         else
         {
            _loc1_ = this._colors;
         }
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc1_.length;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ < this._alphas.length)
            {
               _loc2_[_loc4_] = this._alphas[_loc4_];
            }
            else
            {
               _loc2_[_loc4_] = this._over?0.8:0.618;
            }
            _loc3_[_loc4_] = Math.floor(_loc4_ / _loc5_ * 255);
            _loc4_++;
         }
         this.graphics.clear();
         this.graphics.lineStyle(1,8947848);
         if(_loc1_.length == 1)
         {
            this.graphics.beginFill(_loc1_[0],0.8);
         }
         else
         {
            this._fillMatrix.createGradientBox(this._width,this._height,Math.PI / 2);
            this.graphics.beginGradientFill(GradientType.LINEAR,_loc1_,_loc2_,_loc3_,this._fillMatrix);
         }
         this.graphics.drawRoundRect(0,0,this._width,this._height,4,4);
         this.graphics.endFill();
         this.filters = this._over?[]:_shadow;
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case "fillColors":
               this.fillColors = param2;
               break;
            case "fillAlphas":
               this.fillAlphas = param2;
               break;
         }
      }
      
      public function get fillColors() : Array
      {
         return this._colors;
      }
      
      public function set fillColors(param1:Array) : void
      {
         this._colors = param1;
         this.updateRect();
      }
      
      public function get fillAlphas() : Array
      {
         return this._alphas;
      }
      
      public function set fillAlphas(param1:Array) : void
      {
         this._alphas = param1;
         this.updateRect();
      }
      
      public function remove() : void
      {
         try
         {
            this._motionManager.stop();
            this.parent.removeChild(this);
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width != param1)
         {
            this._width = param1;
            this.updateRect();
         }
         super.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height != param1)
         {
            this._height = param1;
            this.updateRect();
         }
         super.height = param1;
      }
      
      protected function overHandler(param1:MouseEvent) : void
      {
         this._over = true;
         this.updateRect();
      }
      
      protected function outHandler(param1:MouseEvent) : void
      {
         this._over = false;
         this.updateRect();
      }
   }
}
