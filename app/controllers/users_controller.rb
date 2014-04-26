class UsersController < ApplicationController
  
  def new
  end

  def create
    mailchimp_register(params[:name], params[:email])   
  end

  def mailchimp_register(name, email)
  	gb = Gibbon::API.new
    begin

    	gb.lists.subscribe({:id => ENV['MAILCHIMP_LIST_ID'], 
          :email => {:email => email}, 
          :merge_vars => {:FNAME => name},
          :double_optin => false,
        	:send_welcome => true})

		rescue Gibbon::MailChimpError => e
  		flash[:error] = e.message
      redirect_to new_user_path
    else
      flash[:notice] = "Succesfully registered"
      redirect_to root_path
		end
      
  end

end
