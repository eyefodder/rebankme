class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def form_object
    @object
  end


  def start_over_button
    h.link_to(I18n.t("forms.actions.start_over"), h.account_finder_start_path, class: 'btn btn-default')
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