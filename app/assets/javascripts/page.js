// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('ready',function(){
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

$("#foo1").owlCarousel({
  navigation: true,
  pagination: false,
  items: 6
});

$('#foo1 li a.fb').fancybox();


	
	console.log('ready');



// home_slider

$('#refineslide-images').refineSlide({
  maxWidth: '100%',
  useArrows: true,
  transitionDuration: 800,
  transition: 'sliceV',
  arrowTemplate: '<div class="rs-arrows"><a href="#" class="rs-prev"><span class="arrow"></span></a><a href="#" class="rs-next"><span class="arrow"></span></a></div>'

});

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

