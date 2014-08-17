# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# include DataEntrySteps
module EditableObjectSteps
  shared_context 'has index pages' do
    let!(:objects) { [create(type), create(type), create(type)] }
    let(:path_to_test) { send("#{type.to_s.pluralize}_path") }

    subject { page }
    before do
      as_admin
      visit path_to_test
    end
    it 'shows all the names' do
      objects.each do |object|
        expect(page).to have_css('span.editable-object-name', text: object.name)
      end
    end
    it 'has delete link for each item' do
      objects.each do |object|
        fail_msg = "cant find the delete button for #{object.name}"
        expect(page).to have_delete_link(object), fail_msg
      end
    end
    it 'lets me delete an item' do
      klass = type.to_s.camelize.constantize
      expect do
        click_link(tag_id(:delete, objects.first))
      end.to change { klass.count }.by(-1)
    end
    it 'has edit link for each item' do
      objects.each do |object|
        expect(page).to have_edit_link(object)
      end
    end
    # rubocop:disable Style/PredicateName
    def have_edit_link(object)
      have_link("edit_#{type}_#{object.id}", edit_path(object))
    end

    def have_delete_link(object)
      have_xpath(".//a[@href='#{delete_path(object)}' and " \
                 "@data-method='delete' and @class='action_delete' and " \
                 "@id='#{tag_id(:delete, object)}' ]")
    end
    # rubocop:enable Style/PredicateName

  end

  shared_context '#edit edits objects' do
    let!(:item) { create(type) }
    before do
      as_admin
      visit edit_path(item)
    end
    it_behaves_like 'a page that updates item with valid information'
    it_behaves_like 'a page that errors with invalid information'
  end

  shared_context '#new creates objects' do
    before do
      as_admin
      visit new_path
    end
    it_behaves_like 'a page that creates a new item with valid information'
    it_behaves_like "a page that doesn't create with invalid information"
  end
  def delete_path(object)
    send("#{type}_path", object)
  end

  def edit_path(object)
    send("edit_#{type}_path", object)
  end

  def new_path
    send("new_#{type}_path")
  end

  def tag_id(action, object)
    "#{action}_#{type}_#{object.id}"
  end
end
