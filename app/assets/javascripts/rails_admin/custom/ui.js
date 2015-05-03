//= require rails_admin/custom/fancybox.js

$(document).on('rails_admin.dom_ready', function(){
    // your code
    if($.fancybox) {
        var $fancybox_links = $('a.fancybox')
    }
    var $gallery_images_container = $('div.gallery-images')
    $gallery_images_container.sortable({
        change: function(event, ui){
            setTimeout(upload_data, 1000)
        }
    });
    $gallery_images_container.disableSelection();

    $gallery_images_container.on('click', '.delete-gallery-image', function(event){
        var delete_image = confirm("are you sure you want delete image?")
        var $item = $(this).closest('.gallery-image')
        var image_id = $item.attr('data-image-id')
        if(delete_image){
            var request_data = { image_id: image_id }
            $.ajax({
                url: "/delete_gallery_image",
                data: request_data,
                type: "post",
                dataType: 'json'
            })

            $item.remove()
        }
    })
});

$(document).on('ready', function(){
    $('head').append('<link rel="stylesheet" type="text/css" href="/assets/fancybox.css">')
    $.getScript("/assets/fancybox.js", function(){
        $('a.fancybox').fancybox()
    })

})




last_update_time = null
function upload_data(){
    console.log('upload data')
    var current_time = Date.now()
    if(last_update_time == null || current_time - last_update_time >= 1000) {
        last_update_time = current_time
        var order_data = []
        var $gallery_images = $('div.gallery-images > .gallery-image')
        $gallery_images.each(function (index) {
            var $item = $(this)
            var item_data = {id: $item.attr('data-image-id'), position: index + 1}
            order_data.push(item_data)
        })

        ORDER_DATA = order_data
        request_data = {order_data: order_data}

        $.ajax({
            url: "/update_images_order",
            data: request_data,
            type: "post",
            dataType: 'json'
        })
    }
    else{
        setTimeout(upload_data, 1000)
    }
}