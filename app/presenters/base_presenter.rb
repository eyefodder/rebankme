# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class BasePresenter
  attr_reader :log
  attr_reader :template
  alias_method :h, :template
  attr_reader :object
  alias_method :form_object, :object

  def initialize(object, template)
    @object = object
    @template = template
    @log = Logging.logger[self]
    @log.level = :debug
  end

  def body_copy(token_path, options = {})
    options = merge_options({ class: 'body_copy' }, options)
    formatted_copy("#{token_path}.body_copy", options)
  end

  def start_over_button(options = nil)
    h.link_to(I18n.t('forms.actions.start_over'),
              h.account_finder_start_path,
              options)
  end

  private

  def merge_options(presenter_options, view_options)
    presenter_options.merge(view_options) do |key, oldval, newval|
      key == :class ? (newval + ' ' + oldval) : newval
    end
  end

  def render_localized_list(token, list_options, bullet_options)
    bullets = I18n.t(token, default: {}).to_a.map { |obj| obj[1] }
    render_bullets(bullets, list_options, bullet_options)
  end

  def render_bullets(bullets, list_options, bullet_options)
    return if bullets.empty?
    h.content_tag(:ul, list_options) do
      res = ''
      bullets.each do |bullet|
        res << h.content_tag(:li, bullet, bullet_options)
      end
      res.html_safe
    end
  end

  def formatted_copy(token, options, tag = :div)
    h.content_tag(tag, h.simple_format(I18n.t(token, options)), options)
  end

  def path_for(tag_action)
    h.send(path_name_for(tag_action), @object)
  end

  def path_name_for(tag_action)
    omitted_prefixes = [:delete, :show]
    suffix = "#{presented}_path"
    omitted_prefixes.include?(tag_action) ? suffix : "#{tag_action}_#{suffix}"
  end

  def self.returns_localized_content(properties)
    properties.each do |property|
      define_method(property) do
        I18n.t(locale_token(property))
      end
    end
  end

  def self.wraps_localized_content(fields)
    fields.each do |property, tag|
      define_method(property) do |options = {}|
        content_unless_nil(property, options, interpolation_args, tag)
      end
    end
  end
  def content_unless_nil(property, options, interpolation_args = {}, tag = :h3)
    interpolation_args = { default: '' }.merge(interpolation_args)
    text = h.raw(I18n.t(locale_token(property), interpolation_args))
    h.content_tag(tag, text, options) unless text == ''
  end

  def self.presents(name)
    define_method(:presented) { name }
    define_method(name) { @object }
  end

  def method_missing(*args, &block)
    @object.send(*args, &block)
  end
end
