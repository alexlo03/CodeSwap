

var studentsToRemove = [];
var tasToRemove = [];

courses = {
  new: {
    toggleSubmit: function() {
      if(!courses.new.errorsExist()) {
      $('#create_course_confirm').toggle();
      $('#create_course_submit').toggle();
      }
    },

    errorsExist: function() {
      result = false;
      if(! /.csv/i.test($('#students_csv').val())) {
        errors.show('csv_errors','Please ensure the file you have attached is in the format of a .csv');
        result = true;
      }
      fields = ['course_number', 'course_name', 'course_section', 'course_term'];

      $.each(fields, function() {
        if($('#' + this).val() == '') {
          errors.show(this + '_errors', 'Please ensure ' + this.split('_').join(' ') + ' is not blank');
          result = true;
        }
      });
      return result;
    },
  
  },
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

      $('#add_student_button').click(function() {courses.edit.addStudent();});

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
    },

    addStudent: function() {
      first = $('#first_name').val();
      last = $('#last_name').val();
      email = $('#email').val();
      role = $('#role').val();
      id = $('#course_id').text();
      
      $.post('/course/add_student', 
        { 'first':first,
          'last':last,
          'email':email,
          'role':role,
          'course_id':id },
        function(text) {
          if(/error/i.test(text))
            alert(text);
          else
            location.reload();
        });
    }
  },
  groups: {
    pageLoad : function() {
      $('#group1, #group2, #ungrouped').sortable({
      connectWith: ".groupTable",
      items: ">*:not(.sort-disabled)"
    }).disableSelection();
    },
    
    submit: function(id) {
      $group1_rows = $('#group1 tr[class="user-row"]')
      $group2_rows = $('#group2 tr[class="user-row"]')
      $ungrouped_rows = $('#ungrouped tr[class="user-row"]')
      
      group1_ids = []
      group2_ids = []
      ungrouped_ids = []
      
      $.each($group1_rows, function(index, row) {
        group1_ids.push(row.id);
      });
      $.each($group2_rows, function(index, row) {
        group2_ids.push(row.id);
      });
      $.each($ungrouped_rows, function(index, row) {
        ungrouped_ids.push(row.id);
      });
      
      alert('Group1: ' + group1_ids + ' Group2: ' + group2_ids + ' Ungrouped: ' + ungrouped_ids);
      
      $.post('/course/manage_groups/' + id,
      {'group1':group1_ids,
      'group2':group2_ids,
      'ungrouped':ungrouped_ids
      },
      function() {
        location.reload();
      });
      
    }
    
  }
  
}
