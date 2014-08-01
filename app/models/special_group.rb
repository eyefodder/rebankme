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
  validates_presence_of :name_id
  validates_uniqueness_of :name_id

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
end
