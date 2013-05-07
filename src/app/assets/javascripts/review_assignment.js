
var assignment_id;
var that = this;

var num_questions = 0;

reviewassignments = {

  create: {  
    pageLoad: function(a_id) {
        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });
        $('#time-start').timepicker({minuteStep: 1});
        $('#time-end').timepicker({minuteStep: 1});
        reviewassignments.create.addQuestion();

        assignment_id = a_id; 
    },

    radioChanged : function(id) {
        type = $('input[name='+ id + '_type' +']:checked').val();
        $input_area = $('#' + id + '_text');
        $choice_area = $('#' + id + '_choices');
        switch(type) {
          case 'multiple_choice':
            $choice_area.show();
            break;
          default:
            $choice_area.hide();
            break;
        }
    },

    addMultipleChoice : function(id) {
          new_question_field = " \
          <div class='"+id+"_choice'> \
            <input type='text' class='"+id+"_choice_text'/> <p class='btn' onclick='$(this).parent().remove();'>Remove Choice</p> \
          </div>";
          $('#' + id + '_new_choice').before(new_question_field);
    },

    textForEditPopover : function(id) {
      return '<input type="text" class="input-small" id="new_question_'+ id +'_title"></input> <p class="btn" onclick="reviewassignments.create.finishEditPopover(\''+ id +'\');">Accept</p>  <p class="btn" onclick="reviewassignments.create.closePopover(\''+ id +'\');">Cancel</p>';
    },

    finishEditPopover : function(id) {
      $('#question_'+id+'_title').text($('#new_question_'+id+'_title').val());
      reviewassignments.create.closePopover(id);
    },

    closePopover : function(id) {
      $('#new_question_'+id+'_title').val('');
      $('#question_'+id+'_title').popover('hide');
    },



		submitPairing: function(){
				$.post('/reviewassignment/pairings',{},function ()
					{	
						window.location = '/assignment/index'
					}
				);
		},
    submitAssignment: function() {
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var startTime = $('#time-start').val();
      var endTime = $('#time-end').val();
      var name = $('#name').val();
			var prev_id = $('#previous_selection').val();
 			var grouped = $('input[name="grouped"]:checked').val();
      var questions = [];
      questionsOK = true;
      $('.question').each( function() {
        id = this.id;
        type = $('#' + id + ' input[name='+ id + '_type' +']:checked').val();
        question = $('#' + id + '_text').val();
        title = $('#' + id + '_title').text();
				var questionArray = new Array();
				questionArray.push(title);
				questionArray.push(type);
				questionArray.push(question);
        choicesOK = true;
        if(type == 'multiple_choice') {
          if($('.' + id + '_choice_text').length == 0) {
            choicesOK = false;
            errors.show(id, 'Please add at least one choice for this question.');
          }
          $('.' + id + '_choice_text').each(function() {
            if($(this).val() == '' && choicesOK) {
              errors.show(id, 'Please ensure all choices are filled out.');
              questionsOK = false;
              choicesOK = false;
            }
            questionArray.push($(this).val());
          });
        }

        if(typeof type==undefined) {
          errors.show(id, 'Please select a question type for this question!');
          questionsOK = false;
        }
        if(question==''){
          errors.show(id, 'Please enter content for this question or delete it!');
          questionsOK = false;
        }
        if(title==''){
          errors.show(id, 'Please enter a valid title for this question!');
          questionsOK = false;
        }		
        questions.push(questionArray);
      });

      if(!reviewassignments.create.datesFormatOK(startDate, endDate)) {
        errors.show("end-date","Please verify the dates entered are valid.");  
      }
      else if(!name){
        errors.show("name","Oh no!  This assignment is nameless. Try giving it a title.");
      }
      else if(questionsOK) {
        $.post('/reviewassignment/create/'+assignment_id,
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'questions':questions,
					'previous_id':prev_id,
					'startTime':startTime,
					'endTime':endTime,
					'grouped':grouped
          }, function() {
            window.location = '/reviewassignment/pairings';
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

  addQuestion : function() {
    num_questions++;
    
    id = 'question_' + num_questions;
    $('#add_questions_here').before("\
      <div id='" + id +"' class='question'>\
        <p>\
        <strong id='" + id + "_title' class='question_title'>Question " + num_questions +"</strong>\
          <d class='btn btn-danger' onclick='$(this).parent().parent().remove();'>Remove Question</d>\
          <p><strong>Type:</strong>\
            <input name='" + id + "_type' checked='checked' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='instruction'/>Instruction\
            <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='short_answer'/>Short Answer\
            <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='numerical_answer'/>Numerical Answer\
            <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='multiple_choice'/>Multiple Choice\
          </p>\
      </p>\
      <p id='" + id + "_content_area'>\
        <textarea class='span2' id='" + id + "_text' name='" + id + "_text' rows='3'/>\
        <div id='" + id + "_choices' style='display:none'>\
          <p><strong>Choices:</strong></p>\
          <div class='" + id + "_choice'>\
            <input type='text' class='" + id + "_choice_text'/> <p class='btn' onclick='$(this).parent().remove();'>Remove Choice</p>\
          </div>\
          <div class='" + id + "_choice'>\
            <input type='text' class='" + id + "_choice_text'/> <p class='btn' onclick='$(this).parent().remove();'>Remove Choice</p>\
          </div>\
          <d id='" + id + "_new_choice'/>\
          <p class='btn' onclick='reviewassignments.create.addMultipleChoice(\"" + id + "\")'>Add Choice</p>\
        </div>\
      <p>\
      </div>");
    $('#' + id + '_title').tooltip({'title':'Click to Edit', 'placement':'right'});
    $('#' + id + '_title').popover({'title':'Enter Question Title', 'content':reviewassignments.create.textForEditPopover(num_questions)});
  }
  },

	view:{
		submit: function(id, other_id){
				var answers = [];
        var answersOK = true;
        $('.question_area').each(function() {
          val = $(this).attr('value');
          answer = '';

          type = $(this).attr('type');
          if(type == '1'){
            answer = $('input[name="'+ val +'_choice"]:checked').val();
           } else if(type=='0') {
             answer = '';
           }
           else {
            answer = $('#' + val).val();
           }
          answers.push(answer);
        });
        if(answersOK) {
				  $.post('/reviewassignment/studentsubmit',
					  {'answers':answers, 'id':id, 'other_id':other_id},function ()
				      {
                  location = '/assignment/index';
				      });
        }
        else {
          errors.show("errors", 'Please answer all questions.');
        }
		}
	},
	edit:{
	  pageLoad:function(id, name, startDate, endDate, startTime, endTime, grouped, questions, choices, started) {
	    // Initializes date and time pickers
      $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });
      $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });
      $('#time-start').timepicker({minuteStep: 1});
      $('#time-end').timepicker({minuteStep: 1});
      // Loads-in assignment data
      $('#start-date-value').val(startDate);
      $('#end-date-value').val(endDate);
      $('#name').val(name);
			$('#time-start').val(startTime);
			$('#time-end').val(endTime);
			assignment_id = id;
		  $('input[value="'+grouped+'"]').attr('checked', true);
		  questions = $.parseJSON(questions);
		  choices = $.parseJSON(choices);
      $.each(questions, function(index, question) {
        reviewassignments.edit.addQuestion(index, question);
        reviewassignments.create.radioChanged(index);
        question_choices = choices[index];
        $.each(question_choices, function(i, choice) {
          reviewassignments.edit.addMultipleChoice(index, choice);
        });
      });
			if(started){
				$('#name').attr("disabled","disabled");
				$('#grouped');
				$('#radio-button').attr('disabled','disabled');
				$("#questions").hide();
				
			};
			},
	  addMultipleChoice: function(id, choice) {
          new_question_field = " \
          <div class='"+id+"_choice'> \
            <input type='text' class='"+id+"_choice_text' value='"+ choice +"'/> <p class='btn' onclick='$(this).parent().remove();'>Remove Choice</p> \
          </div>";
          $('#' + id + '_new_choice').before(new_question_field);
      },
    addQuestion : function(id, question) {
      $('#add_questions_here').before("\
        <div id='" + id +"' class='question'>\
          <p>\
          <strong id='" + id + "_title' class='question_title'>"+ question.question_title +"</strong>\
            <d class='btn btn-danger' onclick='$(this).parent().parent().remove();'>Remove Question</d>\
            <p><strong>Type:</strong>\
              <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='instruction'/>Instruction\
              <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='short_answer'/>Short Answer\
              <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='numerical_answer'/>Numerical Answer\
              <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='multiple_choice'/>Multiple Choice\
            </p>\
        </p>\
        <p id='" + id + "_content_area'>\
          <textarea class='span2' id='" + id + "_text' name='" + id + "_text' rows='3'>"+question.content+"</textarea>\
          <div id='" + id + "_choices' style='display:none'>\
            <p><strong>Choices:</strong></p>\
            <d id='" + id + "_new_choice'/>\
            <p class='btn' onclick='reviewassignments.create.addMultipleChoice(\"" + id + "\")'>Add Choice</p>\
          </div>\
        <p>\
        </div>");
        var $radios = $('input:radio[name='+id+'_type]');
        if(parseInt(question.question_type) == 0) {
          $radios.filter('[value=instruction]').attr('checked',true);
        } else if(parseInt(question.question_type) == 1) {
          $radios.filter('[value=multiple_choice]').attr('checked',true);
        } else if(parseInt(question.question_type) == 2) {
          $radios.filter('[value=numerical_answer]').attr('checked',true);
        } else if(parseInt(question.question_type) == 3) {
          $radios.filter('[value=short_answer]').attr('checked',true);
        }
    },
    
    submitChanges: function() {
      var startDate = $('#start-date-value').val();
      var endDate = $('#end-date-value').val();
      var startTime = $('#time-start').val();
      var endTime = $('#time-end').val();
      var name = $('#name').val();
 			var grouped = $('input[name="grouped"]:checked').val();
      var questions = [];
      questionsOK = true;
      $('.question').each( function() {
        id = this.id;
        type = $('#' + id + ' input[name='+ id + '_type' +']:checked').val();
        question = $('#' + id + '_text').val();
        title = $('#' + id + '_title').text();
				var questionArray = new Array();
				questionArray.push(title);
				questionArray.push(type);
				questionArray.push(question);
        choicesOK = true;
        if(type == 'multiple_choice') {
          if($('.' + id + '_choice_text').length == 0) {
            choicesOK = false;
            errors.show(id, 'Please add at least one choice for this question.');
          }
          $('.' + id + '_choice_text').each(function() {
            if($(this).val() == '' && choicesOK) {
              errors.show(id, 'Please ensure all choices are filled out.');
              questionsOK = false;
              choicesOK = false;
            }
            questionArray.push($(this).val());
          });
        }

        if(typeof type==undefined) {
          errors.show(id, 'Please select a question type for this question!');
          questionsOK = false;
        }
        if(question==''){
          errors.show(id, 'Please enter content for this question or delete it!');
          questionsOK = false;
        }
        if(title==''){
          errors.show(id, 'Please enter a valid title for this question!');
          questionsOK = false;
        }		
        questions.push(questionArray);
      });

      if(!reviewassignments.create.datesFormatOK(startDate, endDate)) {
        errors.show("end-date","Please verify the dates entered are valid.");  
      }
      else if(!name){
        errors.show("name","Oh no! Try giving the assignment a Title.");
      }
      else if(questionsOK) {
        $.post('/reviewassignment/edit/'+assignment_id,
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'id':assignment_id,
          'questions':questions,
					'startTime':startTime,
					'endTime':endTime,
					'grouped':grouped
          }, function() {
            window.location = "/reviewassignment/view/" + assignment_id;
          }   
        ); 
      }
    },
  },
  view_submission : {
    submit : function(review_mapping_id) {
      content = $('#feedback').val();
      alert(content);
      $.post('/reviewassignment/submit_faculty_review/',
      { 'mapping_id' : review_mapping_id,
        'content' : content
         },
        function(review_assignment_id) {
          window.location = '/reviewassignment/view/' + review_assignment_id;
        });
    }
  },
}

