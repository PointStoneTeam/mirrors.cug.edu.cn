/*
# =============================================================================
#   Sparkline Linechart JS
# =============================================================================
*/


(function() {

  $(document).ready(function() {

    var $alpha, $container, $container2, addEvent, buildMorris, checkin, checkout, d, date, handleDropdown, initDrag, m, now, nowTemp, timelineAnimate, y;
 
    /*
    # =============================================================================
    #   DataTables
    # =============================================================================
    */

    $("#dataTable1").dataTable({
      "sPaginationType": "full_numbers",
	  "bFilter": false,
	   "bPaginate": false,
	   "bInfo": false,
      aoColumnDefs: [
        {
          bSortable: true,
          aTargets: [0]
        }
      ]
    });
    $('.table').each(function() {
      return $(".table #checkAll").click(function() {
        if ($(".table #checkAll").is(":checked")) {
          return $(".table input[type=checkbox]").each(function() {
            return $(this).prop("checked", true);
          });
        } else {
          return $(".table input[type=checkbox]").each(function() {
            return $(this).prop("checked", false);
          });
        }
      });
    });
  });

}).call(this);
