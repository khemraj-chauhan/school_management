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
  has_many :courses, through: :schools
  has_many :student_batches, foreign_key: :student_id, dependent: :destroy
  has_many :approved_student_batches, -> { where(status: :approved) }, class_name: "StudentBatch", foreign_key: :student_id, dependent: :destroy
  has_many :batches, through: :student_batches
  has_many :stundent_courses, -> { distinct }, through: :batches, source: :course
  has_many :stundent_schools, -> { distinct }, through: :stundent_courses, source: :school

  scope :with_student_roles, -> { includes(:roles).where(roles: {name: "student"}) }

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

  def any_admin?
    self.has_role?("admin") || self.has_role?("school_admin")
  end
end
