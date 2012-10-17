# This file should contain all the record creation needed to seed the database with its default values.
# This data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# USERS

# Admins

User.create(:email => 'notadmin@codeswap.com', :first_name => 'Administrator', :last_name => 'Billy', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@codeswap.com', :first_name => 'Administrator', :last_name => 'Joel', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'admin@test.com', :first_name => 'Administrator', :last_name => 'Frodo', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'heman@masteroftheuniverse.com', :first_name => 'Administrator', :last_name => 'He-Man', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'skeletor@lordofdestruction.com', :first_name => 'Administrator', :last_name => 'Skeletor', :password => 'password', :password_confirmation => 'password', :role => :admin)
User.create(:email => 'jiminy@thecricket.com', :first_name => 'Administrator', :last_name => 'Cricket', :password => 'password', :password_confirmation => 'password', :role => :admin)


# Faculty

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

# Students

User.create(:email => 'thequeen@uk.co.uk', :first_name => 'Queen', :last_name => 'Elizabeth', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'prisoner@southafrica.za', :first_name => 'Nelson', :last_name => 'Mandela', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'jackson@neverland.com', :first_name => 'Michael', :last_name => 'Jackson', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'poppinlock@poppins.co.uk', :first_name => 'Mary', :last_name => 'Poppins', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'martha@fedpenfoods.com', :first_name => 'Martha', :last_name => 'Stewart', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'fat@albert.com', :first_name => 'Fat', :last_name => 'Albert', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'america@america.com', :first_name => 'Hulk', :last_name => 'Hogan', :password => 'password', :password_confirmation => 'password', :role => :student)
User.create(:email => 'parker@thedailybugle.com', :first_name => 'Peter', :last_name => 'Parker', :password => 'password', :password_confirmation => 'password', :role => :student)


# TAs

User.create(:email => 'mahatma@gandhi.in', :first_name => 'Mahatma', :last_name => 'Gandhi', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'theemperor@japan.jp', :first_name => 'Emperor', :last_name => 'Akihito', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'stark@starkindustries.com', :first_name => 'Tony', :last_name => 'Stark', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'ckent@thedailyplanet.com', :first_name => 'Clark', :last_name => 'Kent', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => 'bruce@wayneindustries.com', :first_name => 'Bruce', :last_name => 'Wayne', :password => 'password', :password_confirmation => 'password', :role => :ta)
User.create(:email => '300@spartans.gr', :first_name => 'The 300', :last_name => 'Spartans', :password => 'password', :password_confirmation => 'password', :role => :ta)

# # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # COURSES # # # # # # # # # # #



