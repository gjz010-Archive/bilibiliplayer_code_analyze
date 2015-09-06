package scripting
{
   public interface IScanner
   {
       
      function rewind() : *;
      
      function getToken() : Token;
      
      function getLineNumber() : Number;
      
      function getLine() : String;
   }
}
