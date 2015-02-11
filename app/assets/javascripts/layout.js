$document.on('ready', function(){
    $('#scroll-to-top').on('click', function(event){
        event.preventDefault()
        // $document.scrollTop(0)
        $('#body').animate({scrollTop: 0}, 400);
    })
})

$(function() {
        // fade in the grayscaled images to avoid visual jump
        //$('.greyScale').hide().fadeIn(1000);
      });
      // user window.load to ensure images have been loaded
      $(window).load(function () {
        //$('.greyScale').greyScale({
          // call the plugin with non-defult fadeTime (default: 400ms)
          //fadeTime: 500,
          //reverse: false
        //});
      });



//$(window).load(function(){
//
//
//        $('.bwWrapper').BlackAndWhite({
//                hoverEffect:true,
//                webworkerPath: 'src/',
//                intensity:1,
//                onImageReady:function(img){
//                        $(img).parent().animate({
//                                opacity:1
//                        });
//                }
//        });
//});

function isMobile(){
    var is_mobile = window.innerWidth <= 860
    return is_mobile
}

$('div#menu-container ul').on('click', 'li', function(event){
    var $item = $(this)


    if(isMobile()){
        event.preventDefault()
        $item.addClass('open')
    }
})

var $menu_button = $('#mobile-button')
var $menu_wrapper = $('#menu-wrapper')
$menu_button.on('click', toggleMenu)

function toggleMenu(){
    if(isMobile()){
        $body.toggleClass('opened-menu')
    }
}

function showMenu(){
    if(isMobile()) {
        $body.addClass('opened-menu')
    }
}

function hideMenu(){
    if(isMobile()) {
        $body.removeClass('opened-menu')
    }
}

function menuOpened(){
    return $body.hasClass('opened-menu')
}

$window.on('scroll', hideMenu)


//
// TODO: make close menu when clicking anywhere
//


//$document.on('ready', function(){
//    //$body.on('click', hideMenu)
//    //$('#menu').on('leave', hideMenu())
//
//    $body.on('click', '*', function(e){
//        var $this = $(this)
//
//        if(menuOpened() && $this.closest('div#menu').length == 0 && $this.closest('div#mobile-button').length == 0 ){
//            // check
//
//            hideMenu()
//            console.log('true')
//        }
//        else{
//            console.log('false')
//        }
//    })
//})

