
var assignment_id;
var that = this;

var num_questions = 1;

reviewassignments = {

  create: {  
    pageLoad: function(a_id) {
        $('#start-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#start-date').datepicker('hide'); });

        $('#end-date').datepicker({ 'autoClose':true}).on('changeDate', function(ev) { $('#end-date').datepicker('hide'); });

        assignment_id = a_id; 
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
      var name = $('#name').val();
			var prev_id = $('#previous_selection').val();

      var questions = [];
      questionsOK = true;
      $('.question').each( function() {
        id = this.id;
        type = $('#' + id + ' input[name='+ id + '_type' +']:checked').val();
        question = $('#' + id + '_text').val();

        if(type==undefined) {
          errors.show(id, 'Please select a question type for this question!');
          questionsOK = false;
        }
        if(question==''){
          errors.show(id, 'Please enter content for this question or delete it!');
          questionsOK = false;
        }
        questions.push(type+'%$%'+question);
      });

      alert(questions);

      if(!reviewassignments.create.datesFormatOK(startDate, endDate)) {
        errors.show("end-date","Please verify the dates entered are valid.");  
      }
      else if(!name){
<<<<<<< HEAD
        errors.show("name","Oh no!  This assignment is nameless. Try giving it a title.");
      }
      else if(questionsOK) {
=======
        reviewassignments.create.flashError("flash","Oh no!  This assignment is nameless. Try giving it a title");
      }
      else {
>>>>>>> 947b469beff290dd6ce990399cfc4da1c6ec18d5
        $.post('/reviewassignment/create/'+assignment_id,
          {'startDate':startDate,
          'endDate':endDate,
          'name':name,
          'questions':questions,
					'previous_id':prev_id
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
    
    $('#add_questions_here').before(" \
      <div id='question_" + num_questions +"' class='question'>           \
        <p>                           \
        <strong>Question " + num_questions +"</strong>   \
          <input name='question_" + num_questions + "_type' type='radio' value='instruction'/>Instruction      \
          <input name='question_" + num_questions + "_type' type='radio' value='short_answer'/>Short Answer    \
          <input name='question_" + num_questions + "_type' type='radio' value='numerical_answer'/>Numerical Answer            \
      </p>                            \
          <textarea class='span2' id='question_" + num_questions + "_text' name='question_" + num_questions + "_text' rows='3'/>  \
    </div>");
  },

  deleteQuestion: function(id) {
    
  },
  }
}

  
