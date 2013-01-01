require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::key' do

  let(:title) { 'apt::key' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'        =>  'sample1',
      'keyserver'   =>  'server1',
      'fingerprint' =>  'print1',
    }
  }

  describe 'Test apt key by name' do
    it 'should execute an adv command' do
      should contain_exec('aptkey_adv_sample1').with_command('apt-key adv --keyserver server1 --recv print1')
      should contain_exec('aptkey_adv_sample1').with_unless('apt-key list | grep -q sample1')
    end
  end

  describe 'Test apt key by url' do
    let(:params) {
      { 'name'  =>  'sample2',
        'url'   =>  'url2',
      }
    }

    it 'should execute a wget command' do
      should contain_exec('aptkey_add_sample2').with_command('wget -O - url2 | apt-key add -')
      should contain_exec('aptkey_add_sample2').with_unless('apt-key list | grep -q sample2')
    end
  end

end
