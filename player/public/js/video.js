
var fullscreen = false;
$(function(){
    $('#ctrls #fullscreen').click(function(){
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

    $('#ctrls #delete').click(function(){
        if(!confirm('delete?')) return;
        $.del(app_root+'/v/'+video_id, {}, function(e){
            if(e.error) alert('');
            else{
                alert(e.message);
                location.href = app_root;
            }
        }, 'json')
    });
});
