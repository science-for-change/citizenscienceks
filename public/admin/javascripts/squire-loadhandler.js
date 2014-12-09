$(document).ready(function() {
  var editor;
  $('#squire-editor').on("load",function(ele){
    editor = $('#squire-editor')[0].contentWindow.editor;
    editor.setHTML($('#blog-post-body').val());
  });

  $('form').submit(function(ele) {
    $('#blog-post-body').val(editor.getHTML());
  });
});
