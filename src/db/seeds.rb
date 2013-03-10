# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # USERS # # # # # # # # # # # #

# Admins 

User.create(:email => 'notadmin@codeswap.com', :first_name => 'Sneaky', :last_name => 'Admin', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@codeswap.com', :first_name => 'Administrator', :last_name => 'Joel', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :first_name => 'Administrator', :last_name => 'Bilbo', :password => 'password', :password_confirmation => 'password', :role => :admin)


User.create(:email => 'heman@masteroftheuniverse.com', :first_name => 'Administrator', :last_name => 'He-Man', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'skeletor@lordofdestruction.com', :first_name => 'Administrator', :last_name => 'Skeletor', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'jiminy@thecricket.com', :first_name => 'Administrator', :last_name => 'Cricket', :password => 'password', :password_confirmation => 'password', :role => :admin)


# Faculty    nimoy hanks dicaprio locke tzu nitzsche hobbes einstein edison tesla galileo euler obama

nimoy = User.create(:email => 'spock@enterprise.uss', :first_name => 'Leonard', :last_name => 'Nimoy', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
hanks = User.create(:email => 'thanks@thanksbanks.com', :first_name => 'Tom', :last_name => 'Hanks', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
dicaprio = User.create(:email => 'leon.ardo.di@caprio.net', :first_name => 'Leonardo', :last_name => 'DiCaprio', :password => 'password', :password_confirmation => 'password', :role => :faculty).id


locke = User.create(:email => 'JLocke@philosophers.co.uk', :first_name => 'John', :last_name => 'Locke', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
tzu = User.create(:email => 'lao@tzu2.ch', :first_name => 'Lao', :last_name => 'Tzu', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
nietzsche = User.create(:email => 'friedrich@nietzsche.de', :first_name => 'Friedrich', :last_name => 'Nietzsche', :password => 'password', :password_confirmation => 'password', :role => :faculty).id


hobbes = User.create(:email => 'thomas@hobbes.co.uk', :first_name => 'Thomas', :last_name => 'Hobbes', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
einstein = User.create(:email => 'einsteinsemail@einstein.biz', :first_name => 'Albert', :last_name => 'Einstein', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
edison = User.create(:email => 'edison@foundingfathers.com', :first_name => 'Thomas', :last_name => 'Edison', :password => 'password', :password_confirmation => 'password', :role => :faculty).id


tesla = User.create(:email => 'nk@tesla.cr', :first_name => 'Nikolai', :last_name => 'Tesla', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
galileo = User.create(:email => 'galileo@galileo.gr', :first_name => 'Galileo', :last_name => 'Galilei', :password => 'password', :password_confirmation => 'password', :role => :faculty).id
euler = User.create(:email => 'leonard@euler.com', :first_name => 'Leonard', :last_name => 'Euler', :password => 'password', :password_confirmation => 'password', :role => :faculty).id


User.create(:email => 'therealdeal@foundingfathers.com', :first_name => 'Benjamin', :last_name => 'Franklin', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'gwbush@whitehouse.com', :first_name => 'George', :last_name => 'Bush', :password => 'password', :password_confirmation => 'password', :role => :faculty)
obama = User.create(:email => 'obama@whitehouse.gov', :first_name => 'Barack', :last_name => 'Obama', :password => 'password', :password_confirmation => 'password', :role => :faculty).id


User.create(:email => 'fig@newtons.com', :first_name => 'Isaac', :last_name => 'Newton', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'eatmychicken@generaltso.ch', :first_name => 'General', :last_name => 'Tso', :password => 'password', :password_confirmation => 'password', :role => :faculty)
User.create(:email => 'knight@ni.co.uk', :first_name => 'Monty', :last_name => 'Python', :password => 'password', :password_confirmation => 'password', :role => :faculty)


# Students

queen = User.create(:email => 'thequeen@uk.co.uk', :first_name => 'Queen', :last_name => 'Elizabeth', :password => 'password', :password_confirmation => 'password', :role => :student).id
mandella = User.create(:email => 'prisoner@southafrica.za', :first_name => 'Nelson', :last_name => 'Mandela', :password => 'password', :password_confirmation => 'password', :role => :student).id
jackson = User.create(:email => 'jackson@neverland.com', :first_name => 'Michael', :last_name => 'Jackson', :password => 'password', :password_confirmation => 'password', :role => :student).id


poppins = User.create(:email => 'poppinlock@poppins.co.uk', :first_name => 'Mary', :last_name => 'Poppins', :password => 'password', :password_confirmation => 'password', :role => :student).id
stewart = User.create(:email => 'martha@fedpenfoods.com', :first_name => 'Martha', :last_name => 'Stewart', :password => 'password', :password_confirmation => 'password', :role => :student).id
fatalbert = User.create(:email => 'fat@albert.com', :first_name => 'Fat', :last_name => 'Albert', :password => 'password', :password_confirmation => 'password', :role => :student).id

hulk = User.create(:email => 'america@america.com', :first_name => 'Hulk', :last_name => 'Hogan', :password => 'password', :password_confirmation => 'password', :role => :student).id
parker = User.create(:email => 'parker@thedailybugle.com', :first_name => 'Peter', :last_name => 'Parker', :password => 'password', :password_confirmation => 'password', :role => :student).id

gandhi = User.create(:email => 'mahatma@gandhi.in', :first_name => 'Mahatma', :last_name => 'Gandhi', :password => 'password', :password_confirmation => 'password', :role => :student).id
emperor = User.create(:email => 'theemperor@japan.jp', :first_name => 'Emperor', :last_name => 'Akihito', :password => 'password', :password_confirmation => 'password', :role => :student).id
stark = User.create(:email => 'stark@starkindustries.com', :first_name => 'Tony', :last_name => 'Stark', :password => 'password', :password_confirmation => 'password', :role => :student).id

superman = User.create(:email => 'ckent@thedailyplanet.com', :first_name => 'Clark', :last_name => 'Kent', :password => 'password', :password_confirmation => 'password', :role => :student).id
batman = User.create(:email => 'bruce@wayneindustries.com', :first_name => 'Bruce', :last_name => 'Wayne', :password => 'password', :password_confirmation => 'password', :role => :student).id
spartans = User.create(:email => '300@spartans.gr', :first_name => 'The 300', :last_name => 'Spartans', :password => 'password', :password_confirmation => 'password', :role => :student).id

# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # COURSES # # # # # # # # # # #

# faculty usernames: nimoy hanks dicaprio locke tzu nitzsche hobbes einstein edison tesla galileo euler obama

snork1 = Course.create(:name => 'The art of Snorkeling', :course_number => 'Snork-104', :section => '1', :term => 'Winter', :user_id => nimoy).id
snork2 = Course.create(:name => 'The sound of Snorkeling', :course_number => 'Snork-204', :section => '2', :term => 'Winter', :user_id => nimoy).id
snork3 = Course.create(:name => 'The smell of Snorkeling', :course_number => 'Snork-304', :section => '1', :term => 'Winter', :user_id => hanks).id
snork4 = Course.create(:name => 'How to breathe underwater', :course_number => 'Snork-704', :section => '1', :term => 'Winter', :user_id => dicaprio).id


cs120 = Course.create(:name => 'Introduction to Software Development', :course_number => 'CSSE-120', :section => '1', :term => 'Winter', :user_id => locke).id
sr1 = Course.create(:name => 'Senior Project I', :course_number => 'CSSE-497', :section => '1', :term => 'Fall', :user_id => tzu).id

sr2 = Course.create(:name => 'Senior Project II', :course_number => 'CSSE-498', :section => '1', :term => 'Winter', :user_id => hobbes).id
tie = Course.create(:name => 'How to tie a tie', :course_number => 'Tie-532', :section => '1', :term => 'Life', :user_id => nimoy).id

shop1 = Course.create(:name => 'Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Summer', :user_id => tesla).id
shop2 = Course.create(:name => 'More Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Fall', :user_id => galileo).id
shop3 = Course.create(:name => 'Even More Shopping', :course_number => 'Shop-208', :section => '1', :term => 'Winter', :user_id => euler).id
shop4 = Course.create(:name => 'Shopping and dropping', :course_number => 'Shop-208', :section => '1', :term => 'Spring', :user_id => obama).id

# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # ENROLLEES # # # # # # # # # #


# student usernames:  queen mandella jackson poppins stewart fatalbert hulk parker gandhi emperor stark superman batman spartans

snork1_students = [queen, mandella, jackson]
snork1_tas = [gandhi, stewart, obama]

snork2_students = [fatalbert, hulk, poppins]
snork2_tas = [poppins]

snork3_students = [parker, stewart, gandhi]
snork3_tas = [superman, spartans, stark]

snork4_students = [batman]
snork4_tas = [spartans]

tie_students = [mandella, jackson, fatalbert, hulk, parker, gandhi, emperor, stark, superman, batman, spartans]
tie_tas = [poppins]

shop1_students = [poppins, stewart, fatalbert, hulk, parker, gandhi, queen, jackson, mandella, stark, batman, spartans]
shop1_tas = []

shop2_students = [poppins, stewart, fatalbert]
shop2_tas = [batman, jackson]

shop3_students = [poppins, parker, superman]
shop3_tas = [batman, queen, mandella]

shop4_students = [hulk, parker, superman]
shop4_tas = [batman, stark, spartans]


snork1_students.each{ |s| Studentgroup.create(:course_id => snork1, :user_id => s)}
snork1_tas.each{ |t| Tagroup.create(:course_id => snork1, :user_id => t)} 

snork2_students.each{ |s| Studentgroup.create(:course_id => snork2, :user_id => s)}
snork2_tas.each{ |t| Tagroup.create(:course_id => snork2, :user_id => t)}

snork3_students.each{ |s| Studentgroup.create(:course_id => snork3, :user_id => s)}
snork3_tas.each{ |t| Tagroup.create(:course_id => snork3, :user_id => t)}

snork4_students.each{ |s| Studentgroup.create(:course_id => snork4, :user_id => s)}
snork4_tas.each{ |t| Tagroup.create(:course_id => snork4, :user_id => t)}

tie_students.each{ |s| Studentgroup.create(:course_id => tie, :user_id => s)}
tie_tas.each{ |t| Tagroup.create(:course_id => tie, :user_id => t)}

shop1_students.each{ |s| Studentgroup.create(:course_id => shop1, :user_id => s)}
shop1_tas.each{ |t| Tagroup.create(:course_id => shop1, :user_id => t)}

shop2_students.each{ |s| Studentgroup.create(:course_id => shop2, :user_id => s)}
shop2_tas.each{ |t| Tagroup.create(:course_id => shop2, :user_id => t)}

shop3_students.each{ |s| Studentgroup.create(:course_id => shop3, :user_id => s)}
shop3_tas.each{ |t| Tagroup.create(:course_id => shop3, :user_id => t)}

shop4_students.each{ |s| Studentgroup.create(:course_id => shop4, :user_id => s)}
shop4_tas.each{ |t| Tagroup.create(:course_id => shop4, :user_id => t)}


# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # ASSIGNMENTS # # # # # # # # # #

LastMonth = Time.now - 1.month
LastWeek = Time.now - 1.week
Yesterday = Time.now - 1.day

NextMonth = Time.now + 1.month
NextWeek = Time.now + 1.week
Tomorrow = Time.now + 1.day

snork1_a_1 = Assignment.create(:course_id => snork1, :start_date => Yesterday, :end_date => NextWeek, :name => "How to hold your breath!").id
snork2_a_1 = Assignment.create(:course_id => snork2, :start_date => Tomorrow, :end_date => NextWeek, :name => "Using Sonar").id
snork3_a_1 = Assignment.create(:course_id => snork3, :start_date => NextWeek, :end_date => NextMonth, :name => "Breathing Through a Tube").id
snork4_a_1 = Assignment.create(:course_id => snork4, :start_date => Yesterday, :end_date => Tomorrow, :name => "Relinquishing Mortality").id

cs120_a_1 = Assignment.create(:course_id => cs120, :start_date => NextMonth, :end_date => NextMonth + 1.day, :name => "Programming with Letters").id

sr1_a_1 = Assignment.create(:course_id => sr1, :start_date => LastMonth, :end_date => LastMonth, :name => "Fitness survey").id
sr2_a_1 = Assignment.create(:course_id => sr2, :start_date => NextMonth, :end_date => NextMonth, :name => "Happiness survey").id

tie_a_1 = Assignment.create(:course_id => tie, :start_date => Tomorrow, :end_date => NextWeek, :name => "Stretching Your Fingers").id

shop1_a_1 = Assignment.create(:course_id => shop1, :start_date => LastMonth, :end_date => LastWeek, :name => "Window Shopping").id
shop2_a_1 = Assignment.create(:course_id => shop2, :start_date => LastWeek, :end_date => Yesterday, :name => "Extreme Couponing").id
shop3_a_1 = Assignment.create(:course_id => shop3, :start_date => Yesterday, :end_date => NextWeek, :name => "Shopping 4 Free").id
shop4_a_1 = Assignment.create(:course_id => shop4, :start_date => NextWeek, :end_date => NextMonth, :name => "Dropping Practice").id

snork1_a_d_1 = AssignmentDefinition.create(:assignment_id => snork1_a_1, :description => "Don't screw up.").id
snork2_a_d_1 = AssignmentDefinition.create(:assignment_id => snork2_a_1, :description => "Listen carefully.").id
snork3_a_d_1 = AssignmentDefinition.create(:assignment_id => snork3_a_1, :description => "Inflate the nostrils.").id
snork4_a_d_1 = AssignmentDefinition.create(:assignment_id => snork4_a_1, :description => "Step 1. Relax!").id

cs120_a_d_1 = AssignmentDefinition.create(:assignment_id => cs120_a_1, :description => "Spell stuff.").id

sr1_a_d_1 = AssignmentDefinition.create(:assignment_id => sr1_a_1, :description => "How fit are you?").id
sr2_a_d_1 = AssignmentDefinition.create(:assignment_id => sr2_a_1, :description => "How happy are you?").id

tie_a_d_1 = AssignmentDefinition.create(:assignment_id => tie_a_1, :description => "Be sure not to strain the fingers.").id

shop1_a_d_1 = AssignmentDefinition.create(:assignment_id => shop1_a_1, :description => "Look carefully.").id
shop2_a_d_1 = AssignmentDefinition.create(:assignment_id => shop2_a_1, :description => "The more you buy, the more you save!").id
shop3_a_d_1 = AssignmentDefinition.create(:assignment_id => shop3_a_1, :description => "Stealing is only illegal if you get caught!").id
shop4_a_d_1 = AssignmentDefinition.create(:assignment_id => shop4_a_1, :description => "Shop, drop, and roll!").id

snork1_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => snork1_a_d_1, :user_id => s) }
snork2_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => snork2_a_d_1, :user_id => s) }
snork3_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => snork3_a_d_1, :user_id => s) }
snork4_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => snork4_a_d_1, :user_id => s) }

tie_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => tie_a_d_1, :user_id => s) }

shop1_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => shop1_a_d_1, :user_id => s) }
shop2_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => shop2_a_d_1, :user_id => s) }
shop3_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => shop3_a_d_1, :user_id => s) }
shop4_students.each{ |s| AssignmentDefinitionToUser.create(:assignment_definition_id => shop4_a_d_1, :user_id => s) }




