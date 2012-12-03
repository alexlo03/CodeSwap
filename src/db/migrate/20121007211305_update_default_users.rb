class UpdateDefaultUsers < ActiveRecord::Migration
  def self.up	
	User.all.each do |f|
		f.first_name = 'Tes'
		f.last_name = 'Ta'
		f.save
	end
  end
end

