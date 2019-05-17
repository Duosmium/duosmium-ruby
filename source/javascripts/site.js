// This is where it all goes :)

$(document).ready(function(){

  // Highlight table columns on hover
  // Adapted from https://css-tricks.com/row-and-column-highlighting/
  $("table.results-classic td").hover(
    function() {
      $("colgroup col").eq($(this).index()).addClass("hover");
    }, function() {
      $("colgroup col").eq($(this).index()).removeClass("hover");
    });

});
