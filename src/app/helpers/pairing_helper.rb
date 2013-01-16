module PairingHelper

	# Method takes an array and creates a mapping of pairings	
	# list is an array
	# num_of_previous_pairings is the number of times the 
	# same seed has been used to randomize a list
	# seed is a random int
	#
	# Returns a hash of pairings
	#
	#	Example:
	# 
	# create_pairings([1,2,3],0,123) 
	# => {2=>1, 1=>3, 3=>2} 
	def create_pairings(list, shift_amount, seed)
			randomized_list = list.shuffle(random:Random.new(seed))
			double_randomized_list = randomized_list * 2
			pairings = Hash.new
			size = randomized_list.length-1
			for i in 0..size
				pairings[randomized_list[i]] = double_randomized_list[i+1+shift_amount]
			end
			pairings
	end
	
	def pair_assignment(assignment_definition_id, previous_assignment_id)	
		assignment_pairing = AssignmentPairing.new(:assignment_definition_id => assignment_definition_id)
		if previous_assignment_id.nil?
			assignment_pairing.seed = rand(200000000)
			assignment_pairing.depth = 0
		else
			old_pairing = AssignmentPairing.find_by_assignment_definition_id(previous_assignment_id)
			assignment_pairing.seed = old_pairing.seed
			assignment_pairing.depth = old_pairing.depth + 1
			assignment_pairing.previous_id = old_pairing.id
		end
		course = AssignmentDefinition.find(assignment_definition_id).assignment.course
		list = Studentgroup.find_all_by_course_id(course.id).collect(&:user_id)
		if assignment_pairing.depth == list.length - 1
			assignment_pairing.seed = rand(200000000)
			assignment_pairing.depth = 0 
		end
		assignment_pairing.save
		create_pairings(list, assignment_pairing.depth,assignment_pairing.seed)
	end

end
