module PageContentSteps
	extend RSpec::Matchers::DSL

	def have_page_title(title)
		have_title(title)
	end
  def have_page_heading(heading)
    have_css('h2.page-heading', text: heading)
  end
  RSpec::Matchers.define :display_error_message do |expected_error|
    match do |page|
      within("#error-messages") do
        have_content(expected_error).matches?(page)
      end
    end
  end
  RSpec::Matchers.define :display_any_errors do
    match do |page|
      have_css("#error-messages").matches?(page)
    end
  end
  RSpec::Matchers.define :display_account_finder_content do |page_ref|
    match do |page|
      expected_heading = I18n.t("account_finder.#{page_ref}.title")
      have_page_heading(expected_heading).matches?(page)
      have_page_title(expected_heading).matches?(page)
    end
  end
  RSpec::Matchers.define :display_account_finder_question do |page_ref|
    content = I18n.t("account_finder.#{page_ref}.question")
    failure_message_for_should do |actual|
     "expected to find <div class='account-finder-question'> with content: \n#{content}"
    end
    match do |page|

      have_css('div.account-finder-question', text: content).matches?(page)
    end
  end




  RSpec::Matchers.define :have_form_for do |form_ref|
    chain :with_field do |field|
      @field = field
    end

    match do |page|

      # if form_ref.is_a?(Symbol)
      #   base_id = form_ref
      #   form_css_locator = "form#new_#{form_ref}"
      # end
      # puts "find form #{form_id} with_field #{@field} on #{page}"
      result = false
      if have_css(form_css_locator(form_ref)).matches?(actual)
        if @field.nil?
          result = true
        else
          result = have_css(css_locator_for_field form_ref, @field).matches?(actual)
        end
      end
      result
    end
  end

  def css_locator_for_field(form_ref, field_ref)
    "#{form_css_locator form_ref} ##{form_field_id(form_ref, field_ref)}"
  end
  def form_css_locator(form_ref)
    "form##{form_id(form_ref)}"
  end
  def form_id(form_ref)
    "new_#{form_ref}"
  end
  def form_field_id(form_ref, field_ref)
    "#{form_ref}_#{field_ref}"
  end
  def populate_form_field(form_ref, field_ref, value)
    within("##{form_id form_ref}") do
      fill_in(form_field_id(form_ref, field_ref), with: value)
    end
  end

end