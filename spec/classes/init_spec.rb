require 'spec_helper'
describe 'mapr4' do

  context 'with defaults for all parameters' do
    it { should contain_class('mapr4') }
  end
end
