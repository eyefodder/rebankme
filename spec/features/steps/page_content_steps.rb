module PageContentSteps
	extend RSpec::Matchers::DSL

	def have_page_title(title)
		have_title(title)
	end
  def have_page_heading(heading)
    have_css('h2.page-heading', text: heading)
  end

RSpec::Matchers.define :have_body_copy do |locale_content|
  chain :with_id do |id|
    @id = id
  end
  match do |page|
    node = @id ? page.find("##{@id}.body_copy") : page.find('.body_copy')
    node.native.inner_html == simple_format(locale_content)
  end
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
  def click_no_button
    click_form_button(:no)
  end
  def click_yes_button
    click_form_button(:yes)
  end
  def click_form_button(action)
    first(:button, "next_question_#{action}" ).click
   # click_button("next_question_#{action}")
 end

 RSpec::Matchers.define :have_flash_message do |expected_message|
  match do |page|
    within("div.alert-#{expected_message.keys.first}") do
      have_content(expected_message.values.first).matches?(page)
    end
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