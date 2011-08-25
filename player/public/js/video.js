
var fullscreen = false;
$(function(){
    display_tags(tags);

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

    $('#btn_add_tag').click(function(){
        var tag = $('input#input_add_tag').val();
        if(tag.length < 1) return;
        $.post(app_root+'/v/'+video_id+'.json', {tag : tag}, function(e){
            console.log(e);
            if(e.error) alert(e.message);
            else{
                tags = e.data.tags;
                display_tags(tags);
            }
        }, 'json');
    });

    $('input#speed').change(function(e){
        var speed = e.target.value/10.0;
        $('input#speed_val').val(speed+'倍速');
        $('video')[0].playbackRate = speed;
    });
});

var display_tags = function(tags){
    $('div#tags').html('');
    tags.map(function(tag){
        $('<a>').html('['+tag+']').attr('href',app_root+'/tag/'+tag).addClass('tag').appendTo('div#tags');
    });
};