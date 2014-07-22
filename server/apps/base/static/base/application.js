$(function() {

    // Site Bar
    +function() {
        $('.down-arrow').each(function() {
            var that = $(this);
            var parent = that.parents('li').first();
            var top_bar = parent.parents('.top-bar');
            parent.click(function() {
                if(that.hasClass('down-arrow')) {
                    top_bar.find('.up-arrow').click();
                }
                that.toggleClass('up-arrow down-arrow');
            });
        });
    }();

    // Utility Bar
    +function() {

        // Login and Search
        $('.utility-button').each(function() {
            var that = $(this);
            var target = that.data('target');
            var form = $('#' + target).hide();
            that.click(function() {
                if(form.toggle().is(':visible')) {
                    form.find('input').first().focus();
                }
            });
        });

    }();

    // Navigation Displays
    +function() {

        var links = $('#navigation-bar').find('.left');

        // Products, About, Forums, Contact
        links.find('li').each(function() {
            var that = $(this);
            if(that.attr('data-target')) {
                var target = that.data('target');
                var display = $('#' + target).hide();
                that.click(function() {
                    display.toggle();
                });
            }
        });

    }();

})