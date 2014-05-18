require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::conf' do

  let(:title) { 'apt::conf' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'    =>  'sample1',
      'content' =>  'content from template',
    }
  }

  describe 'Test apt conf file creation by content' do
    it 'should create a 10sample1.conf file' do
      should contain_file('apt_conf_sample1').with_ensure('present')
      should contain_file('apt_conf_sample1').with_path('/etc/apt/apt.conf.d/10sample1.conf')
    end
    it 'should populate correctly 10sample1.conf file' do
      should contain_file('apt_conf_sample1').with_content(/content from template/)
    end
    it 'should not request a source' do
      should contain_file('apt_conf_sample1').without_source
    end
  end

  describe 'Test apt conf file creation by source' do
    let(:params) {
      { 'name'    =>  'sample2',
        'source'  =>  'puppet://modules/apt/spec',
      }
    }

    it 'should create a 10sample2.conf file' do
      should contain_file('apt_conf_sample2').with_ensure('present')
      should contain_file('apt_conf_sample2').with_path('/etc/apt/apt.conf.d/10sample2.conf')
    end
    it 'should request a valid source' do
      should contain_file('apt_conf_sample2').with_source('puppet://modules/apt/spec')
    end
    it 'should not have content' do
      should contain_file('apt_conf_sample2').without_content
    end
  end

  describe 'Test apt conf file creation with priority' do
    let(:params) {
      { 'name'     =>  'sample3',
        'content'  =>  'content from template',
        'priority' =>  '99',
      }
    }

    it 'should create a 99sample2.conf file' do
      should contain_file('apt_conf_sample3').with_ensure('present')
      should contain_file('apt_conf_sample3').with_path('/etc/apt/apt.conf.d/99sample3.conf')
    end
    it 'should populate correctly 99sample3.conf file' do
      should contain_file('apt_conf_sample3').with_content(/content from template/)
    end
  end

  describe 'Test apt conf file deletion' do
    let(:params) {
      { 'name'    =>  'sample4',
        'ensure'  =>  'absent',
      }
    }

    it 'should not create a 10sample4.conf file' do
      should contain_file('apt_conf_sample4').with_ensure('absent')
    end
  end

end
