# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class EditableObjectPresenter < BasePresenter
  def delete_tag
    content = h.content_tag(:span, '', class: 'glyphicon glyphicon-trash')
    h.link_to content,
              path_for(:delete),
              method: :delete,
              data: { confirm: 'Are you sure?' },
              class: 'action_delete',
              id: tag_id(:delete)
  end

  def edit_tag
    h.link_to h.content_tag(:span, '', class: 'glyphicon glyphicon-edit'),
              path_for(:edit),
              class: 'action_edit', id: tag_id(:edit)
  end

  def name_tag
    h.content_tag(:span, name_tag_contents, class: 'editable-object-name')
  end

  private

  def name_tag_contents
    @object.name
  end

  def tag_id(tag_action)
    "#{tag_action}_#{presented}_#{@object.id}"
  end

  def text_field_tag(form_builder, id)
    label = form_builder.label(id)
    field = form_builder.text_field(id)
    label + field
  end

  def self.text_field_tags_for(names)
    names.each do |field_name|
      define_method("#{field_name}_field_tag") do |form_builder|
        text_field_tag(form_builder, field_name)
      end
    end
  end

  def select_field_tag(form_builder, id, options)
    label = form_builder.label(id)
    field = form_builder.select(id, options)
    label + field
  end

  def select_field_tag_with_options(form_builder,
                                    association,
                                    name_method = nil)
    name_method ||= :name
    assoc_id = "#{association}_id".to_sym
    klass = association.to_s.camelize.constantize
    list = klass.all.map { |obj| [obj.send(name_method), obj.id] }
    options = h.options_for_select(list, selected: @object[assoc_id])
    select_field_tag(form_builder, assoc_id, options)
  end
end
