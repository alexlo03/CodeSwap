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
	
  # Probably will be killed...
	def pair_assignment(assignment_definition_id, previous_assignment_id)	
		assignment_pairing, list = get_latest_assignment_pairing(assignment_definition_id, previous_assignment_id)
		assignment_pairing.save
		create_pairings(list, assignment_pairing.depth,assignment_pairing.seed)
	end


  def create_pairings_mk_2(list, shift_amount, seed, graders)
    shuffled_list = list.shuffle(random:Random.new(seed))
    size = shuffled_list.length - 1
    doubled_shuffled_list = shuffled_list * 2
    pairings = Hash.new

    graders = 2

    for i in (0..size).step(graders)
      shift = i+graders+shift_amount
      list = []
      for j in 0..graders - 1
        list = list + [doubled_shuffled_list[shift + j]]
      end
      for j in i..i + graders - 1
        pairings[shuffled_list[j]] = list
      end
    end

    if (size + 1).odd?
      unpaired_student = pairings[shuffled_list[i+graders+shift_amount]].first
      pairings[shuffled_list[shift_amount]] += [unpaired_student]
    end

    pairings.delete(nil)
    pairings
  end

	# Method takes an assignment definition ID and previous assignment ID
	# both inputs are integers corresponding to a matching database entity
	#
	# Returns two things: an assignment pairing entity, and a list
	#
  # list contains the students in the course containing the assignment
  # the assignment pairing is assigned values of seed, depth, and previous ID.
  # 
	#	Example:
	# 
	# pairing, list = get_latest_assignment_pairing(1, nil)
	# => [#<AssignmentPairing assignment_definition_id: 1, seed: 32554653, previous_id: nil, depth: 0, number_of_graders: nil>, [25, 26, 27]] 

  def get_latest_assignment_pairing(assignment_id, previous_assignment_id)
    assignment_pairing = AssignmentPairing.new(:assignment_id => assignment_id)
    assignment_pairing.number_of_graders = 2

    old_pairing = AssignmentPairing.find_by_assignment_id(previous_assignment_id)

    assignment_pairing.seed = get_seed(old_pairing.id)
    assignment_pairing.depth = get_depth(old_pairing.id)
    assignment_pairing.previous_id = old_pairing.id

		course = Assignment.find(assignment_id).course
		list = Studentgroup.find_all_by_course_id(course.id).collect(&:user_id)

		if assignment_pairing.depth == list.length - 1
			assignment_pairing.seed = rand(200000000)
			assignment_pairing.depth = 0 
		end

    [assignment_pairing, list]
  end


  # Method takes an array of EVEN LENGTH and creates a mapping of pairings
	# list is an array of even length
	# num_of_previous_pairings is the number of times the 
	# same seed has been used to randomize a list
	# seed is a random int
	#
	# Returns a hash of pairings
	#
	#	Example:
	# 
	# create_pairings_mk_2([1,2,3,4],0,123) 
	# => {1=>[3, 4], 2=>[3, 4], 3=>[1, 2], 4=>[1, 2]}
  def pair_assignment_mk_2(assignment_definition_id, previous_assignment_id)
    assignment_pairing, list = get_latest_assignment_pairing(assignment_definition_id, previous_assignment_id)		
    assignment_pairing.save
    create_pairings_mk_2(list, assignment_pairing.depth, assignment_pairing.seed, assignment_pairing.number_of_graders)
  end

  # Gets the seed from the previous assignment, random if no previous assignment given
  def get_seed(previous_assignment_id)
    if previous_assignment_id.nil?
      return rand(200000000)
    end
    
    old_pairing = AssignmentPairing.find_by_assignment_id (previous_assignment_id)
    if old_pairing.nil? 
      return rand(200000000)
    end

    old_pairing.seed
  end


  # Gets the depth from the previous assignment, 0 if no previous assignment given
  def get_depth(previous_assignment_id)
    if previous_assignment_id.nil?
      return 0
    end
    
    old_pairing = AssignmentPairing.find_by_assignment_id (previous_assignment_id)
    if old_pairing.nil? 
      return 0
    end

    old_pairing.depth + 1
  end


end
