// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require twitter/bootstrap
//= require bootstrap-timepicker
//= require jquery.ui.sortable
//= require_tree .

var button_link = function(href, text) {
  return '<a class="btn" href="' + href + '">' + text + '</a></br>'
}

disableElement = function(id){
	document.getElementById(id).disabled = true
	window.setTimeout(function(){document.getElementById(id).disabled = false}, 4000);
}

users = {

  viewUser : function(id) {
    $.post('/admin/view_user_info',
      { 'id' : id },
      function(user) {
        var courses = '';

        if(user.professor_of.length > 0) {
          courses += 'Professor of: </br><h5>'
          
          $.each(user.professor_of, function(index, course) {
            courses += course.name + ' ' + button_link('/course/show/' + course.id, 'View');
          });

          courses += '</h5>';
        }
  
          if(user.student_in.length > 0) { 
            courses += 'Enrolled in: </br><h5>';
            $.each(user.student_in, function(index, course) {
              courses += course.name + ' ' + button_link('/course/show/' + course.id, 'View');
            });
            courses += '</h5>';
          }
          
          if(user.ta_in.length > 0) {
            courses += 'Teaching Assistant in: </br><h5>';
            $.each(user.ta_in, function(index, course) {
              courses += course.name + ' ' + button_link('/course/show/' + course.id, 'View');
            });
            courses += '</h5>'; 
          }
        
        $('#viewUserName').html(user.name);
        $('#viewUserEmail').html(user.email);
        $('#viewUserCourses').html(courses);
        $('#viewUserModal').modal('show');
    });
  },
}


