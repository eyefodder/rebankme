class AccountTypeFactory

  def self.account_type_for(user)
    # NB explicitly testing against 'false' as we want to avoid nil getting caught in false check
    # ie there is a diff between user.has_predictable_income = false and user.has_predictable_income  = nil!

    if matches_prepay_profile(user)
      return AccountType.PREPAY_CARD
    end
    if matches_safe_or_second_chance(user)
      return safe_or_second_chance(user)
    end
    if matches_special_group_profile(user)
      return AccountType.SPECIAL_GROUP
    end
    if matches_regular_account_profile(user)
      return AccountType.REGULAR_ACCOUNT
    end
    if user.is_delinquent == false && user.is_special_group == false && user.will_use_direct_deposit == false
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

  def self.safe_or_second_chance(user)
    user.in_new_york_city? ? AccountType.SAFE_ACCOUNT : AccountType.SECOND_CHANCE
  end
  def self.matches_safe_or_second_chance(user)
    user.is_delinquent && user.has_predictable_income
  end
  def self.matches_prepay_profile(user)
    user.is_delinquent && user.has_predictable_income == false
  end
  def self.matches_special_group_profile(user)
    user.is_delinquent == false && user.is_special_group
  end
  def self.matches_regular_account_profile(user)
user.is_delinquent == false && user.is_special_group == false && user.will_use_direct_deposit
  end
end