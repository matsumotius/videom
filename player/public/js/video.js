
var fullscreen = false;
$(function(){
    $('#btn_fullscreen').click(function(){
        if(!fullscreen){
            $('video').css('width','100%').css('height','100%');
            $('#head').hide();
            fullscreen = true;
        }
        else{
            $('video').css('width','').css('height','');
            $('#head').show();
            fullscreen = false;
        }
    });

    $('#btn_delete').click(function(){
        if(!confirm('delete?')) return;
        $.del(app_root+'/v/'+video_id, {}, function(e){
            if(e.error) alert(e.message);
            else{
                alert(e.message);
                location.href = app_root;
            }
        }, 'json')
    });
});
