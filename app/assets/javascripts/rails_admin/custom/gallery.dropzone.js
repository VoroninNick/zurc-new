$document.on('rails_admin.dom_ready', function(){
    var $form = $(".multiple-upload-form")
    var url = $form.attr("action")
    if(!$form.length){
        return
    }
    window.myDropzone = new Dropzone($form.get(0), {
        url: url,
        paramName: "gallery_album[images_attributes][][file]",
        addRemoveLinks: true,
        //clickable: ".multiupload-container .form-header ",
        init: function () {
            var mockFiles = JSON.parse($(".multiupload-container").attr('data-existing-images'))
            var this_dropzone = this
            for(var i = 0; i < mockFiles.length; i++){
                var item = mockFiles[i]
                this_dropzone.emit("addedfile", item)
                this_dropzone.emit("thumbnail", item, item.url)
                this_dropzone.emit("complete", item)
                //this_dropzone.options.maxFiles = this_dropzone.options.maxFiles - 1
            }

            this.on('success', function(file, response) {
                $(file.previewTemplate).find('.dz-remove').attr('data-image-id', response.id)
                $(file.previewElement).addClass('dz-success')
            })

        },
        addedfile: function(file){
            Dropzone.prototype.defaultOptions.addedfile.apply(this, arguments)

            $preview_element = $(file.previewElement)
            if (file.url){
                $preview_element.find(".dz-image").replaceWith("<a data-fancybox-group='multiupload-image' href='"+file.large_image_url+"' class='dz-image fancybox'><img src='"+file.url+"' /></a>")
                $preview_element.find(".dz-image").fancybox()
            }

            $preview_element.attr("data-image-id", file.id)
            $preview_element.find("a.dz-remove").attr("data-image-id", file.id )
            var uk_name = file.uk_name
            var en_name = file.en_name

            if (!uk_name){
                uk_name = file.url
                if (uk_name && uk_name.length) {
                    uk_name = uk_name.split("/")
                    uk_name = uk_name[uk_name.length - 1]
                    var ext_index = uk_name.indexOf(".")
                    if (ext_index >= 0) {
                        uk_name = uk_name.substr(0, ext_index)
                    }
                }
            }

            if (!en_name){
                en_name = file.url
                if (en_name && en_name.length) {
                    en_name = en_name.split("/")
                    en_name = en_name[en_name.length - 1]
                    var ext_index = en_name.indexOf(".")
                    if (ext_index >= 0) {
                        en_name = en_name.substr(0, ext_index)
                    }
                }
            }

            $preview_element.append("<div class='custom-details'><div class='uk_name'>" + uk_name + "</div><div class='set-title' data-attr='uk_name'><a>Set uk name</a></div><div class='en_name'>" + en_name + "</div><div class='set-title' data-attr='en_name'><a>Set en name</a></div>")
        },
        removedfile: function(file){
            var id = $(file.previewTemplate).find('.dz-remove').attr('data-image-id')
            var request_data = { image_id: id }
            $.ajax({
                type: 'post',
                url: "/delete_gallery_image",
                data: request_data,
                dataType: 'json',
                success: function(data) {
                    $(file.previewTemplate).remove()
                }
            })

        },
        sending: function (file, xhr, formData) {
            //formData.append('image[advert_id]', advert_id)
            this.on('success', function(file, response) {
                $(file.previewTemplate).find('.dz-remove').attr('data-image-id', response.id)
                $(file.previewElement).addClass('dz-success')
            })
        }
    });

})

$document.on('ready rails_admin.dom_ready', function(){
    $('head').append('<link rel="stylesheet" type="text/css" href="' + stylesheets.fancybox + '">')
    $.getScript(javascripts.fancybox, function(){
        init_fancybox_links()
    })

    var $form = $("form.multiple-upload-form")
    $form.sortable({
        cancel: ".form-header, .form-header *",
        change: function(event, ui){
            setTimeout(dz_upload_data, 1000)
        }
    })

})

$document.on("click", function (e) {
    $(".btn-upload-link").closest("form").trigger("click")
})

function init_fancybox_links($link){
    $link = $link || $('a.fancybox')

    $link.each(function(){
        var $link = $(this)
        if (!$link.hasClass("fancybox-initialized")){
            $link.addClass("fancybox-initialized")
            $link.fancybox()
        }
    })
}

last_update_time = null
function dz_upload_data(){
    console.log('upload data')
    var current_time = Date.now()
    if(last_update_time == null || current_time - last_update_time >= 1000) {
        last_update_time = current_time
        var order_data = []
        var $gallery_images = $('.dz-preview')
        $gallery_images.each(function (index) {
            var $item = $(this)
            var item_data = {id: $item.find("a.dz-remove").attr('data-image-id'), position: index + 1}
            order_data.push(item_data)
        })

        if (!order_data.length){
            return
        }

        console.log("send_sorting_data: ", order_data)

        var ORDER_DATA = order_data
        var request_data = {order_data: order_data}

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

$document.on("click", ".set-title", function(){
    var attr_name = $(this).attr("data-attr")
    $name = $(this).prev()
    name = $name.text()
    new_name = prompt(attr_name + ": '" + name + "'")
    var changed = new_name && new_name.length && new_name != name
    if(changed){
        var image_id = $(this).closest(".dz-preview").attr("data-image-id")

        $name.text(new_name)
        image_data = {}
        image_data[attr_name] = new_name

        $.ajax({
            type: "put",
            url: "update_image/"+image_id,
            data: image_data
        })

    }



})