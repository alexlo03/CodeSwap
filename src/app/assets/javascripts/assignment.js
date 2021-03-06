var course_id;

assignments = {

  create: {
    
    pageLoad: function(courseId) {

        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });

        $('#time-start').timepicker({minuteStep: 1});
        $('#time-end').timepicker({minuteStep: 1});
        course_id = courseId; 
    },

    submitAssignment: function() {
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var startTime = $('#time-start').val();
      var endTime = $('#time-end').val();
      var name = $('#name').val();
      var desc = $('#description').val();
	  	var hidden = $('input[name="hidden"]:checked').val();

      if(!assignments.create.datesFormatOK(startDate, startTime, endDate, endTime)) {
        errors.show("flash","Please verify the dates entered are valid.");
      }
      else if(!assignments.create.dateTimesOK(startDate, startTime, endDate, endTime)) {
        errors.show("flash","The start date cannot occur after the end date.");
      }
      else if(!name){
        errors.show("name","Oh no!  This assignment is nameless. Try giving it a title");
      }
      else if(!desc){
        errors.show("description","Please enter a description for this assignment!");
      }
      else {
        $.post('/assignment/submit_new',
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'description':desc,
          'course_id':course_id,
		  'hidden':hidden,
					'endTime':endTime,
					'startTime':startTime
          }, function() {
            window.location = '/course/show/' + course_id;
          }          
        );
      }
    },
   
    
    datesFormatOK: function(startDate, startTime, endDate, endTime) {
      result = ((startDate.split('-').length == 3) && (endDate.split('-').length == 3));
      result = ((startTime.length == 8) && endTime.length == 8);
      return result;
    },

    dateTimesOK : function(startDate, startTime, endDate, endTime) {
    
      startYear = startDate.split('-')[2];
      startDay = startDate.split('-')[1];
      startMonth = startDate.split('-')[0];

      startTime = startTime.split(':');
      startHour = startTime[0];
      startMinute = startTime[1].split(' ')[0];
      startPM = (startTime[1].split(' ')[1] == 'PM');
      
      if(startPM) {
        startHour = parseInt(startHour) + 12; 
      }

      endYear = endDate.split('-')[2];
      endMonth = endDate.split('-')[0];
      endDay = endDate.split('-')[1];
      
      endTime = endTime.split(':');
      endHour = endTime[0];
      endMinute = endTime[1].split(' ')[0];
      endPM = (endTime[1].split(' ')[1] == 'PM');
      
      if(endPM) {
        endHour = parseInt(endHour) + 12; 
      }
      
      var start = new Date(startYear, startMonth - 1, startDay, startHour, startMinute, 0, 0);
      var end = new Date(endYear, endMonth - 1, endDay, endHour, endMinute, 0, 0);

      return start.getTime() < end.getTime();
    },
  flashError : function(id,message) {
         var path = '#'+id;
         document.getElementById(id).innerHTML="<b>"+message+"</b><br>";
         $(path).delay(500).fadeIn('normal', function() {
        $(path).delay(2500).fadeOut();});
  }
  },

  edit:{
    pageLoad: function(name, startDate, endDate, descr, hidden,startTime,endTime){
      // Initializes date and time pickers
      $('#start-date').datepicker({ 'autoClose':true,'data-date':startDate}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });
      $('#end-date').datepicker({ 'autoClose':true, 'data-date':endDate}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });
	  	
      $('#time-start').timepicker({minuteStep: 1});
      $('#time-end').timepicker({minuteStep: 1});

      // Loads-in assignment data
      $('#start-date-value').val(startDate);
      $('#end-date-value').val(endDate);
      $('#name').val(name);
      $('#description').val(descr);
			$('#time-start').val(startTime);
			$('#time-end').val(endTime);
	  
	    $('input[value="'+hidden+'"]').attr('checked', true)
	    
    },

    submitAssignment: function(assignmentId){
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var name = $('#name').val();
      var desc = $('#description').val();
	  	var hidden = $('input[name="hidden"]:checked').val();
			var startTime = $('#time-start').val();
			var endTime = $('#time-end').val();
      if(!assignments.create.datesFormatOK(startDate,startTime, endDate, endTime)) {
        assignments.create.flashError("flash","Please verify the dates entered are valid.");  
      }
      else if(!assignments.create.dateTimesOK(startDate,startTime, endDate,endTime)) {
        assignments.create.flashError("flash","The start date cannot occur after the end date.");
      }
      else if(!name){
        assignments.create.flashError("flash","Oh no!  This assignment is nameless. Try giving it a title");
      }
      else if(!desc){
        assignments.create.flashError("flash","Gahh! What\'s this assignment about?  Let's add a little description.");
      }
      else {
        $.post('/assignment/submitchanges',
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'description':desc,
          'assignment_id':assignmentId,
		  		'hidden':hidden,
					'startTime':startTime,
					'endTime':endTime
          }, function() {
            window.location = '/assignment/view/' + assignmentId;
          }          
        );
      }
    },
  },
}



  



