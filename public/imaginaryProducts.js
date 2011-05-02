function setPageSize() {
    var doc_height        = $(document).height(),
        page_height       = $('#page-wrapper').height(),
        win_height        = $(window).height(),
        win_width         = $(window).width(),
        nav_height        = $('#navigation-wrapper').height(),
        nav_padding_str   = $('#navigation-wrapper').css('padding-bottom'),
        nav_padding       = nav_padding_str.slice(0, -2),
        footer_height     = $('#footer-wrapper').height(),
        page_width        = 1000;    
    if (win_width < 800) {
        page_width = 800;
    } else if (win_width < 1000) {
        page_width = win_width;
    }
    if (doc_height < win_height) {
        footer_height = doc_height - page_height - nav_height - nave_padding;
        $('#footer-wrapper').height(footer_height);
    }
    $('#page').width(page_width);
    $('#navigation').width(page_width);
    $('#footer').width(page_width);
}