# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module DataEntrySteps
  def object_class
    type.to_s.camelize.constantize
  end

  shared_examples 'a page that creates a new item with valid information' do
    before do
      object_class.delete_all
      populate_required_properties :with_valid
    end
    it 'should  change item count' do
      expect do
        click_submit_button
      end.to change(object_class, :count).by(1)
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

      required_properties.each do |prop|
        if prop.is_a? Hash
          field = prop.keys.first
          value = prop[field][:expected_update_value] || prop[field][:valid]
        else
          field = prop
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
        populate_hashed_field(required_field, valid_or_not)
      else
        populate_standard_field(required_field, valid_string, valid_or_not)
      end
    end
  end

  def populate_hashed_field(field_data, valid_or_not)
    field = field_data.keys.first
    value = field_data[field][:valid]
    field_type = field_data[field][:field_type]
    cant_be_invalid = field_data[field].delete(:cant_be_invalid)
    if field_type == :select
      populate_select_field(field, value, cant_be_invalid, valid_or_not)
    else
      populate_standard_field(field, value, valid_or_not)
    end
  end

  def populate_select_field(field, value, cant_be_invalid, valid_or_not)
    return if cant_be_invalid && (valid_or_not == :with_invalid)
    field = get_field_identifier field
    value = (valid_or_not == :with_valid) ? value : ''
    select(value, from: field)
  end

  def populate_standard_field(field, value, valid_or_not)
    field = get_field_identifier field
    value = (valid_or_not == :with_valid) ? value : ''
    fill_in field, with: value
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
    click_button('submit_button')
  end
end
