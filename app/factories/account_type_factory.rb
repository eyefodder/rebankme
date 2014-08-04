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
      return special_account_for(user)
    end
    if matches_regular_account_profile(user)
      return AccountType.REGULAR_ACCOUNT
    end
    if matches_credit_union_or_safe_account(user)
      return safe_or_credit_union(user)
    end
  end

  private

  def self.safe_or_credit_union(user)
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

  def self.special_account_for(user)
    case user.special_group
    when SpecialGroup.STUDENT
      AccountType.STUDENT_ACCOUNT
    when SpecialGroup.VETERAN
      AccountType.VETERANS_ACCOUNT
    when SpecialGroup.SENIOR
      AccountType.SENIORS_ACCOUNT
    else
      AccountType.SPECIAL_GROUP
    end

  end

  def self.matches_credit_union_or_safe_account(user)
    user.is_delinquent == false && user.is_special_group == false && user.will_use_direct_deposit == false
  end
  def self.safe_or_second_chance(user)
    user.in_new_york_city? ? AccountType.SAFE_ACCOUNT : AccountType.PREPAY_CARD
    # user.in_new_york_city? ? AccountType.SAFE_ACCOUNT : AccountType.SECOND_CHANCE
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