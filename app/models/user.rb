class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :domain, dependent: :destroy
  has_many :lunches, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
    before_save {email.downcase!}
    after_save { create_domain }
    validates :name, presence: true, length: { maximum: 30}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}


    def all_orders(start, endd)
        start=DateTime.strptime(start, "%Y-%m-%d")
        endd=DateTime.strptime(endd, "%Y-%m-%d")
        Lunch.where("day >= ? AND day <= ? AND user_id = ? ", start, endd, id)
    end

    def make_order(date)
        #Insert record into Lunch with date, user_id and company name {domain_name}
        lunches.create(:day => date, :name => domain_name) if !check_exist(date)
    end

    def remove_order(lunch_id)
        #Remove record from Lunch with given date
        lunches.find(lunch_id).destroy if lunch_exist(lunch_id)
    end

    def pop_lunch_admin(date)
        lunches.find_by(:day => date).destroy if check_exist(date)
    end

    def push_lunch_admin(date)
        lunches.create(:day => date, :name => domain_name)
    end


    def domain_name
          Domain.find_by(user_id: self.id).name
    end

    def trim_domain
        self.email.split("@").last.split(".").first
    end

    def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          user = User.create(name: data["name"],
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20],
          )
        end
     end
    end

    private

        def create_domain
          Domain.create(name: trim_domain, user_id: self.id) if !Domain.find_by(user_id: self.id)
        end

        def check_exist(date)
          lunches.find_by(:day => date)
        end

        def lunch_exist(lunch_id)
          lunches.find(lunch_id)
        end
end
