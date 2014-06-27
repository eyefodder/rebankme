module PageContentSteps
	extend RSpec::Matchers::DSL

	def have_page_title(title)
		have_title(title)
	end

end