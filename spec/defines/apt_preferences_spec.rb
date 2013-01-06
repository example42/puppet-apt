require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::preferences' do

  let(:title) { 'apt::preferences' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'    =>  'sample1',
      'content' =>  'content from template',
    }
  }

  describe 'Test apt preferences file creation by content' do
    it 'should create a sample1 file' do
      should contain_file('apt_preferences_sample1').with_ensure('present')
      should contain_file('apt_preferences_sample1').with_path('/etc/apt/preferences.d/sample1')
    end
    it 'should populate correctly sample1 file' do
      content = catalogue.resource('file', 'apt_preferences_sample1').send(:parameters)[:content]
      content.should match(/content from template/)
    end
    it 'should not request a source' do
      content = catalogue.resource('file', 'apt_preferences_sample1').send(:parameters)[:source]
      content.should be_nil
    end
  end

  describe 'Test apt preferences file creation by source' do
    let(:params) {
      { 'name'    =>  'sample2',
        'source'  =>  'puppet://modules/apt/spec',
      }
    }

    it 'should create a sample2 file' do
      should contain_file('apt_preferences_sample2').with_ensure('present')
      should contain_file('apt_preferences_sample2').with_path('/etc/apt/preferences.d/sample2')
    end
    it 'should request a valid source' do
      content = catalogue.resource('file', 'apt_preferences_sample2').send(:parameters)[:source]
      content.should == "puppet://modules/apt/spec"
    end
    it 'should not have content' do
      content = catalogue.resource('file', 'apt_preferences_sample2').send(:parameters)[:content]
      content.should be_nil
    end
  end

  describe 'Test apt preferences file deletion' do
    let(:params) {
      { 'name'    =>  'sample3',
        'ensure'  =>  'absent',
      }
    }

    it 'should not create a sample3 file' do
      should contain_file('apt_preferences_sample3').with_ensure('absent')
    end
  end

end
