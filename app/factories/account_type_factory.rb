class AccountTypeFactory

  def self.account_type_for(user)
    # NB explicitly testing against 'false' as we want to avoid nil getting caught in false check
    # ie there is a diff between user.has_predictable_income = false and user.has_predictable_income  = nil!
    if user.is_delinquent
      if user.has_predictable_income == false
        return AccountType.PREPAY_CARD
      elsif user.has_predictable_income
        return user.in_new_york_city? ? AccountType.SAFE_ACCOUNT : AccountType.SECOND_CHANCE
      end
    elsif user.is_delinquent == false
      if user.is_special_group
        return AccountType.SPECIAL_GROUP
      elsif user.is_special_group == false
        if user.will_use_direct_deposit
          return AccountType.REGULAR_ACCOUNT
        elsif user.will_use_direct_deposit == false
          if !user.in_new_york_city?
            return AccountType.CREDIT_UNION
          else
            if user.needs_debit_card == false
              return AccountType.SAFE_ACCOUNT
            elsif user.needs_debit_card
              return AccountType.CREDIT_UNION
            end
          end
        end

      end
    end



  end
end