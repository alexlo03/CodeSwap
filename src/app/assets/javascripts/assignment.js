
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
	  var hidden = $('input[name="hidden"]:checked').val();
      if(!assignments.create.datesFormatOK(startDate, endDate)) {
        assignments.create.flashError("flash","Please verify the dates entered are valid.");  
      }
      else if(!assignments.create.dateTimesOK(startDate, endDate)) {
        assignments.create.flashError("flash","The start date cannot occur after the end date.");
      }
      else if(!name){
        assignments.create.flashError("flash","Oh no!  This assignment is nameless. Try giving it a title");
      }
      else if(!desc){
        assignments.create.flashError("flash","Gahh! What\'s this assignment about?  Let's add a little description.");
      }
      else {
        $.post('/assignment/submit_new',
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'description':desc,
          'course_id':course_id,
		  'hidden':hidden
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
    pageLoad: function(name, startDate, endDate, descr){
      // Initializes date pickers
      $('#start-date').datepicker({ 'autoClose':true,'data-date':startDate}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });
      $('#end-date').datepicker({ 'autoClose':true, 'data-date':endDate}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });

      // Loads-in assignment data
      $('#start-date-value').val(startDate);
      $('#end-date-value').val(endDate);
      $('#name').val(name);
      $('#description').val(descr);
	  
    },

    submitAssignment: function(assignmentId){
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var name = $('#name').val();
      var desc = $('#description').val();
	  var hidden = $('input[name="hidden"]:checked').val();
	  
      if(!assignments.create.datesFormatOK(startDate, endDate)) {
        assignments.create.flashError("flash","Please verify the dates entered are valid.");  
      }
      else if(!assignments.create.dateTimesOK(startDate, endDate)) {
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
		  'hidden':hidden
          }, function() {
            window.location = '/assignment/view/' + assignmentId;
          }          
        );
      }
    },
  },
}



  



