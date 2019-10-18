// This function is used to get error message for all ajax calls
function getErrorMessage(jqXHR, exception) {
  var msg = '';
  if (jqXHR.status === 0) {
    //msg = 'Not connect.\n Verify Network.';
    msg = 'Brak połączenia. Skontaktuj się z administratorem sieci';
  } else if (jqXHR.status == 401) {
    //window.location.reload();
    msg = '[401] - Sesja wygasła. Odśwież stronę' + jqXHR.responseText;
  } else if (jqXHR.status == 403) {
    msg = '[403] - Dostęp zabroniony' + jqXHR.responseText;
  } else if (jqXHR.status == 404) {
    //msg = 'Requested page not found. [404]';
    msg = '[404] - Nie znalazłem takiej strony.';
  } else if (jqXHR.status == 500) {
    msg = '[500] - Internal Server Error [500].';
  } else if (exception === 'parsererror') {
    msg = 'Requested JSON parse failed.';
  } else if (exception === 'timeout') {
    msg = 'Time out error.';
  } else if (exception === 'abort') {
    msg = 'Ajax request aborted.';
  } else {
    msg = 'Uncaught Error.\n' + jqXHR.responseText;
  };


  toastr.options = {
    "closeButton": false,
    "debug": true,
    "newestOnTop": false,
    "progressBar": false,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "100",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };

  toastr['error'](msg);

  //alert(msg)
};