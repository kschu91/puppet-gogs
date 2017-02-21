require 'spec_helper_acceptance'

describe 'gogs' do

  context 'with defaults' do
    it 'should listen on 3000' do
      pp = <<-EOS
        class { 'gogs': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(3000) do
      it { is_expected.to be_listening }
    end

  end

end
