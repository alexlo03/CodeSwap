

var studentsToRemove = [];
var tasToRemove = [];

courses = {
  
  edit : {

    submit: function() {

      course_section = $('#course_section').text();
      course_term = $('#course_term').text();
      course_number = $('#course_number').text();    
      course_name = $('#course_name').text();
      course_id = $('#course_id').text();


      $.post('/course/submit_edit/',
        {'section':course_section,
        'term':course_term,
        'number':course_number,
        'course_id':course_id,
        'name':course_name,
        'students_to_remove':studentsToRemove,
        'tas_to_remove':tasToRemove
        },
        function() {
          window.location = '/course/show/' + course_id;
        });
    },

    pageLoad : function() {

      $('#course_name').tooltip({'title':'Click to Edit', 'placement':'right'});
      $('#course_term').tooltip({'title':'Click to Edit', 'placement':'right'});
      $('#course_number').tooltip({'title':'Click to Edit', 'placement':'right'});
      $('#course_section').tooltip({'title':'Click to Edit', 'placement':'right'});

      $('#course_name').popover({'title':'Enter New Course Title', 'content':courses.edit.textForEditPopover('name')});
      $('#course_term').popover({'title':'Enter New Course Term', 'content':courses.edit.textForEditPopover('term')});
      $('#course_number').popover({'title':'Enter New Course Number', 'content':courses.edit.textForEditPopover('number')});
      $('#course_section').popover({'title':'Enter New Course Section', 'content':courses.edit.textForEditPopover('section')});

    },

    textForEditPopover : function(id) {
      return '<input type="text" class="input-small" id="new_course_'+ id +'"></input> <p class="btn" onclick="courses.edit.finishEdit(\''+ id +'\');">Accept</p>  <p class="btn" onclick="courses.edit.closePopover(\''+ id +'\');">Cancel</p>';
    },

    finishEdit : function(id) {
      $('#course_'+id).text($('#new_course_'+id).val());
      courses.edit.closePopover(id);
    },

    closePopover : function(id) {
      $('#new_course_'+id).val('');
      $('#course_'+id).popover('hide');
    },

    toggleStudentsDisplay: function() {
      
    },

    toggleTa: function(id) {
      if($.inArray(id, tasToRemove) > -1) {
        $('#'+id+'_enrolled').text('Enrolled');

        tasToRemove = $.grep(tasToRemove, function(sid) {
          return sid != id;
        });

        $('#'+id+'_add').toggle();
        $('#'+id+'_remove').toggle();
      }
      else {
        $('#'+id+'_enrolled').text('NOT Enrolled');
        tasToRemove.push(id);
        
        $('#'+id+'_add').toggle();
        $('#'+id+'_remove').toggle();
      }
    },

    toggleStudent: function(id) {
      if($.inArray(id, studentsToRemove) > -1) {
        $('#'+id+'_enrolled').text('Enrolled');

        studentsToRemove = $.grep(studentsToRemove, function(sid) {
          return sid != id;
        });

        $('#'+id+'_add').toggle();
        $('#'+id+'_remove').toggle();
      }
      else {
        $('#'+id+'_enrolled').text('NOT Enrolled');
        studentsToRemove.push(id);
        
        $('#'+id+'_add').toggle();
        $('#'+id+'_remove').toggle();
      }
    }
  }
}