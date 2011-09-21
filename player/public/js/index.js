
$(function(){
      $('.btn_delete').click(
          function(e){
              var video_id = e.currentTarget.id;
              if(!confirm('delete?')) return;
              $.del(app_root+'/v/'+video_id, {}, 
                    function(e){
                        if(e.error) alert(e.message);
                        else{
                            alert(e.message);
                        }
                    }, 'json')
          }
      );
    
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
