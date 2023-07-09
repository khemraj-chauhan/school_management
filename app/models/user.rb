class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :email, :phone, presence: true

  has_one :address, as: :addressable, dependent: :destroy

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :school_admins, foreign_key: :admin_id, dependent: :destroy
  has_many :schools, through: :school_admins

  # after_create :assign_role

  def has_role?(role_name)
    roles.pluck(:name).include?(role_name)
  end

  def has_any_role?(*role_names)
    role_names.flatten.any? { |r| roles.pluck(:name).include?(r) }
  end

  def admin?
    self.has_role?("admin")
  end

  def school_admin?
    self.has_role?("school_admin")
  end

  def student?
    self.has_role?("student")
  end

  private

  # def assign_role
  #   return if roles.present?

  #   student_role = Role.find_by_name("student")
  #   UserRole.create!(role_id: student_role.id, user_id: id)
  # end
end
