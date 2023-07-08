module SchoolsHelper
  def onboard_school
    ActiveRecord::Base.transaction do
      @school.save
      school_admin = User.new(user_params)
      school_admin.save!
      role = Role.find_by_name("school_admin")
      UserRole.create!(role_id: role.id, user_id: school_admin.id)
      SchoolAdmin.create!(school_id: @school.id, admin_id: school_admin.id)
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, address_attributes: [:location, :city, :state, :pincode])
  end
end
