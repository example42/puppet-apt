require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::unattended_upgrade_automatic' do

  let(:title) { 'apt::unattended_upgrade_automatic' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :lsbdistid => 'Unknown' } }
  let(:params) { {} }

  describe 'Test automatic unattended upgrade for unknown distro' do
    it 'should create a 99unattended-upgrade.conf file' do
      should contain_file('apt_conf_unattended-upgrade').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrade').with_path('/etc/apt/apt.conf.d/99unattended-upgrade.conf')
    end
    it 'should populate correctly 99unattended-upgrade.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrade').send(:parameters)[:content]
      content.should match(/APT::Periodic::Unattended-Upgrade "1";/)
    end
    it 'should create a 10periodic.conf file' do
      should contain_file('apt_conf_periodic').with_ensure('present')
      should contain_file('apt_conf_periodic').with_path('/etc/apt/apt.conf.d/10periodic.conf')
    end
    it 'should request a valid source for 10periodic.conf file' do
      content = catalogue.resource('file', 'apt_conf_periodic').send(:parameters)[:source]
      content.should == "puppet:///modules/apt/10periodic"
    end
  end

  describe 'Test automatic unattended upgrade for squeeze' do
    let(:facts) { { :lsbdistid => 'Debian', :lsbdistcodename => 'squeeze' } }

    it 'should create a 99unattended-upgrade.conf file' do
      should contain_file('apt_conf_unattended-upgrade').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrade').with_path('/etc/apt/apt.conf.d/99unattended-upgrade.conf')
    end
    it 'should populate correctly 99unattended-upgrade.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrade').send(:parameters)[:content]
      content.should match(/APT::Periodic::Unattended-Upgrade "1";/)
    end
    it 'should create a 10periodic.conf file' do
      should contain_file('apt_conf_periodic').with_ensure('present')
      should contain_file('apt_conf_periodic').with_path('/etc/apt/apt.conf.d/10periodic.conf')
    end
    it 'should request a valid source for 10periodic.conf file' do
      content = catalogue.resource('file', 'apt_conf_periodic').send(:parameters)[:source]
      content.should == "puppet:///modules/apt/10periodic"
    end
    it 'should create a 50unattended-upgrades.conf file' do
      should contain_file('apt_conf_unattended-upgrades').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrades').with_path('/etc/apt/apt.conf.d/50unattended-upgrades.conf')
    end
    it 'should populate correctly 50unattended-upgrades.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrades').send(:parameters)[:content]
      content.should match(/Unattended-Upgrade::Allowed-Origins \{
  "Debian stable";
  "Debian squeeze-security";
\};/)
    end
  end

  describe 'Test automatic unattended upgrade for lenny' do
    let(:facts) { { :lsbdistid => 'Debian', :lsbdistcodename => 'lenny' } }

    it 'should create a 99unattended-upgrade.conf file' do
      should contain_file('apt_conf_unattended-upgrade').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrade').with_path('/etc/apt/apt.conf.d/99unattended-upgrade.conf')
    end
    it 'should populate correctly 99unattended-upgrade.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrade').send(:parameters)[:content]
      content.should match(/APT::Periodic::Unattended-Upgrade "1";/)
    end
    it 'should create a 10periodic.conf file' do
      should contain_file('apt_conf_periodic').with_ensure('present')
      should contain_file('apt_conf_periodic').with_path('/etc/apt/apt.conf.d/10periodic.conf')
    end
    it 'should request a valid source for 10periodic.conf file' do
      content = catalogue.resource('file', 'apt_conf_periodic').send(:parameters)[:source]
      content.should == "puppet:///modules/apt/10periodic"
    end
    it 'should create a 50unattended-upgrades.conf file' do
      should contain_file('apt_conf_unattended-upgrades').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrades').with_path('/etc/apt/apt.conf.d/50unattended-upgrades.conf')
    end
    it 'should populate correctly 50unattended-upgrades.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrades').send(:parameters)[:content]
      content.should match(/Unattended-Upgrade::Allowed-Origins \{
        "Debian oldstable";
\};/)
    end
  end

  describe 'Test automatic unattended upgrade for Ubuntu' do
    let(:facts) { { :lsbdistid => 'Ubuntu', :lsbdistcodename => 'precise' } }

    it 'should create a 99unattended-upgrade.conf file' do
      should contain_file('apt_conf_unattended-upgrade').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrade').with_path('/etc/apt/apt.conf.d/99unattended-upgrade.conf')
    end
    it 'should populate correctly 99unattended-upgrade.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrade').send(:parameters)[:content]
      content.should match(/APT::Periodic::Unattended-Upgrade "1";/)
    end
    it 'should create a 10periodic.conf file' do
      should contain_file('apt_conf_periodic').with_ensure('present')
      should contain_file('apt_conf_periodic').with_path('/etc/apt/apt.conf.d/10periodic.conf')
    end
    it 'should request a valid source for 10periodic.conf file' do
      content = catalogue.resource('file', 'apt_conf_periodic').send(:parameters)[:source]
      content.should == "puppet:///modules/apt/10periodic"
    end
    it 'should create a 50unattended-upgrades.conf file' do
      should contain_file('apt_conf_unattended-upgrades').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrades').with_path('/etc/apt/apt.conf.d/50unattended-upgrades.conf')
    end
    it 'should populate correctly 50unattended-upgrades.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrades').send(:parameters)[:content]
      content.should match(/Unattended-Upgrade::Allowed-Origins \{
        "Ubuntu precise-security";
        \/\/"Ubuntu precise-updates";
\};
Unattended-Upgrade::Package-Blacklist \{/)
    end
  end

  describe 'Test automatic unattended upgrade for Ubuntu with mail' do
    let(:facts) { { :lsbdistid => 'Ubuntu', :lsbdistcodename => 'precise' } }
    let(:params) { { :mail => 'root@somewhere' } }

    it 'should create a 99unattended-upgrade.conf file' do
      should contain_file('apt_conf_unattended-upgrade').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrade').with_path('/etc/apt/apt.conf.d/99unattended-upgrade.conf')
    end
    it 'should populate correctly 99unattended-upgrade.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrade').send(:parameters)[:content]
      content.should match(/APT::Periodic::Unattended-Upgrade "1";/)
    end
    it 'should create a 10periodic.conf file' do
      should contain_file('apt_conf_periodic').with_ensure('present')
      should contain_file('apt_conf_periodic').with_path('/etc/apt/apt.conf.d/10periodic.conf')
    end
    it 'should request a valid source for 10periodic.conf file' do
      content = catalogue.resource('file', 'apt_conf_periodic').send(:parameters)[:source]
      content.should == "puppet:///modules/apt/10periodic"
    end
    it 'should create a 50unattended-upgrades.conf file' do
      should contain_file('apt_conf_unattended-upgrades').with_ensure('present')
      should contain_file('apt_conf_unattended-upgrades').with_path('/etc/apt/apt.conf.d/50unattended-upgrades.conf')
    end
    it 'should populate correctly 50unattended-upgrades.conf file' do
      content = catalogue.resource('file', 'apt_conf_unattended-upgrades').send(:parameters)[:content]
      content.should match(/Unattended-Upgrade::Mail "root@somewhere";/)
    end
  end

end
