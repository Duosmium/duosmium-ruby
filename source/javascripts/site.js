// This is where it all goes :)

$(document).ready(function(){

  // Highlight table columns on hover
  // Adapted from https://css-tricks.com/row-and-column-highlighting/
  $("table.results-classic td, table.results-classic th").hover(
    function() {
      $("colgroup col").eq($(this).index()).addClass("hover");
    }, function() {
      $("colgroup col").eq($(this).index()).removeClass("hover");
    });

  // Sort teams (rows) by various things
  // Adapted from https://blog.niklasottosson.com/javascript/jquery-sort-table-rows-on-column-value/
  var sort_select = function() {
    let thing = $("#sort-select option:selected").val()

    var sort_by_number = function(a, b) {
      let number_a = parseInt($(a).find("td.number").text());
      let number_b = parseInt($(b).find("td.number").text());

      return number_a - number_b;
    }

    var sort_by_school = function(a, b) {
      let school_a = $(a).find("td.school").text();
      let school_b = $(b).find("td.school").text();

      if (school_a > school_b) { return 1; }
      else if (school_a < school_b) { return -1; }
      else { return sort_by_number(a, b); }
    }

    var sort_by_rank = function(a, b) {
      let rank_col = $("#event-select option:selected").val();

      if (rank_col === "all") {
        var rank_a = parseInt($(a).find("td.rank").text());
        var rank_b = parseInt($(b).find("td.rank").text());
      } else {
        var rank_a = parseInt($(a).find("td.event-points").eq(rank_col).text());
        var rank_b = parseInt($(b).find("td.event-points").eq(rank_col).text());
      }

      let diff = rank_a - rank_b;
      if (diff !== 0) { return diff; }
      else { return sort_by_number(a, b); }
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

  // Show the hidden column with event points directly next to team name for
  // small screens
  var sort_and_toggle_event_rank = function() {
    let rank_col = $("#event-select option:selected").val();

    // re-sort if by rank is selected (needed because rank would be by event)
    if($("#sort-select option:selected").val() === "rank") {
      sort_select();
    }

    if (rank_col !== "all") {
      $("div.results-classic-wrapper").addClass("event-focused");
      $("th.event-points-focus div").text($("#event-select option:selected").text());

      // copy info from event-points to event-points-focus
      let rows = $("table.results-classic tbody tr").get();
      $.each(rows, function(index, row) {
        let points = $(row).find("td.event-points").eq(rank_col).text();
        let points_elem = $(row).find("td.event-points-focus");
        points_elem.children("div").text(points);
        points_elem.attr("data-points", points);
      });
    } else {
      $("div.results-classic-wrapper").removeClass("event-focused");
      $("th.event-points-focus div").text("");
      $("td.event-points-focus div").text("");
    }
  }
  sort_and_toggle_event_rank();
  $("#event-select").change(sort_and_toggle_event_rank);

  // Toggle rows based on checkboxes
  // First, make sure all checkboxes are checked initially (browser might tend
  // to remember previous state)
  $("div#team-filter input").prop("checked", true);
  $("div#team-filter input").change(function() {
    let id = $(this).attr("id");
    let all_box = $("div#team-filter input#allTeams");
    let team_boxes = $("div#team-filter input").not("#allTeams");

    if (id === "allTeams") {
      if ($(this).prop("checked")) {
        team_boxes.not(":checked").trigger("click");
      } else {
        team_boxes.filter(":checked").trigger("click");
      }
      all_box.prop("indeterminate", false);

    } else {
      let team_number = id.slice("team".length);
      let r = "table.results-classic tr[data-team-number='" + team_number + "']";

      if ($(this).prop("checked")) {
        $(r).show();
      } else {
        $(r).hide();
      }
      if (team_boxes.not(":checked").length === 0) {
        all_box.prop("indeterminate", false);
        all_box.prop("checked", true);

      } else if (team_boxes.filter(":checked").length === 0) {
        all_box.prop("indeterminate", false);
        all_box.prop("checked", false);

      } else {
        all_box.prop("indeterminate", true);
      }
    }
  });

  // Toggle medal highlighting based on checkboxes
  // Make all checkboxes checked initially
  $("div#settings input").prop("checked", true);
  $("div#settings input").change(function() {
      let medal_number = $(this).attr("id").slice("medal".length);
      let medals = $("td[data-points='" + medal_number + "'] div")
      
      if ($(this).prop("checked")) {
        medals.removeAttr("style"); // default state is 'highlighted'
      } else {
        medals.css("background-color", "transparent");
      }
  });
});
