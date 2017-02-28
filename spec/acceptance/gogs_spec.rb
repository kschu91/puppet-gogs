require 'spec_helper_acceptance'

describe 'gogs' do

  context 'with defaults' do
    it 'should run' do
      pp = <<-EOS
        class { 'gogs': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # @todo enable if gogs will restart only if version changed
      # apply_manifest(pp, :catch_changes => true)
    end

    describe user('git') do
      it { should exist }
    end

    describe group('git') do
      it { should exist }
    end

    describe file('/opt/gogs') do
      it { should be_directory }
    end

    describe file('/var/git') do
      it { should be_directory }
    end

    describe port(3000) do
      it { is_expected.to be_listening }
    end
  end

  context 'with custom user' do
    it 'should run' do
      pp = <<-EOS
        class { 'gogs':
          owner => 'foo',
          group => 'bar',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # @todo enable if gogs will restart only if version changed
      # apply_manifest(pp, :catch_changes => true)
    end

    describe user('foo') do
      it { should exist }
    end

    describe group('bar') do
      it { should exist }
    end

    describe file('/opt/gogs') do
      it { should be_directory }
    end

    describe file('/var/git') do
      it { should be_directory }
    end

    describe port(3000) do
      it { is_expected.to be_listening }
    end
  end

  # context 'with custom port' do
  #   it 'should listen on 3210' do
  #     pp = <<-EOS
  #       class { '::gogs':
  #           app_ini_sections => {
  #               'server'   => {
  #                   'HTTP_PORT' => 3210,
  #               },
  #           },
  #       }
  #     EOS
  #
  #     apply_manifest(pp, :catch_failures => true)
  #     # @todo enable if gogs will restart only if version changed
  #     # apply_manifest(pp, :catch_changes => true)
  #   end
  #
  #   describe port(3210) do
  #     it { is_expected.to be_listening }
  #   end
  # end

end
