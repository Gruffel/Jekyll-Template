document.addEventListener("DOMContentLoaded", function(event) {
  var accordion = document.getElementsByClassName("accordion");
  var accordionContent = document.getElementsByClassName('panel');

  for (var i = 0; i < accordion.length; i++) {
    accordion[i].onclick = function() {
        var setClasses = !this.classList.contains('accordionActive');
        setClass(accordion, 'accordionActive', 'remove');
        setClass(accordionContent, 'show', 'remove');

        if (setClasses) {
            this.classList.toggle("accordionActive");
            this.nextElementSibling.classList.toggle("show");
        }
    }
  }

  function setClass(els, className, fnName) {
    for (var i = 0; i < els.length; i++) {
        els[i].classList[fnName](className);
    }
  }
});
