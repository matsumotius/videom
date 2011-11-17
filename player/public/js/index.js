
$(function(){
      var search = function(){
          var word = $('#input_search').val();
          location.href = app_root+'/search/'+word;        
      };
      
    $('#btn_search').click(search);
    $('#input_search').keydown(
        function(e){
            if(e.keyCode == 13) search();
        }
    );
});
