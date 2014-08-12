# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# @SEE https://coderwall.com/p/jsutlq
def show_page
  save_page Rails.root.join('public', 'capybara.html')
  %x(`launchy http://localhost:3000/capybara.html`)
end
