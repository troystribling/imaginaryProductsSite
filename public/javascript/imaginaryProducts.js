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
function showVignette (product) {
  var uagent = navigator.userAgent.toLowerCase();
  var vignette = '<div id="'+product+'-vignette-top"></div>' +
                 '<div id="'+product+'-vignette-right"></div>' +
                 '<div id="'+product+'-vignette-bottom"></div>' +
                 '<div id="'+product+'-vignette-left"></div>';
  if (uagent.search('ipad') == -1 && uagent.search('ipod') == -1 && uagent.search('iphone') == -1) {
    $('#content').before(vignette)               
  }
}
