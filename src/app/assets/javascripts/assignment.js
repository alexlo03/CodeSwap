
var course_id;

assignments = {

  create: {
    
    pageLoad: function(courseId) {
        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });
        
        course_id = courseId; 
    },

    submitAssignment: function() {
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var name = $('#name').val();
      var desc = $('#description').val();
      if(!assignments.create.datesFormatOK(startDate, endDate)) {
        alert('Please verify the dates entered are valid.');  
      }
      else if(!assignments.create.dateTimesOK(startDate, endDate)) {
        alert('The start date cannot occur after the end date.');
      }
      else {
        $.post('/assignment/submit_new',
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'description':desc,
          'course_id':course_id
          }, function() {
            window.location = '/course/show/' + course_id;
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
      alert(start.getTime());
      return start.getTime() < end.getTime();
    },

  }

}
