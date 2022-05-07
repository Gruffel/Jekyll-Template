{% comment %}

window.onload = function() {
setTimeout(arrowMagic, 15000);
console.log('Arrow Delay');
}


function arrowMagic(){
setInterval("myFunction()", 5);
console.log('Arrow interval');

}

function myFunction() {
  var yar = document.getElementsByClassName("slick-arrow");
  var x = document.getElementById("navLinks");
  console.log('myFunction is working');



  if (document.hasFocus(x)) {
for (i = 0; i < yar.length; i++) {
     yar[i].setAttribute("style", "display:none!important");
     }
     console.log('Arrow Gone');
  } else {
    for (i = 0; i < yar.length; i++) {
     yar[i].setAttribute("style", "display:inline-block!important");
   }
     console.log('Arrow back');

  }
}


window.onload = function() {
  setTimeout(arrowMagic(), 1000);
  console.log('Arrow Delay');
}
var previous = document.getElementsByClassName("slick-prev");
var next = document.getElementsByClassName("slick-next");
var x = document.getElementById("navLinks");

function arrowMagic() {

  console.log('Arrow interval');


x.addEventListener("mouseover", function(event) {
  event.next.setAttribute("style", "display:none");
  event.console.log('mouseover works');
  event.previous.setAttribute("style", "display:none");
}
}


next[0].setAttribute("style", "display:inline-block");
previous[0].setAttribute("style", "display:inline-block");
{% endcomment %}


{% comment %}



var previous = document.getElementsByClassName("slick-prev");
var next = document.getElementsByClassName("slick-next");

var x = document.getElementById("navLinks");
x.addEventListener("mouseover", function(event) {

  next[0].setAttribute("style", "display:none");
  console.log('mouseover works');
  previous[0].setAttribute("style", "display:none");
  setTimeout(function() {
  }, 500);
  }, false);

 // document.getElementById("navLinks").onmouseenter = MouseEnter;
 // document.getElementById("navLinks").onmouseleave = MouseLeave;


 document.getElementById("navLinks").addEventListener("mouseenter", MouseEnter => {
   document.getElementsByClassName("slick-next")[0].style.display ="none";
   document.getElementsByClassName("slick-prev")[0].style.display ="none";
   document.getElementsByClassName("home-slider__pauseButton")[0].style.display ="none";

 });


 document.getElementById("navLinks").addEventListener("mouseleave", MouseLeave => {
   document.getElementsByClassName("slick-next")[0].style.display ="inline-block";
   document.getElementsByClassName("slick-prev")[0].style.display ="inline-block";
   document.getElementsByClassName("home-slider__pauseButton")[0].style.display ="inline-block";
 });
 {% endcomment %}
