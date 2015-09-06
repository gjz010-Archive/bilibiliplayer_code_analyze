package tv.bilibili.script
{
   import tv.bilibili.script.interfaces.IScriptDisplay;
   import flash.display.DisplayObjectContainer;
   import com.longtailvideo.jwplayer.player.IPlayer;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import tv.bilibili.script.interfaces.ICommentField;
   import flash.display.Shape;
   import tv.bilibili.script.interfaces.ICommentCanvas;
   import tv.bilibili.script.interfaces.ICommentButton;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.filters.BlurFilter;
   import tv.bilibili.script.interfaces.IMotionElement;
   import flash.display.DisplayObject;
   import flash.geom.Matrix3D;
   import flash.geom.ColorTransform;
   import flash.text.TextFormat;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import flash.filters.BevelFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.ConvolutionFilter;
   import flash.display.BitmapData;
   import flash.filters.DisplacementMapFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GradientBevelFilter;
   import flash.filters.GradientGlowFilter;
   import flash.geom.Utils3D;
   
   public class ScriptDisplay extends Object implements IScriptDisplay
   {
       
      protected var _layer:DisplayObjectContainer;
      
      protected var _player:IPlayer;
      
      bilibili var _defaultConfig:Object;
      
      protected var _scriptManager:ScriptManager;
      
      public function ScriptDisplay(param1:IPlayer, param2:DisplayObjectContainer, param3:ScriptManager)
      {
         super();
         this._player = param1;
         this._layer = param2;
         this._scriptManager = param3;
         bilibili::_defaultConfig = {
            "x":0,
            "y":0,
            "z":null,
            "scale":1,
            "alpha":1,
            "parent":this._layer,
            "lifeTime":3,
            "motion":null
         };
      }
      
      bilibili  static function extend(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            if(!param1.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = param2[_loc3_];
            }
         }
         if(param2.hasOwnProperty("motion") && param1["motion"] === null)
         {
            param1.motion = {};
         }
      }
      
      public function get fullScreenWidth() : uint
      {
         return this._layer.stage.fullScreenWidth;
      }
      
      public function get fullScreenHeight() : uint
      {
         return this._layer.stage.fullScreenHeight;
      }
      
      public function get screenWidth() : uint
      {
         return this._layer.stage.fullScreenWidth;
      }
      
      public function get screenHeight() : uint
      {
         return this._layer.stage.fullScreenHeight;
      }
      
      public function get stageWidth() : uint
      {
         return this._layer.stage.stageWidth;
      }
      
      public function get stageHeight() : uint
      {
         return this._layer.stage.stageHeight;
      }
      
      public function get width() : uint
      {
         return this._player.config.width;
      }
      
      public function get height() : uint
      {
         return this._player.config.height;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._layer;
      }
      
      public function createMatrix(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 0, param6:Number = 0) : Matrix
      {
         return new Matrix(param1,param2,param3,param4,param5,param6);
      }
      
      public function createGradientBox(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Matrix
      {
         var _loc6_:Matrix = new Matrix();
         _loc6_.createGradientBox(param1,param2,param3,param4,param5);
         return _loc6_;
      }
      
      public function createPoint(param1:Number = 0, param2:Number = 0) : Point
      {
         return new Point(param1,param2);
      }
      
      public function createComment(param1:String, param2:Object) : ICommentField
      {
         bilibili::extend(param2,bilibili::_defaultConfig);
         bilibili::extend(param2,{
            "color":16777215,
            "font":"黑体",
            "fontsize":25
         });
         var _loc3_:CommentField = new CommentField();
         _loc3_.text = param1;
         _loc3_.initStyle(param2);
         bilibili::setupMotionElement(param2,_loc3_);
         return _loc3_;
      }
      
      public function createShape(param1:Object) : Shape
      {
         bilibili::extend(param1,bilibili::_defaultConfig);
         var _loc2_:CommentShape = new CommentShape();
         _loc2_.initStyle(param1);
         bilibili::setupMotionElement(param1,_loc2_);
         return _loc2_;
      }
      
      public function createCanvas(param1:Object) : ICommentCanvas
      {
         bilibili::extend(param1,bilibili::_defaultConfig);
         var _loc2_:CommentCanvas = new CommentCanvas();
         _loc2_.initStyle(param1);
         bilibili::setupMotionElement(param1,_loc2_);
         return _loc2_;
      }
      
      public function createButton(param1:Object) : ICommentButton
      {
         var param:Object = param1;
         bilibili::extend(param,bilibili::_defaultConfig);
         bilibili::extend(param,{
            "text":"Button",
            "width":60,
            "height":30
         });
         var cb:CommentButton = new CommentButton();
         cb.initStyle(param);
         cb.text = param.text;
         if(param.onclick)
         {
            cb.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               param.onclick();
            });
         }
         bilibili::setupMotionElement(param,cb);
         return cb;
      }
      
      public function createGlowFilter(param1:uint = 16711680, param2:Number = 1.0, param3:Number = 6.0, param4:Number = 6.0, param5:Number = 2, param6:int = 1, param7:Boolean = false, param8:Boolean = false) : GlowFilter
      {
         return new GlowFilter(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function createBlurFilter(param1:Number = 0, param2:Number = 0, param3:uint = 1) : BlurFilter
      {
         return new BlurFilter(param1,param2,param3);
      }
      
      bilibili function setupMotionElement(param1:Object, param2:IMotionElement) : void
      {
         var complete:Function = null;
         var motionConfig:Object = null;
         var config:Object = param1;
         var elm:IMotionElement = param2;
         complete = function():void
         {
            if(elm["parent"])
            {
               elm["parent"].removeChild(elm);
            }
            _scriptManager.popEl(elm);
         };
         if(elm.motionManager == null)
         {
            elmbilibili::["motionManager"] = new MotionManager(elm as DisplayObject);
         }
         elm.motionManager.setPlayTime(this._player.stime * 1000);
         if(config.motionGroup)
         {
            elm.motionManager.initTweenGroup(config.motionGroup,config.lifeTime);
         }
         else
         {
            motionConfig = config.motion;
            if(isNaN(motionConfig.lifeTime))
            {
               motionConfig.lifeTime = config.lifeTime;
            }
            if(motionConfig.lifeTime < 0)
            {
               motionConfig.lifeTime = 0.001;
            }
            elm.motionManager.initTween(motionConfig);
         }
         elm.motionManager.setCompleteListener(complete);
         this._scriptManager.pushEl(elm);
         if(config.parent && config.parent.hasOwnProperty("addChild"))
         {
            config.parent.addChild(elm);
         }
         else
         {
            this._layer.addChild(elm as DisplayObject);
         }
         if(this._player.state == "PLAYING")
         {
            elm.motionManager.play();
         }
      }
      
      public function toIntVector(param1:Array) : Vector.<int>
      {
         return Vector.<int>(param1);
      }
      
      public function toUIntVector(param1:Array) : Vector.<uint>
      {
         return Vector.<uint>(param1);
      }
      
      public function toNumberVector(param1:Array) : Vector.<Number>
      {
         return Vector.<Number>(param1);
      }
      
      public function createMatrix3D(param1:*) : Matrix3D
      {
         if(param1 is Vector.<Number>)
         {
            return new Matrix3D(param1);
         }
         return new Matrix3D(Vector.<Number>(param1));
      }
      
      public function createColorTransform(param1:Number = 1.0, param2:Number = 1.0, param3:Number = 1.0, param4:Number = 1.0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : ColorTransform
      {
         return new ColorTransform(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function createTextFormat(param1:String = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:String = null, param8:String = null, param9:String = null, param10:Object = null, param11:Object = null, param12:Object = null, param13:Object = null) : TextFormat
      {
         return new TextFormat(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
      }
      
      public function createVector3D(param1:Number = 0.0, param2:Number = 0.0, param3:Number = 0.0, param4:Number = 0.0) : Vector3D
      {
         return new Vector3D(param1,param2,param3,param4);
      }
      
      public function createTextField() : TextField
      {
         return new CommentField();
      }
      
      public function createBevelFilter(param1:Number = 4.0, param2:Number = 45, param3:uint = 16777215, param4:Number = 1.0, param5:uint = 0, param6:Number = 1.0, param7:Number = 4.0, param8:Number = 4.0, param9:Number = 1, param10:int = 1, param11:String = "inner", param12:Boolean = false) : *
      {
         return new BevelFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
      }
      
      public function createColorMatrixFilter(param1:Array = null) : *
      {
         return new ColorMatrixFilter(param1);
      }
      
      public function createConvolutionFilter(param1:Number = 0, param2:Number = 0, param3:Array = null, param4:Number = 1.0, param5:Number = 0.0, param6:Boolean = true, param7:Boolean = true, param8:uint = 0, param9:Number = 0.0) : *
      {
         return new ConvolutionFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function createDisplacementMapFilter(param1:BitmapData = null, param2:Point = null, param3:uint = 0, param4:uint = 0, param5:Number = 0.0, param6:Number = 0.0, param7:String = "wrap", param8:uint = 0, param9:Number = 0.0) : *
      {
         return new DisplacementMapFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public function createDropShadowFilter(param1:Number = 4.0, param2:Number = 45, param3:uint = 0, param4:Number = 1.0, param5:Number = 4.0, param6:Number = 4.0, param7:Number = 1.0, param8:int = 1, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false) : *
      {
         return new DropShadowFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public function createGradientBevelFilter(param1:Number = 4.0, param2:Number = 45, param3:Array = null, param4:Array = null, param5:Array = null, param6:Number = 4.0, param7:Number = 4.0, param8:Number = 1, param9:int = 1, param10:String = "inner", param11:Boolean = false) : *
      {
         return new GradientBevelFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public function createGradientGlowFilter(param1:Number = 4.0, param2:Number = 45, param3:Array = null, param4:Array = null, param5:Array = null, param6:Number = 4.0, param7:Number = 4.0, param8:Number = 1, param9:int = 1, param10:String = "inner", param11:Boolean = false) : *
      {
         return new GradientGlowFilter(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public function get frameRate() : Number
      {
         return this._layer.stage.frameRate;
      }
      
      public function set frameRate(param1:Number) : void
      {
         if(param1 > 0 && param1 < 120)
         {
            this._layer.stage.frameRate = param1;
         }
      }
      
      public function pointTowards(param1:Number, param2:Matrix3D, param3:Vector3D, param4:Vector3D = null, param5:Vector3D = null) : Matrix3D
      {
         return Utils3D.pointTowards(param1,param2,param3,param4,param5);
      }
      
      public function projectVector(param1:Matrix3D, param2:Vector3D) : Vector3D
      {
         return Utils3D.projectVector(param1,param2);
      }
      
      public function projectVectors(param1:Matrix3D, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>) : void
      {
         return Utils3D.projectVectors(param1,param2,param3,param4);
      }
   }
}
