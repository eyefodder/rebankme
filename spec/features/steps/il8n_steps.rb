# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
module Il8nSteps
  extend RSpec::Matchers::DSL

  def there_should_be_a_translation_for(token)
    res = I18n.t(token)
    expect(res).not_to eq "translation missing: en.#{token}"
  end

  matcher :have_a_translation do |_expected|
    match do |actual|
      I18n.t(actual) != "translation missing: en.#{actual}"
    end
  end

  def parsed_tokens(object, prefix = '', &block)
    object = YAML.load(object) if object.is_a?(String)
    if object.nil?
      yield(prefix.chop)
    else
      object.each do |key, child|
        new_prefix = "#{prefix}#{key}."
        parsed_tokens(child, new_prefix, &block)
      end
    end
  end

  shared_examples 'localized content' do
    it 'has specified Localizations' do
      parsed_tokens(expected_tokens) do |parsed_token|
        expect(parsed_token).to have_a_translation
      end
    end
  end
  shared_examples 'templated localized content' do
    it 'has specified Localizations' do
      token_groups.each do |token_group|
        parsed_tokens(token_template) do |template|
          expect("#{token_group}.#{template}").to have_a_translation
        end
      end
    end
  end
end
