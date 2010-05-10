namespace :db do
  
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    require 'action_controller/test_process'
    
    # [User, Subscription, Valuation].each(&:delete_all)
        
    #####################  CREATE USERS  #####################
   
    # User.populate 1 do |admin|
    #   admin.login = "ian"
    #   admin.name = "Ian Alexander Wood"
    #   admin.email = "ianalexanderwood@gmail.com"
    #   admin.role = "admin"
    #   admin.crypted_password = "8010530181ee423288e72b2a45d9bf045ed97be6"
    #   admin.salt = "7823cecd5bcd10b8d86df120d11240e4c35a630b"
    #   admin.activation_code = nil
    #   admin.activated_at = Time.now
    # end
        
    # @new_users = []
    # 
    # 200.times do
    #   user = User.new( :login => (Faker::Internet.user_name + rand(10000).to_s),
    #             :name => Faker::Name.name,
    #             :email => (rand(10000).to_s + Faker::Internet.email)
    #   )
    #   @new_users.map{|x| x.login}.each do |login|
    #     if login == user.login
    #       user.delete
    #     end
    #   end
    #   @new_users.map{|x| x.email}.each do |email|
    #     if email == user.email
    #       user.delete
    #     end
    #   end
    #   @new_users << user
    # end
    # 
    # @new_users.each do |new_user|
    #   User.populate 1 do |user|
    #     user.login = new_user.login
    #     user.name = new_user.name
    #     user.email = new_user.email
    #     user.role = ["analyst","investor"]
    #     user.crypted_password = "8010530181ee423288e72b2a45d9bf045ed97be6"
    #     user.salt = "7823cecd5bcd10b8d86df120d11240e4c35a630b"
    #     user.activation_code = nil
    #     user.activated_at = Time.now
    #   end
    # end
    
    #####################  CREATE VALUATIONS  #####################

    # @analysts = User.all(:conditions => "role = 'analyst'")
    # @investors = User.all(:conditions => "role = 'investor'")
    # @admins = User.all(:conditions => "role = 'admin'")
    # @users = @analysts + @investors + @admins
    # @random_users = (@users.sample((@users.length / 2)) + @admins).uniq
    # 
    # @prices = Price.all
    # 
    # @companies = Company.all    
    # 
    # 100.times do
    #   Valuation.create_valuation( @analysts.map {|user| user.id}.shuffle.last, {:company_id => @companies.map {|company| company.id}.shuffle.last, :file => ActionController::TestUploadedFile.new("#{Rails.root}/test/files/test#{rand(10)}.xls","application/vnd.ms-excel") })
    # end
    # 
    # @companies.each do |company|
    #   @admins.each do |user|
    #     Valuation.create_valuation( user.id, {:company_id => company.id, :file => ActionController::TestUploadedFile.new("#{Rails.root}/test/files/test#{rand(10)}.xls","application/vnd.ms-excel") })
    #   end
    # end

    #####################  CREATE SUBSCRIPTIONS  #####################    
    
    # @valuations = Valuation.all(:conditions => "active=1")
    # 
    # @valuations.each do |valuation|
    #   @random_users.each do |user|
    #     Subscription.create(:user_id => user.id, :valuation_id => valuation.id)
    #   end
    # end
        
  end
  
end