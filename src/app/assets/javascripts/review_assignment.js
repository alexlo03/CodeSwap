
var assignment_id;
var that = this;

var num_questions = 0;

reviewassignments = {

  create: {  
    pageLoad: function(a_id) {
        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });

//        $('#question_1_title').tooltip({'title':'Click to Edit', 'placement':'right'});
//        $('#question_1_title').popover({'title':'Enter Question Title', 'content':reviewassignments.create.textForEditPopover('1')});

//        $('input[name="question_1_type"]').change(function(){ reviewassignments.create.radioChanged(1); });
 
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

        choices = '';
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
            choices += '@#!$' + $(this).val();
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

        s = '~`~`~';
        questions.push(title+s+type+s+question + choices);
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
            <input name='" + id + "_type' onchange='reviewassignments.create.radioChanged(\""+id+"\");' type='radio' value='instruction'/>Instruction\
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
             answer = ' '; 
           }
           else {
            answer = $('#' + val).val();
           }
          if(typeof answer == 'undefined' || answer == '') {
            answersOK = false;

          } else { 
          answers.push(answer); 
          }
        });
        if(answersOK) {
				  $.post('/reviewassignment/studentsubmit',
					  {'answers':answers, 'id':id, 'other_id':other_id},function ()
				      {
                  window.location = '/assignment/index';
				      });
        }
        else {
          errors.show("errors", 'Please answer all questions.');
        }
		}
	}
}

  
