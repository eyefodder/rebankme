module Il8nSteps
  extend RSpec::Matchers::DSL

  def there_should_be_a_translation_for(token)
    res = I18n.t(token)
    expect(res).not_to eq "translation missing: en.#{token}"
  end

  matcher :have_a_translation do |expected|
    match do |actual|
      I18n.t(actual) != "translation missing: en.#{actual}"
    end
  end
end