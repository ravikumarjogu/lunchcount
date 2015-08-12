class LunchOrdersController < ApplicationController
  respond_to :json
  before_action :logged_in_user, only_for: [:put_order, :drop_order, :cancel_order]
  before_action :is_admin?, only_for: [:cancel_order]

  def get_events
       @events = current_user.all_orders(params[:start], params[:end])
       events = []  
       if @events.count == 0
          events << { :id => "23", :title => "None", :start => "2013-2-23"}
       end
       @events.each do |event|
            events << { :id =>  "#{event.id}", :title => "Yes" , :start => "#{event.day}" }
       end
       
       respond_to do |format|
          format.html { redirect_to dashboards_path}
          format.json {  render :text => events.to_json }
          format.js { render :text => events.to_json }
       end

  end


  def put_order
      date = params[:date]
      status = current_user.make_order(date)

      respond_to do |format|
          if status
            format.html { redirect_to dashboards_path }
            format.json { render response: :success}
            format.js   { render response: :success}
          else
            format.html { }
            format.json { }
            format.js   { }
          end  
      end
  end

  def drop_order
      lunch_id = params[:id]
      status = current_user.remove_order(lunch_id)
      
      respond_to do |format|
          if status
            format.html { redirect_to dashboards_path }
            format.json { render response: :success}
            format.js   { render response: :success}
          else
            format.html { }
            format.json { }
            format.js   { }
          end  
      end 
  end

  def pop_lunch
      user=User.find(params[:id])
      status = user.pop_lunch_admin(params[:date])
      respond_to do |format|
          if status
            format.html { redirect_to dashboards_path }
            format.json { render response: :success}
            format.js   { render response: :success}
          else
            format.html { }
            format.json { }
            format.js   { }
          end  
      end
  end

  def push_lunch
      user=User.find(params[:id])
      status = user.push_lunch_admin(params[:date])
      respond_to do |format|
          if status
            format.html { redirect_to dashboards_path }
            format.json { render response: :success}
            format.js   { render response: :success}
          else
            format.html { }
            format.json { }
            format.js   { }
          end  
      end  
  end

end
