package tv.bilibili.script.interfaces
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.filters.BlurFilter;
   import flash.display.BitmapData;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import flash.geom.ColorTransform;
   
   public interface IScriptDisplay
   {
       
      function get fullScreenWidth() : uint;
      
      function get fullScreenHeight() : uint;
      
      function get width() : uint;
      
      function get height() : uint;
      
      function get frameRate() : Number;
      
      function set frameRate(param1:Number) : void;
      
      function createMatrix(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 0, param6:Number = 0) : Matrix;
      
      function createGradientBox(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Matrix;
      
      function createPoint(param1:Number = 0, param2:Number = 0) : Point;
      
      function createComment(param1:String, param2:Object) : ICommentField;
      
      function createShape(param1:Object) : Shape;
      
      function createCanvas(param1:Object) : ICommentCanvas;
      
      function createButton(param1:Object) : ICommentButton;
      
      function createGlowFilter(param1:uint = 16711680, param2:Number = 1.0, param3:Number = 6.0, param4:Number = 6.0, param5:Number = 2, param6:int = 1, param7:Boolean = false, param8:Boolean = false) : GlowFilter;
      
      function createBlurFilter(param1:Number = 0, param2:Number = 0, param3:uint = 1) : BlurFilter;
      
      function createBevelFilter(param1:Number = 4.0, param2:Number = 45, param3:uint = 16777215, param4:Number = 1.0, param5:uint = 0, param6:Number = 1.0, param7:Number = 4.0, param8:Number = 4.0, param9:Number = 1, param10:int = 1, param11:String = "inner", param12:Boolean = false) : *;
      
      function createColorMatrixFilter(param1:Array = null) : *;
      
      function createConvolutionFilter(param1:Number = 0, param2:Number = 0, param3:Array = null, param4:Number = 1.0, param5:Number = 0.0, param6:Boolean = true, param7:Boolean = true, param8:uint = 0, param9:Number = 0.0) : *;
      
      function createDisplacementMapFilter(param1:BitmapData = null, param2:Point = null, param3:uint = 0, param4:uint = 0, param5:Number = 0.0, param6:Number = 0.0, param7:String = "wrap", param8:uint = 0, param9:Number = 0.0) : *;
      
      function createDropShadowFilter(param1:Number = 4.0, param2:Number = 45, param3:uint = 0, param4:Number = 1.0, param5:Number = 4.0, param6:Number = 4.0, param7:Number = 1.0, param8:int = 1, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false) : *;
      
      function createGradientBevelFilter(param1:Number = 4.0, param2:Number = 45, param3:Array = null, param4:Array = null, param5:Array = null, param6:Number = 4.0, param7:Number = 4.0, param8:Number = 1, param9:int = 1, param10:String = "inner", param11:Boolean = false) : *;
      
      function createGradientGlowFilter(param1:Number = 4.0, param2:Number = 45, param3:Array = null, param4:Array = null, param5:Array = null, param6:Number = 4.0, param7:Number = 4.0, param8:Number = 1, param9:int = 1, param10:String = "inner", param11:Boolean = false) : *;
      
      function toIntVector(param1:Array) : Vector.<int>;
      
      function toNumberVector(param1:Array) : Vector.<Number>;
      
      function toUIntVector(param1:Array) : Vector.<uint>;
      
      function createMatrix3D(param1:*) : Matrix3D;
      
      function createVector3D(param1:Number = 0.0, param2:Number = 0.0, param3:Number = 0.0, param4:Number = 0.0) : Vector3D;
      
      function createTextFormat(param1:String = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:String = null, param8:String = null, param9:String = null, param10:Object = null, param11:Object = null, param12:Object = null, param13:Object = null) : TextFormat;
      
      function createTextField() : TextField;
      
      function createColorTransform(param1:Number = 1.0, param2:Number = 1.0, param3:Number = 1.0, param4:Number = 1.0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : ColorTransform;
      
      function pointTowards(param1:Number, param2:Matrix3D, param3:Vector3D, param4:Vector3D = null, param5:Vector3D = null) : Matrix3D;
      
      function projectVector(param1:Matrix3D, param2:Vector3D) : Vector3D;
      
      function projectVectors(param1:Matrix3D, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>) : void;
   }
}
