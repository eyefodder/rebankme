class BasePresenter

  attr_reader :log

  def initialize(object, template)
    create_templated_methods
    @object = object
    @template = template
    @log = Logging.logger[self]
    @log.level = :debug
  end

  def form_object
    @object
  end


  def start_over_button options=nil
# 'btn btn-default btn-block'
h.link_to(I18n.t("forms.actions.start_over"), h.account_finder_start_path, options)
end

def delete_tag
  content = h.content_tag(:span, '', class: 'glyphicon glyphicon-trash')
  h.link_to content,
  path_for(:delete),
  method: :delete,
  data: {confirm: 'Are you sure?'},
  :class => 'action_delete',
  id: tag_id(:delete)
end
def edit_tag
  h.link_to h.content_tag(:span, '', class: 'glyphicon glyphicon-edit'),
  path_for(:edit),
  :class => 'action_edit', id: tag_id(:edit)
end
def name_tag
  h.content_tag(:span, @object.name, class: 'editable-object-name')
end

private

def create_templated_methods

end

def text_field_tag(form_builder, id)
  label = form_builder.label(id)
  field = form_builder.text_field(id)
  label + field
end
def select_field_tag(form_builder, id, options)
  label = form_builder.label(id)
  field = form_builder.select(id, options)
  label + field
end

def tag_id(tag_action)
  "#{tag_action}_#{presented}_#{@object.id}"
end


def path_for(tag_action)
  h.send(path_name_for(tag_action), param_for_action(tag_action))
end

def param_for_action(tag_action)
  @object
end


def path_name_for(tag_action)
  omitted_prefixes = [:delete, :show]
  suffix = "#{presented}_path"
  omitted_prefixes.include?(tag_action) ? suffix : "#{tag_action}_#{suffix}"
end

def select_field_tag_with_options(form_builder, association, name_method=nil)
  name_method ||= :name
  assoc_id = "#{association}_id".to_sym
  klass = association.to_s.camelize.constantize
  list = klass.all.map {|obj| [obj.send(name_method), obj.id]}
  options = h.options_for_select(list, selected: @object[assoc_id])
  select_field_tag(form_builder, assoc_id, options)
end

def self.text_field_tags_for(names)
  names.each do |field_name|
    define_method("#{field_name}_field_tag") do |form_builder|
      text_field_tag(form_builder, field_name)
    end
  end
end

def self.presents(name)
  define_method(:presented) do
    name
  end

  define_method(name) do
    @object
  end

  define_method("delete_#{name}_tag") do
    delete_tag
  end
  define_method("edit_#{name}_tag") do
    edit_tag
  end
end

def h
  @template
end


def method_missing(*args, &block)
  @object.send(*args, &block)
end
end