$(document).ready(function() {

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	$('#calendar').fullCalendar({
		header: {
			left: 'prevYear,prev,next,nextYear today',
			center: 'title',
			right: 'listYear,listMonth,month,agendaWeek,agendaDay'
		},
		buttonText: {
	    listYear: 	'lista-rok',
	    listMonth: 	'lista-miesiąc',
	    today:    	'dziś',
	    month:    	'miesiąc',
	    week:     	'tydzień',
	    day:      	'dzień',
	    list:     	'lista-dzień'
		},
		defaultView: 'month',
		locale: 'pl',
		timezone: 'local',
		allDayText: 'Cały dzień',
		weekHeader: 'Tydz',
		dateFormat: 'dd.mm.yy',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		monthNamesShort: ['Sty', 'Lu', 'Mar', 'Kw', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Pa', 'Lis', 'Gru'],
		dayNames: ["Niedziela","Poniedziałek","Wtorek","Środa","Czwartek","Piątek","Sobota"],
		dayNamesShort: ["Nd","Pn","Wt","Śr","Czw","Pt","So"],
		dayNamesMin: ["N","Pn","Wt","Śr","Cz","Pt","So"],
		firstDay: 1,
		editable: false,
		timeFormat: 'HH:mm',
		axisFormat: 'HH:mm',
		slotLabelFormat: 'HH:mm', 
		timezone: "local",
	  events: {
			url: '/events.json',
			type: 'GET',
      error: function (jqXHR, exception) {
        console.log(jqXHR);
        if (jqXHR.status == 401) {
          window.location.reload();
        } else {
          getErrorMessage(jqXHR, exception);
        }
      }
		},
    eventAfterRender: function(event, element) { 
    	if (event.attachments_count > 0) {
        element.find('.fc-title').append("&nbsp;&nbsp;<span class='badge alert-info'>" + event.attachments_count.toString() + "</span>");     		
    	}
     }
	});
});
