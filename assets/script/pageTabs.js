$(document).ready(function () {
  //alert($('.resp-tabs').width());
  // $('.resp-tabs').easyResponsiveTabs({
  //    closed: true
  // });

  if($('.resp-tabs').width() > 430){
    $('.resp-tabs').easyResponsiveTabs({
       closed: false
    });
  }
});
