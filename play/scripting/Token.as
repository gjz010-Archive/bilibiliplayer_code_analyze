package scripting
{
   public class Token extends Object
   {
       
      public var type:String;
      
      public var value;
      
      public function Token(param1:String, param2:*)
      {
         super();
         this.type = param1;
         this.value = param2;
      }
   }
}
