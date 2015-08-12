class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :index, :show, :edit, :update]
  before_action :is_admin, only: [:destroy, :moduser, :modadmin ]
  def new
  end

  def index
      @users = User.paginate(page: params[:page])
      flash.now[:info] = "You can change roles, delete the users here...."
  end

  def show
      @user = User.find(params[:id])
  end

  def destroy
      name = User.find(params[:id]).name
      User.find(params[:id]).destroy
      flash[:success] = "#{name} account dropped.."
      redirect_to users_url
  end

  def edit

  end

  def update

  end



  def modadmin
      touser = User.find(params[:id])
      touser.toggle!(:admin)
      flash[:success] = "#{touser.name} is Admin now "
      redirect_to users_url

  end

  def moduser
      touser = User.find(params[:id])
      touser.toggle!(:admin)
      flash[:info] = "#{touser.name} changed to User "
      redirect_to users_url
  end


  private

      def is_admin
          redirect_to(root_url) if !current_user.admin?
      end


end