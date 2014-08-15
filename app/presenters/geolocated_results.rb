# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module GeolocatedResults
  def geolocated_choice_map
    google_map_if_not_nil(selected_result, :google_maps_src_for_account)
  end

  def google_map_search
    google_map_if_not_nil(map_search_term, :google_map_search_uri)
  end

  def geolocated_option_title(bank_account)
    bank_account.branch.full_name
  end

  def geolocated_option_street(bank_account)
    bank_account.branch.street
  end

  def geolocated_distance_from_user(bank_account, tag = :span, options = nil)
    distance = user.distance_to(bank_account.branch)
    h.content_tag(tag, h.number_to_human(distance, units: :miles), options)
  end

  def geolocated_result_link(account, options = {})
    options = merge_options({ id: "select_account_#{account.id}" },
                            options)
    options = merge_options({ class: 'recommended_option' },
                            options) if (account == recommended_option)
    options = merge_options({ class: 'selected_option' },
                            options) if (account == selected_result)
    link = h.account_finder_path(user, selected_account_id: account.id)
    h.link_to(link, options) do
      yield
    end
  end

  private

  def map_search_term
    GoogleSearchTermFactory.map_search_term_for(account_type, user)
  end

  def google_map_if_not_nil(property, src_method)
    return if property.nil?
    src = send(src_method, property)
    h.render partial: 'account_finder/account_type/google_map',
             locals: { src: src }
  end

  def google_maps_src_for_account(account)
    URI.encode('https://www.google.com/maps/embed/v1/place?key=' \
               "#{ApiKeys.google_maps}&q=#{account.branch.bank.name}+" \
               "#{account.branch.full_address}")
  end

  def google_map_search_uri(search_term)
    URI.encode('https://www.google.com/maps/embed/v1/search?key=' \
               "#{ApiKeys.google_maps}&q=#{search_term}")
  end
end
