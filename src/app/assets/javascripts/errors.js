errors = {
  show : function(field, message) {
      $("#" + field).append($("<div id='alert' class='alert alert-error fade in' data-alert>"+
           "<button type='button' class='close' data-dismiss='alert'>×</button><strong> " + message + " </strong></div>"));
          $('#alert').delay(1500).fadeOut('slow', function(){ $('#alert').remove() });
  }
};
