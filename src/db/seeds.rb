# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # USERS # # # # # # # # # # # #

# Admins [Count: 6]

# 1
User.create(:email => 'notadmin@codeswap.com', :first_name => 'Administrator', :last_name => 'Billy', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@codeswap.com', :first_name => 'Administrator', :last_name => 'Joel', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :first_name => 'Administrator', :last_name => 'Frodo', :password => 'password', :password_confirmation => 'password', :role => :admin)


User.create(:email => 'heman@masteroftheuniverse.com', :first_name => 'Administrator', :last_name => 'He-Man', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'skeletor@lordofdestruction.com', :first_name => 'Administrator', :last_name => 'Skeletor', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'jiminy@thecricket.com', :first_name => 'Administrator', :last_name => 'Cricket', :password => 'password', :password_confirmation => 'password', :role => :admin)


# Faculty [Count: 18]

# 7
User.create(:email => 'leonard.nimoy1@leonardnimoy.com', :first_name => 'Leonard', :last_name => 'Nimoy', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'thanks@thanksbanks.com', :first_name => 'Tom', :last_name => 'Hanks', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'leon.ardo.di@caprio.net', :first_name => 'Leonardo', :last_name => 'DiCaprio', :password => 'password', :password_confirmation => 'password', :role => :faculty)


User.create(:email => 'JLocke@philosophers.co.uk', :first_name => 'John', :last_name => 'Locke', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'lao@tzu2.ch', :first_name => 'Lao', :last_name => 'Tzu', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'friedrich@nietzsche.de', :first_name => 'Friedrich', :last_name => 'Nietzsche', :password => 'password', :password_confirmation => 'password', :role => :faculty)


User.create(:email => 'thomas@hobbes.co.uk', :first_name => 'Thomas', :last_name => 'Hobbes', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'einsteinsemail@einstein.biz', :first_name => 'Albert', :last_name => 'Einstein', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'edison@foundingfathers.com', :first_name => 'Thomas', :last_name => 'Edison', :password => 'password', :password_confirmation => 'password', :role => :faculty)


User.create(:email => 'nk@tesla.cr', :first_name => 'Nikolai', :last_name => 'Tesla', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'galileo@galileo.gr', :first_name => 'Galileo', :last_name => 'Galilei', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'leonard@euler.com', :first_name => 'Leonard', :last_name => 'Euler', :password => 'password', :password_confirmation => 'password', :role => :faculty)


User.create(:email => 'therealdeal@foundingfathers.com', :first_name => 'Benjamin', :last_name => 'Franklin', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'gwbush@whitehouse.com', :first_name => 'George', :last_name => 'Bush', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'obama@whitehouse.gov', :first_name => 'Barack', :last_name => 'Obama', :password => 'password', :password_confirmation => 'password', :role => :faculty)


User.create(:email => 'fig@newtons.com', :first_name => 'Isaac', :last_name => 'Newton', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'eatmychicken@generaltso.ch', :first_name => 'General', :last_name => 'Tso', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'knight@ni.co.uk', :first_name => 'Monty', :last_name => 'Python', :password => 'password', :password_confirmation => 'password', :role => :faculty)


# Students [Count: 8]

# 25
User.create(:email => 'thequeen@uk.co.uk', :first_name => 'Queen', :last_name => 'Elizabeth', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'prisoner@southafrica.za', :first_name => 'Nelson', :last_name => 'Mandela', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'jackson@neverland.com', :first_name => 'Michael', :last_name => 'Jackson', :password => 'password', :password_confirmation => 'password', :role => :student)


User.create(:email => 'poppinlock@poppins.co.uk', :first_name => 'Mary', :last_name => 'Poppins', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'martha@fedpenfoods.com', :first_name => 'Martha', :last_name => 'Stewart', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'fat@albert.com', :first_name => 'Fat', :last_name => 'Albert', :password => 'password', :password_confirmation => 'password', :role => :student)


User.create(:email => 'america@america.com', :first_name => 'Hulk', :last_name => 'Hogan', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'parker@thedailybugle.com', :first_name => 'Peter', :last_name => 'Parker', :password => 'password', :password_confirmation => 'password', :role => :student)


# TAs [Count: 6]

# 33
User.create(:email => 'mahatma@gandhi.in', :first_name => 'Mahatma', :last_name => 'Gandhi', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'theemperor@japan.jp', :first_name => 'Emperor', :last_name => 'Akihito', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'stark@starkindustries.com', :first_name => 'Tony', :last_name => 'Stark', :password => 'password', :password_confirmation => 'password', :role => :student)

User.create(:email => 'ckent@thedailyplanet.com', :first_name => 'Clark', :last_name => 'Kent', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'bruce@wayneindustries.com', :first_name => 'Bruce', :last_name => 'Wayne', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => '300@spartans.gr', :first_name => 'The 300', :last_name => 'Spartans', :password => 'password', :password_confirmation => 'password', :role => :student)

# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # COURSES # # # # # # # # # # #

Course.create(:name => 'The art of Snorkeling', :course_number => 'Snork-104', :section => '1', :term => 'Winter')
Course.create(:name => 'The art of Snorkeling', :course_number => 'Snork-104', :section => '2', :term => 'Winter') 

Course.create(:name => 'Introduction to Software Development', :course_number => 'CSSE-120', :section => '1', :term => 'Winter')
Course.create(:name => 'Senior Project I', :course_number => 'CSSE-497', :section => '1', :term => 'Fall')

Course.create(:name => 'Senior Project II', :course_number => 'CSSE-498', :section => '1', :term => 'Winter')
Course.create(:name => 'How to tie a tie', :course_number => 'Tie-532', :section => '1', :term => 'Life')
Course.create(:name => 'Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Summer')

Course.create(:name => 'Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Fall')
Course.create(:name => 'Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Winter')
Course.create(:name => 'Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Spring')

Course.create(:name => 'The smell of Snorkeling', :course_number => 'Snork-204', :section => '1', :term => 'Winter')
Course.create(:name => 'How to breathe underwater', :course_number => 'Snork-704', :section => '1', :term => 'Winter')

# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # ENROLLEES # # # # # # # # # #

Studentgroup.create(:course_id => '7', :user_id => '25')
Studentgroup.create(:course_id => '7', :user_id => '26')
Studentgroup.create(:course_id => '7', :user_id => '27')

Studentgroup.create(:course_id => '7', :user_id => '28')
Studentgroup.create(:course_id => '7', :user_id => '29')
Studentgroup.create(:course_id => '7', :user_id => '30')

Studentgroup.create(:course_id => '7', :user_id => '31')
Studentgroup.create(:course_id => '7', :user_id => '33')

Tagroup.create(:course_id => '7', :user_id => '33')
Tagroup.create(:course_id => '7', :user_id => '34')
Tagroup.create(:course_id => '7', :user_id => '35')

Tagroup.create(:course_id => '7', :user_id => '36')
Tagroup.create(:course_id => '7', :user_id => '37')
Tagroup.create(:course_id => '7', :user_id => '38')

Studentgroup.create(:course_id => '2', :user_id => '25')
Studentgroup.create(:course_id => '2', :user_id => '26')
Studentgroup.create(:course_id => '2', :user_id => '27')

Studentgroup.create(:course_id => '3', :user_id => '28')
Studentgroup.create(:course_id => '3', :user_id => '29')
Studentgroup.create(:course_id => '3', :user_id => '30')

Studentgroup.create(:course_id => '3', :user_id => '31')
Studentgroup.create(:course_id => '3', :user_id => '32')

Studentgroup.create(:course_id => '4', :user_id => '25')
Studentgroup.create(:course_id => '5', :user_id => '26')

Tagroup.create(:course_id => '6', :user_id => '25')
Tagroup.create(:course_id => '6', :user_id => '34')
Tagroup.create(:course_id => '6', :user_id => '35')

Tagroup.create(:course_id => '6', :user_id => '36')
Tagroup.create(:course_id => '6', :user_id => '37')
Tagroup.create(:course_id => '6', :user_id => '38')

