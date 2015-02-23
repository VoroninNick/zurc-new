$document.on('ready page:load', function(){
    var $container = $('div.gallery-items-row');



    function init_isotope(tags){
        if(!tags){
            tags = []
        }

        var built_item_selector = 'div.gallery-item'
        var built_filter = tags.map(function(tag){return "." + tag }).join('')
        console.log("item_selector: ", built_item_selector)
        $container.isotope({
            // options
            itemSelector:  built_item_selector,
            layoutMode: 'fitRows',
            filter: built_filter
        });
    }

    init_isotope()

    var $gallery_tags_container = $('div.gallery-tags')
    var $gallery_image_anchors = $('div.image-item a.fb')
    $gallery_image_anchors.attr('rel', 'fb')

    $gallery_tags_container.on( 'change', 'input[type=checkbox]', function(){
        console.log('event handler')
        var $checkbox = $(this)
        var $selected_checkboxes = $gallery_tags_container.find('input:checked')
        var classes = []
        $selected_checkboxes.each(function(){ var $checkbox = $(this); classes.push($checkbox.attr("id")) })
        init_isotope(classes)


        var selector = "div.image-item" + classes.map(function(e){ return "." + e }).join('')

        console.log('selector: ', selector)
        var rel = classes.join(',')
        $gallery_image_anchors.attr('rel', '')
        $(selector).find('a.fb').attr('rel', rel)




    })



    $('div.image-item a.fb').fancybox()
})