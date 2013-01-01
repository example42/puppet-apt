require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::key' do

  let(:title) { 'apt::key' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'        =>  'sample1',
      'fingerprint' =>  'print1',
    }
  }

  describe 'Test apt key by name' do
    it 'should execute an adv command' do
      should contain_exec('aptkey_adv_sample1').with_command('apt-key adv --keyserver subkeys.pgp.net --recv print1')
      should contain_exec('aptkey_adv_sample1').with_unless('apt-key list | grep -q sample1')
    end
  end

  describe 'Test apt key by name with specific server' do
    let(:params) {
      { 'name'        =>  'sample2',
        'keyserver'   =>  'server2',
        'fingerprint' =>  'print2',
      }
    }

    it 'should execute an adv command' do
      should contain_exec('aptkey_adv_sample2').with_command('apt-key adv --keyserver server2 --recv print2')
      should contain_exec('aptkey_adv_sample2').with_unless('apt-key list | grep -q sample2')
    end
  end

  describe 'Test apt key by url' do
    let(:params) {
      { 'name'  =>  'sample3',
        'url'   =>  'url3',
      }
    }

    it 'should execute a wget command' do
      should contain_exec('aptkey_add_sample3').with_command('wget -O - url3 | apt-key add -')
      should contain_exec('aptkey_add_sample3').with_unless('apt-key list | grep -q sample3')
    end
  end

end
