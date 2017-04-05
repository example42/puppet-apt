require 'spec_helper'

describe 'apt::unattended_upgrade' do

  let(:title) { 'apt::unattended_upgrade' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :lsbdistid => 'Debian', :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :puppetversion   => Puppet.version} }

  describe 'Test standard installation' do
    it { should contain_package('unattended-upgrades').with_ensure('present') }
  end

end
