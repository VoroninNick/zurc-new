// ===========================================
// -------------------------------------------
// TODO: make event uncheck and make it working
// -------------------------------------------
// ===========================================

(function($){
    $body = null
    $document = $(document)
    $window = $(window)
    $html = $('html')

    var hide_class = 'hide'
    var prev_checked_value_property_name = 'prev_checked_value'
    $.fn.handle_input = function(options){

        var allow_bubble = options && options['allow_bubble'] == true
        var $input = $(this)
        var checked = $input.filter(':checked').length > 0
        var show_selector = $input.attr('data-show-selector')
        var hide_selector = $input.attr('data-hide-selector')
        var $items_to_show = $(show_selector)
        var $items_to_hide = $(hide_selector)

        var input_data = $input.data('input_data')
        var input_value = $input.val()
        var input_name = $input.attr('name')
        var initialized = input_data != undefined




        if(checked){
            console.log('checked; items_to_show: ' + $items_to_show.length + ' ; items_to_hide: ' + $items_to_hide.length)
            $items_to_show.removeClass(hide_class)
            $items_to_hide.addClass(hide_class)
        }
        else{
            console.log('unchecked')
            $items_to_show.addClass(hide_class)
            $items_to_hide.removeClass(hide_class)
        }

        //if(!initialized){
        //    input_data = {}
        //}
        //
        //
        //
        //if(checked || !initialized) {
        //    if (initialized) {
        //        console.log('initialized: ', initialized)
        //        var prev_value = $input.data('input_data')[prev_checked_value_property_name]
        //        var $prev_input = $('input[value=' + prev_value + ']')
        //        if (allow_bubble) {
        //            $prev_input.handle_input()
        //        }
        //    }
        //    else {
        //        //input_data.prev_checked_value = input_value
        //    }
        //
        //    input_data.prev_checked_value = input_value
        //
        //
        //
        //    var inputs_by_its_name = document.getElementsByName(input_name)
        //    var $inputs_by_its_name = $(inputs_by_its_name)
        //    $inputs_by_its_name.data('input_data', input_data)
        //}



    };

    var group_names = [];
    $('input[name][type=radio]').each(function(i){
        name = $(i).attr('name');
        if(group_names.indexOf(name) < 0){
            group_names.push(name)
        }
    })

    var $last = $('[name=radioButtonGroup]:checked');

// Select the radio buttons as a group.
    var $radios = $('input[type=radio]').bind('change', function (ev) {
        // Click event handler
        var $clicked = $(ev.target); // This is the radio that just got clicked.
        $last.trigger('unclick'); // Fire the "unclick" event on the Last radio.

        $last = $('[name=radioButtonGroup]:checked'); // Update the $last item.

        // Should see the clicked item's "Value" property.
        console.log("Clicked " + $clicked.attr('value'), $clicked, ev);
    }).bind('unclick', function (ev) {
        // Handler for our new "unclick" event - which fires whenever a radio loses focus.
        var $unclicked = $(ev.target); // This is the radio which is losing it's checked status.

        // Should see the unclicked item's "Value" property.
        console.log("Unclicked " + $unclicked.attr('value'), $unclicked, ev);
    });



    $document.on('ready', function(){
        $body = $('body')
        ////if($body.hasClass('admin_vs_menu_items')){
        ////
        ////    var $vs_menu_item_link_source_input = $('#vs_menu_item_link_source_input')
        ////    $vs_menu_item_link_source_input.on('change', function(){
        ////        var $input_wrapper = $(this)
        ////        var $inputs = $vs_menu_item_link_source_input.find('input')
        ////        var $checked_input = $inputs.filter(':checked')
        ////        var checked_input_value = $checked_input.val()
        ////        if(checked_input_value == 'url'){
        ////
        ////        }
        ////
        ////        //alert('hello')
        ////        //alert('' + $input.val())
        ////    })
        ////}
        //
        //
        var $inputs_for_check_on_show_or_hide = $body.find('[data-show-selector], [data-hide-selector]')
        $inputs_for_check_on_show_or_hide.each(function(){
            var $input = $(this)
            $input.handle_input()
        })

        $inputs_for_check_on_show_or_hide.on('change', function(){
            var $input = $(this)
            $input.handle_input({allow_bubble: true})
            //console.log('change', $input.get(0))

        })
    })
})(jQuery)