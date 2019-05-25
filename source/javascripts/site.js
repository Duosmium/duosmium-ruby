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

  // Sort teams (rows) by various things
  // Adapted from https://blog.niklasottosson.com/javascript/jquery-sort-table-rows-on-column-value/
  sort_select = function() {
    let thing = $("#sort-select option:selected").val()

    var sort_by_number = function(a, b) {
      number_a = parseInt($(a).find("td.number").text());
      number_b = parseInt($(b).find("td.number").text());

      return number_a - number_b;
    }

    var sort_by_school = function(a, b) {
      school_a = $(a).find("td.school").text();
      school_b = $(b).find("td.school").text();

      if (school_a > school_b) { return 1; }
      else if (school_a < school_b) { return -1; }
      else { return sort_by_number(a, b); }
    }

    var sort_by_rank = function(a, b) {
      rank_a = parseInt($(a).find("td.rank").text());
      rank_b = parseInt($(b).find("td.rank").text());

      return rank_a - rank_b;
    }

    switch(thing) {
      case "number":
        var sort_fun = sort_by_number;
        break;
      case "school":
        var sort_fun = sort_by_school;
        break;
      case "rank":
        var sort_fun = sort_by_rank;
        break;
      default:
        return;
    }

    let rows = $("table.results-classic tbody tr").get();
    rows.sort(sort_fun);

    $.each(rows, function(index, row) {
      $("table.results-classic tbody").append(row);
    });
  }
  sort_select(); // call sort immediately if selection is different from default
  $("#sort-select").change(sort_select); // call sort on selection change
});
