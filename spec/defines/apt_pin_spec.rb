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

  describe 'Test short-hand apt pinning by release' do
    it 'should create a pin-sample1-release file' do
      should contain_file('apt_pin_sample1').with_ensure('present')
      should contain_file('apt_pin_sample1').with_path('/etc/apt/preferences.d/pin-sample1-release')
    end
    it 'should populate correctly pin-sample1-release file' do
      content = catalogue.resource('file', 'apt_pin_sample1').send(:parameters)[:content]
      content.should match(/Package: sample1
Pin: release release1
Pin-Priority: 10/)
    end
  end

  describe 'Test short-hand apt pinning by version' do
    let(:params) {
      { 'name'     =>  'sample2',
        'version'  =>  'version2',
        'priority' =>  '20',
      }
    }

    it 'should create a pin-sample2 file' do
      should contain_file('apt_pin_sample2').with_ensure('present')
      should contain_file('apt_pin_sample2').with_path('/etc/apt/preferences.d/pin-sample2-version')
    end
    it 'should populate correctly pin-sample2-version file' do
      content = catalogue.resource('file', 'apt_pin_sample2').send(:parameters)[:content]
      content.should match(/Package: sample2
Pin: version version2
Pin-Priority: 20/)
    end
  end

  describe 'Test apt pinning using type and value' do
    let(:params) {
      { 'name'     =>  'sample3',
        'type'     =>  'origin',
        'value'    =>  'example.com',
        'priority' =>  '30',
      }
    }

    it 'should create a pin-sample3-origin file' do
      should contain_file('apt_pin_sample3').with_ensure('present')
      should contain_file('apt_pin_sample3').with_path('/etc/apt/preferences.d/pin-sample3-origin')
    end
    it 'should populate correctly pin-sample3-origin file' do
      content = catalogue.resource('file', 'apt_pin_sample3').send(:parameters)[:content]
      content.should match(/Package: sample3
Pin: origin example.com
Pin-Priority: 30/)
    end
  end

  describe 'Test apt pinning with specific template' do
    let(:params) {
      { 'name'     =>  'sample4',
        'template' =>  'apt/spec.erb',
      }
    }
    let(:facts) { { :options => {} } }

    it 'should create a pin-sample4-version file' do
      should contain_file('apt_pin_sample4').with_ensure('present')
      should contain_file('apt_pin_sample4').with_path('/etc/apt/preferences.d/pin-sample4-version')
    end
    it 'should populate correctly pin-sample4-version file' do
      content = catalogue.resource('file', 'apt_pin_sample4').send(:parameters)[:content]
      content.should match(/name: sample4/)
    end
  end

  describe 'Test deleting apt pinning' do
    let(:params) {
      { 'name'     =>  'sample5',
        'ensure'   =>  'absent',
      }
    }

    it 'should not create a pin-sample5 file' do
      should contain_file('apt_pin_sample5').with_ensure('absent')
    end
  end

end
