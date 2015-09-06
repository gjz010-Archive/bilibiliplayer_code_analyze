package scripting
{
   public class VMSyntaxError extends Error
   {
       
      public function VMSyntaxError(param1:String)
      {
         super(param1);
         this.name = "VMSyntaxError";
      }
   }
}
