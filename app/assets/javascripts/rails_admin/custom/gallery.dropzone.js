$document.on('rails_admin.dom_ready', function(){
    var $form = $(".multiple-upload-form")
    var url = $form.attr("action")
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
                $(file.previewTemplate).find('.dz-remove').attr('id', response.fileID)
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


            $preview_element.find("a.dz-remove").attr("id", file.id )

        },
        removedfile: function(file){
            var id = $(file.previewTemplate).find('.dz-remove').attr('id')
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
                $(file.previewTemplate).find('.dz-remove').attr('id', response.id)
                $(file.previewElement).addClass('dz-success')
            })
        }
    });

})

$document.on('ready rails_admin.dom_ready', function(){
    $('head').append('<link rel="stylesheet" type="text/css" href="/assets/fancybox.css">')
    $.getScript("/assets/fancybox.js", function(){
        init_fancybox_links()
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