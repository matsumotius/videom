
var fullscreen = false;
$(function(){
    display_tags(tags);
    $('#tag_ctrls #edit').hide();

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

    $('#btn_edit_tag').click(function(){
        $('#tag_ctrls #edit').show();
        $('#tag_ctrls #default').hide();
        $('div#tags').html('');
        $('#tag_ctrls input#tags').val(
            tags.map(function(tag){
                return '['+tag+']';
            }).join('')
        );
    });

    $('#btn_cancel_tag').click(function(){
        $('#tag_ctrls #edit').hide();
        $('#tag_ctrls #default').show();
        display_tags(tags);
    });

    $('#btn_save_tag').click(function(){
        var post_data = {};
        post_data.tags = $('input#tags').val().split(/[\[\]]/).filter(function(tag){ return tag.length > 0});
        $.post(app_root+'/v/'+video_id+'.json', post_data, function(e){
            if(e.error) alert(e.message);
            else{
                tags = e.data.tags;
                display_tags(tags);
                $('#tag_ctrls #edit').hide();
                $('#tag_ctrls #default').show();
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