$(document).ready(function(){
    setPageSize();
	var totWidth=0;
	var positions = new Array();
	$('#slides .slide').each(function(i){
		positions[i]= totWidth;
		totWidth += $(this).width();
		if(!$(this).width()) {
			alert("Please, fill in width & height for all your images!");
			return false;
		}
	});
    var current=1;
    function autoAdvance() {
        if(current==-1) return false;
        $('#menu ul li a').eq(current % $('#menu ul li a').length).trigger('click', [true]);   
        current++;
    }
    var changeEvery = 10;
    var intval = setInterval(function(){autoAdvance()},changeEvery*1000);
	$('#slides').width(totWidth);
	$('#menu ul li a').click(function(e, args){
	    if (!args) {clearInterval(intval);}
		$('li.menuItem').removeClass('act').addClass('inact');
		$(this).parent().addClass('act');
		var pos = $(this).parent().prevAll('.menuItem').length;
		$('#slides').stop().animate({marginLeft:-positions[pos]+'px'},450);
		e.preventDefault();
	});
	$('#menu ul li.menuItem:first').addClass('act').siblings().addClass('inact');
});

/*-------------------------------------------------------------------------------*/
function setPageSize() {
    var doc_height     = $(document).height(),
        page_height    = $('#page-wrapper').height(),
        win_height     = $(window).height(),
        win_width      = $(window).width(),
        nav_height     = $('#navigation-wrapper').height(),
        nav_padding     = $('#navigation-wrapper').css('padding-bottom')
        footer_height  = doc_height-nav_height; 
    if (win_height < 800) {
       win_height = 800; 
    } 
    // $('#page-wrapper').width(page_width);
    // $('#title-wrapper').width(page_width);
    // $('#toolbar-wrapper').width(page_width);
    // $('#navigation').width(page_width);
    // $('#subtitle').width(page_width);
    // $('#page__flash').width(page_width);
    // $('#footer-wrapper').width(page_width);
}