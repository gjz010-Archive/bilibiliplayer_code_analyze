package tv.bilibili.script
{
   import flash.text.TextField;
   import tv.bilibili.script.interfaces.ICommentField;
   import tv.bilibili.script.interfaces.IMotionManager;
   import flash.text.TextFormat;
   import org.lala.utils.CommentConfig;
   import flash.text.AntiAliasType;
   import flash.text.TextFieldAutoSize;
   import flash.text.GridFitType;
   
   public class CommentField extends TextField implements ICommentField
   {
       
      protected var _motionManager:IMotionManager;
      
      protected var _format:TextFormat;
      
      public function CommentField()
      {
         super();
         this._motionManager = new MotionManager(this);
         selectable = false;
         mouseEnabled = false;
      }
      
      public function get motionManager() : IMotionManager
      {
         return this._motionManager;
      }
      
      public function initStyle(param1:Object) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         this.alpha = param1.alpha;
         this.scaleX = this.scaleY = param1.scale;
         var _loc2_:TextFormat = new TextFormat(param1.font,param1.fontsize,param1.color,CommentConfig.getInstance().bold);
         this._format = _loc2_;
         this.defaultTextFormat = _loc2_;
         this.setTextFormat(_loc2_);
         this.embedFonts = false;
         this.antiAliasType = AntiAliasType.NORMAL;
         this.autoSize = TextFieldAutoSize.LEFT;
         this.gridFitType = GridFitType.NONE;
         this.filters = CommentConfig.getInstance().getFilterByColor(param1.color);
      }
      
      public function remove() : void
      {
         try
         {
            this._motionManager.stop();
            this.parent.removeChild(this);
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      public function get align() : String
      {
         return this._format.align;
      }
      
      public function set align(param1:String) : void
      {
         this._format.align = param1;
         this.setTextFormat(this._format);
      }
      
      public function get bold() : Boolean
      {
         return this._format.bold as Boolean;
      }
      
      public function set bold(param1:Boolean) : void
      {
         this._format.bold = param1;
         this.setTextFormat(this._format);
      }
      
      public function get font() : String
      {
         return this._format.font;
      }
      
      public function set font(param1:String) : void
      {
         this._format.font = param1;
         this.setTextFormat(this._format);
      }
      
      public function get fontsize() : uint
      {
         return this._format.size as uint;
      }
      
      public function set fontsize(param1:uint) : void
      {
         this._format.size = param1;
         this.setTextFormat(this._format);
      }
      
      public function get color() : uint
      {
         return this._format.color as uint;
      }
      
      public function set color(param1:uint) : void
      {
         this._format.color = param1;
         this.setTextFormat(this._format);
      }
      
      override public function get htmlText() : String
      {
         return super.text;
      }
      
      override public function set htmlText(param1:String) : void
      {
         super.text = param1;
      }
   }
}
