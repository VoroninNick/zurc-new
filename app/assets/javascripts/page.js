// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('ready',function(){
    var $home_first_about_links = $('#home-about-row div.columns a.name')
    if(Modernizr.mq("only screen and (min-width: 641px)")) {
        $home_first_about_links.each(function () {

            var $a = $(this)
            var current_value = $a.html()
            $a.attr('data-first-letter', current_value[0])
            var new_value = current_value.substr(1)
            $a.html(new_value)
        })
    }
    $( window ).resize(function() {
        if(Modernizr.mq("only screen and (max-width: 640px)")){
            $home_first_about_links.each(function(){
                var $a = $(this)
                var data_first_letter = $a.attr('data-first-letter')
                if(data_first_letter){
                    $a.text(data_first_letter + $a.text())
                }
                $a.removeAttr('data-first-letter')
            })
        }
        else{
            $home_first_about_links.each(function(){
                var $a = $(this)
                var data_first_letter = $a.attr('data-first-letter')
                if(!data_first_letter){
                    var current_text = $a.text()
                    var new_text = current_text.substr(1)
                    var first_letter = current_text[0]
                    $a.attr('data-first-letter', first_letter)
                    $a.text(new_text)
                }
                //$a.removeAttr('data-first-letter')
            })
        }
    });
	 /*$("#home-images #flexiselDemo1").flexisel({  //# Create bestseller carousel
   		enableResponsiveBreakpoints: true,
   		visibleItems: 6,
   		animationSpeed: 200,
   		responsiveBreakpoints:{
     		portrait:{
       			changePoint: 480,
       			visibleItems: 1
   			},

    		landscape:{
       			changePoint: 640,
       			visibleItems: 2
			},

    		tablet:{
       			changePoint: 768,
       			visibleItems: 3
   			}
   		}
	});*/

//$("#foo1").carouFredSel();

/*carousel = new Carousel(
  $('#foo1'),
  {
    onChange: function(items) {
      // something when the items change
    },
    //otherCarouFredSelOptions: 'go here'_
    padding: [0,10,0,10],
    width: '100%',
    items: {
    	width: ''+1/6*100+'%',
    	visible:6
    },
    auto:{
    	timeoutDuration: 5000
    }
  }
);*/

var $home_carousel = $('#foo1')

//$home_carousel.owlCarousel({
//  navigation: true,
//  pagination: false,
//  items: 6
//});

$home_carousel.owlCarousel({
    //loop: false,
    //nav: false,
    //margin: 10,
    //items: 1,
    pagination: false,
    navigation: true,
    items: 6,
    itemsDesktop: [1200, 6],
    itemsDesktopSmall: [1000, 5],
    itemsTablet: [641, 3],
    itemsMobile: [0, 2],
    autoPlay: false
});

$('#foo1 li a.fb').fancybox();


	
	console.log('ready');



// home_slider

$('#refineslide-images').refineSlide({
  autoPlay: true,
  delay: 2000,
  transitionDuration: 400,
  maxWidth: '100%',
  useArrows: true,
  transitionDuration: 800,
  transition: 'sliceV',
  arrowTemplate: '<div class="rs-arrows"><a href="#" class="rs-prev"><span class="arrow"></span></a><a href="#" class="rs-next"><span class="arrow"></span></a></div>'

});

    console.log('hello: refine-slide')

  /*$('#refineslide-images').refineSlide({
                transition : 'fade',
                onInit : function () {
                    var slider = this.slider,
                       $triggers = $('.translist').find('> li > a');

                    $triggers.parent().find('a[href="#_'+ this.slider.settings['transition'] +'"]').addClass('active');

                    $triggers.on('click', function (e) {
                       e.preventDefault();

                        if (!$(this).find('.unsupported').length) {
                            $triggers.removeClass('active');
                            $(this).addClass('active');
                            slider.settings['transition'] = $(this).attr('href').replace('#_', '');
                        }
                    });

                    function support(result, bobble) {
                        var phrase = '';

                        if (!result) {
                            phrase = ' not';
                            $upper.find('div.bobble-'+ bobble).addClass('unsupported');
                            $upper.find('div.bobble-js.bobble-css.unsupported').removeClass('bobble-css unsupported').text('JS');
                        }
                    }

                    support(this.slider.cssTransforms3d, '3d');
                    support(this.slider.cssTransitions, 'css');
                }
            });*/

    
});


$document.on('ready', function() {
    $body.on('click', '[data-target]', function (event) {
        event.preventDefault()
        var $this = $(this)
        var data_target = $this.attr('data-target')
        var $target = $('#body').find("[data-id=" + data_target + "]")
        var top = $target.offset().top;
        $('html, #body').animate(
            {scrollTop: '' + top + 'px'},
            300,
            "swing",
            function () {
                //alert(animation complete! - your custom code here!);
            }
        )
    })

    var $what_we_do_category_page = $('.what-we-do-category-page')
    $what_we_do_category_page.on('click', 'a.expander', function(event){
        event.preventDefault()
        var $expander = $(this)
        var action = 'expand'
        var $article_container = $expander.closest('div.article-subcategory-article')
        if($article_container.hasClass('expanded')){
            action = 'collapse'
        }


        console.log("action: ", action)

        switch(action){
            case 'collapse':
                //$expander.removeClass('expanded').addClass('collapsed');

                var container_top = $article_container.offset().top
                $("html, #body").animate({scrollTop: container_top + "px"})
                setTimeout(function(){$article_container.removeClass('expanded').addClass('collapsed');}, 300)
                break;
            case 'expand':
            default:
                //$expander.removeClass('collapsed').addClass('expanded');
                $article_container.removeClass('collapsed').addClass('expanded');

        }
    })

})