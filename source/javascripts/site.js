// This is where it all goes :)

$(document).ready(function(){

  // First, make sure all default checkboxes are checked initially (browser
  // might tend to remember previous state and it's not apparent to the user
  // that the boxes would be unchecked without going into the menu)
  $("div#team-filter input").prop("checked", true);
  $("div#settings input").prop("checked", true);

  // Correct minimum width of header based on number of events
  var fix_width = function(extra) {
    let width = $("colgroup.event-columns col").length * 2 + 28 + extra;
    let min_width = width + 0.5;
    $("div.results-classic-thead-background").css("min-width", min_width + "em");
    $("div.results-classic-header").css("width", width + "em");
  };
  fix_width(0);

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

      // update medal highlighting based on checkboxes
      $("div#settings input").each(function(index) {
        let medal_number = $(this).attr("id").slice("medal".length);
        let medals = $("td.event-points-focus[data-points='" + medal_number + "'] div")

        if ($(this).prop("checked")) {
          medals.removeAttr("style"); // default state is 'highlighted'
        } else {
          medals.css("background-color", "transparent");
        }
      });
      fix_width(4);

    } else {
      $("div.results-classic-wrapper").removeClass("event-focused");
      $("th.event-points-focus div").text("");
      $("td.event-points-focus div").text("");
      fix_width(0);
    }
  }
  sort_and_toggle_event_rank();
  $("#event-select").change(sort_and_toggle_event_rank);

  // Toggle rows based on checkboxes
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
  $("div#settings input").change(function() {
      let medal_number = $(this).attr("id").slice("medal".length);
      let medals = $("td[data-points='" + medal_number + "'] div")
      
      if ($(this).prop("checked")) {
        medals.removeAttr("style"); // default state is 'highlighted'
      } else {
        medals.css("background-color", "transparent");
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
