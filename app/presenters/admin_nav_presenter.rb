# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AdminNavPresenter < BasePresenter
  def admin_home_link
    link_for('Admin Home', h.admin_path)
  end

  def banks_link
    link_for('Banks', h.banks_path)
  end

  def bank_accounts_link
    link_for('Bank Accounts', h.bank_accounts_path)
  end

  def branches_link
    link_for('Branches', h.branches_path)
  end

  def edit_account_link
    link_for('Edit Account', h.edit_admin_user_registration_path)
  end

  def job_queue_link
    link_for('Job Queue', h.job_queue_path)
  end

  def vanity_link
    link_for('Metrics', controller: :vanity, action: :index)
  end

  def logout_link
    link = h.link_to('Log out',
                     h.destroy_admin_user_session_path,
                     method: :delete,
                     id: 'logout')
    h.content_tag(:li, link)
  end

  private

  def link_for(copy, path)
    h.content_tag(:li, h.link_to(copy, path), class: nav_link_class(path))
  end

  def nav_link_class(path)
    h.request.fullpath == path ? 'active' : ''
  end
end
