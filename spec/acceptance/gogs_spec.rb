require 'spec_helper_acceptance'

describe 'gogs' do

  context 'with defaults' do
    it 'should listen on 3000' do
      pp = <<-EOS
        class { 'gogs': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # @todo enable if gogs will restart only if version changed
      # apply_manifest(pp, :catch_changes => true)
    end

    describe port(3000) do
      it { is_expected.to be_listening }
    end
  end

  context 'with custom port' do
    it 'should listen on 6000' do
      pp = <<-EOS
        class { '::gogs':
            app_ini_sections => {
                'server'   => {
                    'HTTP_PORT' => 6000,
                },
            },
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # @todo enable if gogs will restart only if version changed
      # apply_manifest(pp, :catch_changes => true)
    end

    describe port(6000) do
      it { is_expected.to be_listening }
    end
  end

end
