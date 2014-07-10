class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end





  private




  # def path_for(tag_action)
  #   h.send(path_name_for(tag_action), param_for_action(tag_action))
  # end

  # def param_for_action(tag_action)
  #   @object
  # end


  # def path_name_for(tag_action)
  #   omitted_prefixes = [:delete, :show]
  #   suffix = "#{presented}_path"
  #   omitted_prefixes.include?(tag_action) ? suffix : "#{tag_action}_#{suffix}"
  # end


  def self.presents(name)
    define_method(:presented) do
      name
    end

    define_method(name) do
      @object
    end

    # define_method("delete_#{name}_tag") do
    #   delete_tag
    # end
  end

  def h
    @template
  end


  def method_missing(*args, &block)
    @object.send(*args, &block)
  end
end