require 'spec_helper'
describe 'gogs' do
  context 'with default values for all parameters' do
    let(:facts) do
      {
          :osfamily => 'Debian',
          :operatingsystem => 'Ubuntu',
          :architecture => 'amd46'
      }
    end
    let(:pre_condition) { "define puppetstats($enabled) {}" }
    it {should contain_class('gogs')}
  end
end