require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt' do

  let(:title) { 'apt' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('apt').with_ensure('present') }
    it { should contain_package('debconf-utils').with_ensure('present') }
    it { should_not contain_service('apt') }
    it { should_not contain_file('apt.conf') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('apt').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    it { should contain_package('apt').with_ensure('present') }
    it { should contain_package('debconf-utils').with_ensure('present') }
    it { should_not contain_service('apt') }
    it { should_not contain_file('apt.conf') }
    it { should_not contain_monitor__process }
    it { should_not contain_firewall }
  end

  describe 'Test installation of extra packages, as string' do
    let(:params) { {:extra_packages => 'aptitude,apt-utils' } }
    it { should contain_package('aptitude').with_ensure('present') }
    it { should contain_package('apt-utils').with_ensure('present') }
  end

  describe 'Test installation of extra packages, as array' do
    let(:params) { {:extra_packages => [ 'aptitude','apt-utils' ] } }
    it { should contain_package('aptitude').with_ensure('present') }
    it { should contain_package('apt-utils').with_ensure('present') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true} }

    it 'should remove Package[apt]' do should contain_package('apt').with_ensure('absent') end 
    it { should_not contain_service('apt') }
    it 'should remove apt configuration file' do should contain_file('apt.conf').with_ensure('absent') end
    it 'should remove sources.list file' do should contain_file('apt_sources.list').with_ensure('absent') end
    it { should_not contain_monitor__process }
    it { should_not contain_firewall }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "apt/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      should contain_file('apt.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should not request a source ' do
      should contain_file('apt.conf').without_source
    end
    it 'should generate a template that uses custom options' do
      should contain_file('apt.conf').with_content(/value_a/)
    end

  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/apt/spec" , :source_dir => "puppet://modules/apt/dir/spec" , :source_dir_purge => true } }

    it 'should request a valid source ' do
      should contain_file('apt.conf').with_source('puppet://modules/apt/spec')
    end
    it 'should not have content' do
      should contain_file('apt.conf').without_content
    end
    it 'should request a valid source dir' do
      should contain_file('apt.dir').with_source('puppet://modules/apt/dir/spec')
    end
    it 'should purge source dir if source_dir_purge is true' do
      should contain_file('apt.dir').with_purge(true)
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "apt::spec", :template => "apt/spec.erb" } }
    it 'should automatically include a custom class' do
      should contain_file('apt.conf').with_content(/fqdn: rspec.example42.com/)
    end
  end

  describe 'Test installation without apt.conf file' do
    let(:params) { {:force_conf_d => true } }
    it { should contain_package('apt').with_ensure('present') }
    it { should contain_file('apt.conf').with_ensure('absent') }
  end

  describe 'Test installation without sources.list file' do
    let(:params) { {:force_sources_list_d => true } }
    it { should contain_package('apt').with_ensure('present') }
    it { should contain_file('apt_sources.list').with_ensure('absent') }
  end

end

