# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module DataEntrySteps
  def object_class
    type.to_s.camelize.constantize
  end

  shared_examples 'a page that creates a new item with valid information' do
    before do
      populate_required_properties :with_valid
    end
    it 'should  change item count' do
      expect { click_submit_button }.to change(object_class, :count).by(1)
    end
    it 'should navigate to post create path' do
      click_submit_button
      expect(current_path).to eq post_create_path
    end
  end

  shared_examples "a page that doesn't create with invalid information" do
  before do
    populate_required_properties :with_invalid
  end
  it 'should not change item count' do
    expect { click_submit_button }.not_to change(object_class, :count)
  end
end

  shared_examples 'a page that errors with invalid information' do
    before do
      populate_required_properties :with_invalid
      click_submit_button
    end
    include_examples 'a page with an error'
  end

  shared_examples 'a page that updates item with valid information' do
    before do
     populate_required_properties :with_valid
     click_submit_button
   end

    specify 'updates the properties' do

     required_properties.each do |property|
       if property.is_a? Hash
         field = property.keys.first
         value = property[field][:expected_update_value] || property[field][:valid]
       else
         field = property
         value = valid_string
       end
       expect(item.reload[field]).to eq value
     end

   end
  end

  shared_examples 'a page with an error' do
    it { should have_content('error') }
  end

  def populate_required_properties(valid_or_not)
    required_properties.each do |required_field|
     if required_field.is_a? Hash
       field = required_field.keys.first
       value = required_field[field][:valid]
       field_type = required_field[field][:field_type]
       cant_be_invalid = required_field[field].delete(:cant_be_invalid)
     else
       field = required_field
       value = valid_string
    end
     field = get_field_identifier field

     value = (valid_or_not == :with_valid) ? value : ''

     if field_type == :select
       select(value, from: field) unless cant_be_invalid &&  (valid_or_not == :with_invalid)
     else
       fill_in field, with: value
     end
   end
  end

  def get_field_identifier(field)
    if defined? form_for_prefix
      "#{form_for_prefix}_#{field}"
    else
      field.to_s.humanize

    end
  end

  def valid_string
    'aafafafwfg'
  end

  def click_submit_button
    # click_link('submit_button')
    click_button('submit_button')
  end
end
