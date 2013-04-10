class CreateQuestionExtra < ActiveRecord::Migration
	class QuestionExtra	< ActiveRecord::Base
   attr_accessible :review_question_id,:extra
	end

  def up
		create_table :question_extras do |t|
			t.timestamps
			t.integer(:review_question_id)
			t.string(:extra)
		end

		split_string = '@#!$'

		ReviewQuestion.find_all_by_question_type(1).each do |review_question|
			contents = review_question.content.split(split_string)
			review_question.content = contents.first
			review_question.save
			contents.last(contents.size-1).each do |extra|
				QuestionExtra.create(:review_question_id => review_question.id,:extra => extra)
			end
		end
  end

  def down
		split_string = '@#!$'
		ReviewQuestion.find_all_by_question_type(1).each do |review_question|
			new_contents = review_question.content
			review_question.question_extras.collect(&:extra).each do |extra|
				new_contents += split_string+extra
			end
			review_question.content = new_contents
			review_question.save
		end
		drop_table :question_extras
  end
end
