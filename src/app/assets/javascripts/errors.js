errors = {
  show : function(field, message) {
      $("#" + field).append($("<div id='alert"+field+"' class='alert alert-error fade in' data-alert>"+
           "<button type='button' class='close' data-dismiss='alert'>×</button><strong> " + message + " </strong></div>"));
          $('#alert'+field).delay(1500).fadeOut('slow', function(){ $('#alert'+field).remove() });
  }
};
