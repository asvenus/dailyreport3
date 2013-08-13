class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :update,:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
   @users=User.all
    filename = "data_users.xls"
    respond_to do |format|
      format.html # index.html.erb
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
      format.xml  { render :xml => @users }
    end
   
  end
   
  

  def new
  	#@password = SecureRandom.hex(10)
    @password = 'foobar'
  	@user = User.new
  end

  def show
  	@user = User.find_by(id:params[:id])
    if !@user.active?
    @user.toggle!(:active)    # change attribute active false->true // active User
    flash[:success]="Users actived!"
    sign_in @user 
    redirect_to root_url
    else 
      redirect_to root_url
    end

  end

  def create
	@user= User.new(save_params)

  	if @user.save 
      UserMailer.registration_confirmation(@user).deliver  
  		flash[:success] = "Acount created.Wait for adminstration aproval!"
  		redirect_to root_url
  	else
  		render 'new'
  	end
  end
  
  def edit
  	@user = User.find_by(id: params[:id])

   
  end

  def update   #for admin 
  	@user =User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success]= "Profile updated"
  		sign_in @user
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end


  def destroy
  	@user = User.find(params[:id])
  	@user.destroy

  end



  private
  	def user_params
  		params.require(:user).permit(:name, :email, :group_id , :manager_group, :active)
  	end

  	def save_params
  		params.require(:user).permit(:name, :email, :password,:password_confirmation )
  	end

  	def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end