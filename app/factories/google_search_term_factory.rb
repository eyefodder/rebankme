# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class GoogleSearchTermFactory

  def self.map_search_term_for(account_type, user)
    case account_type
    when AccountType.CREDIT_UNION
      "Credit Unions near #{user.zipcode}"
    when AccountType.REGULAR_ACCOUNT
      "Free Checking near #{user.zipcode}"
    when AccountType.STUDENT_ACCOUNT
      "Free Student Checking near #{user.zipcode}"
    when AccountType.SENIORS_ACCOUNT
     seniors_search_term(user)
   when AccountType.VETERANS_ACCOUNT
      "Chase Branches near #{user.zipcode}" if user.state.chase_state?
    end
  end

  #   def veterans_search_term
  #   "Chase Branches near #{user.zipcode}" if user.state.chase_state?
  # end

  def self.seniors_search_term(user)
    user.state.us_bank_state? ? "USBank Branches near #{user.zipcode}" : "Credit Unions near #{user.zipcode}"
  end

end