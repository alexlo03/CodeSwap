module PairingHelper

	## Creates a mapping of pairings from array
	# [PARMS]
  ## * list - an array [1, 2, 3]
	## * num_of_previous_pairings - number of times the same seed has been used to randomize a list
	## * seed is a random int
	# [RETURN]
	## *  Hash of pairings
	#	[EXAMPLE]
	## * create_pairings([1,2,3],0,123) => {[2]=>[1], [1]=>[3], [3]=>[2]}
	def create_pairings(list, shift_amount, seed)
			randomized_list = list.shuffle(random:Random.new(seed))
			double_randomized_list = randomized_list * 2
			pairings = Hash.new
			size = randomized_list.length-1
			for i in 0..size
				pairings[randomized_list[i]] = double_randomized_list[i+1+shift_amount]
			end
			new_pairings = Hash.new
			pairings.each do |k,v|
				new_pairings[[k]] = [v]
			end
			new_pairings
	end

	# Method takes an assignment definition ID and previous assignment ID both inputs are integers corresponding to a matching database entity
	# [PARAMS]
	## * assignment_id - id of the assignment
	## * previous_assignment_id - ID of the linked assignment
	# [RETURN]
	## * list of: an assignment pairing entity, and a list of student IDs
  # list contains the students in the course containing the assignment
  # the assignment pairing is assigned values of seed, depth, and previous ID.
  def get_latest_assignment_pairing(assignment_id, previous_assignment_id)
    assignment_pairing = AssignmentPairing.new(:assignment_id => assignment_id)
    assignment_pairing.number_of_graders = 2

    old_pairing = AssignmentPairing.find_by_assignment_id(previous_assignment_id)

    assignment_pairing.seed = get_seed(old_pairing.id)
    assignment_pairing.depth = get_depth(old_pairing.id)
    assignment_pairing.previous_id = old_pairing.id

		course = Assignment.find(assignment_id).course
		list = StudentInCourse.find_all_by_course_id(course.id).collect(&:user_id)

		if assignment_pairing.depth == list.length - 1
			assignment_pairing.seed = rand(200000000)
			assignment_pairing.depth = 0 
		end

    [assignment_pairing, list]
  end

  # Gets the seed from the previous review assignment, random if no previous assignment given
	# [PARAMS]
	## * id - AssignmentPairing id
	# [RETURN]
	## * random int from 1 to 200000000 if id is nil or does not map to an assignment_pairing
	## * the seed for the assignment pairing otherwise
  def get_seed(id)
    if id.nil?
      return rand(200000000)
    end
    old_pairing = AssignmentPairing.find(id)
    if old_pairing.nil? 
      return rand(200000000)
    end
    old_pairing.seed
  end


  # Increments the depth of the assignment_pairing with id \"id\""
	# [PARAMS]
	## * id - AssignmentPairing id
	# [RETURN]
	## * 0 if id is nil or does not map to an assignment_pairing
	## * the depth for the assignment pairing +1
  def get_depth(id)
    if id.nil?
      return 0
    end
    
    old_pairing = AssignmentPairing.find_by_assignment_id(id)
    if old_pairing.nil? 
      return 0
    end

    old_pairing.depth + 1
  end

	## Creates a mapping of pairings from array, uses two arrays (groups of students)
	# [PARMS]
	## * student_group_1 - array of user_ids
	## * student_group_2 - array of user_ids
  ## * list - an array [1, 2, 3]
	## * seed - int used to 'randomized' the arrays
	## * depth - number of times a seed has been used
	## * prof_id - user id to use with odd student groups
	# [RETURN]
	## * Hash of pairings
	# [NOTE]
	## * Returns a 1 to 2 mapping, not 1 to 1
	## * Returns a mapping of professor to student if one of the lists is odd in size 
	def pair(student_group_1, student_group_2,seed,depth,prof_id = nil)
		student_group_1 = student_group_1.shuffle(:random => Random.new(seed)).rotate(depth)
		student_group_2 = student_group_2.shuffle(:random => Random.new(seed-1)).rotate(depth)

		oddman1 = nil
		oddman2 = nil	
		if (student_group_1.length%2)!=0
			oddman1 = student_group_1.last
			student_group_1 = student_group_1[0..student_group_1.length-2]
		end
		if (student_group_2.length%2)!=0
			oddman2 = student_group_2.last
			student_group_2 = student_group_2[0..student_group_2.length-2]
		end

		student_group_1 = group(student_group_1)
		student_group_2 = group(student_group_2)

		zipped_list = zip_and_flatten(student_group_1,student_group_2)
		double = zipped_list *2	
		pairings = Hash.new
		size = zipped_list.length-1
		for i in 0..size
			pairings[zipped_list[i]] = double[i+1+depth].clone
		end
	
		prof_grades = []

		unless oddman1.nil?
			pairings.keys[0].push(oddman1)
			prof_grades.push(oddman1)
		end
		unless oddman2.nil?
			pairings.keys[1].push(oddman2)
			prof_grades.push(oddman2)
		end
		unless prof_grades.empty?
			pairings[[prof_id]] = prof_grades
		end
		pairings
	end


	# Zips two arrays, then flattens the result
	# [PARMS]
	## * array1 - an array
	## * array2 - an array
	# [RETURN]
	## * array1 and array2 zipped and flattened by one
	def zip_and_flatten(array1,array2)	
		(array1.zip(array2)).flatten(1).reject{|x| x.nil?}
	end

	# Groups elements of an array into tuples
	# [PARMS]
	## * array - an array
	# [RETURN]
	## * The array with elements grouped together
	# [NOTE]
	## * Odd sized arrays will look like [1,2,3,4,5,6,7] => [(1,4),(2,5),(3,6,7)]
	def group(array)
		if (array.length%2) == 0 
			array2=array[0..(array.length-1)/2]
			array=array[(array.length)/2..array.length]
			return array.zip(array2)
		else
			odd_man = array[-1]
			array = array[0..array.length-2]
			grouped = group(array)
			grouped[-1] = grouped[-1].push(odd_man)
			grouped
		end
end


end
