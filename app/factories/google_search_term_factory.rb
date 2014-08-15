# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class GoogleSearchTermFactory
  def self.map_search_term_for(act_type, user)
    prefix = account_type_search_prefix(act_type)
    return "#{prefix} near #{user.zipcode}" unless  prefix.nil?
    return srs_search_term(user) if act_type == AccountType.SENIORS_ACCOUNT
    return vets_search_term(user) if act_type == AccountType.VETERANS_ACCOUNT
  end

  def self.vets_search_term(user)
    "Chase Branches near #{user.zipcode}" if user.state.chase_state?
  end

  def self.srs_search_term(user)
    if user.state.us_bank_state?
      "USBank Branches near #{user.zipcode}"
    else
      "Credit Unions near #{user.zipcode}"
    end
  end

  def self.account_type_search_prefix(account_type)
    simple_prefixes = { AccountType.CREDIT_UNION => 'Credit Unions',
                        AccountType.REGULAR_ACCOUNT => 'Free Checking',
                        AccountType.STUDENT_ACCOUNT => 'Free Student Checking' }
    simple_prefixes[account_type]
  end
end
