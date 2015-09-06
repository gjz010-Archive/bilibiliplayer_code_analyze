package scripting
{
   public class ExpressionResult extends Object
   {
       
      public var type:String;
      
      public var value;
      
      public var isLeftHandSide:Boolean = false;
      
      public function ExpressionResult()
      {
         super();
         this.initialize();
      }
      
      public static function createLiteral(param1:*) : ExpressionResult
      {
         var _loc2_:ExpressionResult = new ExpressionResult();
         _loc2_.setTypeLiteral(param1);
         return _loc2_;
      }
      
      public static function createStack() : ExpressionResult
      {
         var _loc1_:ExpressionResult = new ExpressionResult();
         _loc1_.setTypeStack();
         return _loc1_;
      }
      
      public function clone() : ExpressionResult
      {
         var _loc1_:ExpressionResult = new ExpressionResult();
         _loc1_.setTypeAndValue(this.type,this.value);
         return _loc1_;
      }
      
      public function initialize() : *
      {
         this.type = "empty";
         this.value = null;
      }
      
      public function setType(param1:String) : *
      {
         this.type = param1;
      }
      
      public function isType(param1:String) : Boolean
      {
         return this.type == param1;
      }
      
      public function setValue(param1:*) : *
      {
         this.value = param1;
      }
      
      public function setTypeAndValue(param1:String, param2:*) : *
      {
         this.type = param1;
         this.value = param2;
      }
      
      public function isLiteral() : Boolean
      {
         return this.isType("literal");
      }
      
      public function isVariableOrMember() : Boolean
      {
         return this.isVariable() || this.isMember();
      }
      
      public function isVariable() : Boolean
      {
         return this.isType("variable");
      }
      
      public function isMember() : Boolean
      {
         return this.isType("member");
      }
      
      public function setTypeStack() : *
      {
         this.setType("stack");
      }
      
      public function setTypeLiteral(param1:*) : *
      {
         this.setTypeAndValue("literal",param1);
      }
      
      public function setTypeMember(param1:ExpressionResult, param2:ExpressionResult) : *
      {
         this.setTypeAndValue("member",{
            "object":param1,
            "member":param2
         });
      }
      
      public function getObjectExpression() : ExpressionResult
      {
         if(!this.isMember())
         {
            return null;
         }
         return this.value.object;
      }
      
      public function getMemberExpression() : ExpressionResult
      {
         if(!this.isMember())
         {
            return null;
         }
         return this.value.member;
      }
   }
}
