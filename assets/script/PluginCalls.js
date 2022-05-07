// JavaScript Document
$(document).ready(function(){
	// performCountDown();
	// performRotation();
	// majorsTabFeed();
	// mobileMenu();
	accordion();
	// toggleButton();
	$('.abstract-toggle').css('display','none');
		/*
	<summary>Navigation display for tablet and desktop view will always be desplayed*</summary>
	<returns>Nothing</returns>
	*/
});
// function toggleButton(){
//
// 	$('.abstract-button').click(function(){
// 		if($(this).parent().next('.abstract-toggle').is(':visible')){
// 			$(this).parent().next('div.abstract-toggle').css("display","none");
// 		}else{
// 			$(this).parent().next('div.abstract-toggle').css("display","block");
// 		}
// 	});
// }
/*
 <summary>Performs the countdown plugin call</summary>
 <returns>Nothing</returns>
*/
// function performCountDown(){
// 		var domain = document.domain;
// 			domain = "https://" + domain + "/files/countdownchange.txt";
// 		var file = domain;
// 		var spit;
//         $.get(file, function(data) {
//               		spit = data.split('\n');
// 			   	var date = spit[0];
// 			   	var time = spit[1];
// 				var title = spit[2];
// 				var links = spit[3];
//
// 				var dateSplit = date.split('/');
// 				var timeSplit = time.split(':');
// 				var month = dateSplit[0];
// 				var day = dateSplit[1];
// 				var year = dateSplit[2];
// 				var hour = timeSplit[0];
// 				var minute = timeSplit[1];
// 				$('#fall').CountDown({
//                     month: month,
//                     day: day,
//                     year: year,
//                    	hours: hour,
//                     minute: minute,
// 					title: title,
// 					links: links,
//                 });
//          });
// }
/*
 <summary>Performs the image rotation</summary>
 <returns>Nothing</returns>
*/
// function performRotation(){
// 	var domain = document.domain;
// 			domain = "https://" + domain + "/files/rotationTabs.txt";
// 	$('.introrotation').rotation({
// 		pullFromFeed: false,
// 		whichFeed: "newsFeed",/* newsFeed, spotlightFeed, ""(both) */
// 		csvLocation: domain,
// 		limit: 4,
// 	});
// }
/*
 <summary>Applies a tabular menu to majors and minors feed from catalog</summary>
 <returns>Nothing</returns>
*/
// function majorsTabFeed(){
// 		var nav = '<ul class="tabs-menu">';
// 		$('.tabs-content .tabs-panel .tabs-heading').each(function(){
// 			var menuItem = $(this).text();
// 			nav += '<li class="menu-heading"><a href="#" onclick="return false;">' + menuItem + '</a></li>';
// 		});
// 		nav += '</ul';
// 		$('.tabs-nav').append(nav);
// 		$('.tabs-panel').css('display','none');
// 		$('.tabs-panel:nth-child(1)').css('display','block');
// 		$('li.menu-heading:nth-child(1)').addClass('active');
// 		$('li.menu-heading').click(function(){
// 			var clickedIndex = $(this).index();
// 			$('.tabs-panel').css('display','none');
// 			$('li.menu-heading').removeClass('active');
// 			$(this).addClass('active');
// 			var selected = clickedIndex;
// 			$(".tabs-content .tabs-panel:eq("+selected+")").css('display','block');
// 		});
// }
/*
 <summary>Applies the slide toggle to the menu button in the mobile view</summary>
 <returns>Nothing</returns>
*/
// function mobileMenu(){
// 	$('.hamburger').bind('click touch',function(){
// 		$(this).next('.toggleNav').slideToggle('slow');
// 	});
// }
/*
 <summary>Applies an accordion menu to items Under accordion class, and headers being h2</summary>
 <returns>Nothing</returns>
*/
function accordion(){
	$('.accordion').each(function(){
		$(this).find('h2').nextUntil('h2').css("display","none");
	});
	$('.expand-all, .collapse-all').click(function() {
		$('.accordion div').each(function() {
    			if($('.all-toggle').hasClass('expand-all')){
					$(this).show('slow');
					$('.accordMenuClosed').addClass('accordMenuOpen');
					$('.accordMenuClosed').removeClass('accordMenuClosed');

				}else{
					$(this).hide('slow');
					$('.accordMenuOpen').addClass('accordMenuClosed');
					$('.accordMenuOpen').removeClass('accordMenuOpen');
				}
		});
		if($(this).hasClass('expand-all')){
			$(this).removeClass('expand-all');
			$(this).addClass('collapse-all');
		}else{
			$(this).removeClass('collapse-all');
			$(this).addClass('expand-all');
		}

	});
	$('.accordion h2').click(function(){

		$(this).nextUntil('h2').slideToggle('slow');
		if($(this).hasClass('accordMenuClosed')){
			$('.accordMenuOpen').nextUntil('h2').slideToggle('slow');
			$('.accordMenuOpen').addClass('accordMenuClosed');
			$('.accordMenuOpen').removeClass('accordMenuOpen');
			$(this).removeClass('accordMenuClosed');
			$(this).addClass('accordMenuOpen');
		}else{
			$(this).removeClass('accordMenuOpen');
			$(this).addClass('accordMenuClosed');
		}
	});
}
