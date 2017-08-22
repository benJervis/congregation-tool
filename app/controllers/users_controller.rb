class UsersController < ApplicationController

	skip_before_action :require_login, only: [:signup, :signup_create]

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def signup
		@hide_sidebar = true
		@user = User.new
	end

	def edit
    @user = User.find(params[:id])
	end

	def show
    @user = User.find(params[:id])

		@pronoun = @user == current_user ? "You're" : "This user is"

		@address_link = "https://www.google.com.au/maps/place/#{CGI::escape(@user.address)}" unless @user.address.nil?
	end

	def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
			flash[:success] = "Details updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
	end

	def update_password
		@user = User.find(params[:id])

		if @user.update_attributes(password_params_only)
			flash[:success] = "Your password has been updated"
			#TODO email password update notification
			redirect_to @user
		else
			render 'update_password'
		end
	end

	def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
	end

	# For admins creating users inside the app
	def create
		@user = User.new(user_params)
		temporary_password = User.new_token
		@user.password = @user.password_confirmation = temporary_password
		@user.level = 'member'

		if @user.save
			@user.send_activation_email
			#TODO Setup heroku email sending https://www.railstutorial.org/book/account_activation#sec-activation_email_in_production
			flash[:success] = "User created successfully"
			redirect_to users_path
		else
			render 'new'
		end
	end

	def signup_create
		@user = User.new(user_signup_params)
		@user.level = 'visitor'

		if @user.save
			@user.send_activation_email
			log_in @user
			flash[:success] = 'Welcome to civitasCRM!'
			#TODO send notification to all admins
			redirect_to root_path
		else
			render 'signup'
		end
	end

	private

    def user_params
    	params[:user][:phone_number] = params[:user][:phone_number].split.join('').to_i
			params[:user][:level] ||= 'visitor'
      params.require(:user).permit(:first_name, :last_name, :email, :address, :phone_number, :dob, :password, :password_confirmation, :level)
    end

		def user_signup_params
			params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
		end
end
