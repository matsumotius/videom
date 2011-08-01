
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
});
