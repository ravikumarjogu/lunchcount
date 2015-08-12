module DashboardsHelper

  
  def domain_registered?
      if Domain.find_by(user_id: current_user.id)
        return true
      else
        return false
      end
      
  end

  def dom_counter(date)
      dom_count = Hash.new
      all=Lunch.where(:day => date)
      all.group_by(&:name).each do |name, ids|
        dom_count[name] = ids.count
      end
      dom_count
  end

  def view_all_list(date)
      User.includes(:lunches).where(:lunches => {:day => date})
  end

  def dom_wise_list(domain, date)
      User.includes(:lunches).where(:lunches => {:day => date, :name => domain}).all
  end

  def current_user?(user)
      user == current_user
  end

  def logged_in_user
          unless user_signed_in? 
          redirect_to new_user_session_path
          end  
      end

  def is_admin?
    current_user.admin?
  end

  def js_date(from_date)
      DateTime.strptime(from_date, "%Y-%m-%d").strftime("%m/%d/%Y").to_s
  end


end
