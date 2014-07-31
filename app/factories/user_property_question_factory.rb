class UserPropertyQuestionFactory
def self.next_property_for(user)
    if user.is_delinquent
      :has_predictable_income
    elsif user.is_delinquent == false
      if user.is_special_group == false
        if user.will_use_direct_deposit == false
          :needs_debit_card
        else
          :will_use_direct_deposit
        end
      else
        :special_group
      end
    else
      :is_delinquent
    end
  end
end

# So:
# what we want to do is change :is_special_group to :special_group, and drop the sub/^is_/ from user setoption
# then, ensure values are set correctly for is_delinquent: temporarily
# then, ensure special_group_id is passed through form