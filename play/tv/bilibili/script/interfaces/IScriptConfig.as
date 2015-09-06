package tv.bilibili.script.interfaces
{
   public interface IScriptConfig
   {
       
      function get isPlayerControlApiEnable() : Boolean;
      
      function get scriptEnabled() : Boolean;
      
      function get debugEnabled() : Boolean;
      
      function get codeHighlightEnabled() : Boolean;
      
      function get commentTriggerManager() : ICommentTriggerManager;
      
      function get commentList() : Array;
   }
}
