function nearBottomOfPage() {
    return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
    return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

$document.on('ready page:load', function() {

    var $infinity_scroll_list = $('.infinity-scroll-list')
    var infinity_scroll_list_count = $infinity_scroll_list.length
    var load_started = false

    if (infinity_scroll_list_count > 0) {
        console.log('infinity_scroll_list_count: ', infinity_scroll_list_count)
        var current_pagination_page = 1
        var max_pagination_page = +$('.pagination span.page:not(.gap):last a').text()
        console.log('max_pagination_page: ', max_pagination_page)
        if (max_pagination_page > current_pagination_page) {
            var url = window.location.pathname

            $window.on('scroll', function (event) {
                console.log("scroll")
                if (!load_started && current_pagination_page < max_pagination_page && nearBottomOfPage()) {
                    load_started = true
                    var required_page = current_pagination_page + 1
                    current_pagination_page++

                    $.ajax({
                        url: url,
                        type: 'get',
                        data: 'ajax=true&page=' + required_page,
                        dataType: 'json',
                        complete: function (jqXHR, textStatus) {
                            var response_text = jqXHR.responseText
                            var data = $.parseJSON(response_text)
                            var html_source = data['html']
                            //var $html_source
                            if (textStatus == 'success') {
                                $infinity_scroll_list.append(html_source)
                            }
                            load_started = false
                        }
                    })
                }
            })
        }
    }
})