
var fullscreen = false;
$(function(){
    $('#ctrls #fullscreen').click(function(){
        console.log(fullscreen);
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
});
