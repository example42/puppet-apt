require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::pin' do

  let(:title) { 'apt::pin' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'     =>  'sample1',
      'release'  =>  'release1',
      'priority' =>  '10',
    }
  }

  describe 'Test apt pinning by release' do
    it 'should create a pin-sample1-release1 file' do
      should contain_file('apt_pin_sample1').with_ensure('present')
      should contain_file('apt_pin_sample1').with_path('/etc/apt/preferences.d/pin-sample1-release1')
    end
    it 'should populate correctly pin-sample1-release1 file' do
      content = catalogue.resource('file', 'apt_pin_sample1-release1').send(:parameters)[:content]
      content.should match(/Package: sample1
Pin: release release1
Pin-Priority: 10/)
    end
  end

  describe 'Test apt pinning by version' do
    let(:params) {
      { 'name'     =>  'sample2',
        'version'  =>  'version2',
        'priority' =>  '20',
      }
    }

    it 'should create a pin-sample2-version2 file' do
      should contain_file('apt_pin_sample2').with_ensure('present')
      should contain_file('apt_pin_sample2').with_path('/etc/apt/preferences.d/pin-sample2-version2')
    end
    it 'should populate correctly pin-sample2-version2 file' do
      content = catalogue.resource('file', 'apt_pin_sample2').send(:parameters)[:content]
      content.should match(/Package: sample2
Pin: version version2
Pin-Priority: 20/)
    end
  end

  describe 'Test apt pinning with specific template' do
    let(:params) {
      { 'name'     =>  'sample3',
        'template' =>  'apt/spec.erb',
      }
    }
    let(:facts) { { :options => {} } }

    it 'should create a pin-sample3-version file' do
      should contain_file('apt_pin_sample3').with_ensure('present')
      should contain_file('apt_pin_sample3').with_path('/etc/apt/preferences.d/pin-sample3-version')
    end
    it 'should populate correctly pin-sample3 file' do
      content = catalogue.resource('file', 'apt_pin_sample3').send(:parameters)[:content]
      content.should match(/name: sample3
version: */)
    end
  end

  describe 'Test deleting apt pinning' do
    let(:params) {
      { 'name'     =>  'sample4',
        'ensure'   =>  'absent',
      }
    }

    it 'should not create a pin-sample4 file' do
      should contain_file('apt_pin_sample4').with_ensure('absent')
    end
  end

end
