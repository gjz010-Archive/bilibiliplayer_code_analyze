package scripting
{
   public class Label extends Object
   {
       
      public var address;
      
      public var isExists:Boolean;
      
      public function Label()
      {
         super();
         this.initialize();
      }
      
      public function initialize() : *
      {
         this.address = null;
         this.isExists = false;
      }
      
      public function commitAddress(param1:*) : *
      {
         this.address = param1;
         this.isExists = true;
      }
   }
}
