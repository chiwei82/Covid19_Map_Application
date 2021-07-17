document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.sidenav');
    var instances = M.Sidenav.init(elems, {
      // specify options here
    });
    var elems_carousel = document.querySelectorAll('.carousel');
    var instances_carousel = M.Carousel.init(elems_carousel, {
      fullWidth: true,
      indicators: true,
    });
    var elems_floatbtn = document.querySelectorAll('.fixed-action-btn');
    var instances_floatbtn = M.FloatingActionButton.init(elems_floatbtn, {
      // specify options here
    });
});