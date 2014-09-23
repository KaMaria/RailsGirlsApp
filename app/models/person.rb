# == Schema Information
#
# Table name: people
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)      default(""), not null
#  group_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  picture                :string(255)
#  twitter                :string(255)
#  working_on             :text
#

class Person < ActiveRecord::Base
  rolify
  include TwitterHandle
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups, through: :memberships
  has_many :memberships, dependent: :destroy
  has_many :topics
  has_many :posts

  mount_uploader :picture, PictureUploader

  validates :first_name, presence: true

  def self.admin
    joins(:roles).where('roles.name = \'admin\'')
  end

  def in_group?
    groups.empty? == false && accepted_groups
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def name
    full_name
  end

  def to_s
    full_name
  end

  def pending_groups
    pending_memberships = memberships.where(pending: true)
    pending_memberships.map { |m| m.group } unless pending_memberships.empty?
  end

  def accepted_groups
    accepted_memberships = memberships.where(pending: false)
    accepted_memberships.map { |m| m.group } unless accepted_memberships.empty?
  end

  def join!(group, type = 'StudentMembership', pending = true)
    memberships.create!(group_id: group.id, type: type, pending: pending)
  end

  def member_of?(group)
    # double !! makes it return a boolean
    !!memberships.find_by(group_id: group.id, pending: false)
  end

  def waiting_to_join(group)
    !!memberships.find_by(group_id: group.id, pending: true)
  end
end
