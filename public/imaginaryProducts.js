function setPageSize() {
    var doc_height    = $(document).height(),
        page_height   = $('#page-wrapper').height(),
        win_height    = $(window).height(),
        win_width     = $(window).width(),
        nav_height    = $('#navigation-wrapper').height(),
        nav_padding   = $('#navigation-wrapper').css('padding-bottom').slice(0, -2),
        footer_height = $('#footer-wrapper').height() - 1,
        footer_padding = $('#footer-wrapper').css('padding-top').slice(0, -2),
        footer_margin  = $('#footer-wrapper').css('margin-top').slice(0, -2),
        page_width    = 1000;    
    if (win_width < 800) {
        page_width = 800;
    } else if (win_width < 1000) {
        page_width = win_width;
    }
    if (doc_height == win_height) {
        var page_height  = doc_height - footer_height - nav_height - nav_padding - footer_padding - footer_margin;
        if (win_width >= 800 && win_width < 1000) {
            page_height += 15;
        }
        $('#page-wrapper').height(page_height);
    }
    $('#page').width(page_width);
    $('#navigation').width(page_width);
    $('#footer').width(page_width);
    
    var gallery = $('#gallery')
    if (gallery) {
        var padding_top = 2 * (page_height - 500) / 5;
        $('#page-wrapper').css('padding-top', padding_top)
        $('#page-wrapper').height(page_height - padding_top);
    }
}