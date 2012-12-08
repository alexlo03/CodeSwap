


admin = {

  clearTable : function(table) { $('#' + table + '_table').empty(); },

  deleteUser : function(email){
      $.post('/admin/delete_user',
        { 'email' : email },
        function(user){
          var row = $("#user-"+user.id);
          row.toggle('fast', function(){ row.remove()});
        });
  },

  updateTableWithUser : function(table, user) {
    var table = $('#' + table + '_table');
    table.append(
      '<tr id="user-'+user.id + '" style="display:none">' 
    + '<td>'+user.id+'</td>'
    + '<td>'+user.email+'</td>'
    + '<td>'+user.first_name + ' ' + user.last_name+'</td>'
    + '<td></td>'
    + '<td>'
    + '<p class=\'btn\'>View</p>' + ' '
    + '<p class=\'btn btn-danger\' id="user-'+ user.id +'-remove" onclick="deleteUser(\''+ user.email +'\');">Delete</p>'
    + '</td>'
    + '</tr>');
    $('#user-'+user.id).show('fast');
  },

  addErrorToGroup : function(message, group) {
    $("#add_" + group).append($("<div id='alert' class='alert alert-error fade in' data-alert>"+
             "<button type='button' class='close' data-dismiss='alert'>×</button><strong> " + message + " </strong></div>"));
            $('#alert').delay(1500).fadeOut('slow', function(){ $('#alert').remove() });
  },

  searchAdmin : function() {
    var email = $('#search_email').attr('value');
    var first_name = $('#search_first_name').attr('value');
    var last_name = $('#search_last_name').attr('value');
      
    $.post('/admin/search_users',
      { 'email' : email,
        'first_name' : first_name,
        'last_name' : last_name,
        'role' : 'admin'
      },
      function(result){
        admin.clearTable('admin');
        $.each(result, function(index, ele){ admin.updateTableWithUser('admin', ele); });
      });
  },

  addAdmin : function(){

    var email = $('#admin_email').attr('value');
    var name = $('#admin_name').attr('value');
    var role = 'admin';
    if(name.split(' ').length < 2) {
      admin.addErrorToGroup('Please enter a valid [First Last] name.', 'admin');
    }
    else {
    $.post('/admin/add_user',
      { 'email': email,
        'name' : name,
        'role' : role
      },
      function(user){
        if ( user.errormessage ) {
          admin.addErrorToGroup(user.errormessage, 'admin');
        }
        else {
          admin.updateTableWithUser('admin', user);
        }
          $('#admin_email').attr('value','');
          $('#admin_name').attr('value','');
        });
    }
  },

  addFaculty : function(){
    var email = $('#faculty_email').attr('value');
    var name = $('#faculty_name').attr('value');
    var role = 'faculty';
    if(name.split(' ').length < 2) {
      addError('Please enter a valid [First Last] name.');
    }
    else {
    $.post('/admin/add_user',
      { 'email': email,
        'name' : name,
        'role' : role
      },
      function(user){
        if ( user.errormessage ) {
          admin.addErrorToGroup(user.errormessage, 'faculty');
        }
        else {
          admin.updateTableWithUser('faculty', user);
        }
          $('#faculty_email').attr('value','');
          $('#faculty_name').attr('value','');
        });
    }
  },

  searchFaculty : function() {
    var email = $('#search_email').attr('value');
    var first_name = $('#search_first_name').attr('value');
    var last_name = $('#search_last_name').attr('value');
      
    $.post('/admin/search_users',
      { 'email' : email,
        'first_name' : first_name,
        'last_name' : last_name,
        'role' : 'faculty'
      },
      function(result){
        admin.clearTable('faculty');
        $.each(result, function(index, ele){ admin.updateTableWithUser('faculty', ele); });
      });
  },

  searchStudents : function() {
    var email = $('#search_email').attr('value');
    var first_name = $('#search_first_name').attr('value');
    var last_name = $('#search_last_name').attr('value');
    var role = 'student';
    $.post('/admin/search_users',
      { 'email' : email,
        'first_name' : first_name,
        'last_name' : last_name,
        'role' : role
      },
      function(result){
        admin.clearTable(role);
        $.each(result, function(index, ele){ admin.updateTableWithUser(role, ele); });
      });
  },


  admins : {

    /* ************************** */

    pageLoad : function() {

      $(document).ready(function(){ 
        $('#add_admin').toggle();

        $('#view_more_admin_row').click(function(){
          window.location.href = "/view_admin";
        });

        $('#add_admin_button').click(function(){
          $('#add_admin').toggle('fast');
        });

        $('#submit_admin').click(function(){
          admin.addAdmin();
        });

        $('#search_email').keyup(function() { admin.searchAdmin(); });
        $('#search_first_name').keyup(function () { admin.searchAdmin(); });
        $('#search_last_name').keyup(function () { admin.searchAdmin(); });
      });
    }

  // End of Admin User Functions
  },

  faculty : {

    pageLoad : function() { 
      $('#add_faculty').toggle();
      $('#add_faculty_button').click(function(){
          $('#add_faculty').toggle('fast');
      });

      $('#view_more_faculty_row').click(function(){
        window.location.href = '/view_faculty';
      });

      $('#search_email').keyup(function() { admin.searchFaculty(); });
      $('#search_first_name').keyup(function () { admin.searchFaculty(); });
      $('#search_last_name').keyup(function () { admin.searchFaculty(); });

      $('#submit_faculty').click(function(){admin.addFaculty()});
      $('#faculty_email').keypress(function(event){
        if(event.which == 13) {
          admin.addFaculty();
          return false;
        }
      });
    }

  // End of Faculty User Functions
  },

  students : {

    pageLoad : function() {
      $('#view_more_students_row').click(function(){
        window.location.href = "/view_students";
      });

      $('#search_email').keyup(function() { admin.searchStudents(); });
      $('#search_first_name').keyup(function () { admin.searchStudents(); });
      $('#search_last_name').keyup(function () { admin.searchStudents(); });
    }

  // End of Student functions
  }
  // End of Admin
}



