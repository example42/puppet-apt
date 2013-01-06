require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::sources_list' do

  let(:title) { 'apt::sources_list' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'    =>  'sample1',
      'content' =>  'content from template',
    }
  }

  describe 'Test apt sources.list file creation by content' do
    it 'should create a sample1.list file' do
      should contain_file('apt_sourceslist_sample1').with_ensure('present')
      should contain_file('apt_sourceslist_sample1').with_path('/etc/apt/sources.list.d/sample1.list')
    end
    it 'should populate correctly sample1.list file' do
      content = catalogue.resource('file', 'apt_sourceslist_sample1').send(:parameters)[:content]
      content.should match(/content from template/)
    end
    it 'should not request a source' do
      content = catalogue.resource('file', 'apt_sourceslist_sample1').send(:parameters)[:source]
      content.should be_nil
    end
  end

  describe 'Test apt sources.list file creation by source' do
    let(:params) {
      { 'name'    =>  'sample2',
        'source'  =>  'puppet://modules/apt/spec',
      }
    }

    it 'should create a sample2.list file' do
      should contain_file('apt_sourceslist_sample2').with_ensure('present')
      should contain_file('apt_sourceslist_sample2').with_path('/etc/apt/sources.list.d/sample2.list')
    end
    it 'should request a valid source' do
      content = catalogue.resource('file', 'apt_sourceslist_sample2').send(:parameters)[:source]
      content.should == 'puppet://modules/apt/spec'
    end
    it 'should not have content' do
      content = catalogue.resource('file', 'apt_sourceslist_sample2').send(:parameters)[:content]
      content.should be_nil
    end
  end

  describe 'Test apt sources.list file deletion' do
    let(:params) {
      { 'name'    =>  'sample3',
        'ensure'  =>  'absent',
      }
    }

    it 'should not create a sample3.list file' do
      should contain_file('apt_sourceslist_sample3').with_ensure('absent')
    end
  end

end
