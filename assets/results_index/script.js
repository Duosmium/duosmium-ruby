$(document).ready(function(){
  // Set intial focus on search bar (autofocus HTML5 attr not used because it
  // doesn't activate the floating label JS)
  $("div.search-wrapper input").focus();
  // Change layout when user starts typing in search bar
  $("div.search-wrapper input").val(""); // Start with empty search bar
  $("div.search-wrapper input").on("input", function() {
    if ($(this).val().length === 0) {
      $("div.search-wrapper").removeClass("searching");
    } else {
      $("div.search-wrapper").addClass("searching");
    }
  });

  // Blur logo when showing tournament summary (in results index)
  $("div.card-body div.summary").on("show.bs.collapse", function() {
    $(this).parent().children("img").addClass("blur");
  });
  $("div.card-body div.summary").on("hide.bs.collapse", function() {
    $(this).parent().children("img").removeClass("blur");
    // Unfocus tournament summary button when summary is hidden
    let button = $(this).parent().parent().find("div.card-actions button");
    button.blur(); // removes the focus, nothing to do with visual blur
  });

  // Make tournament summary toggle when clicking summary button
  $("div.card-actions button").on("click", function() {
    $(this).parent().parent().children("div.card-body").click();
  });
});
