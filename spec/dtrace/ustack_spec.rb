require 'spec_helper'

RSpec.describe 'ustack helper' do
  let(:probe) {
    <<-eoprobe
      ruby$target::: { printf(ustack()) }
    eoprobe
  }
end
