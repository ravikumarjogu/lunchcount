class DashboardsController < ApplicationController
  require 'date'
  before_action :logged_in_user, only_for: [:new, :edit, :create, :destroy, :index, :getOnDay, :view_all, :domain_wise]
  before_action :is_admin?, only_for: [:getOnDay, :view_all, :domain_wise]
  def new
  end

  def index
      @date = DateTime.now.strftime("%Y-%m-%d")
      flash.now[:info] = "Showing company wise list for today" if current_user.admin?
      @dom_cil = dom_counter(@date)
  end

  def create
      #make_order
  end

  def destroy
      #remove_order
  end

  def getOnDay
      @date=get_date_exact
      flash.now[:info] = "Showing orders on #{@date}"

      @dom_cil = dom_counter(@date)
      render 'index'
  end

  def view_all
      @date=get_date_exact
      @all=view_all_list(@date)
      render 'viewed_all'
  end

  def domain_wise
      @date = get_date_exact
      @domain_name = params[:domain_name]
      @all=dom_wise_list(@domain_name, @date)
      
      render 'viewed'

  end

  def lunch

  end
 
  
  private
    def domain_registered?
      if Domain.find_by(user_id: current_user.id)
         return true
      else
         return false
      end
    end

      
    def domain_name
          Domain.find_by(user_id: current_user.id).name
    end

    def get_date_exact
      if !params[:date].empty?
        date = DateTime.strptime(params[:date],"%m/%d/%Y")
        date = date.strftime("%Y-%m-%d")
      else
        date = DateTime.now.strftime("%Y-%m-%d")
      end
    end


end
