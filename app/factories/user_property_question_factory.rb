# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class UserPropertyQuestionFactory
  def self.next_property_for(user)
    return :is_delinquent if user.is_delinquent.nil?
    return :has_predictable_income if user.is_delinquent
    return :special_group if user.special_group?.nil?
    return :will_use_direct_deposit if user.will_use_direct_deposit.nil?
    :needs_debit_card
  end
end
