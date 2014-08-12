# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe AccountFinderController,:type => :controller do
  # NB most tests are carried out as integration tests
  # but this one is in response to a bug where following a certain path
  # results in the user params not getting posted to the controller
  # which we rescue and redirect to the start path
  describe '#next_type_question' do
    it 'redirects to start path if no user params supplied' do
      post :next_type_question
      expect(response).to redirect_to(account_finder_start_path)
    end

  end
end