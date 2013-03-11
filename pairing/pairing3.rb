# Pairing Algorithm v 3.0
# Takes in 2 arrays of student IDs, a seed, number of swaps and a Professor ID to be used with odd cases
#
def pair(student_group_1, student_group_2,seed,depth,prof_id = nil)
	
	student_group_1 = student_group_1.shuffle(:random => Random.new(seed)).rotate(depth)
	student_group_2 = student_group_2.shuffle(:random => Random.new(seed-1)).rotate(depth)

	oddman1 = nil
	oddman2 = nil	
	if (student_group_1.length%2)!=0
		oddman1 = student_group_1.last
		student_group_1 = student_group_1[0..student_group_1.length-2]
		puts "IF 1"
	end
	puts student_group_1
	if (student_group_2.length%2)!=0
		oddman2 = student_group_2.last
		student_group_2 = student_group_2[0..student_group_2.length-2]
		puts "IF 2"
		puts student_group_1
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



def zip_and_flatten(array1,array2)
	(array1.zip(array2)).flatten(1)
end

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
