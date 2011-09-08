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
function centerGallery() {
  var win_height   = $(window).height(),
      head         = 70,
      foot         = 95, 
      gallery      = 525,
      pad          = 50; 
  var bladder_height = (win_height - head - foot - gallery - 2 * pad) / 2;
  if (bladder_height > 0) {
    $('#bladder').height(bladder_height);
  }
}

function showVignette(product) {
  var uagent = navigator.userAgent.toLowerCase();
  var vignette = '<div id="'+product+'-vignette-top"></div>' +
                 '<div id="'+product+'-vignette-right"></div>' +
                 '<div id="'+product+'-vignette-bottom"></div>' +
                 '<div id="'+product+'-vignette-left"></div>';
  if (uagent.search('ipad') == -1 && uagent.search('ipod') == -1 && uagent.search('iphone') == -1 && !$.browser.mozilla) {
    $('#content').before(vignette);               
  }
}
function setCodeFontSize() {
  var uagent = navigator.userAgent.toLowerCase();
  if (uagent.search('iphone') > -1) {
    $('#agent-xmpp-left .code pre').css('font-size', '50%');               
    $('#zgomot-documentation #documentation pre').css('font-size', '47%');               
    $('#agent-xmpp-documentation #documentation pre').css('font-size', '47%');               
  }
}
