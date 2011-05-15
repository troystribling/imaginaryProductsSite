function setPageWidth() {
  var win_width   = $(window).width(),
      page_width  = 1000;   
  if (win_width < 800) {
      page_width = 800;
  } else if (win_width < 1000) {
      page_width = win_width;
  }
  $('#page').width(page_width);
  $('#navigation').width(page_width);
  $('#footer').width(page_width);
}