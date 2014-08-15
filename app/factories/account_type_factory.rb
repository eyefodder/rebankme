# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AccountTypeFactory
  # NB explicitly testing against 'false' as we want
  # to avoid nil getting caught in false check
  # ie there is a diff between user.has_predictable_income = false
  # and user.has_predictable_income  = nil!
  def self.account_type_for(user)
    return AccountType.PREPAY_CARD if matches_prepay_profile(user)
    return safe_or_second_chance(user) if matches_safe_or_second_chance(user)
    return special_account_for(user) if matches_special_group_profile(user)
    return AccountType.REGULAR_ACCOUNT if matches_regular_account_profile(user)
    return safe_or_credit_union(user) if match_cred_union_or_safe_account(user)
  end

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

  def self.safe_or_second_chance(user)
    user.in_new_york_city? ? AccountType.SAFE_ACCOUNT : AccountType.PREPAY_CARD
  end

  def self.match_cred_union_or_safe_account(user)
    match_profile(user,
                  is_delinquent: false,
                  special_group?: false,
                  will_use_direct_deposit: false)
  end

  def self.matches_safe_or_second_chance(user)
    match_profile(user, is_delinquent: true, has_predictable_income: true)
  end

  def self.matches_prepay_profile(user)
    match_profile(user, is_delinquent: true, has_predictable_income: false)
  end

  def self.matches_special_group_profile(user)
    match_profile(user, is_delinquent: false, special_group?: true)
  end

  def self.matches_regular_account_profile(user)
    match_profile(user,
                  is_delinquent: false,
                  special_group?: false,
                  will_use_direct_deposit: true)
  end

  def self.match_profile(user, props_hash)
    props_hash.each do |key, value|
      return false if user.send(key) != value
    end
    true
  end
end
