package scripting
{
   public class Scanner extends Object implements IScanner
   {
       
      private var source:String;
      
      private var index;
      
      private var linesCount;
      
      public function Scanner(param1:String)
      {
         super();
         this.source = param1;
         this.rewind();
      }
      
      public function rewind() : *
      {
         this.index = 0;
         this.linesCount = 0;
      }
      
      public function getLineNumber() : Number
      {
         return this.linesCount + 1;
      }
      
      public function getLine() : String
      {
         return this.source.split("\n")[this.linesCount];
      }
      
      private function getChar() : String
      {
         return this.source.charAt(this.index);
      }
      
      private function nextChar() : String
      {
         if(this.getChar() == "\n")
         {
            this.linesCount++;
         }
         return this.source.charAt(++this.index);
      }
      
      private function isSpace(param1:String) : Boolean
      {
         return param1 == " " || param1 == "\t" || param1 == "\r" || param1 == "\n";
      }
      
      private function isAlphabet(param1:String) : Boolean
      {
         var _loc2_:* = param1.charCodeAt(0);
         return 65 <= _loc2_ && _loc2_ <= 90 || 97 <= _loc2_ && _loc2_ <= 122;
      }
      
      private function isNumber(param1:String) : Boolean
      {
         var _loc2_:* = param1.charCodeAt(0);
         return 48 <= _loc2_ && _loc2_ <= 57;
      }
      
      private function isAlphabetOrNumber(param1:String) : Boolean
      {
         var _loc2_:* = param1.charCodeAt(0);
         return 48 <= _loc2_ && _loc2_ <= 57 || 65 <= _loc2_ && _loc2_ <= 90 || 97 <= _loc2_ && _loc2_ <= 122;
      }
      
      private function isHex(param1:String) : Boolean
      {
         var _loc2_:* = param1.charCodeAt(0);
         return 48 <= _loc2_ && _loc2_ <= 57 || 65 <= _loc2_ && _loc2_ <= 70 || 97 <= _loc2_ && _loc2_ <= 102;
      }
      
      private function isIdentifier(param1:String) : Boolean
      {
         var _loc2_:* = param1.charCodeAt(0);
         return _loc2_ == 36 || _loc2_ == 95 || 48 <= _loc2_ && _loc2_ <= 57 || 65 <= _loc2_ && _loc2_ <= 90 || 97 <= _loc2_ && _loc2_ <= 122;
      }
      
      public function getToken() : Token
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:String = this.getChar();
         while(this.isSpace(_loc1_))
         {
            _loc1_ = this.nextChar();
         }
         if(!_loc1_)
         {
            return null;
         }
         if(this.isAlphabet(_loc1_) || _loc1_ == "$" || _loc1_ == "_")
         {
            _loc2_ = _loc1_;
            while(_loc1_ = this.nextChar() && this.isIdentifier(_loc1_))
            {
               _loc2_ = _loc2_ + _loc1_;
            }
            _loc3_ = _loc2_.toLowerCase();
            switch(_loc3_)
            {
               case "break":
               case "case":
               case "continue":
               case "default":
               case "delete":
               case "do":
               case "else":
               case "for":
               case "function":
               case "if":
               case "instanceof":
               case "new":
               case "return":
               case "switch":
               case "this":
               case "typeof":
               case "var":
               case "while":
               case "with":
               case "coroutine":
               case "suspend":
               case "yield":
               case "loop":
                  return new Token(_loc3_,null);
               case "null":
                  return new Token("null",null);
               case "undefined":
                  return new Token("undefined",undefined);
               case "true":
                  return new Token("bool",true);
               case "false":
                  return new Token("bool",false);
               default:
                  return new Token("identifier",_loc2_);
            }
         }
         else
         {
            if(this.isNumber(_loc1_))
            {
               _loc2_ = _loc1_;
               if(_loc1_ == "0")
               {
                  if(_loc1_ = this.nextChar() && _loc1_ == "x" || _loc1_ == "X")
                  {
                     _loc2_ = _loc2_ + _loc1_;
                     while(_loc1_ = this.nextChar() && this.isHex(_loc1_))
                     {
                        _loc2_ = _loc2_ + _loc1_;
                     }
                  }
                  else if(this.isNumber(_loc1_))
                  {
                     _loc2_ = _loc2_ + _loc1_;
                     while(_loc1_ = this.nextChar() && this.isNumber(_loc1_))
                     {
                        _loc2_ = _loc2_ + _loc1_;
                     }
                  }
               }
               else
               {
                  while(_loc1_ = this.nextChar() && this.isNumber(_loc1_))
                  {
                     _loc2_ = _loc2_ + _loc1_;
                  }
               }
               if(_loc1_ == ".")
               {
                  _loc2_ = _loc2_ + _loc1_;
                  while(_loc1_ = this.nextChar() && this.isNumber(_loc1_))
                  {
                     _loc2_ = _loc2_ + _loc1_;
                  }
                  return new Token("number",parseFloat(_loc2_));
               }
               return new Token("number",parseInt(_loc2_));
            }
            if(_loc1_ == "\'")
            {
               _loc2_ = "";
               while(_loc1_ = this.nextChar() && _loc1_ != "\'")
               {
                  if(_loc1_ == "\\")
                  {
                     _loc1_ = this.nextChar();
                     if(_loc1_ == "n")
                     {
                        _loc2_ = _loc2_ + "\n";
                        continue;
                     }
                     if(_loc1_ == "t")
                     {
                        _loc2_ = _loc2_ + "\t";
                        continue;
                     }
                     if(_loc1_ == "r")
                     {
                        _loc2_ = _loc2_ + "\r";
                        continue;
                     }
                     if(_loc1_ == "x")
                     {
                        _loc4_ = this.nextChar();
                        _loc5_ = this.nextChar();
                        _loc2_ = _loc2_ + String.fromCharCode(parseInt("0x" + _loc4_ + _loc5_));
                        continue;
                     }
                     if(_loc1_ == "0")
                     {
                        _loc4_ = this.nextChar();
                        _loc5_ = this.nextChar();
                        _loc2_ = _loc2_ + String.fromCharCode(parseInt(_loc4_ + _loc5_,8));
                        continue;
                     }
                     if(_loc1_ == "\\")
                     {
                        _loc2_ = _loc2_ + "\\";
                        continue;
                     }
                  }
                  _loc2_ = _loc2_ + _loc1_;
               }
               if(_loc1_ != "\'")
               {
                  throw new VMSyntaxError("String literal is not closed.");
               }
               this.nextChar();
               return new Token("string",_loc2_);
            }
            if(_loc1_ == "\"")
            {
               _loc2_ = "";
               while(_loc1_ = this.nextChar() && _loc1_ != "\"")
               {
                  if(_loc1_ == "\\")
                  {
                     _loc1_ = this.nextChar();
                     if(_loc1_ == "n")
                     {
                        _loc2_ = _loc2_ + "\n";
                        continue;
                     }
                     if(_loc1_ == "t")
                     {
                        _loc2_ = _loc2_ + "\t";
                        continue;
                     }
                     if(_loc1_ == "r")
                     {
                        _loc2_ = _loc2_ + "\r";
                        continue;
                     }
                     if(_loc1_ == "x")
                     {
                        _loc4_ = this.nextChar();
                        _loc5_ = this.nextChar();
                        _loc2_ = _loc2_ + String.fromCharCode(parseInt("0x" + _loc4_ + _loc5_));
                        continue;
                     }
                     if(_loc1_ == "0")
                     {
                        _loc4_ = this.nextChar();
                        _loc5_ = this.nextChar();
                        _loc2_ = _loc2_ + String.fromCharCode(parseInt(_loc4_ + _loc5_,8));
                        continue;
                     }
                     if(_loc1_ == "\\")
                     {
                        _loc2_ = _loc2_ + "\\";
                        continue;
                     }
                  }
                  _loc2_ = _loc2_ + _loc1_;
               }
               if(_loc1_ != "\"")
               {
                  throw new VMSyntaxError("String literal is not closed.");
               }
               this.nextChar();
               return new Token("string",_loc2_);
            }
            if(_loc1_ == "/")
            {
               if(_loc1_ = this.nextChar())
               {
                  if(_loc1_ == "=")
                  {
                     this.nextChar();
                     return new Token("/=",null);
                  }
                  if(_loc1_ == "/")
                  {
                     while(_loc1_ = this.nextChar() && _loc1_ != "\n")
                     {
                     }
                     this.nextChar();
                     return this.getToken();
                  }
                  if(_loc1_ == "*")
                  {
                     _loc1_ = this.nextChar();
                     while(_loc1_)
                     {
                        if(_loc1_ == "*")
                        {
                           if(_loc1_ = this.nextChar() && _loc1_ == "/")
                           {
                              break;
                           }
                        }
                        else
                        {
                           _loc1_ = this.nextChar();
                        }
                     }
                     this.nextChar();
                     return this.getToken();
                  }
               }
               return new Token("/",null);
            }
            if(_loc1_ == "*" || _loc1_ == "%" || _loc1_ == "^")
            {
               _loc3_ = _loc1_;
               if(_loc1_ = this.nextChar() && _loc1_ == "=")
               {
                  this.nextChar();
                  return new Token(_loc3_ + "=",null);
               }
               return new Token(_loc3_,null);
            }
            if(_loc1_ == "+" || _loc1_ == "-" || _loc1_ == "|" || _loc1_ == "&")
            {
               _loc3_ = _loc1_;
               if(_loc1_ = this.nextChar())
               {
                  if(_loc1_ == _loc3_)
                  {
                     this.nextChar();
                     return new Token(_loc3_ + _loc3_,null);
                  }
                  if(_loc1_ == "=")
                  {
                     this.nextChar();
                     return new Token(_loc3_ + "=",null);
                  }
               }
               return new Token(_loc3_,null);
            }
            if(_loc1_ == "=" || _loc1_ == "!")
            {
               _loc3_ = _loc1_;
               if(_loc1_ = this.nextChar() && _loc1_ == "=")
               {
                  if(_loc1_ = this.nextChar() && _loc1_ == "=")
                  {
                     this.nextChar();
                     return new Token(_loc3_ + "==",null);
                  }
                  return new Token(_loc3_ + "=",null);
               }
               return new Token(_loc3_,null);
            }
            if(_loc1_ == ">" || _loc1_ == "<")
            {
               _loc3_ = _loc1_;
               if(_loc1_ = this.nextChar())
               {
                  if(_loc1_ == "=")
                  {
                     this.nextChar();
                     return new Token(_loc3_ + "=",null);
                  }
                  if(_loc1_ == _loc3_)
                  {
                     if(_loc1_ = this.nextChar())
                     {
                        if(_loc3_ == ">" && _loc1_ == ">")
                        {
                           if(_loc1_ = this.nextChar() && _loc1_ == "=")
                           {
                              this.nextChar();
                              return new Token(">>>=",null);
                           }
                           return new Token(">>>",null);
                        }
                        if(_loc1_ == "=")
                        {
                           this.nextChar();
                           return new Token(_loc3_ + _loc3_ + "=",null);
                        }
                     }
                     return new Token(_loc3_ + _loc3_,null);
                  }
               }
               return new Token(_loc3_,null);
            }
            switch(_loc1_)
            {
               case "{":
               case "}":
               case "(":
               case ")":
               case "[":
               case "]":
               case ".":
               case ";":
               case ",":
               case "~":
               case "?":
               case ":":
                  this.nextChar();
                  return new Token(_loc1_,null);
               default:
                  throw new VMSyntaxError("Unknown character : \"" + _loc1_ + "\" at index " + this.index + ".");
            }
         }
      }
   }
}
