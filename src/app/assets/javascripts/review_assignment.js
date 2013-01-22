
var assignment_id;
var that = this;
reviewassignments = {

  create: {
    alert("testing");

  }
}

 /* 
    pageLoad: function(a_id) {
        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });

        
        assignment_id = a_id; 
    },

    submitAssignment: function() {
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var name = $('#name').val();
      var desc = $('#description').val();
      if(!reviewassignments.create.datesFormatOK(startDate, endDate)) {
        reviewassignments.create.flashError("flash","Please verify the dates entered are valid.");  
      }
      else if(!reviewassignments.create.dateTimesOK(startDate, endDate)) {
        reviewassignments.create.flashError("flash","The start date cannot occur after the end date.");
      }
      else if(!name){
        reviewassignments.create.flashError("flash","Oh no!  This assignment is nameless. Try giving it a title");
      }
      else if(!desc){
        reviewassignments.create.flashError("flash","Gahh! What\'s this assignment about?  Let's add a little description.");
      }
      else {
        $.post('/reviewassignment/create/'+assignment_id,
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'description':desc
          }, function() {
            window.location = '/';
          }          
        );
      }
    },
   
    
    datesFormatOK: function(startDate, endDate) {
      return (startDate.split('-').length == 3) && (endDate.split('-').length == 3);
    },

    dateTimesOK : function(startDate, endDate) {
      startYear = startDate.split('-')[2];
      startDay = startDate.split('-')[1];
      startMonth = startDate.split('-')[0];

      endYear = endDate.split('-')[2];
      endMonth = endDate.split('-')[0];
      endDay = endDate.split('-')[1];
      
      var start = new Date(startYear, startMonth - 1, startDay);
      var end = new Date(endYear, endMonth - 1, endDay);

      return start.getTime() < end.getTime();
    },
  flashError : function(id,message) {
         
         document.getElementById(id).innerHTML="<b>"+message+"</b><br>";
         $('#'+id).delay(500).fadeIn('normal', function() {
        $(that).delay(2500).fadeOut();});
  }
  }
}*/

  
