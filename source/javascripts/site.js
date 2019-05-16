// This is where it all goes :)

// Adapted from https://css-tricks.com/row-and-column-highlighting/
$(function(){
  $("table.results-classic").delegate('td','mouseover mouseleave', function(e) {
    if (e.type == 'mouseover') {
      $("colgroup col").eq($(this).index()).addClass("hover");
    }
    else {
      $("colgroup col").eq($(this).index()).removeClass("hover");
    }
  });
})
