package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class libBitmap_2 extends Sprite
   {
       
      public var classes:Array;
      
      public function libBitmap_2()
      {
         this.classes = [libBitmap];
         super();
         Security.allowDomain("*");
      }
   }
}
