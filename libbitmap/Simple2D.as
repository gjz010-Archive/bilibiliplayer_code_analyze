package
{
   import flash.display.BitmapData;
   
   public class Simple2D extends Object
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public var vx:Number;
      
      public var vy:Number;
      
      public var mass:Number;
      
      private var alpha:String;
      
      private var color:String;
      
      public var Allcolor:uint;
      
      public var isOut:Boolean;
      
      public function Simple2D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 1, param6:uint = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.vx = param3;
         this.vy = param4;
         this.mass = param5;
         this.Allcolor = param6;
         this.set_alpha();
         this.set_color();
         this.isOut = false;
      }
      
      public function valid(param1:BitmapData) : Boolean
      {
         if(this.x <= 0)
         {
            this.isOut = true;
         }
         if(this.x >= param1.width)
         {
            this.isOut = true;
         }
         if(this.y <= 0)
         {
            this.isOut = true;
         }
         if(this.y >= param1.height)
         {
            this.isOut = true;
         }
         if(this.get_alpha() == "00")
         {
            this.isOut = true;
         }
         if(this.isOut)
         {
            this.Allcolor = 0;
            this.x = 0;
            this.y = 0;
            this.vx = 0;
            this.vy = 0;
            this.mass = 0;
         }
         return this.isOut;
      }
      
      public function update() : void
      {
         this.x = this.x + this.vx;
         this.y = this.y + this.vy;
         var _loc1_:Number = parseInt(this.alpha,16) - this.mass * 3;
         if(_loc1_ <= 0)
         {
            _loc1_ = 0;
         }
         this.alpha = _loc1_.toString(16);
         this.alpha = ("0" + this.alpha).substr(-2);
         this.set_Allcolor();
      }
      
      public function set_alpha() : void
      {
         var _loc1_:String = this.Allcolor.toString(16);
         this.alpha = _loc1_.substring(0,2);
         this.alpha = ("0" + this.alpha).substr(-2);
      }
      
      public function set_color() : void
      {
         var _loc1_:String = this.Allcolor.toString(16);
         this.color = _loc1_.substring(2,_loc1_.length);
      }
      
      public function set_Allcolor() : void
      {
         this.Allcolor = new Number("0x" + this.alpha + this.color);
      }
      
      public function get_Allcolor() : uint
      {
         return this.Allcolor;
      }
      
      public function get_alpha() : String
      {
         return this.alpha;
      }
   }
}
