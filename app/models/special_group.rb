# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# == Schema Information
#
# Table name: special_groups
#
#  id         :integer          not null, primary key
#  name_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class SpecialGroup < ActiveRecord::Base
  validates :name_id, presence: true
  validates :name_id, uniqueness: true

  # rubocop:disable Style/MethodName
  # because we want these to appear semantically as constants
  def self.STUDENT
    SpecialGroup.find_by(name_id: 'student')
  end
  def self.VETERAN
    SpecialGroup.find_by(name_id: 'veteran')
  end
  def self.SENIOR
    SpecialGroup.find_by(name_id: 'senior')
  end

  def self.NOT_SPECIAL
    SpecialGroup.find_by(name_id: 'not_special')
  end

  def self.FALSE_VALUE
    SpecialGroup.NOT_SPECIAL
  end

  # rubocop:enable Style/MethodName
end
