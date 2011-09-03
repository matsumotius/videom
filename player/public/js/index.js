
$(function(){
    $('.btn_delete').click(function(e){
        var video_id = e.currentTarget.id;
        if(!confirm('delete?')) return;
        $.del(app_root+'/v/'+video_id, {}, function(e){
            if(e.error) alert(e.message);
            else{
                alert(e.message);
            }
        }, 'json')
    });
    
    $('#btn_search').click(function(){
        var word = $('#input_search').val();
        location.href = app_root+'/search/'+word;
    });
});
