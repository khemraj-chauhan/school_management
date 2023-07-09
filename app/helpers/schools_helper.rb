module SchoolsHelper
  def onboard
    ActiveRecord::Base.transaction do
      @school.save
      school_admin = User.new(user_params)
      school_admin.save!
      role = Role.find_by_name("school_admin")
      UserRole.create!(role_id: role.id, user_id: school_admin.id)
      SchoolAdmin.create!(school_id: @school.id, admin_id: school_admin.id)
    end
  end

  def modification
    ActiveRecord::Base.transaction do
      @school.update(school_params)
      params[:school][:admins_attributes].each do |school_admin|
        admin = @school.admins.find_by_id(school_admin[1][:id])
        next if admin.blank?

        admin.update(school_admin[1].permit(:name, :email, :phone))
      end
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, address_attributes: [:location, :city, :state, :pincode])
  end

  def user_params
    params[:school][:user][:password] = "test123"
    params[:school][:user].permit(:name, :email, :phone, :password)
  end
end
