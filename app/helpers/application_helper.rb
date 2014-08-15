# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module ApplicationHelper
  def typekit_include_tag(apikey)
    javascript_include_tag("http://use.typekit.com/#{apikey}.js") +
    javascript_tag('try{Typekit.load()}catch(e){}')
  end

  def full_title(page_title = '')
    base_title = 'Rebank Me'
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
      messages_from_array(type, message)
    else
      message_from_string(type, message)
    end
  end

  private

  def message_from_string(type, message)
    raw(content_tag(:div, class: "alert alert-#{type}") do
      content_tag(:a,
                  raw('&times;'),
                  class: 'close',
                  data: { dismiss: 'alert' }) +
      message
    end)
  end

  def messages_from_array(type, messages)
    options = { class: "alert alert-#{type}", id: "#{type}-messages" }
    link_options = { class: 'close', data: { dismiss: 'alert' } }
    msg_list = messages.reduce('') { |a, e| a << content_tag(:li, e) }
    raw(content_tag(:div, options) do
      content_tag(:a, raw('&times;'), link_options) +
      content_tag(:ul, msg_list.html_safe)
    end)
  end
end
