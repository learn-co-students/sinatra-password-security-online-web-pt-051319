class User < ActiveRecord::Base
	 has_secure_password
	#has_secure_password is being called just like a normal ruby method. It works in conjunction with a gem called bcrypt and gives #us all of those abilities in a secure way that doesn't actually store the plain text password in the database
	
	#we told Ruby to add an authenticate method to our class (invisibly!) when the program runs. While we, as programmers can't see it, it will be there.
end