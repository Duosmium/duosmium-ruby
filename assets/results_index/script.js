$(document).ready(function(){
  // Change layout and filter results when user starts typing in search bar
  $("div.search-wrapper input").val(""); // Start with empty search bar
  $("div.search-wrapper input").on("input", function() {
    let search_text = $(this).val().toLowerCase().trim();
    if (search_text.length === 0) {
      $("div.search-wrapper").removeClass("searching");
      $("style#search_style").html("");
    } else {
      $("div.search-wrapper").addClass("searching");

      // inspired by
      // http://www.redotheweb.com/2013/05/15/client-side-full-text-search-in-css.html
      // may not scale well?
      let search_html = "";
      // replace "div c" with "div-c", and like, for the data-search attribute
      let words = search_text.replace(/(div|division) ([abc])/, "$1-$2");
      words.split(/\s+/).forEach(function(word) { // split on whitespace
        search_html += "div.card:not([data-search*=\"" + word + "\"])" +
                       "{ display: none; }\n";
      });
      $("style#search_style").html(search_html);
    }
  });

  // Cause input box to lose focus after hitting enter (esp. for mobile devices
  // where keyboard takes up a lot of the screen)
  $("input#searchTournaments").change(function(e) {
    $("input#searchTournaments").blur();
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
