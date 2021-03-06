require 'test_helper'

class PairingHelperTest < ActionView::TestCase
	basic_students = [1,2,3,4,5,6,7,8]
	basic_seed = rand(1000000)
	basic_depth = rand(basic_students.length)
  two_graders = 2
  one_grader = 1

	test "create_pairings returns a hash" do
    assert create_pairings(basic_students,basic_depth,basic_seed).is_a?(Hash)
  end	


	test "create_pairings has all of the students as keys" do		
    hash = create_pairings(basic_students,basic_depth,basic_seed)

		basic_students.each do |student_num|
			assert hash.has_key?(student_num)
		end
  end	

	test "create_pairings has all of the students as values" do		
    hash = create_pairings(basic_students,basic_depth,basic_seed)

		basic_students.each do |student_num|
			assert hash.has_value?(student_num)
		end
  end	

	
	test "create_pairings creates hashes that do not map a student to themselves" do		
		for i in 0..(basic_students.length-2)
	    hash = create_pairings(basic_students,i,rand(100000))
			hash.each do |key,value|
				assert key!=value, "hash = #{hash.to_s} \ndepth = #{i.to_s} \nmax = #{basic_students.length-1} \nkey = #{key} \nvalue = #{value}"
			end
		end
  end

	test "create_pairings same seed creates same hash" do		
    hash_0 = create_pairings(basic_students,0,basic_seed)
    hash_1 = create_pairings(basic_students,0,basic_seed)
		assert hash_0 = hash_1
		
  end	

	test "create_pairings moves through list correctly" do		
    hash_depth_0 = create_pairings(basic_students,0,basic_seed)
    hash_depth_1 = create_pairings(basic_students,1,basic_seed)
    hash_depth_2 = create_pairings(basic_students,2,basic_seed)
		assert hash_depth_0.keys == hash_depth_1.keys
		assert hash_depth_1.keys == hash_depth_2.keys

		new_list = hash_depth_0.keys
		assert hash_depth_0[new_list[0]] == new_list[1]
		assert hash_depth_1[new_list[0]] == new_list[2]
		assert hash_depth_2[new_list[0]] == new_list[3]
  end

  test "create_pairings_mk_2 returns a hash for each type of input" do
    assert create_pairings_mk_2(basic_students,basic_depth,basic_seed,one_grader).is_a?(Hash)
    assert create_pairings_mk_2(basic_students,basic_depth,basic_seed,two_graders).is_a?(Hash)
  end

  test "create_pairings_mk_2 has all of the students as keys" do		
    hash = create_pairings_mk_2(basic_students,basic_depth,basic_seed,one_grader)

		basic_students.each do |student_num|
			assert hash.has_key?(student_num)
		end
  end

	test "create_pairings_mk_2 has all of the students as values" do		
    hash = create_pairings_mk_2(basic_students,basic_depth,basic_seed,one_grader)
    hash_values = hash.values.flatten
    
		basic_students.each do |student_num|
			assert hash_values.include?(student_num)
		end
  end

	test "create_pairings_mk_2 creates hashes that do not map a student to themselves" do		
		for i in 0..(basic_students.length-3)
	    hash = create_pairings_mk_2(basic_students,i,rand(100000),one_grader)
			hash.each do |key,value|
				assert !value.include?(key), "hash = #{hash.to_s} \ndepth = #{i.to_s} \nmax = #{basic_students.length-1} \nkey = #{key} \nvalue = #{value}"
			end
		end
  end

	test "create_pairings_mk_2 same seed creates same hash" do		
    hash_0 = create_pairings_mk_2(basic_students,0,basic_seed,one_grader)
    hash_1 = create_pairings_mk_2(basic_students,0,basic_seed,one_grader)
		assert hash_0 = hash_1
  end	

	test "create_pairings_mk_2 moves through list correctly" do		
    hash_depth_0 = create_pairings_mk_2(basic_students,0,basic_seed,one_grader)
    hash_depth_1 = create_pairings_mk_2(basic_students,1,basic_seed,one_grader)
    hash_depth_2 = create_pairings_mk_2(basic_students,2,basic_seed,one_grader)
		assert hash_depth_0.keys == hash_depth_1.keys
		assert hash_depth_1.keys == hash_depth_2.keys

		new_list = hash_depth_0.keys
		assert hash_depth_0[new_list[0]] == new_list[1]
		assert hash_depth_1[new_list[0]] == new_list[2]
		assert hash_depth_2[new_list[0]] == new_list[3]
  end



end
