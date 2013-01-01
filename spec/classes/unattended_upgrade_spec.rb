require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::unattended_upgrade' do

  let(:title) { 'apt::unattended_upgrade' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('unattended-upgrades').with_ensure('present') }
  end

end
