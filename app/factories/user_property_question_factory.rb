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
        :is_special_group
      end
    else
      :is_delinquent
    end
  end
end