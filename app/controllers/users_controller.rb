class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

		if @user.save
			flash[:notice] = "Thanks for registering"
			redirect_to root_path
			mailchimp_register
		else
			flash[:errors] = format_errors(@user.errors.messages)
			puts "ERROR"
			puts @user.errors.messages
			redirect_to new_user_path
		end
  end

  def mailchimp_register
  	gb = Gibbon::API.new
 
        list_id = '8b25d7ddf4'
    begin

    	gb.lists.subscribe({:id => list_id, 
          :email => {:email => @user.email}, 
          :merge_vars => {:FNAME => @user.name},
          :double_optin => false,
        	:send_welcome => true})

		rescue Gibbon::MailChimpError => e
  		flash[:errors] = e.message
		end
      
  end

	private
		def user_params
			params.require(:user).permit(:name, :email)
		end
end
