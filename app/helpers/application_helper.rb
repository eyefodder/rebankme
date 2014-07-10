module ApplicationHelper

  def typekit_include_tag apikey
    javascript_include_tag("http://use.typekit.com/#{apikey}.js") +
    javascript_tag("try{Typekit.load()}catch(e){}")
  end

  def full_title(page_title="")
    base_title = "Rebank Me"
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}".html_safe
    end
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def flash_block
    output = ''
    flash.each do |type, message|
      output += flash_container(type, message)
    end

    raw(output)
  end

  def flash_container(type, message)
    if message.is_a?(Array)
      raw(content_tag(:div, :class => "alert alert-#{type}", id: "#{type}-messages") do
        content_tag(:a, raw("&times;"),:class => 'close', :data => {:dismiss => 'alert'}) +
        content_tag(:ul) do
          str = ''
          message.each do |sub_message|
            str = str + content_tag(:li, sub_message)
          end
          str.html_safe
        end
      end)

    else
      raw(content_tag(:div, :class => "alert alert-#{type}") do
        content_tag(:a, raw("&times;"),:class => 'close', :data => {:dismiss => 'alert'}) +
        message
      end)
    end
  end
end
