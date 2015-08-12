# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  

  

$(document).on 'ready page:load', ->
  $('#date').datepicker()

  setInterval (->
    $('#calendar').fullCalendar 'refetchEvents'
    return
  ), 60 * 1000
  
  $('button').click ->
    myValue = $(this).attr('class')
    if $(this).html() == 'Cancel'
     $(this).text 'Order'
     $.ajax
              url: '/lunch_orders/pop_lunch'
              type: 'GET'
              data:
                id: myValue
                date: $("#to_date").html()
              success: (resp) ->
                alert('done removed')
                $('#calendar').fullCalendar 'refetchEvents'
                return
              error: (resp) ->
                return
    else
     $(this).text 'Cancel'
     $.ajax
              url: '/lunch_orders/push_lunch'
              type: 'GET'
              data:
                id: myValue
                date: $("#to_date").html()
              success: (resp) ->
                alert('done addded')
                $('#calendar').fullCalendar 'refetchEvents'
                return
              error: (resp) ->
                return
    return

  $('#calendar').fullCalendar
    header:
      left: 'prev'
      center: 'title'
      right: 'today next'
    defaultView: 'month'
    height: 500
    slotDuration: '00:00:05'
    eventColor: '#378006' 
    events: '/lunch_orders/get_events'
    dayRender: (date,cell) ->
      toDay = moment().format("YYYY-MM-DD")
      modDate = moment(date).format("YYYY-MM-DD")
      if moment().diff(date,toDay) > 86400000
          weekends=date.weekday()
          if weekends == 0 || weekends == 6
            cell.addClass("Nokesaram")
          else
            cell.addClass("kesaram")
      else
          weekends=date.weekday()
          if weekends == 0 || weekends == 6
            cell.addClass("Nokesaram")
          else
            cell.addClass("kesaram")
      return
    eventClick: (calEvent, jsEvent, view) ->     
      toDay = moment().format("YYYY-MM-DD")
      date=moment(calEvent._start).format("YYYY-MM-DD")
      if moment().diff(date,toDay) > 86400000
        $(".alertMsg").css "color", "red"
        $(".alertMsg").text ("You cant modify previous dates")
        setTimeout('$(".alertMsg").hide()',1500)
        $(".alertMsg").show()     
      else
        $.ajax
              url: '/lunch_orders/drop_order'
              type: 'GET'
              data:
                id: calEvent.id
              success: (resp) ->
                $(".alertMsg").css "color", "green"
                $(".alertMsg").text ("Lunch removed successfully...")
                setTimeout('$(".alertMsg").hide()',1500)
                $(".alertMsg").show()
                $('#calendar').fullCalendar 'refetchEvents'
                return
              error: (resp) ->
                $(".alertMsg").css "color", "orange"
                $(".alertMsg").text ("Please click on the 'Yes' ")
                setTimeout('$(".alertMsg").hide()',1500)
                $(".alertMsg").show()
                return
      return
    eventRender: (event, element, view) ->
        toDay=moment().format("YYYY-MM-DD")
        dateOfEvent=moment(event.start).format("YYYY-MM-DD")
        element.css("background-color", "green")
        return
    dayClick: (date, jsEvent, view) ->
      toDay = moment().format("YYYY-MM-DD")
      modDate = moment(date).format("YYYY-MM-DD")
      if moment().diff(modDate,toDay) < 86400000
        weekends=date.weekday()
        if weekends == 0 || weekends == 6
          $(".alertMsg").css "color", "orange"
          $(".alertMsg").text ("No information on weekends")
          setTimeout('$(".alertMsg").hide()',1500)
          $(".alertMsg").show()
        else
          $.ajax
            url: '/lunch_orders/put_order'
            type: 'GET'
            data:
              date: modDate
            success: (resp) ->
              $(".alertMsg").css "color", "green"
              $(".alertMsg").text ("Lunch created successfully...")
              setTimeout('$(".alertMsg").hide()',1500)
              $(".alertMsg").show()
              $('#calendar').fullCalendar 'refetchEvents'
              return
            error: (resp) ->
              $(".alertMsg").css "color", "orange"
              $(".alertMsg").text ("Click on the 'Yes'")
              setTimeout('$(".alertMsg").hide()',1500)
              $(".alertMsg").show()
              return
      else
        $(".alertMsg").css "color", "red"
        $(".alertMsg").text ("You cant modify previous dates")
        setTimeout('$(".alertMsg").hide()',1500)
        $(".alertMsg").show()
      $('#calendar').fullCalendar 'dayRender'
      $('#calendar').fullCalendar 'unselect'
      return
    eventAfterAllRender: (view) ->
      $('td:not([class])').append '<a class=\'fc-day-grid-event fc-h-event fc-event fc-start fc-end notSelect\' ><div class=\'fc-content\'> <span class=\'fc-title\'>No</span></div></a>'

      return  
return
