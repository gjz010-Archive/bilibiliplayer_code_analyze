package scripting
{
   import flash.display.DisplayObject;
   
   public class VirtualMachine extends Object
   {
       
      private var byteCode:Array;
      
      private var byteCodeLength;
      
      private var programCounter;
      
      private var global;
      
      private var localObject;
      
      private var thisObject;
      
      private var returnValue;
      
      private var stack:Array;
      
      public var optimized:Boolean = false;
      
      public function VirtualMachine()
      {
         super();
         this.initialize();
      }
      
      public function initialize() : *
      {
         this.programCounter = 1;
         this.byteCode = new Array();
         this.stack = new Array();
         this.global = new Object();
         this.global.__scope = null;
         this.localObject = this.global;
         this.thisObject = this.global;
      }
      
      public function rewind() : *
      {
         this.programCounter = 1;
      }
      
      public function setProgramCounter(param1:*) : *
      {
         this.programCounter = param1;
      }
      
      public function runCoroutine(param1:*, param2:Array = null) : *
      {
         var _loc3_:Array = null;
         if(param2 == null)
         {
            _loc3_ = [];
         }
         else
         {
            _loc3_ = param2;
         }
         return this.executeFunction(new Object(),_loc3_,this.global[param1].__entryPoint,this.global[param1].__scope);
      }
      
      public function getGlobalObject() : *
      {
         return this.global;
      }
      
      public function getLocalObject() : *
      {
         return this.localObject;
      }
      
      public function setByteCode(param1:Array) : *
      {
         this.byteCode = param1;
         this.byteCodeLength = param1.length;
      }
      
      public function getByteCode() : Array
      {
         return this.byteCode;
      }
      
      public function getByteCodeLength() : *
      {
         return this.byteCodeLength;
      }
      
      public function execute() : Boolean
      {
         var _loc4_:* = undefined;
         var _loc1_:Array = this.byteCode;
         var _loc2_:* = this.programCounter;
         var _loc3_:* = this.byteCodeLength;
         if(this.optimized == false)
         {
            while(_loc2_ < _loc3_)
            {
               if((_loc4_ = this[_loc1_[_loc2_]](_loc1_,_loc2_)) == null)
               {
                  this.programCounter = _loc2_ + 1;
                  delete _loc1_[0];
                  return true;
               }
               _loc2_ = _loc4_;
            }
         }
         else
         {
            while(_loc2_ < _loc3_)
            {
               if((_loc4_ = _loc1_[_loc2_](_loc1_,_loc2_)) == null)
               {
                  this.programCounter = _loc2_ + 1;
                  delete _loc1_[0];
                  return true;
               }
               _loc2_ = _loc4_;
            }
         }
         this.programCounter = _loc2_;
         delete _loc1_[0];
         return false;
      }
      
      private function executeFunction(param1:*, param2:Array, param3:*, param4:*) : *
      {
         var _loc6_:* = this.thisObject;
         var _loc7_:* = this.localObject;
         var _loc8_:* = this.programCounter;
         this.thisObject = param1;
         this.localObject = {
            "arguments":param2,
            "__scope":param4
         };
         this.programCounter = param3;
         while(this.execute())
         {
         }
         this.programCounter = _loc8_;
         this.localObject = _loc7_;
         this.thisObject = _loc6_;
         return this.returnValue;
      }
      
      private function __resolve(param1:String) : *
      {
         throw new Error("VirtualMachine [UnknownOperation] : " + param1 + " at pc" + arguments[1]);
      }
      
      public function NOP(param1:Array, param2:*) : *
      {
         return param2 + 1;
      }
      
      public function SPD(param1:Array, param2:*) : *
      {
         return null;
      }
      
      public function LIT(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = param1[param2 + 1];
         return param2 + 3;
      }
      
      public function CALL(param1:Array, param2:*) : *
      {
         var _loc4_:String = param1[param2 + 1];
         var _loc5_:* = null;
         var _loc6_:* = this.localObject;
         while(_loc6_ != null)
         {
            if(_loc6_.hasOwnProperty(_loc4_))
            {
               _loc5_ = _loc6_[_loc4_];
               break;
            }
            _loc6_ = _loc6_.__scope;
         }
         var _loc7_:* = param1[param2 + 2] + 1;
         var _loc8_:Array = this.stack;
         var _loc9_:Array = [];
         while(--_loc7_)
         {
            _loc9_.push(_loc8_.pop());
         }
         _loc9_.reverse();
         if(_loc5_.hasOwnProperty("__entryPoint"))
         {
            _loc8_.push(param2 + 4);
            _loc8_.push(this.thisObject);
            _loc8_.push(this.localObject);
            _loc8_.push(param1[param2 + 3]);
            this.thisObject = this.global;
            this.localObject = {
               "arguments":_loc9_,
               "__scope":_loc5_.__scope
            };
            return _loc5_.__entryPoint;
         }
         param1[param1[param2 + 3]] = _loc5_.apply(this.global,_loc9_);
         return param2 + 4;
      }
      
      public function CALLL(param1:Array, param2:*) : *
      {
         var _loc4_:* = this.localObject[param1[param2 + 1]];
         var _loc5_:* = param1[param2 + 2] + 1;
         var _loc6_:Array = this.stack;
         var _loc7_:Array = [];
         while(--_loc5_)
         {
            _loc7_.push(_loc6_.pop());
         }
         _loc7_.reverse();
         if(_loc4_.hasOwnProperty("__entryPoint"))
         {
            _loc6_.push(param2 + 4);
            _loc6_.push(this.thisObject);
            _loc6_.push(this.localObject);
            _loc6_.push(param1[param2 + 3]);
            this.thisObject = this.global;
            this.localObject = {
               "arguments":_loc7_,
               "__scope":_loc4_.__scope
            };
            return _loc4_.__entryPoint;
         }
         param1[param1[param2 + 3]] = _loc4_.apply(this.global,_loc7_);
         return param2 + 4;
      }
      
      public function CALLM(param1:Array, param2:*) : *
      {
         var _loc4_:* = param1[param2 + 1];
         var _loc5_:* = _loc4_[param1[param2 + 2]];
         var _loc6_:* = param1[param2 + 3] + 1;
         var _loc7_:Array = this.stack;
         var _loc8_:Array = [];
         while(--_loc6_)
         {
            _loc8_.push(_loc7_.pop());
         }
         _loc8_.reverse();
         if(_loc5_.hasOwnProperty("__entryPoint"))
         {
            _loc7_.push(param2 + 5);
            _loc7_.push(this.thisObject);
            _loc7_.push(this.localObject);
            _loc7_.push(param1[param2 + 4]);
            this.thisObject = _loc4_;
            this.localObject = {
               "arguments":_loc8_,
               "__scope":_loc5_.__scope
            };
            return _loc5_.__entryPoint;
         }
         param1[param1[param2 + 4]] = _loc5_.apply(_loc4_,_loc8_);
         return param2 + 5;
      }
      
      public function CALLF(param1:Array, param2:*) : *
      {
         var _loc4_:* = param1[param2 + 1];
         var _loc5_:* = param1[param2 + 2] + 1;
         var _loc6_:Array = this.stack;
         var _loc7_:Array = [];
         while(--_loc5_)
         {
            _loc7_.push(_loc6_.pop());
         }
         _loc7_.reverse();
         if(_loc4_.hasOwnProperty("__entryPoint"))
         {
            _loc6_.push(param2 + 4);
            _loc6_.push(this.thisObject);
            _loc6_.push(this.localObject);
            _loc6_.push(param1[param2 + 3]);
            this.thisObject = this.global;
            this.localObject = {
               "arguments":_loc7_,
               "__scope":_loc4_.__scope
            };
            return _loc4_.__entryPoint;
         }
         param1[param1[param2 + 3]] = _loc4_.apply(this.global,_loc7_);
         return param2 + 4;
      }
      
      public function RET(param1:Array, param2:*) : *
      {
         this.returnValue = param1[param2 + 1];
         return this.byteCodeLength;
      }
      
      public function CRET(param1:Array, param2:*) : *
      {
         var _loc3_:Array = this.stack;
         param1[_loc3_.pop()] = param1[param2 + 1];
         this.localObject = _loc3_.pop();
         this.thisObject = _loc3_.pop();
         return Number(_loc3_.pop());
      }
      
      public function FUNC(param1:Array, param2:*) : *
      {
         var vm:VirtualMachine = null;
         var entryPoint:* = undefined;
         var scope:* = undefined;
         var code:Array = param1;
         var pc:* = param2;
         vm = this;
         entryPoint = pc + 3;
         scope = this.localObject;
         code[code[pc + 2]] = function():*
         {
            return vm.executeFunction(this,arguments,entryPoint,scope);
         };
         return code[pc + 1];
      }
      
      public function COR(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = {
            "__entryPoint":param2 + 3,
            "__scope":this.localObject
         };
         return param1[param2 + 1];
      }
      
      public function ARG(param1:Array, param2:*) : *
      {
         this.localObject[param1[param2 + 2]] = this.localObject.arguments[param1[param2 + 1]];
         if(this.localObject.parameters == undefined)
         {
            this.localObject.parameters = [];
         }
         this.localObject.parameters.push(param1[param2 + 2]);
         return param2 + 3;
      }
      
      public function JMP(param1:Array, param2:*) : *
      {
         return param1[param2 + 1];
      }
      
      public function IF(param1:Array, param2:*) : *
      {
         if(param1[param2 + 1])
         {
            return param2 + 3;
         }
         return param1[param2 + 2];
      }
      
      public function NIF(param1:Array, param2:*) : *
      {
         if(param1[param2 + 1])
         {
            return param1[param2 + 2];
         }
         return param2 + 3;
      }
      
      public function ADD(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] + param1[param2 + 2];
         return param2 + 4;
      }
      
      public function SUB(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] - param1[param2 + 2];
         return param2 + 4;
      }
      
      public function MUL(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] * param1[param2 + 2];
         return param2 + 4;
      }
      
      public function DIV(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] / param1[param2 + 2];
         return param2 + 4;
      }
      
      public function MOD(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] % param1[param2 + 2];
         return param2 + 4;
      }
      
      public function AND(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] & param1[param2 + 2];
         return param2 + 4;
      }
      
      public function OR(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] | param1[param2 + 2];
         return param2 + 4;
      }
      
      public function XOR(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] ^ param1[param2 + 2];
         return param2 + 4;
      }
      
      public function NOT(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = ~param1[param2 + 1];
         return param2 + 3;
      }
      
      public function LNOT(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = !param1[param2 + 1];
         return param2 + 3;
      }
      
      public function LSH(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] << param1[param2 + 2];
         return param2 + 4;
      }
      
      public function RSH(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] >> param1[param2 + 2];
         return param2 + 4;
      }
      
      public function URSH(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] >>> param1[param2 + 2];
         return param2 + 4;
      }
      
      public function INC(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = param1[param2 + 1] + 1;
         return param2 + 3;
      }
      
      public function DEC(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = param1[param2 + 1] - 1;
         return param2 + 3;
      }
      
      public function CEQ(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] == param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CSEQ(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] === param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CNE(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] != param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CSNE(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] !== param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CLT(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] < param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CGT(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] > param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CLE(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] <= param1[param2 + 2];
         return param2 + 4;
      }
      
      public function CGE(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] >= param1[param2 + 2];
         return param2 + 4;
      }
      
      public function DUP(param1:Array, param2:*) : *
      {
         var _loc3_:* = param1[param2 + 1];
         param1[param1[param2 + 2]] = _loc3_;
         param1[param1[param2 + 3]] = _loc3_;
         return param2 + 4;
      }
      
      public function THIS(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 1]] = this.thisObject;
         return param2 + 2;
      }
      
      public function ARRAY(param1:Array, param2:*) : *
      {
         var _loc3_:* = param1[param2 + 1];
         var _loc4_:Array = new Array(_loc3_);
         var _loc5_:Array = this.stack;
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_[_loc6_] = _loc5_.pop();
            _loc6_++;
         }
         _loc4_.reverse();
         param1[param1[param2 + 2]] = _loc4_;
         return param2 + 3;
      }
      
      public function OBJ(param1:Array, param2:*) : *
      {
         var _loc7_:* = undefined;
         var _loc3_:* = param1[param2 + 1];
         var _loc4_:* = new Object();
         var _loc5_:Array = this.stack;
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = _loc5_.pop();
            _loc4_[_loc5_.pop()] = _loc7_;
            _loc6_++;
         }
         param1[param1[param2 + 2]] = _loc4_;
         return param2 + 3;
      }
      
      public function SETL(param1:Array, param2:*) : *
      {
         if(String(param1[param2 + 1]) == "__scope")
         {
            throw new Error("不能用  __scope!");
         }
         this.localObject[param1[param2 + 1]] = param1[param1[param2 + 3]] = param1[param2 + 2];
         return param2 + 4;
      }
      
      public function GETL(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = this.localObject[param1[param2 + 1]];
         return param2 + 3;
      }
      
      public function SET(param1:Array, param2:*) : *
      {
         var _loc3_:String = param1[param2 + 1];
         if(_loc3_ == "__scope")
         {
            throw new Error("不能用  __scope!");
         }
         var _loc4_:* = this.localObject;
         while(_loc4_ != null)
         {
            if(_loc4_.hasOwnProperty(_loc3_))
            {
               _loc4_[_loc3_] = param1[param1[param2 + 3]] = param1[param2 + 2];
               return param2 + 4;
            }
            _loc4_ = _loc4_.__scope;
         }
         this.global[_loc3_] = param1[param1[param2 + 3]] = param1[param2 + 2];
         return param2 + 4;
      }
      
      public function GET(param1:Array, param2:*) : *
      {
         var _loc3_:String = param1[param2 + 1];
         var _loc4_:* = this.localObject;
         while(_loc4_ != null)
         {
            if(_loc4_.hasOwnProperty(_loc3_))
            {
               param1[param1[param2 + 2]] = _loc4_[_loc3_];
               return param2 + 3;
            }
            _loc4_ = _loc4_.__scope;
         }
         param1[param1[param2 + 2]] = undefined;
         return param2 + 3;
      }
      
      public function SETM(param1:Array, param2:*) : *
      {
         if(String(param1[param2 + 2]) == "__scope")
         {
            throw new Error("不能用  __scope!");
         }
         param1[param2 + 1][param1[param2 + 2]] = param1[param1[param2 + 4]] = param1[param2 + 3];
         return param2 + 5;
      }
      
      public function GETM(param1:Array, param2:*) : *
      {
         var _loc3_:String = param1[param2 + 2];
         if(param1[param2 + 1] is DisplayObject)
         {
            if("string" !== "number")
            {
               _loc3_ = String(_loc3_);
            }
            if(_loc3_ == "root" || _loc3_ == "parent" || _loc3_ == "stage")
            {
               throw new Error("属性禁止访问！(禁止向上访问播放器的显示列表)");
            }
            if(_loc3_ == "loaderInfo")
            {
               throw new Error("属性无法访问。");
            }
         }
         param1[param1[param2 + 3]] = param1[param2 + 1][_loc3_];
         return param2 + 4;
      }
      
      public function GETMV(param1:Array, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1[param2 + 2] == "GETL")
         {
            _loc3_ = this.localObject[param1[param2 + 3]];
         }
         else
         {
            _loc4_ = this.localObject;
            while(_loc4_ != null)
            {
               if(_loc4_.hasOwnProperty(param1[param2 + 3]))
               {
                  _loc3_ = _loc4_[param1[param2 + 3]];
               }
               _loc4_ = _loc4_.__scope;
            }
         }
         if(param1[param2 + 1] is DisplayObject)
         {
            if(typeof _loc3_ !== "number")
            {
               _loc3_ = String(_loc3_);
            }
            if(_loc3_ == "root" || _loc3_ == "parent" || _loc3_ == "stage")
            {
               throw new Error("属性禁止访问！(禁止向上访问播放器的显示列表)");
            }
            if(_loc3_ == "loaderInfo")
            {
               throw new Error("属性无法访问。");
            }
         }
         param1[param1[param2 + 4]] = param1[param2 + 1][_loc3_];
         return param2 + 5;
      }
      
      public function NEW(param1:Array, param2:*) : *
      {
         var _loc3_:Function = param1[param2 + 1];
         this._constructor.prototype = _loc3_.prototype;
         var _loc4_:* = _loc3_;
         var _loc5_:* = param1[param2 + 2] + 1;
         var _loc6_:Array = this.stack;
         var _loc7_:Array = [];
         while(--_loc5_)
         {
            _loc7_.push(_loc6_.pop());
         }
         param1[param1[param2 + 3]] = _loc3_.apply(_loc4_,_loc7_) || _loc4_;
         return param2 + 4;
      }
      
      private function _constructor() : *
      {
      }
      
      public function DEL(param1:Array, param2:*) : *
      {
         var _loc3_:String = param1[param2 + 1];
         var _loc4_:* = this.localObject;
         while(_loc4_ != null)
         {
            if(_loc4_.hasOwnProperty(_loc3_))
            {
               param1[param1[param2 + 2]] = delete _loc4_[_loc3_];
               return param2 + 3;
            }
            _loc4_ = _loc4_.__scope;
         }
         param1[param1[param2 + 2]] = false;
         return param2 + 3;
      }
      
      public function DELL(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = delete this.localObject[param1[param2 + 1]];
         return param2 + 3;
      }
      
      public function DELM(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = delete param1[param2 + 1][param1[param2 + 2]];
         return param2 + 4;
      }
      
      public function TYPEOF(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = typeof param1[param2 + 1];
         return param2 + 3;
      }
      
      public function INSOF(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 3]] = param1[param2 + 1] is param1[param2 + 2];
         return param2 + 4;
      }
      
      public function NUM(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = Number(param1[param2 + 1]);
         return param2 + 3;
      }
      
      public function STR(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 2]] = String(param1[param2 + 1]);
         return param2 + 3;
      }
      
      public function WITH(param1:Array, param2:*) : *
      {
         var _loc3_:* = param1[param2 + 1];
         _loc3_.__scope = this.localObject;
         this.localObject = _loc3_;
         return param2 + 2;
      }
      
      public function EWITH(param1:Array, param2:*) : *
      {
         this.localObject = this.localObject.__scope;
         return param2 + 1;
      }
      
      public function PUSH(param1:Array, param2:*) : *
      {
         this.stack.push(param1[param2 + 1]);
         return param2 + 2;
      }
      
      public function POP(param1:Array, param2:*) : *
      {
         param1[param1[param2 + 1]] = this.stack.pop();
         return param2 + 2;
      }
   }
}
